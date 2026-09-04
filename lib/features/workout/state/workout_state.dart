import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../routines/models/interval.dart';
import '../../routines/models/machine_type.dart';
import '../../routines/models/routine.dart';
import '../../../services/sound_service.dart';

enum WorkoutStatus {
  running,
  paused,
  resumingCountdown,
  finished,
  stopped,
}

/// Runtime state for an active workout.
///
/// Active elapsed wall-clock time is the single source of truth. Periodic
/// timers only refresh the UI; they never advance the workout by counting
/// callbacks. This keeps interval state, completion, and treadmill distance
/// correct when the OS suspends Dart while another app is in the foreground.
class WorkoutState extends ChangeNotifier {
  WorkoutState({
    required this.routine,
    required this.startTime,
    DateTime Function()? nowProvider,
    bool isPreview = false,
  })  : _now = nowProvider ?? DateTime.now,
        initialTotalSeconds = routine.totalDurationSeconds {
    // Preview instances are frozen with setPreviewElapsed() right after
    // construction, so skip the normal init (which plays the countdown
    // beep) since it would just be undone.
    if (!isPreview) {
      _initializeWorkout();
    }
  }

  static const Duration _countdownStep = Duration(milliseconds: 900);
  static const int _countdownSteps = 3;
  static const Duration _runningRefreshRate = Duration(milliseconds: 250);
  static const Duration _countdownRefreshRate = Duration(milliseconds: 100);

  final Routine routine;
  final DateTime startTime;
  final DateTime Function() _now;

  /// Snapshot of the planned duration at workout creation.
  final int initialTotalSeconds;

  int _currentIntervalIndex = 0;
  int _currentIntervalRemainingMilliseconds = 0;
  int _remainingSeconds = 0;
  int _totalElapsedSeconds = 0;
  int _activeElapsedMilliseconds = 0;
  WorkoutStatus _status = WorkoutStatus.running;
  bool _stoppedEarly = false;

  DateTime? _runningAnchor;
  Timer? _runningRefreshTimer;

  int _countdownNumber = _countdownSteps;
  DateTime? _countdownEndsAt;
  Timer? _countdownRefreshTimer;
  bool _isInitialCountdown = true;
  bool _isBackgrounded = false;

  bool _finishedSfxPlayed = false;

  int get currentIntervalIndex => _currentIntervalIndex;
  int get remainingSeconds => _remainingSeconds;
  int get totalElapsedSeconds => _totalElapsedSeconds;
  WorkoutStatus get status => _status;
  bool get stoppedEarly => _stoppedEarly;
  int get countdownNumber => _countdownNumber;
  bool get isInitialCountdown => _isInitialCountdown;

  Interval get currentInterval => routine.intervals[_currentIntervalIndex];
  int get totalIntervals => routine.intervals.length;

  int get totalRemainingSeconds {
    return (totalRemainingDuration.inMilliseconds / 1000).ceil();
  }

  /// Remaining active workout time with millisecond precision.
  ///
  /// Live Activities use this duration to hand the system a wall-clock end
  /// date, allowing their countdown to keep moving while Dart is suspended.
  Duration get totalRemainingDuration {
    final remainingMilliseconds =
        (_totalDurationMilliseconds - totalElapsedMilliseconds).clamp(
      0,
      _totalDurationMilliseconds,
    );
    return Duration(milliseconds: remainingMilliseconds);
  }

  double get currentIntervalProgress {
    if (routine.intervals.isEmpty) return 0;
    final intervalMilliseconds = currentInterval.durationSeconds * 1000;
    if (intervalMilliseconds <= 0) return 1;
    final elapsed =
        intervalMilliseconds - _currentIntervalRemainingMilliseconds;
    return (elapsed / intervalMilliseconds).clamp(0.0, 1.0);
  }

  double get totalWorkoutProgress {
    final total = _totalDurationMilliseconds;
    if (total <= 0) return 0;
    return (totalElapsedMilliseconds / total).clamp(0.0, 1.0);
  }

  double get totalRemainingProgress {
    if (initialTotalSeconds <= 0) return 0;
    return (totalRemainingSeconds / initialTotalSeconds).clamp(0.0, 1.0);
  }

  int get currentIntervalElapsedSeconds {
    if (routine.intervals.isEmpty) return 0;
    final elapsedMilliseconds = currentInterval.durationSeconds * 1000 -
        _currentIntervalRemainingMilliseconds;
    return (elapsedMilliseconds.clamp(
              0,
              currentInterval.durationSeconds * 1000,
            ) /
            1000)
        .floor();
  }

  int get totalElapsedMilliseconds {
    if (_status != WorkoutStatus.running || _runningAnchor == null) {
      return _activeElapsedMilliseconds;
    }

    final sinceAnchor = _now().difference(_runningAnchor!).inMilliseconds;
    return (_activeElapsedMilliseconds + sinceAnchor).clamp(
      0,
      _totalDurationMilliseconds,
    );
  }

  int get roundedElapsedSeconds => (totalElapsedMilliseconds / 1000).round();

  bool get isTreadmill => routine.machineType == MachineType.treadmill;

  /// Remaining real time before the current interval ends.
  Duration get currentIntervalRemainingDuration {
    if (_status != WorkoutStatus.running || routine.intervals.isEmpty) {
      return Duration(
        milliseconds: _currentIntervalRemainingMilliseconds.clamp(
          0,
          _totalDurationMilliseconds,
        ),
      );
    }

    final activeNow = totalElapsedMilliseconds;
    final intervalEnd = _intervalEndMilliseconds(_currentIntervalIndex);
    return Duration(
        milliseconds: (intervalEnd - activeNow).clamp(0, intervalEnd));
  }

  /// Remaining real time before an initial/resume countdown completes.
  Duration get countdownRemainingDuration {
    if (_status != WorkoutStatus.resumingCountdown ||
        _countdownEndsAt == null) {
      return Duration.zero;
    }
    final milliseconds = _countdownEndsAt!.difference(_now()).inMilliseconds;
    return Duration(milliseconds: milliseconds < 0 ? 0 : milliseconds);
  }

  /// Treadmill distance is integrated across every interval's speed instead of
  /// applying a delayed background tick to whichever interval happens to be
  /// current when the app resumes.
  double get distanceMeters {
    if (!isTreadmill) return 0;

    var elapsedMilliseconds = totalElapsedMilliseconds;
    var distance = 0.0;
    for (final interval in routine.intervals) {
      if (elapsedMilliseconds <= 0) break;
      final intervalMilliseconds = interval.durationSeconds * 1000;
      final overlapMilliseconds = elapsedMilliseconds.clamp(
        0,
        intervalMilliseconds,
      );
      final speedMetersPerSecond = (interval.speedKmh ?? 0) * 1000.0 / 3600.0;
      distance += speedMetersPerSecond * overlapMilliseconds / 1000.0;
      elapsedMilliseconds -= overlapMilliseconds;
    }
    return distance;
  }

  int get _totalDurationMilliseconds => initialTotalSeconds * 1000;

  void _initializeWorkout() {
    _finishedSfxPlayed = false;

    if (routine.intervals.isEmpty || _totalDurationMilliseconds <= 0) {
      _status = WorkoutStatus.finished;
      _activeElapsedMilliseconds = 0;
      _remainingSeconds = 0;
      _playFinishSfxOnce();
      notifyListeners();
      return;
    }

    _currentIntervalIndex = 0;
    _currentIntervalRemainingMilliseconds =
        routine.intervals.first.durationSeconds * 1000;
    _remainingSeconds = routine.intervals.first.durationSeconds;
    startInitialCountdown();
  }

  /// Freezes the workout at a deterministic point for store screenshots.
  /// No countdown, timers, sounds, haptics, or persistence are started.
  void setPreviewElapsed(Duration elapsed) {
    _runningRefreshTimer?.cancel();
    _countdownRefreshTimer?.cancel();
    _runningRefreshTimer = null;
    _countdownRefreshTimer = null;
    _countdownEndsAt = null;
    _countdownNumber = 0;
    _isInitialCountdown = false;
    _activeElapsedMilliseconds = elapsed.inMilliseconds.clamp(
      0,
      _totalDurationMilliseconds,
    );
    _runningAnchor = null;
    _status = WorkoutStatus.running;
    _deriveTimelineFromElapsed();
    notifyListeners();
  }

  int _intervalEndMilliseconds(int intervalIndex) {
    var result = 0;
    for (var index = 0; index <= intervalIndex; index++) {
      result += routine.intervals[index].durationSeconds * 1000;
    }
    return result;
  }

  void _startRunningAt(DateTime startedAt) {
    _countdownRefreshTimer?.cancel();
    _countdownRefreshTimer = null;
    _countdownEndsAt = null;
    _countdownNumber = 0;
    _status = WorkoutStatus.running;
    _runningAnchor = startedAt;
    if (!_isBackgrounded) {
      _startRunningRefreshTimer();
    }
  }

  void _startRunningRefreshTimer() {
    _runningRefreshTimer?.cancel();
    if (_status != WorkoutStatus.running || _isBackgrounded) return;

    _runningRefreshTimer = Timer.periodic(_runningRefreshRate, (_) {
      _synchronizeRunning(_now());
    });
  }

  void _synchronizeRunning(
    DateTime snapshotTime, {
    bool notify = true,
    bool playSounds = true,
  }) {
    if (_status != WorkoutStatus.running || _runningAnchor == null) return;

    final deltaMilliseconds =
        snapshotTime.difference(_runningAnchor!).inMilliseconds;
    if (deltaMilliseconds <= 0) return;

    final oldRemainingSeconds = _remainingSeconds;
    final oldIntervalIndex = _currentIntervalIndex;
    final targetElapsed = (_activeElapsedMilliseconds + deltaMilliseconds)
        .clamp(0, _totalDurationMilliseconds);
    _activeElapsedMilliseconds = targetElapsed;
    _runningAnchor = snapshotTime;
    _deriveTimelineFromElapsed();

    if (_activeElapsedMilliseconds >= _totalDurationMilliseconds) {
      _finishWorkout(playSound: playSounds, notify: notify);
      return;
    }

    if (playSounds && _currentIntervalIndex != oldIntervalIndex) {
      SoundService().playBeep();
      _safeHaptic(HapticFeedback.heavyImpact);
    } else if (playSounds &&
        _currentIntervalIndex == oldIntervalIndex &&
        _remainingSeconds != oldRemainingSeconds &&
        (_remainingSeconds == 3 || _remainingSeconds == 2 || _remainingSeconds == 1)) {
      _safeHaptic(HapticFeedback.lightImpact);
    }
    if (notify) notifyListeners();
  }

  void _deriveTimelineFromElapsed() {
    _totalElapsedSeconds = _activeElapsedMilliseconds ~/ 1000;

    if (routine.intervals.isEmpty) {
      _currentIntervalIndex = 0;
      _currentIntervalRemainingMilliseconds = 0;
      _remainingSeconds = 0;
      return;
    }

    var intervalStart = 0;
    for (var index = 0; index < routine.intervals.length; index++) {
      final intervalMilliseconds =
          routine.intervals[index].durationSeconds * 1000;
      final intervalEnd = intervalStart + intervalMilliseconds;
      if (_activeElapsedMilliseconds < intervalEnd) {
        _currentIntervalIndex = index;
        _currentIntervalRemainingMilliseconds =
            intervalEnd - _activeElapsedMilliseconds;
        _remainingSeconds =
            (_currentIntervalRemainingMilliseconds / 1000).ceil();
        return;
      }
      intervalStart = intervalEnd;
    }

    _currentIntervalIndex = routine.intervals.length - 1;
    _currentIntervalRemainingMilliseconds = 0;
    _remainingSeconds = 0;
  }

  void _finishWorkout({bool playSound = true, bool notify = true}) {
    if (_status == WorkoutStatus.finished) return;

    _activeElapsedMilliseconds = _totalDurationMilliseconds;
    _deriveTimelineFromElapsed();
    _runningAnchor = null;
    _runningRefreshTimer?.cancel();
    _runningRefreshTimer = null;
    _countdownRefreshTimer?.cancel();
    _countdownRefreshTimer = null;
    SoundService().stopSilentLoop();
    if (playSound) {
      _playFinishSfxOnce();
      Future.delayed(Duration.zero, () => _safeHaptic(HapticFeedback.vibrate));
      Future.delayed(const Duration(milliseconds: 300), () => _safeHaptic(HapticFeedback.mediumImpact));
      Future.delayed(const Duration(milliseconds: 600), () => _safeHaptic(HapticFeedback.heavyImpact));
    }
    _status = WorkoutStatus.finished;
    if (notify) notifyListeners();
  }

  void _playFinishSfxOnce() {
    if (_finishedSfxPlayed) return;
    _finishedSfxPlayed = true;
    SoundService().playFinished();
  }

  /// Reconciles the timeline with the injected/system wall clock immediately.
  /// Useful on lifecycle resume and in tests that simulate OS suspension.
  void synchronizeWithClock({bool playSounds = false}) {
    final snapshot = _now();
    if (_status == WorkoutStatus.resumingCountdown) {
      _synchronizeCountdown(snapshot, playSounds: playSounds);
    }
    if (_status == WorkoutStatus.running) {
      _synchronizeRunning(snapshot, playSounds: playSounds);
    }
  }

  /// Stops UI refresh callbacks while allowing active workout time to continue
  /// against the wall clock. The OS notification schedule owns background cues.
  void suspendForBackground() {
    if (_isBackgrounded) return;
    _isBackgrounded = true;
    synchronizeWithClock(playSounds: false);
    _runningRefreshTimer?.cancel();
    _runningRefreshTimer = null;
    _countdownRefreshTimer?.cancel();
    _countdownRefreshTimer = null;
  }

  /// Reconciles all background time and restarts foreground UI refreshes.
  void resumeFromBackground() {
    if (!_isBackgrounded) return;
    _isBackgrounded = false;
    synchronizeWithClock(playSounds: false);
    if (_status == WorkoutStatus.running) {
      _startRunningRefreshTimer();
    } else if (_status == WorkoutStatus.resumingCountdown) {
      _startCountdownRefreshTimer();
    }
  }

  void stopWorkout() {
    if (_status == WorkoutStatus.running) {
      _synchronizeRunning(_now(), playSounds: false);
      if (_status == WorkoutStatus.finished) return;
    }

    _runningRefreshTimer?.cancel();
    _runningRefreshTimer = null;
    _countdownRefreshTimer?.cancel();
    _countdownRefreshTimer = null;
    _runningAnchor = null;
    _countdownEndsAt = null;
    SoundService().stopSilentLoop();
    _playFinishSfxOnce();
    _status = WorkoutStatus.stopped;
    _stoppedEarly = true;
    notifyListeners();
  }

  void pauseWorkout() {
    if (_status != WorkoutStatus.running) return;

    _synchronizeRunning(_now(), playSounds: false);
    if (_status == WorkoutStatus.finished) return;

    _status = WorkoutStatus.paused;
    _runningAnchor = null;
    _runningRefreshTimer?.cancel();
    _runningRefreshTimer = null;
    SoundService().stopSilentLoop();
    notifyListeners();
  }

  void startInitialCountdown() {
    _isInitialCountdown = true;
    _beginCountdown();
  }

  void startResumeCountdown() {
    if (_status != WorkoutStatus.paused) return;
    _isInitialCountdown = false;
    _beginCountdown();
  }

  void _beginCountdown() {
    _status = WorkoutStatus.resumingCountdown;
    _countdownNumber = _countdownSteps;
    _countdownEndsAt = _now().add(
      Duration(
        milliseconds: _countdownStep.inMilliseconds * _countdownSteps,
      ),
    );
    _countdownRefreshTimer?.cancel();
    SoundService().playBeep();
    SoundService().startSilentLoop();
    if (!_isBackgrounded) {
      _startCountdownRefreshTimer();
    }
    notifyListeners();
  }

  void _startCountdownRefreshTimer() {
    _countdownRefreshTimer?.cancel();
    if (_status != WorkoutStatus.resumingCountdown || _isBackgrounded) return;

    _countdownRefreshTimer = Timer.periodic(_countdownRefreshRate, (_) {
      _synchronizeCountdown(_now());
    });
  }

  void _synchronizeCountdown(
    DateTime snapshotTime, {
    bool playSounds = true,
  }) {
    final endsAt = _countdownEndsAt;
    if (_status != WorkoutStatus.resumingCountdown || endsAt == null) return;

    final remainingMilliseconds =
        endsAt.difference(snapshotTime).inMilliseconds;
    if (remainingMilliseconds <= 0) {
      _startRunningAt(endsAt);
      _synchronizeRunning(
        snapshotTime,
        playSounds: playSounds,
      );
      if (_status == WorkoutStatus.running && snapshotTime == endsAt) {
        notifyListeners();
      }
      return;
    }

    final nextNumber = (remainingMilliseconds / _countdownStep.inMilliseconds)
        .ceil()
        .clamp(1, _countdownSteps);
    if (nextNumber == _countdownNumber) return;

    _countdownNumber = nextNumber;
    if (playSounds) {
      SoundService().playBeep();
      _safeHaptic(HapticFeedback.mediumImpact);
    }
    notifyListeners();
  }

  void resumeWorkout() {
    startResumeCountdown();
  }

  @override
  void dispose() {
    _runningRefreshTimer?.cancel();
    _countdownRefreshTimer?.cancel();
    super.dispose();
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String formatTotalTime(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _safeHaptic(Future<void> Function() hapticAction) {
    try {
      hapticAction().catchError((_) {
        // Fail silently in tests
      });
    } catch (_) {
      // Ignored in unit tests or platform exceptions
    }
  }
}
