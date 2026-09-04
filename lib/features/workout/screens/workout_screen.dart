import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart' hide Interval;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:valcue/l10n/app_localizations.dart';
import 'package:valcue/l10n/localized_format.dart';
import '../../routines/models/routine.dart';
import '../../routines/models/machine_type.dart';
import '../../../app_settings/app_settings_provider.dart';
import '../../../utils/app_shadows.dart';
import '../../../widgets/bidi_safe_text.dart';
import '../../../theme/app_theme.dart';
import '../state/workout_state.dart';
import '../widgets/flashing_metric_text.dart';
import 'workout_finished_screen.dart';
import '../../../widgets/secondary_outlined_button.dart';
import '../../../services/voice_guide_service.dart';
import '../../../services/firebase_workout_live_activity_schedule_backend.dart';
import '../../../services/workout_interval_notification_planner.dart';
import '../../../services/workout_live_activity_payload_builder.dart';
import '../../../services/workout_live_activity_schedule_backend.dart';
import '../../../services/workout_live_activity_schedule_coordinator.dart';
import '../../../services/workout_live_activity_schedule_models.dart';
import '../../../services/workout_live_activity_schedule_planner.dart';
import '../../../services/workout_live_activity_service.dart';
import '../../../services/workout_reminder_service.dart';
import '../../../services/analytics_service.dart';

class WorkoutScreen extends StatefulWidget {
  final Routine routine;
  final bool backgroundNotificationsAuthorized;
  final WorkoutLiveActivityScheduleBackend? liveActivityScheduleBackend;
  final DateTime Function()? nowProvider;
  final Duration? previewElapsed;

  const WorkoutScreen({
    super.key,
    required this.routine,
    this.backgroundNotificationsAuthorized = false,
    this.liveActivityScheduleBackend,
    this.nowProvider,
    this.previewElapsed,
  });

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen>
    with WidgetsBindingObserver {
  static const int _maxLiveActivityStartRetries = 1;
  // Refresh token-rotation uploads from the current workout timeline instead
  // of keeping already elapsed boundaries for the full eight-hour window.
  static const Duration _remoteScheduleRefreshAge = Duration(minutes: 4);

  late WorkoutState _workoutState;
  late final DateTime Function() _now;
  bool _pauseSheetOpen = false;
  bool _endConfirmOpen = false;
  bool _hasNavigatedToFinished = false;
  bool _hasLoggedWorkoutCompletion = false;
  bool _hasLoggedWorkoutStop = false;
  bool _isCountdownActive = false;
  bool _isLandscapeMode = false;
  int _lastSpokenIntervalIndex = -1;
  int? _lastSpokenCountdownSecond;
  int _lastSpokenCountdownIntervalIndex = -1;
  bool _suppressIntervalGuidanceOnResume = false;
  bool _isSpeakingIntervalInfo =
      false; // Prevent countdown during interval speech
  late final bool _notificationsAuthorized;
  bool _backgroundLifecycleHandled = false;
  bool _liveActivityStarted = false;
  bool _liveActivityEnded = false;
  bool _liveActivityInitializing = false;
  bool _retryLiveActivityInitialization = false;
  bool _isReconcilingLiveActivityFromBackground = false;
  int _liveActivityStartRetryCount = 0;
  String? _lastLiveActivitySignature;
  String? _finishedLiveActivityStatusText;
  Map<String, dynamic>? _lastLiveActivityPayload;
  Future<void> _liveActivityCommandQueue = Future<void>.value();
  late final String _workoutSessionId;
  late final WorkoutLiveActivityScheduleCoordinator
      _liveActivityScheduleCoordinator;
  StreamSubscription<WorkoutLiveActivityNativeEvent>?
      _liveActivityNativeEventsSubscription;
  AppSettingsProvider? _observedSettingsProvider;
  bool? _lastRemoteScheduleFeatureEnabled;
  String? _lastRemoteScheduleTransition;

  @override
  void initState() {
    super.initState();
    if (widget.previewElapsed == null) {
      WidgetsBinding.instance.addObserver(this);
    }
    _notificationsAuthorized = widget.backgroundNotificationsAuthorized;
    _now = widget.nowProvider ?? DateTime.now;
    _workoutState = WorkoutState(
      routine: widget.routine,
      startTime: _now(),
      nowProvider: _now,
      isPreview: widget.previewElapsed != null,
    );
    if (widget.previewElapsed != null) {
      _workoutState.setPreviewElapsed(widget.previewElapsed!);
    }
    _workoutState.addListener(_onWorkoutStateChanged);
    if (widget.previewElapsed == null) {
      AnalyticsService.instance.logEvent(
        'workout_started',
        {
          'machine_type': widget.routine.machineType.name,
          'duration_seconds': widget.routine.totalDurationSeconds,
          'interval_count': widget.routine.intervals.length,
        },
      );
    }
    _workoutSessionId = generateWorkoutLiveActivitySessionId();
    _liveActivityScheduleCoordinator = WorkoutLiveActivityScheduleCoordinator(
      sessionId: _workoutSessionId,
      backend: widget.liveActivityScheduleBackend ??
          FirebaseWorkoutLiveActivityScheduleBackend(),
      nowProvider: _now,
    );
    if (widget.previewElapsed == null) {
      _liveActivityNativeEventsSubscription =
          WorkoutLiveActivityService.instance.events.listen(
        _handleLiveActivityNativeEvent,
        onError: (Object _, StackTrace __) {},
      );
    }

    // Keep screen awake
    if (widget.previewElapsed == null) {
      WakelockPlus.enable();
    }

    // Lock orientation initially
    if (widget.previewElapsed == null) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }

    if (widget.previewElapsed == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _applyRemoteScheduleForCurrentState(force: true);
        unawaited(_refreshNativePushRegistrations());
        _requestLiveActivityInitialization();
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.previewElapsed != null) return;
    final provider = Provider.of<AppSettingsProvider>(context, listen: false);
    if (identical(provider, _observedSettingsProvider)) return;

    _observedSettingsProvider?.removeListener(_onAppSettingsChanged);
    _observedSettingsProvider = provider;
    _lastRemoteScheduleFeatureEnabled =
        _isRemoteScheduleFeatureEnabled(provider);
    provider.addListener(_onAppSettingsChanged);
  }

  @override
  void dispose() {
    if (widget.previewElapsed == null) {
      WidgetsBinding.instance.removeObserver(this);
    }
    _observedSettingsProvider?.removeListener(_onAppSettingsChanged);
    unawaited(_liveActivityNativeEventsSubscription?.cancel());
    if (widget.previewElapsed == null &&
        !_liveActivityScheduleCoordinator.isTerminal) {
      unawaited(
        _liveActivityScheduleCoordinator.cancel(
          WorkoutLiveActivityScheduleCancelReason.disposed,
          terminal: true,
        ),
      );
    }
    _liveActivityScheduleCoordinator.dispose();
    if (widget.previewElapsed == null) {
      unawaited(
        WorkoutReminderService.instance.cancelWorkoutIntervalNotifications(),
      );
      _endLiveActivityFromDispose();
    }
    _workoutState.removeListener(_onWorkoutStateChanged);
    _workoutState.dispose();

    // Release wakelock
    if (widget.previewElapsed == null) {
      WakelockPlus.disable();
    }

    // Reset orientation back to the app-wide portrait-only default
    if (widget.previewElapsed == null) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.previewElapsed != null) return;
    switch (state) {
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        if (_backgroundLifecycleHandled) return;
        _backgroundLifecycleHandled = true;
        VoiceGuideService.instance.stop();
        _workoutState.suspendForBackground();
        unawaited(_liveActivityScheduleCoordinator.reconcile());
        unawaited(_scheduleBackgroundWorkoutNotifications());
        break;
      case AppLifecycleState.resumed:
        _liveActivityStartRetryCount = 0;
        unawaited(
          WorkoutReminderService.instance.cancelWorkoutIntervalNotifications(),
        );
        if (!_backgroundLifecycleHandled) {
          _requestLiveActivityInitialization();
          return;
        }
        _backgroundLifecycleHandled = false;
        // Do not replay a voice cue that the background notification already
        // delivered while reconciling possibly several elapsed intervals.
        _suppressIntervalGuidanceOnResume = true;
        _isReconcilingLiveActivityFromBackground = true;
        try {
          _workoutState.resumeFromBackground();
        } finally {
          _isReconcilingLiveActivityFromBackground = false;
          _suppressIntervalGuidanceOnResume = false;
        }
        _lastSpokenIntervalIndex = _workoutState.currentIntervalIndex;
        if (_liveActivityScheduleCoordinator.desiredPlan?.isActive == true &&
            !_liveActivityScheduleCoordinator.isDesiredStateAcknowledged) {
          // An upload may have been waiting for a token/network while interval
          // boundaries elapsed. Rebuild from the reconciled current timeline.
          _applyRemoteScheduleForCurrentState(force: true);
        } else {
          unawaited(_liveActivityScheduleCoordinator.reconcile());
        }
        unawaited(_refreshNativePushRegistrations());
        if (_liveActivityStarted) {
          // State reconciliation callbacks are suppressed above, so this is
          // the single ActivityKit update for the foreground resume.
          _syncLiveActivity(force: true);
        } else {
          // Native start is allowed only while UIApplication is active. Retry
          // if the user left while the initial capability checks were pending.
          _requestLiveActivityInitialization();
        }
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  Future<void> _scheduleBackgroundWorkoutNotifications() async {
    if (!mounted) return;

    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final service = WorkoutReminderService.instance;
    if (!settingsProvider.isPremium ||
        !settingsProvider.backgroundIntervalNotificationsEnabled ||
        !_notificationsAuthorized) {
      await service.cancelWorkoutIntervalNotifications();
      return;
    }

    final state = _workoutState;
    late final int firstIntervalIndex;
    late final Duration delayUntilFirstInterval;
    switch (state.status) {
      case WorkoutStatus.running:
        firstIntervalIndex = state.currentIntervalIndex + 1;
        delayUntilFirstInterval = state.currentIntervalRemainingDuration;
        break;
      case WorkoutStatus.resumingCountdown:
        if (state.isInitialCountdown) {
          firstIntervalIndex = state.currentIntervalIndex;
          delayUntilFirstInterval = state.countdownRemainingDuration;
        } else {
          // Resuming the same section is not a new interval, so the first alert
          // remains the next actual boundary after countdown + remaining time.
          firstIntervalIndex = state.currentIntervalIndex + 1;
          delayUntilFirstInterval = state.countdownRemainingDuration +
              state.currentIntervalRemainingDuration;
        }
        break;
      case WorkoutStatus.paused:
      case WorkoutStatus.finished:
      case WorkoutStatus.stopped:
        await service.cancelWorkoutIntervalNotifications();
        return;
    }

    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final notifications = WorkoutIntervalNotificationPlanner.build(
      routine: widget.routine,
      firstIntervalIndex: firstIntervalIndex,
      delayUntilFirstInterval: delayUntilFirstInterval,
      measurement: settingsProvider.measurement,
      languageCode: settingsProvider.language,
      labels: WorkoutNotificationLabels(
        newInterval: l10n.backgroundIntervalNotificationTitle,
        workoutComplete: l10n.workoutComplete,
        speed: l10n.speed,
        incline: l10n.incline,
        resistance: l10n.resistance,
        level: l10n.level,
        duration: l10n.duration,
        inclineValueTemplate: l10n.inclineValue('{value}'),
        rpmValueTemplate: l10n.rpmValue('{value}'),
        resistanceValueTemplate: l10n.resistanceColon('{value}'),
        levelValueTemplate: l10n.levelColon('{value}'),
      ),
    );
    await service.scheduleWorkoutIntervalNotifications(
      notifications: notifications,
      routineId: widget.routine.id,
      languageCode: settingsProvider.language,
    );
  }

  bool _isRemoteScheduleFeatureEnabled(AppSettingsProvider provider) {
    if (widget.routine.intervals.isEmpty ||
        _workoutState.status == WorkoutStatus.finished ||
        _workoutState.status == WorkoutStatus.stopped) {
      return false;
    }
    return provider.isPremium &&
        provider.backgroundIntervalNotificationsEnabled;
  }

  void _onAppSettingsChanged() {
    if (!mounted) return;
    final provider = _observedSettingsProvider;
    if (provider == null) return;

    final enabled = _isRemoteScheduleFeatureEnabled(provider);
    if (_lastRemoteScheduleFeatureEnabled == enabled) return;
    _lastRemoteScheduleFeatureEnabled = enabled;

    if (enabled) {
      _lastRemoteScheduleTransition = null;
      _applyRemoteScheduleForCurrentState(force: true);
      _requestLiveActivityInitialization();
      return;
    }

    final reason = provider.isPremium
        ? WorkoutLiveActivityScheduleCancelReason.featureDisabled
        : WorkoutLiveActivityScheduleCancelReason.premiumRevoked;
    unawaited(
      _liveActivityScheduleCoordinator.cancel(reason, terminal: true),
    );
    unawaited(
      WorkoutReminderService.instance.cancelWorkoutIntervalNotifications(),
    );
    _syncLiveActivity();
  }

  void _handleLiveActivityNativeEvent(
    WorkoutLiveActivityNativeEvent event,
  ) {
    unawaited(_processLiveActivityNativeEvent(event));
  }

  Future<void> _processLiveActivityNativeEvent(
    WorkoutLiveActivityNativeEvent event,
  ) async {
    if (event.workoutSessionId != _workoutSessionId ||
        event.activityId.isEmpty) {
      return;
    }

    switch (event.type) {
      case WorkoutLiveActivityNativeEventType.activityStarted:
        await _liveActivityScheduleCoordinator.attachActivity(
          sessionId: event.workoutSessionId,
          activityId: event.activityId,
        );
        break;
      case WorkoutLiveActivityNativeEventType.activitySnapshot:
        await _liveActivityScheduleCoordinator.attachActivity(
          sessionId: event.workoutSessionId,
          activityId: event.activityId,
        );
        await _applyPushTokenEvent(event);
        break;
      case WorkoutLiveActivityNativeEventType.pushToken:
        // A token can beat the start method result. The coordinator buffers it
        // by activity ID until attachActivity joins the other half.
        await _applyPushTokenEvent(event);
        break;
      case WorkoutLiveActivityNativeEventType.pushTokenInvalidated:
        final attachedActivityId = _liveActivityScheduleCoordinator.activityId;
        if (attachedActivityId == null ||
            attachedActivityId == event.activityId) {
          await _liveActivityScheduleCoordinator.cancel(
            WorkoutLiveActivityScheduleCancelReason.staleSession,
            terminal: true,
          );
        }
        break;
      case WorkoutLiveActivityNativeEventType.activityState:
        if (event.activityState == 'ended' ||
            event.activityState == 'dismissed') {
          final attachedActivityId =
              _liveActivityScheduleCoordinator.activityId;
          if (attachedActivityId != null &&
              attachedActivityId != event.activityId) {
            break;
          }
          await _liveActivityScheduleCoordinator.cancel(
            WorkoutLiveActivityScheduleCancelReason.staleSession,
            terminal: true,
          );
        }
        break;
      case WorkoutLiveActivityNativeEventType.unknown:
        break;
    }
  }

  Future<void> _applyPushTokenEvent(
    WorkoutLiveActivityNativeEvent event,
  ) async {
    final token = event.tokenHex;
    final environment = _remotePushEnvironment(event.environment);
    if (token == null || token.isEmpty || environment == null) return;

    final desiredPlan = _liveActivityScheduleCoordinator.desiredPlan;
    final isNewerToken =
        event.tokenVersion > _liveActivityScheduleCoordinator.tokenVersion;
    final shouldRefreshPlan = mounted &&
        !_liveActivityScheduleCoordinator.isTerminal &&
        isNewerToken &&
        desiredPlan != null &&
        desiredPlan.isActive &&
        _now().difference(desiredPlan.generatedAt) >=
            _remoteScheduleRefreshAge &&
        _isLiveActivityFeatureEnabled;

    // Store and upload the rotated token first. Any subsequent fresh-plan
    // registration then uses only the new bearer token, even if its first
    // network attempt fails or an interval boundary is due concurrently.
    await _liveActivityScheduleCoordinator.updatePushToken(
      sessionId: event.workoutSessionId,
      activityId: event.activityId,
      pushToken: token,
      tokenVersion: event.tokenVersion,
      environment: environment,
    );

    if (shouldRefreshPlan &&
        mounted &&
        !_liveActivityScheduleCoordinator.isTerminal &&
        _isLiveActivityFeatureEnabled) {
      await _liveActivityScheduleCoordinator.applyPlan(
        _buildRemoteSchedulePlan(),
      );
    }
  }

  WorkoutLiveActivityPushEnvironment? _remotePushEnvironment(String value) {
    return switch (value) {
      'sandbox' => WorkoutLiveActivityPushEnvironment.sandbox,
      'production' => WorkoutLiveActivityPushEnvironment.production,
      _ => null,
    };
  }

  Future<void> _refreshNativePushRegistrations() async {
    final registrations =
        await WorkoutLiveActivityService.instance.getPushRegistrations();
    for (final registration in registrations) {
      await _processLiveActivityNativeEvent(registration);
    }
  }

  void _applyRemoteScheduleForCurrentState({bool force = false}) {
    if (!mounted || widget.routine.intervals.isEmpty) return;

    final state = _workoutState;
    final isTerminal = state.status == WorkoutStatus.finished ||
        state.status == WorkoutStatus.stopped;
    if (!isTerminal && !_isLiveActivityFeatureEnabled) return;
    if (isTerminal && _liveActivityScheduleCoordinator.isTerminal) return;

    final transition = '${state.status.name}:${state.isInitialCountdown}';
    if (!force && transition == _lastRemoteScheduleTransition) return;
    _lastRemoteScheduleTransition = transition;

    // The initial/resume plans already contain all later interval boundaries.
    // Foreground ticks and running interval changes must not churn revisions.
    if (!force && state.status == WorkoutStatus.running) return;
    if (!force &&
        state.status == WorkoutStatus.resumingCountdown &&
        state.isInitialCountdown) {
      return;
    }

    unawaited(
      _liveActivityScheduleCoordinator.applyPlan(
        _buildRemoteSchedulePlan(),
      ),
    );
  }

  WorkoutLiveActivitySchedulePlan _buildRemoteSchedulePlan() {
    final state = _workoutState;
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final capturedAt = _now();
    final machineName = switch (widget.routine.machineType) {
      MachineType.treadmill => l10n.treadmill,
      MachineType.cycle => l10n.cycle,
      MachineType.stairmaster => l10n.stairmaster,
    };
    final phase = switch (state.status) {
      WorkoutStatus.resumingCountdown => state.isInitialCountdown
          ? WorkoutLiveActivitySchedulePhase.initialCountdown
          : WorkoutLiveActivitySchedulePhase.resumeCountdown,
      WorkoutStatus.running => WorkoutLiveActivitySchedulePhase.running,
      WorkoutStatus.paused => WorkoutLiveActivitySchedulePhase.paused,
      WorkoutStatus.finished => WorkoutLiveActivitySchedulePhase.finished,
      WorkoutStatus.stopped => WorkoutLiveActivitySchedulePhase.stopped,
    };

    return WorkoutLiveActivitySchedulePlanner.build(
      WorkoutLiveActivityScheduleSnapshot(
        routine: widget.routine,
        phase: phase,
        currentIntervalIndex: state.currentIntervalIndex,
        currentIntervalRemaining: state.currentIntervalRemainingDuration,
        totalRemaining: state.totalRemainingDuration,
        countdownRemaining: state.countdownRemainingDuration,
        progress: state.totalWorkoutProgress,
        measurement: settingsProvider.measurement,
        locale: settingsProvider.locale.toLanguageTag(),
        capturedAt: capturedAt,
        labels: WorkoutLiveActivityScheduleLabels(
          machineName: machineName,
          preparingStatusText: l10n.liveActivityPreparing,
          runningStatusText: l10n.liveActivityInProgress,
          finishedStatusText: l10n.workoutComplete,
          intervalText: (current, total) => l10n.liveActivityIntervalFormat(
            LocalizedFormat.decimal(context, current, decimalDigits: 0),
            LocalizedFormat.decimal(context, total, decimalDigits: 0),
          ),
          durationText: (durationSeconds) {
            final formatted = WorkoutIntervalNotificationPlanner.formatDuration(
              durationSeconds,
              settingsProvider.language,
            );
            return l10n.liveActivityDurationFormat(formatted);
          },
          speedLabel: l10n.speed,
          inclineLabel: l10n.incline,
          resistanceLabel: l10n.resistance,
          levelLabel: l10n.level,
          inclineValueTemplate: l10n.inclineValue('{value}'),
          rpmValueTemplate: l10n.rpmValue('{value}'),
          resistanceValueTemplate: l10n.resistanceColon('{value}'),
          levelValueTemplate: l10n.levelColon('{value}'),
        ),
      ),
    );
  }

  void _requestLiveActivityInitialization() {
    if (!mounted ||
        _liveActivityStarted ||
        _liveActivityEnded ||
        widget.routine.intervals.isEmpty) {
      return;
    }

    if (_liveActivityInitializing) {
      _retryLiveActivityInitialization = true;
      return;
    }

    unawaited(_initializeLiveActivity());
  }

  bool get _isApplicationResumed {
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    return lifecycle == null || lifecycle == AppLifecycleState.resumed;
  }

  bool get _isLiveActivityFeatureEnabled {
    if (!mounted || widget.routine.intervals.isEmpty) return false;
    if (_workoutState.status == WorkoutStatus.finished ||
        _workoutState.status == WorkoutStatus.stopped) {
      return false;
    }

    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    return settingsProvider.isPremium &&
        settingsProvider.backgroundIntervalNotificationsEnabled;
  }

  bool get _canInitializeLiveActivity =>
      !_liveActivityStarted &&
      !_liveActivityEnded &&
      _isApplicationResumed &&
      _isLiveActivityFeatureEnabled;

  Future<void> _initializeLiveActivity() async {
    if (_liveActivityInitializing) {
      _retryLiveActivityInitialization = true;
      return;
    }

    _liveActivityInitializing = true;
    try {
      if (!_canInitializeLiveActivity) return;

      final service = WorkoutLiveActivityService.instance;
      final supported = await service.isSupported();
      if (!supported || !_canInitializeLiveActivity) return;

      final enabled = await service.areActivitiesEnabled();
      if (!enabled || !_canInitializeLiveActivity) return;
      if (!mounted) return;

      // Capture both immediately before start. Absolute deadlines stay valid
      // if native startup takes a moment.
      final payload = _buildLiveActivityPayload();
      final signature = _liveActivitySignature;
      final finishedStatusText = AppLocalizations.of(context)!.workoutComplete;
      _finishedLiveActivityStatusText = finishedStatusText;

      // Premium or the feature may have changed while capability calls were in
      // flight. Recheck at the last possible point before creating the native
      // activity.
      if (!_canInitializeLiveActivity) return;
      final startResult = await service.startSession(payload);
      final started = startResult.started &&
          startResult.activityId.isNotEmpty &&
          startResult.workoutSessionId == _workoutSessionId;
      if (!started) {
        if (_isApplicationResumed &&
            _isLiveActivityFeatureEnabled &&
            _liveActivityStartRetryCount < _maxLiveActivityStartRetries) {
          _liveActivityStartRetryCount++;
          _retryLiveActivityInitialization = true;
        }
        return;
      }

      final finishedPayload = _finishedLiveActivityPayload(
        payload,
        statusText: finishedStatusText,
      );
      if (!mounted) {
        await service.end(<String, dynamic>{
          ...finishedPayload,
          'dismissImmediately': true,
        });
        return;
      }

      // cleanup() may have run while native start was pending. Never allow a
      // late result to recreate a disabled or non-premium activity.
      if (!_isLiveActivityFeatureEnabled) {
        await service.end(<String, dynamic>{
          ...finishedPayload,
          'dismissImmediately': true,
        });
        return;
      }

      _liveActivityStarted = true;
      _liveActivityStartRetryCount = 0;
      _lastLiveActivityPayload = payload;
      _lastLiveActivitySignature = signature;
      await _liveActivityScheduleCoordinator.attachActivity(
        sessionId: startResult.workoutSessionId,
        activityId: startResult.activityId,
      );
      unawaited(_refreshNativePushRegistrations());

      // Avoid an unconditional start+update pair. Only catch up if the status
      // or interval actually changed while awaiting ActivityKit.
      if (_liveActivitySignature != signature) {
        _syncLiveActivity();
      }
    } finally {
      _liveActivityInitializing = false;
      final shouldRetry = _retryLiveActivityInitialization;
      _retryLiveActivityInitialization = false;
      if (shouldRetry &&
          mounted &&
          !_liveActivityStarted &&
          !_liveActivityEnded &&
          _isApplicationResumed) {
        scheduleMicrotask(_requestLiveActivityInitialization);
      }
    }
  }

  void _syncLiveActivity({bool force = false}) {
    if (!_liveActivityStarted || _liveActivityEnded || !mounted) return;

    if (!_isLiveActivityFeatureEnabled) {
      _liveActivityStarted = false;
      _liveActivityEnded = true;
      _queueLiveActivityCommand(
        WorkoutLiveActivityService.instance.cleanup,
      );
      return;
    }

    final status = _workoutState.status;
    if (status == WorkoutStatus.finished || status == WorkoutStatus.stopped) {
      _endLiveActivity();
      return;
    }

    final signature = _liveActivitySignature;
    if (!force && signature == _lastLiveActivitySignature) return;

    final payload = _buildLiveActivityPayload();
    _lastLiveActivitySignature = signature;
    _lastLiveActivityPayload = payload;
    _queueLiveActivityCommand(
      () => WorkoutLiveActivityService.instance.update(payload),
    );
  }

  void _endLiveActivity() {
    if (!_liveActivityStarted || _liveActivityEnded) return;
    _liveActivityEnded = true;

    final payload = mounted
        ? _buildLiveActivityPayload(forceFinished: true)
        : _finishedLiveActivityPayload(_lastLiveActivityPayload);
    if (_workoutState.status == WorkoutStatus.stopped) {
      payload['dismissImmediately'] = true;
    } else {
      payload['dismissalDelaySeconds'] = 60;
    }
    _lastLiveActivityPayload = payload;
    _queueLiveActivityCommand(
      () => WorkoutLiveActivityService.instance.end(payload),
    );
  }

  void _endLiveActivityFromDispose() {
    if (!_liveActivityStarted || _liveActivityEnded) return;
    _liveActivityEnded = true;
    final payload = <String, dynamic>{
      ..._finishedLiveActivityPayload(_lastLiveActivityPayload),
      'dismissImmediately': true,
    };
    _lastLiveActivityPayload = payload;
    _queueLiveActivityCommand(
      () => WorkoutLiveActivityService.instance.end(payload),
    );
  }

  void _queueLiveActivityCommand(Future<void> Function() command) {
    _liveActivityCommandQueue = _liveActivityCommandQueue
        .catchError((Object _) {})
        .then((_) => command());
  }

  Map<String, dynamic> _buildLiveActivityPayload({
    bool forceFinished = false,
  }) {
    final state = _workoutState;
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;
    final phase = forceFinished
        ? WorkoutLiveActivityPhase.finished
        : _liveActivityPhaseFor(state.status);
    final machineName = switch (widget.routine.machineType) {
      MachineType.treadmill => l10n.treadmill,
      MachineType.cycle => l10n.cycle,
      MachineType.stairmaster => l10n.stairmaster,
    };
    final statusText = switch (phase) {
      WorkoutLiveActivityPhase.preparing => l10n.liveActivityPreparing,
      WorkoutLiveActivityPhase.running => l10n.liveActivityInProgress,
      WorkoutLiveActivityPhase.paused => l10n.paused,
      WorkoutLiveActivityPhase.finished => state.status == WorkoutStatus.stopped
          ? l10n.endWorkout
          : l10n.workoutComplete,
    };
    final interval = state.currentInterval;
    final formattedDuration = WorkoutIntervalNotificationPlanner.formatDuration(
      interval.durationSeconds,
      settingsProvider.language,
    );

    return <String, dynamic>{
      ...WorkoutLiveActivityPayloadBuilder.build(
        routine: widget.routine,
        intervalIndex: state.currentIntervalIndex,
        phase: phase,
        intervalRemaining: state.currentIntervalRemainingDuration,
        totalRemaining: state.totalRemainingDuration,
        countdownRemaining: state.countdownRemainingDuration,
        progress: state.totalWorkoutProgress,
        measurement: settingsProvider.measurement,
        locale: settingsProvider.locale.toLanguageTag(),
        now: _now(),
        machineName: machineName,
        statusText: statusText,
        intervalText: l10n.liveActivityIntervalFormat(
          LocalizedFormat.decimal(
            context,
            state.currentIntervalIndex + 1,
            decimalDigits: 0,
          ),
          LocalizedFormat.decimal(
            context,
            state.totalIntervals,
            decimalDigits: 0,
          ),
        ),
        durationText: l10n.liveActivityDurationFormat(formattedDuration),
        speedLabel: l10n.speed,
        inclineLabel: l10n.incline,
        resistanceLabel: l10n.resistance,
        levelLabel: l10n.level,
        inclineValueTemplate: l10n.inclineValue('{value}'),
        rpmValueTemplate: l10n.rpmValue('{value}'),
        resistanceValueTemplate: l10n.resistanceColon('{value}'),
        levelValueTemplate: l10n.levelColon('{value}'),
      ),
      'workoutSessionId': _workoutSessionId,
    };
  }

  Map<String, dynamic> _finishedLiveActivityPayload(
    Map<String, dynamic>? source, {
    String? statusText,
  }) {
    return <String, dynamic>{
      ...?source,
      'status': WorkoutLiveActivityPhase.finished.name,
      'statusText': statusText ??
          _finishedLiveActivityStatusText ??
          source?['statusText'] ??
          '',
      'timerEndAtMs': 0,
      'workoutEndAtMs': 0,
      'progress': _workoutState.status == WorkoutStatus.finished
          ? 1.0
          : (source?['progress'] ?? 0.0),
    };
  }

  WorkoutLiveActivityPhase _liveActivityPhaseFor(WorkoutStatus status) {
    switch (status) {
      case WorkoutStatus.resumingCountdown:
        return WorkoutLiveActivityPhase.preparing;
      case WorkoutStatus.running:
        return WorkoutLiveActivityPhase.running;
      case WorkoutStatus.paused:
        return WorkoutLiveActivityPhase.paused;
      case WorkoutStatus.finished:
      case WorkoutStatus.stopped:
        return WorkoutLiveActivityPhase.finished;
    }
  }

  String get _liveActivitySignature {
    final state = _workoutState;
    final intervalRemainingMs =
        state.currentIntervalRemainingDuration.inMilliseconds;
    final totalRemainingMs = state.totalRemainingDuration.inMilliseconds;
    final progressBucket = (state.totalWorkoutProgress * 1000).round();
    return '${state.status.name}:${state.currentIntervalIndex}:'
        '${state.isInitialCountdown}:$intervalRemainingMs:'
        '$totalRemainingMs:$progressBucket';
  }

  void _onWorkoutStateChanged() {
    final status = _workoutState.status;
    _applyRemoteScheduleForCurrentState();

    if (status == WorkoutStatus.finished && !_hasLoggedWorkoutCompletion) {
      _hasLoggedWorkoutCompletion = true;
      AnalyticsService.instance.logEvent(
        'workout_completed',
        {
          'machine_type': widget.routine.machineType.name,
          'elapsed_seconds': _workoutState.roundedElapsedSeconds,
          'interval_count': widget.routine.intervals.length,
        },
      );
    }

    if (status == WorkoutStatus.stopped && !_hasLoggedWorkoutStop) {
      _hasLoggedWorkoutStop = true;
      AnalyticsService.instance.logEvent(
        'workout_stopped',
        {
          'machine_type': widget.routine.machineType.name,
          'elapsed_seconds': _workoutState.roundedElapsedSeconds,
          'interval_index': _workoutState.currentIntervalIndex,
          'interval_count': widget.routine.intervals.length,
        },
      );
    }

    // Stop immediately when paused/stopped/finished to avoid lingering speech.
    if (status == WorkoutStatus.paused ||
        status == WorkoutStatus.stopped ||
        status == WorkoutStatus.finished) {
      VoiceGuideService.instance.stop();
    }

    if (_workoutState.status == WorkoutStatus.finished ||
        _workoutState.status == WorkoutStatus.stopped) {
      _endLiveActivity();
      unawaited(
        WorkoutReminderService.instance.cancelWorkoutIntervalNotifications(),
      );
      _navigateToFinished();
    } else if (_workoutState.status == WorkoutStatus.running &&
        _isCountdownActive) {
      // Countdown finished, reset flag
      _isCountdownActive = false;
      // If this running transition came from "resume countdown", do NOT
      // re-announce the current session just because user resumed.
      if (_suppressIntervalGuidanceOnResume) {
        _suppressIntervalGuidanceOnResume = false;
      }
    }

    // Voice guide triggers during running only (never during countdown overlay).
    if (status == WorkoutStatus.running) {
      if (!_suppressIntervalGuidanceOnResume) {
        _maybeSpeakIntervalGuidance();
      }
      // Only speak countdown if not currently speaking interval info
      if (!_isSpeakingIntervalInfo) {
        _maybeSpeakCountdownGuidance();
      }
    }

    if (status != WorkoutStatus.finished &&
        status != WorkoutStatus.stopped &&
        !_isReconcilingLiveActivityFromBackground) {
      _syncLiveActivity();
    }

    // Note: Pause sheet is shown in _pauseWorkout(), not here, to avoid duplication
  }

  void _maybeSpeakCountdownGuidance() {
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final sec = _workoutState.remainingSeconds;
    final targets = settingsProvider.voiceGuideCountdownTriggers;
    if (!targets.contains(sec)) return;

    final idx = _workoutState.currentIntervalIndex;
    if (_lastSpokenCountdownIntervalIndex == idx &&
        _lastSpokenCountdownSecond == sec) {
      return;
    }

    _lastSpokenCountdownIntervalIndex = idx;
    _lastSpokenCountdownSecond = sec;

    VoiceGuideService.instance.speakCountdown(sec);
    HapticFeedback.lightImpact();
  }

  void _maybeSpeakIntervalGuidance() {
    final idx = _workoutState.currentIntervalIndex;
    if (_lastSpokenIntervalIndex == idx) return;
    _lastSpokenIntervalIndex = idx;

    // Reset countdown counter when new interval starts
    _lastSpokenCountdownIntervalIndex = -1;
    _lastSpokenCountdownSecond = null;

    final interval = _workoutState.currentInterval;

    // Delay to let beep sound play first (beep happens in WorkoutState when interval changes)
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted || _workoutState.currentIntervalIndex != idx) return;
      if (_workoutState.status != WorkoutStatus.running) return;

      switch (widget.routine.machineType) {
        case MachineType.treadmill:
          final settingsProvider =
              Provider.of<AppSettingsProvider>(context, listen: false);

          final speedKmh = interval.speedKmh ?? 0.0;
          // Match the UI unit setting: speak mph if measurement is mph.
          final speed = settingsProvider.measurement == 'mph'
              ? (speedKmh * 0.621371)
              : speedKmh;
          final incline = interval.grade ?? 0.0;

          // Speak speed and incline together in one sentence
          _isSpeakingIntervalInfo = true;
          VoiceGuideService.instance
              .speakSpeedAndIncline(
            speed,
            incline,
            measurement: settingsProvider.measurement,
          )
              .then((_) {
            Future.delayed(const Duration(milliseconds: 300), () {
              _isSpeakingIntervalInfo = false;
            });
          });
          break;

        case MachineType.cycle:
          // Cycle has both resistance (treated as level) and RPM.
          final resistance = interval.resistance ?? 0;
          final rpm = interval.rpm ?? 0;

          // Speak level and RPM together in one sentence
          _isSpeakingIntervalInfo = true;
          VoiceGuideService.instance
              .speakLevelAndRpm(resistance, rpm)
              .then((_) {
            Future.delayed(const Duration(milliseconds: 300), () {
              _isSpeakingIntervalInfo = false;
            });
          });
          break;

        case MachineType.stairmaster:
          final level = interval.level ?? 0;
          _isSpeakingIntervalInfo = true;
          VoiceGuideService.instance.speakLevel(level).then((_) {
            Future.delayed(const Duration(milliseconds: 300), () {
              _isSpeakingIntervalInfo = false;
            });
          });
          break;
      }
    });
  }

  void _navigateToFinished() {
    if (_hasNavigatedToFinished || !mounted) {
      return;
    }
    _hasNavigatedToFinished = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => WorkoutFinishedScreen(
          routine: widget.routine,
          elapsedSeconds: _workoutState.roundedElapsedSeconds,
          elapsedMilliseconds: _workoutState.totalElapsedMilliseconds,
          finishTime: DateTime.now(),
          distanceMeters:
              _workoutState.isTreadmill ? _workoutState.distanceMeters : null,
          currentIntervalIndex: _workoutState.currentIntervalIndex,
          elapsedSecondsInCurrentSession:
              _workoutState.currentIntervalElapsedSeconds,
        ),
      ),
    );
  }

  void _toggleOrientation() {
    // Toggle between portrait and landscape mode
    if (_isLandscapeMode) {
      // Switch back to portrait mode
      _isLandscapeMode = false;
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    } else {
      // Switch to landscape mode
      _isLandscapeMode = true;
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  void _pauseWorkout(WorkoutState state) {
    // Guard: prevent duplicate sheets
    if (_pauseSheetOpen) {
      return;
    }

    state.pauseWorkout();
    unawaited(
      WorkoutReminderService.instance.cancelWorkoutIntervalNotifications(),
    );
    _showPauseSheet(state);
  }

  void _showPauseSheet(WorkoutState state) {
    // Guard: prevent duplicate sheets
    if (_pauseSheetOpen || !mounted) {
      return;
    }

    _pauseSheetOpen = true;

    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true, // Can dismiss by tapping outside
      enableDrag: false, // Cannot drag to dismiss
      backgroundColor: Colors.transparent,
      barrierColor: theme.colorScheme.shadow.withValues(alpha: 0.4),
      builder: (context) => PopScope(
        canPop: false,
        child: _PauseBottomSheet(
          onResume: () {
            // Close bottom sheet immediately
            if (mounted) {
              _pauseSheetOpen = false;
            }
            Navigator.pop(context);
            // Start countdown after bottom sheet is closed
            if (mounted && !_isCountdownActive) {
              _isCountdownActive = true;
              _suppressIntervalGuidanceOnResume = true;
              state.startResumeCountdown();
            }
          },
          onEndWorkout: () {
            // Reset flag before opening confirmation (will reopen pause sheet if cancelled)
            if (mounted) {
              _pauseSheetOpen = false;
            }
            Navigator.pop(context);
            // Open confirmation bottom sheet - will reopen pause sheet if cancelled
            _showEndWorkoutConfirmation(state);
          },
        ),
      ),
    ).then((_) {
      // Only reset flag if it wasn't already reset by explicit actions
      // This is a safety net, but actions should handle their own flag management
      if (mounted && _pauseSheetOpen) {
        _pauseSheetOpen = false;
      }
    });
  }

  void _showEndWorkoutConfirmation(WorkoutState state) {
    // Guard: prevent duplicate bottom sheets
    if (_endConfirmOpen || !mounted) {
      return;
    }

    _endConfirmOpen = true;

    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true, // Can dismiss by tapping outside
      enableDrag: false, // Cannot drag to dismiss
      backgroundColor: Colors.transparent,
      barrierColor: theme.colorScheme.shadow.withValues(alpha: 0.4),
      builder: (context) => PopScope(
        canPop: false,
        child: _EndWorkoutConfirmationBottomSheet(
          onCancel: () {
            // Cancel: close bottom sheet and reopen pause sheet
            Navigator.pop(context);
            if (mounted) {
              _endConfirmOpen = false;
              // Reopen pause sheet after confirmation bottom sheet is dismissed
              Future.microtask(() {
                if (mounted &&
                    state.status == WorkoutStatus.paused &&
                    !_pauseSheetOpen) {
                  _showPauseSheet(state);
                }
              });
            }
          },
          onConfirm: () {
            // End workout: ONLY action that calls stopWorkout()
            Navigator.pop(context);
            if (mounted) {
              _endConfirmOpen = false;
              _pauseSheetOpen = false; // Reset flag since we're ending
            }
            // Explicitly end workout - this is the ONLY place stopWorkout() is called
            state.stopWorkout();
          },
        ),
      ),
    ).then((_) {
      // Safety net: ensure flag is reset if bottom sheet is dismissed unexpectedly
      if (mounted) {
        _endConfirmOpen = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.previewElapsed != null,
      child: ChangeNotifierProvider.value(
        value: _workoutState,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            bottom: false,
            child: OrientationBuilder(
              builder: (context, orientation) {
                return Consumer2<WorkoutState, AppSettingsProvider>(
                  builder: (context, state, settingsProvider, child) {
                    return Stack(
                      children: [
                        orientation == Orientation.portrait
                            ? _buildPortraitLayout(state, settingsProvider)
                            : _buildLandscapeLayout(state, settingsProvider),
                        _IntervalPulseOverlay(
                          triggerKey: state.currentIntervalIndex,
                          enabled: state.status == WorkoutStatus.running,
                        ),
                        // Countdown overlay
                        if (state.status == WorkoutStatus.resumingCountdown)
                          _buildCountdownOverlay(state),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPortraitLayout(
      WorkoutState state, AppSettingsProvider settingsProvider) {
    // Format remaining seconds as mm:ss
    final remainingSeconds = state.remainingSeconds;
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final countdownLabel =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    final detailChips = _getDetailChips(context, state, settingsProvider);
    final primaryMetricLabel = _getPrimaryMetricLabel(context);

    // Calculate dynamic scaleFactor for portrait based on baseline iPhone 14 Pro (393 x 852)
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    const double basePortraitWidth = 393.0;
    const double basePortraitHeight = 852.0;

    final double widthScale =
        screenWidth > 0 ? screenWidth / basePortraitWidth : 1.0;
    final double heightScale =
        screenHeight > 0 ? screenHeight / basePortraitHeight : 1.0;
    final double scaleFactor =
        math.min(widthScale, heightScale).clamp(0.75, 1.15);
    final displayScale = settingsProvider.workoutDisplaySize.scale;
    final contentScaleFactor = scaleFactor * displayScale;
    final headerScaleFactor = scaleFactor * math.min(displayScale, 1.15);

    final portraitMainFontSize =
        (screenWidth * 0.14 * scaleFactor * displayScale)
            .clamp(48.0, 102.0)
            .toDouble();
    final portraitTimerSize = math
        .min(
          154 * contentScaleFactor,
          screenWidth - (48 * scaleFactor),
        )
        .clamp(112 * scaleFactor, 214 * scaleFactor)
        .toDouble();

    return Column(
      children: [
        // Top section: Total routine remaining time and progress bar
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              24 * scaleFactor,
              28 * scaleFactor,
              24 * scaleFactor,
              12 * scaleFactor,
            ),
            child: Column(
              children: [
                _HeaderTimeSummary(
                  totalRemainingTimeFormatted:
                      state.formatTime(state.totalRemainingSeconds),
                  currentIntervalIndex: state.currentIntervalIndex,
                  totalIntervals: widget.routine.intervals.length,
                  scaleFactor: headerScaleFactor,
                ),
                SizedBox(height: 10 * scaleFactor),
                // Total routine remaining progress bar
                _TopPillProgressBar(
                  progress: state.totalRemainingProgress,
                  height: 12 * scaleFactor,
                ),
              ],
            ),
          ),
        ),
        // Main content: Current session info and circular timer
        Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.fromSTEB(
              20 * scaleFactor,
              8 * scaleFactor,
              20 * scaleFactor,
              20 * scaleFactor,
            ),
            child: Align(
              alignment: const Alignment(0, -0.08),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 560 * scaleFactor),
                child: _WorkoutHeroPanel(
                  isPortrait: true,
                  scaleFactor: scaleFactor,
                  mainSection: _CurrentValueSection(
                    metricLabel: primaryMetricLabel,
                    mainValueText:
                        _getMainValueText(context, state, settingsProvider),
                    detailChips: detailChips,
                    mainFontSize: portraitMainFontSize,
                    currentIntervalIndex: state.currentIntervalIndex,
                    scaleFactor: contentScaleFactor,
                    alignCenter: true,
                  ),
                  timerSection: SizedBox(
                    width: double.infinity,
                    child: _TimerSurface(
                      isPortrait: true,
                      scaleFactor: scaleFactor,
                      child: _CircularSessionTimer(
                        timeText: countdownLabel,
                        progress: 1.0 - state.currentIntervalProgress,
                        isPaused: state.status == WorkoutStatus.paused,
                        size: portraitTimerSize,
                        currentIntervalIndex: state.currentIntervalIndex,
                        scaleFactor: contentScaleFactor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Bottom buttons
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            20 * scaleFactor,
            0,
            20 * scaleFactor,
            32 * scaleFactor,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 360 * scaleFactor),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PrimaryButton(
                  width: 200 * scaleFactor,
                  label: state.status == WorkoutStatus.paused
                      ? AppLocalizations.of(context)!.resume
                      : AppLocalizations.of(context)!.pause,
                  onPressed: state.status == WorkoutStatus.resumingCountdown
                      ? () {} // Disabled during countdown
                      : (state.status == WorkoutStatus.paused
                          ? () {
                              if (mounted) {
                                _pauseSheetOpen = false;
                                if (!_isCountdownActive) {
                                  _isCountdownActive = true;
                                  _suppressIntervalGuidanceOnResume = true;
                                  state.startResumeCountdown();
                                }
                              }
                            }
                          : () => _pauseWorkout(state)),
                  scaleFactor: scaleFactor,
                ),
                SizedBox(width: 12 * scaleFactor),
                _SecondaryButton(
                  onPressed: state.status == WorkoutStatus.resumingCountdown
                      ? () {} // Disabled during countdown
                      : _toggleOrientation,
                  scaleFactor: scaleFactor,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(
      WorkoutState state, AppSettingsProvider settingsProvider) {
    // Format remaining seconds as mm:ss
    final remainingSeconds = state.remainingSeconds;
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    final countdownLabel =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    final detailChips = _getDetailChips(context, state, settingsProvider);
    final primaryMetricLabel = _getPrimaryMetricLabel(context);

    return MediaQuery(
      data: MediaQuery.of(context),
      child: SafeArea(
        left: false, // No left padding in landscape
        right: false, // No right padding in landscape
        minimum: const EdgeInsets.only(
            top: 12,
            bottom:
                16), // Keep top breathing room and ensure bottom space on devices with 0 bottom padding (like Android)
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Get available dimensions after SafeArea
            final availableWidth = constraints.maxWidth;
            final availableHeight = constraints.maxHeight;
            final shortestSide = math.min(availableWidth, availableHeight);

            // Calculate scaleFactor based on shortest side
            // Base reference: iPhone 14 Pro landscape (926x428) -> shortestSide = 428
            // Scale factor: shortestSide / 428, clamped to safe range
            const baseShortestSide = 428.0;
            double scaleFactor =
                (shortestSide / baseShortestSide).clamp(0.85, 1.25);

            // Breakpoint adjustments for very small screens
            if (availableWidth < 700 || availableHeight < 320) {
              // Reduce scale more aggressively for small screens
              scaleFactor = (shortestSide / baseShortestSide).clamp(0.75, 1.0);
            }
            final displayScale = settingsProvider.workoutDisplaySize.scale;
            final contentScaleFactor = scaleFactor * displayScale;
            final headerScaleFactor =
                scaleFactor * math.min(displayScale, 1.15);

            // Helper function to scale values
            double scaled(double base) => base * scaleFactor;

            // Calculate responsive sizes
            final baseCircleSize = math
                .min(
                  scaled(availableHeight * 0.52),
                  scaled(availableWidth * 0.26),
                )
                .clamp(scaled(112.0), scaled(170.0));
            final circleSize = math
                .min(baseCircleSize * displayScale, availableHeight * 0.68)
                .toDouble();

            final mainFontSize = (availableHeight * 0.17 * scaleFactor)
                    .clamp(scaled(46.0), scaled(88.0)) *
                displayScale;
            final panelMaxWidth = math.max(
              scaled(600),
              math.min(availableWidth - scaled(56), scaled(940)),
            );

            return Stack(
              fit: StackFit.expand,
              children: [
                Column(
                  children: [
                    // Top section: Total routine remaining time and progress bar (full width)
                    _TopRoutineProgressHeader(
                      totalRemainingTimeFormatted:
                          state.formatTime(state.totalRemainingSeconds),
                      progress: state.totalRemainingProgress,
                      currentIntervalIndex: state.currentIntervalIndex,
                      totalIntervals: widget.routine.intervals.length,
                      scaleFactor: headerScaleFactor,
                    ),
                    // Main content: Two columns layout
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            scaled(20),
                            scaled(12),
                            scaled(20),
                            scaled(42),
                          ),
                          child: ConstrainedBox(
                            constraints:
                                BoxConstraints(maxWidth: panelMaxWidth),
                            child: _WorkoutHeroPanel(
                              isPortrait: false,
                              scaleFactor: scaleFactor,
                              mainSection: _CurrentValueSection(
                                metricLabel: primaryMetricLabel,
                                mainValueText: _getMainValueText(
                                    context, state, settingsProvider),
                                detailChips: detailChips,
                                mainFontSize: mainFontSize,
                                currentIntervalIndex:
                                    state.currentIntervalIndex,
                                scaleFactor: contentScaleFactor,
                                alignCenter: false,
                              ),
                              timerSection: SizedBox(
                                width: math.max(
                                  circleSize + scaled(28),
                                  scaled(198),
                                ),
                                child: _TimerSurface(
                                  isPortrait: false,
                                  scaleFactor: scaleFactor,
                                  child: _CircularSessionTimer(
                                    timeText: countdownLabel,
                                    progress:
                                        1.0 - state.currentIntervalProgress,
                                    isPaused:
                                        state.status == WorkoutStatus.paused,
                                    size: circleSize,
                                    currentIntervalIndex:
                                        state.currentIntervalIndex,
                                    scaleFactor: contentScaleFactor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _BottomControlBar(
                    isPaused: state.status == WorkoutStatus.paused,
                    isResumingCountdown:
                        state.status == WorkoutStatus.resumingCountdown,
                    onPauseResume: state.status ==
                            WorkoutStatus.resumingCountdown
                        ? () {}
                        : (state.status == WorkoutStatus.paused
                            ? () {
                                if (mounted) {
                                  _pauseSheetOpen = false;
                                  if (!_isCountdownActive) {
                                    _isCountdownActive = true;
                                    _suppressIntervalGuidanceOnResume = true;
                                    state.startResumeCountdown();
                                  }
                                }
                              }
                            : () => _pauseWorkout(state)),
                    onRotate: state.status == WorkoutStatus.resumingCountdown
                        ? () {}
                        : _toggleOrientation,
                    scaleFactor: scaleFactor,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getMainValueText(BuildContext context, WorkoutState state,
      AppSettingsProvider settingsProvider) {
    final l10n = AppLocalizations.of(context)!;
    switch (widget.routine.machineType) {
      case MachineType.treadmill:
        return settingsProvider
            .formatSpeed(state.currentInterval.speedKmh ?? 0.0);
      case MachineType.cycle:
        return l10n.resistanceColon(
          LocalizedFormat.decimal(
            context,
            state.currentInterval.resistance ?? 0,
            decimalDigits: 0,
          ),
        );
      case MachineType.stairmaster:
        return l10n.levelColon(
          LocalizedFormat.decimal(
            context,
            state.currentInterval.level ?? 0,
            decimalDigits: 0,
          ),
        );
    }
  }

  String _getPrimaryMetricLabel(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final label = switch (widget.routine.machineType) {
      MachineType.treadmill => l10n.speed,
      MachineType.cycle => l10n.level,
      MachineType.stairmaster => l10n.level,
    };
    return '${l10n.current} $label';
  }

  String _getSecondaryValueText(BuildContext context, WorkoutState state) {
    switch (widget.routine.machineType) {
      case MachineType.treadmill:
        final l10n = AppLocalizations.of(context)!;
        final grade = state.currentInterval.grade ?? 0.0;
        return l10n.inclineValue(
          LocalizedFormat.decimal(context, grade),
        );
      case MachineType.cycle:
        // Show current session RPM when there's no next session, or show current RPM in secondary area
        final l10n = AppLocalizations.of(context)!;
        final currentRpm = state.currentInterval.rpm ?? 0;
        return l10n.rpmValue(
          LocalizedFormat.decimal(context, currentRpm, decimalDigits: 0),
        );
      case MachineType.stairmaster:
        return ''; // No secondary value for stairmaster
    }
  }

  String _getNextValueText(BuildContext context, WorkoutState state,
      AppSettingsProvider settingsProvider) {
    final l10n = AppLocalizations.of(context)!;
    // Get next interval if available
    if (state.currentIntervalIndex < widget.routine.intervals.length - 1) {
      final nextInterval =
          widget.routine.intervals[state.currentIntervalIndex + 1];
      switch (widget.routine.machineType) {
        case MachineType.treadmill:
          return l10n.nextMetric(
            settingsProvider.formatSpeed(nextInterval.speedKmh ?? 0.0),
          );
        case MachineType.cycle:
          return l10n.nextMetric(
            l10n.resistanceColon(
              LocalizedFormat.decimal(
                context,
                nextInterval.resistance ?? 0,
                decimalDigits: 0,
              ),
            ),
          );
        case MachineType.stairmaster:
          return l10n.nextMetric(
            l10n.levelColon(
              LocalizedFormat.decimal(
                context,
                nextInterval.level ?? 0,
                decimalDigits: 0,
              ),
            ),
          );
      }
    }
    return ''; // No next interval
  }

  String _getNextRpmText(BuildContext context, WorkoutState state) {
    final l10n = AppLocalizations.of(context)!;
    // Only show RPM for cycle workouts in next session area
    if (widget.routine.machineType != MachineType.cycle) {
      return '';
    }
    // For first session (index 0), show current session RPM instead of next
    if (state.currentIntervalIndex == 0) {
      final currentRpm = state.currentInterval.rpm ?? 0;
      return l10n.rpmValue(
        LocalizedFormat.decimal(context, currentRpm, decimalDigits: 0),
      );
    }
    // Get next interval if available
    if (state.currentIntervalIndex < widget.routine.intervals.length - 1) {
      final nextInterval =
          widget.routine.intervals[state.currentIntervalIndex + 1];
      return l10n.rpmValue(
        LocalizedFormat.decimal(
          context,
          nextInterval.rpm ?? 0,
          decimalDigits: 0,
        ),
      );
    }
    return ''; // No next interval
  }

  List<_WorkoutDetailChipData> _getDetailChips(
    BuildContext context,
    WorkoutState state,
    AppSettingsProvider settingsProvider,
  ) {
    final chips = <_WorkoutDetailChipData>[];
    final nextValueText = _getNextValueText(context, state, settingsProvider);
    final nextRpmText = _getNextRpmText(context, state);
    final secondaryValueText = _getSecondaryValueText(context, state);

    if (nextValueText.isNotEmpty) {
      chips.add(
        _WorkoutDetailChipData(
          icon: Icons.arrow_outward_rounded,
          text: nextValueText,
          isAccent: true,
        ),
      );
    }

    if (nextRpmText.isNotEmpty) {
      chips.add(
        _WorkoutDetailChipData(
          icon: Icons.speed_rounded,
          text: nextRpmText,
        ),
      );
    }

    if (nextRpmText.isEmpty && secondaryValueText.isNotEmpty) {
      chips.add(
        _WorkoutDetailChipData(
          icon: _secondaryMetricIcon(),
          text: secondaryValueText,
        ),
      );
    }

    return chips;
  }

  IconData _secondaryMetricIcon() {
    switch (widget.routine.machineType) {
      case MachineType.treadmill:
        return Icons.terrain_rounded;
      case MachineType.cycle:
        return Icons.speed_rounded;
      case MachineType.stairmaster:
        return Icons.stairs_rounded;
    }
  }

  Widget _buildCountdownOverlay(WorkoutState state) {
    return _CountdownOverlay(countdownNumber: state.countdownNumber);
  }
}

// Top pill progress bar with white container and red fill
class _TopPillProgressBar extends StatefulWidget {
  final double progress;
  final double? height;

  const _TopPillProgressBar({
    required this.progress,
    this.height,
  });

  @override
  State<_TopPillProgressBar> createState() => _TopPillProgressBarState();
}

class _TopPillProgressBarState extends State<_TopPillProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _previousProgress = widget.progress;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: widget.progress,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    _controller.value = 1.0; // Start at the end
  }

  @override
  void didUpdateWidget(_TopPillProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _previousProgress = _animation.value;

      // If progress decreased (session ended, resetting to 0), skip animation and reset immediately
      if (widget.progress < _previousProgress) {
        _animation = Tween<double>(
          begin: widget.progress,
          end: widget.progress,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ));
        _controller.value = 1.0; // Set immediately without animation
      } else {
        // Progress increased (new session starting), animate normally
        _animation = Tween<double>(
          begin: _previousProgress,
          end: widget.progress,
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ));
        _controller.reset();
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final trackColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : theme.colorScheme.onSurface.withValues(alpha: 0.06);
    return Container(
      height: widget.height ?? 12,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.08),
            blurRadius: 14,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        // Force LTR direction so progress bar always goes left to right, even in RTL mode
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Stack(
            children: [
              // Background
              Container(
                width: double.infinity,
                color: trackColor,
              ),
              // Primary fill bar with smooth animation (always left to right)
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return FractionallySizedBox(
                    widthFactor: _animation.value.clamp(0.0, 1.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            Color.lerp(
                                  theme.colorScheme.primary,
                                  Colors.white,
                                  isDark ? 0.08 : 0.18,
                                ) ??
                                theme.colorScheme.primary,
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Painter for progress ring: gray background + primary arc
class _ProgressRingPainter extends CustomPainter {
  final double strokeWidth;
  final double progress; // 0.0 to 1.0
  final Color trackColor;
  final Color progressColor;

  final Paint _trackPaint;
  final Paint _progressPaint;

  _ProgressRingPainter({
    required this.strokeWidth,
    required this.progress,
    required this.trackColor,
    required this.progressColor,
  })  : _trackPaint = Paint()
          ..color = trackColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
        _progressPaint = Paint()
          ..color = progressColor
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Draw background ring (full circle)
    canvas.drawCircle(center, radius, _trackPaint);

    // Draw progress arc (clockwise from top)
    if (progress > 0) {
      // Start from top (-90 degrees) and draw clockwise
      // Progress arc: sweepAngle = progress * 360 degrees (2π radians)
      // Positive sweepAngle = clockwise direction in Flutter
      final sweepAngle = progress * 2 * math.pi;
      const startAngle = -math.pi / 2; // Start from top (-90 degrees)

      final rect = Rect.fromCircle(center: center, radius: radius);

      // Draw main progress arc
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        false,
        _progressPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_ProgressRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor;
  }
}

// Primary button (red) - for Pause/Resume
class _PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final double width;
  final double scaleFactor;

  const _PrimaryButton({
    required this.label,
    required this.onPressed,
    this.width = 150,
    this.scaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 56 * scaleFactor,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
        boxShadow: AppShadows.elevatedSoft,
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16 * scaleFactor,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3 * scaleFactor,
          ),
        ),
      ),
    );
  }
}

// Secondary button (neutral/gray) - for Rotate
class _SecondaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double scaleFactor;

  const _SecondaryButton({
    required this.onPressed,
    this.scaleFactor = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final appColors = theme.extension<AppColors>()!;
    // Default colors
    final bgColor = isDark
        ? appColors.surfaceElevated.withValues(alpha: 0.5)
        : theme.colorScheme.surface;
    final borderColor = appColors.border;

    return Opacity(
      opacity: onPressed == null ? 0.5 : 1.0,
      child: Container(
        width: 56 * scaleFactor,
        height: 56 * scaleFactor,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14 * scaleFactor),
          color: bgColor,
          border: Border.all(
            color: borderColor,
            width: 1.0,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(14 * scaleFactor),
            splashColor: theme.colorScheme.onSurface.withValues(alpha: 0.08),
            highlightColor: theme.colorScheme.onSurface.withValues(alpha: 0.05),
            child: Icon(
              Icons.rotate_right,
              color: theme.colorScheme.onSurface,
              size: 24 * scaleFactor,
            ),
          ),
        ),
      ),
    );
  }
}

class _WorkoutHeroPanel extends StatelessWidget {
  final bool isPortrait;
  final double scaleFactor;
  final Widget mainSection;
  final Widget timerSection;

  const _WorkoutHeroPanel({
    required this.isPortrait,
    required this.scaleFactor,
    required this.mainSection,
    required this.timerSection,
  });

  double _scaled(double base) => base * scaleFactor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: _scaled(isPortrait ? 4 : 8),
        vertical: _scaled(isPortrait ? 12 : 6),
      ),
      child: isPortrait
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                mainSection,
                SizedBox(height: _scaled(34)),
                timerSection,
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: _scaled(560)),
                  child: mainSection,
                ),
                SizedBox(width: _scaled(18)),
                timerSection,
              ],
            ),
    );
  }
}

class _TimerSurface extends StatelessWidget {
  final bool isPortrait;
  final double scaleFactor;
  final Widget child;

  const _TimerSurface({
    required this.isPortrait,
    required this.scaleFactor,
    required this.child,
  });

  double _scaled(double base) => base * scaleFactor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: _scaled(isPortrait ? 0 : 8)),
      child: child,
    );
  }
}

class _WorkoutDetailChipData {
  final IconData icon;
  final String text;
  final bool isAccent;

  const _WorkoutDetailChipData({
    required this.icon,
    required this.text,
    this.isAccent = false,
  });
}

class _WorkoutDetailChip extends StatelessWidget {
  final _WorkoutDetailChipData chip;
  final double scaleFactor;

  const _WorkoutDetailChip({
    required this.chip,
    required this.scaleFactor,
  });

  double _scaled(double base) => base * scaleFactor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final chipColor = chip.isAccent
        ? theme.colorScheme.primary.withValues(alpha: isDark ? 0.08 : 0.04)
        : isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02);
    final borderColor = chip.isAccent
        ? theme.colorScheme.primary.withValues(alpha: isDark ? 0.55 : 0.28)
        : isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.10);

    return Container(
      constraints: BoxConstraints(minHeight: _scaled(40)),
      padding: EdgeInsets.symmetric(
        horizontal: _scaled(14),
        vertical: _scaled(9),
      ),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(_scaled(999)),
        border: Border.all(
          color: borderColor,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            chip.icon,
            size: _scaled(15),
            color: chip.isAccent
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface.withValues(alpha: 0.56),
          ),
          SizedBox(width: _scaled(10)),
          Flexible(
            child: Text(
              chip.text,
              style: TextStyle(
                fontSize: _scaled(15),
                fontWeight: FontWeight.w600,
                color: chip.isAccent
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.84),
                letterSpacing: -0.1,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _IntervalPulseOverlay extends StatefulWidget {
  final int triggerKey;
  final bool enabled;

  const _IntervalPulseOverlay({
    required this.triggerKey,
    required this.enabled,
  });

  @override
  State<_IntervalPulseOverlay> createState() => _IntervalPulseOverlayState();
}

class _IntervalPulseOverlayState extends State<_IntervalPulseOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(_IntervalPulseOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled) return;
    if (oldWidget.triggerKey != widget.triggerKey) {
      HapticFeedback.lightImpact();
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final decay = Curves.easeOutQuad.transform(_controller.value);
          final intensity = 1 - decay;
          final flashOpacity = intensity * (isDark ? 0.16 : 0.10);
          final borderOpacity = intensity * (isDark ? 0.50 : 0.34);
          final glowOpacity = intensity * (isDark ? 0.28 : 0.16);
          final borderWidth = 1.0 + (intensity * 5.5);

          if (flashOpacity <= 0.001 &&
              borderOpacity <= 0.001 &&
              glowOpacity <= 0.001) {
            return const SizedBox.shrink();
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0, -0.05),
                    radius: 1.0,
                    colors: [
                      theme.colorScheme.primary.withValues(
                        alpha: flashOpacity,
                      ),
                      theme.colorScheme.primary.withValues(alpha: 0),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(
                      alpha: borderOpacity,
                    ),
                    width: borderWidth,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(
                        alpha: glowOpacity,
                      ),
                      blurRadius: 28,
                      spreadRadius: 6,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Bottom control bar widget (landscape mode)
class _BottomControlBar extends StatelessWidget {
  final bool isPaused;
  final bool isResumingCountdown;
  final VoidCallback onPauseResume;
  final VoidCallback onRotate;
  final double scaleFactor;

  const _BottomControlBar({
    required this.isPaused,
    required this.isResumingCountdown,
    required this.onPauseResume,
    required this.onRotate,
    required this.scaleFactor,
  });

  double _scaled(double base) => base * scaleFactor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: _scaled(4),
        bottom: 0,
        start: _scaled(32),
        end: _scaled(32),
      ),
      child: Align(
        alignment: Alignment.center,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: _scaled(320)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Center: Primary pause/resume button (pill shape)
              Container(
                height: _scaled(48),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      _scaled(24)), // >= 20 for premium look
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.1),
                      blurRadius: _scaled(8),
                      spreadRadius: 0,
                      offset: Offset(0, _scaled(2)),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: isResumingCountdown ? null : onPauseResume,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: _scaled(32),
                      vertical: _scaled(12),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(_scaled(24)),
                    ),
                  ),
                  child: Text(
                    isPaused ? l10n.resume : l10n.pause,
                    style: TextStyle(
                      fontSize: _scaled(17),
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
              ),
              SizedBox(width: _scaled(10)),
              // Right: Rotate button (right of pause button)
              SecondaryOutlinedIconButton(
                onPressed: isResumingCountdown
                    ? null
                    : () {
                        HapticFeedback.lightImpact();
                        onRotate();
                      },
                size: _scaled(44),
                iconColor: theme.colorScheme.onSurface,
                icon: Icon(
                  Icons.rotate_right,
                  size: _scaled(20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Countdown overlay widget with persistent background
class _CountdownOverlay extends StatefulWidget {
  final int countdownNumber;

  const _CountdownOverlay({
    required this.countdownNumber,
  });

  @override
  State<_CountdownOverlay> createState() => _CountdownOverlayState();
}

class _CountdownOverlayState extends State<_CountdownOverlay> {
  @override
  Widget build(BuildContext context) {
    // Persistent background that never flickers - stays mounted for entire countdown
    return Container(
      color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.35),
      child: Stack(
        children: [
          // Animated number in center - only this part changes
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.5, end: 1.0).animate(
                      CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOut,
                      ),
                    ),
                    child: child,
                  ),
                );
              },
              child: Text(
                '${widget.countdownNumber}',
                key: ValueKey(widget.countdownNumber),
                style: const TextStyle(
                  fontSize: 120,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -3.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderTimeSummary extends StatelessWidget {
  final String totalRemainingTimeFormatted;
  final int currentIntervalIndex;
  final int totalIntervals;
  final double scaleFactor;

  const _HeaderTimeSummary({
    required this.totalRemainingTimeFormatted,
    required this.currentIntervalIndex,
    required this.totalIntervals,
    required this.scaleFactor,
  });

  double _scaled(double base) => base * scaleFactor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: _scaled(40),
      child: Stack(
        alignment: Alignment.center,
        children: [
          BidiSafeText(
            totalRemainingTimeFormatted,
            style: TextStyle(
              fontSize: _scaled(28),
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.7,
              height: 1.0,
              fontFeatures: const [ui.FontFeature.tabularFigures()],
            ),
            forceLTR: true,
          ),
          PositionedDirectional(
            end: 0,
            child: _HeaderIntervalIndicator(
              currentIntervalIndex: currentIntervalIndex,
              totalIntervals: totalIntervals,
              scaleFactor: scaleFactor,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderIntervalIndicator extends StatelessWidget {
  final int currentIntervalIndex;
  final int totalIntervals;
  final double scaleFactor;

  const _HeaderIntervalIndicator({
    required this.currentIntervalIndex,
    required this.totalIntervals,
    required this.scaleFactor,
  });

  double _scaled(double base) => base * scaleFactor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final safeTotal = totalIntervals < 1 ? 1 : totalIntervals;
    final currentStep =
        math.min(math.max(currentIntervalIndex + 1, 1), safeTotal);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: _scaled(10),
        vertical: _scaled(6),
      ),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.05)
            : Colors.black.withValues(alpha: 0.035),
        borderRadius: BorderRadius.circular(_scaled(999)),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: BidiSafeText(
        '$currentStep/$safeTotal',
        style: TextStyle(
          fontSize: _scaled(14),
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
          letterSpacing: -0.2,
          fontFeatures: const [ui.FontFeature.tabularFigures()],
        ),
        forceLTR: true,
      ),
    );
  }
}

// Top routine progress header widget (reusable for landscape)
class _TopRoutineProgressHeader extends StatelessWidget {
  final String totalRemainingTimeFormatted;
  final double progress;
  final int currentIntervalIndex;
  final int totalIntervals;
  final double scaleFactor;

  const _TopRoutineProgressHeader({
    required this.totalRemainingTimeFormatted,
    required this.progress,
    required this.currentIntervalIndex,
    required this.totalIntervals,
    required this.scaleFactor,
  });

  double _scaled(double base) => base * scaleFactor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            _scaled(32),
            _scaled(8),
            _scaled(32),
            _scaled(6),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _HeaderTimeSummary(
                totalRemainingTimeFormatted: totalRemainingTimeFormatted,
                currentIntervalIndex: currentIntervalIndex,
                totalIntervals: totalIntervals,
                scaleFactor: scaleFactor,
              ),
              SizedBox(height: _scaled(10)),
              // Total routine remaining progress bar (thinner)
              Padding(
                padding:
                    EdgeInsetsDirectional.symmetric(horizontal: _scaled(8)),
                child: _TopPillProgressBar(
                  progress: progress,
                  height: _scaled(10), // Reduced from 22 to 10 (10~12px range)
                ),
              ),
            ],
          ),
        ),
        // Subtle divider line under header
        Divider(
          height: 1,
          thickness: 1,
          color: theme.dividerColor.withValues(alpha: 0.3),
          indent: _scaled(32),
          endIndent: _scaled(32),
        ),
      ],
    );
  }
}

// Current value section widget (left column in landscape)
class _CurrentValueSection extends StatefulWidget {
  final String metricLabel;
  final String mainValueText;
  final List<_WorkoutDetailChipData> detailChips;
  final double mainFontSize;
  final int currentIntervalIndex;
  final double scaleFactor;
  final bool alignCenter;

  const _CurrentValueSection({
    required this.metricLabel,
    required this.mainValueText,
    required this.detailChips,
    required this.mainFontSize,
    required this.currentIntervalIndex,
    required this.scaleFactor,
    required this.alignCenter,
  });

  double _scaled(double base) => base * scaleFactor;

  @override
  State<_CurrentValueSection> createState() => _CurrentValueSectionState();
}

class _CurrentValueSectionState extends State<_CurrentValueSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  int _previousIntervalIndex = -1;

  @override
  void initState() {
    super.initState();
    _previousIntervalIndex = widget.currentIntervalIndex;
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(_CurrentValueSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Pulse animation when interval changes
    if (oldWidget.currentIntervalIndex != widget.currentIntervalIndex &&
        _previousIntervalIndex != widget.currentIntervalIndex) {
      _previousIntervalIndex = widget.currentIntervalIndex;
      _pulseController.reset();
      _pulseController.forward();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: widget.alignCenter
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Text(
          widget.metricLabel,
          style: TextStyle(
            fontSize: widget._scaled(13),
            fontWeight: FontWeight.w700,
            color:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.56),
            letterSpacing: 1.3,
          ),
          textAlign: widget.alignCenter ? TextAlign.center : TextAlign.start,
        ),
        SizedBox(height: widget._scaled(12)),
        // Current session value (large primary text) with pulse animation
        Align(
          alignment: widget.alignCenter
              ? Alignment.center
              : AlignmentDirectional.centerStart,
          widthFactor: widget.alignCenter ? null : 1,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              final scale = 1.0 + (_pulseController.value * 0.1);
              return Transform.scale(
                scale: scale,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: widget.alignCenter
                      ? Alignment.center
                      : AlignmentDirectional.centerStart,
                  child: FlashingMetricText(
                    text: widget.mainValueText,
                    style: TextStyle(
                      fontSize: widget.mainFontSize,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: -1.8,
                    ),
                    defaultColor: Theme.of(context).colorScheme.onSurface,
                    flashColor: Theme.of(context).colorScheme.primary,
                    enableScalePulse: true,
                    triggerKey: widget.currentIntervalIndex,
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.detailChips.isNotEmpty) ...[
          SizedBox(height: widget._scaled(16)),
          Align(
            alignment: widget.alignCenter
                ? Alignment.center
                : AlignmentDirectional.centerStart,
            widthFactor: widget.alignCenter ? null : 1,
            child: Wrap(
              alignment: widget.alignCenter
                  ? WrapAlignment.center
                  : WrapAlignment.start,
              spacing: widget._scaled(10),
              runSpacing: widget._scaled(10),
              children: [
                for (final chip in widget.detailChips)
                  _WorkoutDetailChip(
                    chip: chip,
                    scaleFactor: widget.scaleFactor,
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// Circular session timer widget (right column in landscape)
class _CircularSessionTimer extends StatefulWidget {
  final String timeText;
  final double progress; // 0.0 to 1.0, where 1.0 = full ring, 0.0 = empty
  final bool isPaused;
  final double size;
  final int currentIntervalIndex;
  final double scaleFactor;

  const _CircularSessionTimer({
    required this.timeText,
    required this.progress,
    required this.isPaused,
    required this.size,
    required this.currentIntervalIndex,
    required this.scaleFactor,
  });

  double _scaled(double base) => base * scaleFactor;

  @override
  State<_CircularSessionTimer> createState() => _CircularSessionTimerState();
}

class _CircularSessionTimerState extends State<_CircularSessionTimer>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _pulseController;
  late Animation<double> _animation;
  late Animation<double> _pulseAnimation;
  double _previousProgress = 0.0;
  int _previousIntervalIndex = -1;

  @override
  void initState() {
    super.initState();
    _previousProgress = widget.progress;
    _previousIntervalIndex = widget.currentIntervalIndex;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: widget.progress,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _controller.value = 1.0; // Start at the end
  }

  @override
  void didUpdateWidget(_CircularSessionTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _previousProgress = _animation.value;
      _animation = Tween<double>(
        begin: _previousProgress,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.linear,
      ));
      _controller.reset();
      _controller.forward();
    }
    // Pulse animation when interval changes
    if (oldWidget.currentIntervalIndex != widget.currentIntervalIndex &&
        _previousIntervalIndex != widget.currentIntervalIndex) {
      _previousIntervalIndex = widget.currentIntervalIndex;
      _pulseController.reset();
      _pulseController.forward().then((_) {
        // Ensure animation returns to original state after completion
        if (mounted) {
          _pulseController.reset();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = theme.colorScheme.surface;
    final textColor = theme.colorScheme.onSurface;
    final trackColor =
        theme.colorScheme.onSurface.withValues(alpha: isDark ? 0.08 : 0.06);
    final strokeWidth =
        (widget.size * 0.07).clamp(widget._scaled(10.0), widget._scaled(14.0));
    final fontSize =
        (widget.size * 0.18).clamp(widget._scaled(24.0), widget._scaled(36.0));

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Circular timer
        SizedBox(
          key: const ValueKey('workout-session-timer'),
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: [
              // Background circle with shadow (always rendered, outside AnimatedBuilder)
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color:
                          Colors.black.withValues(alpha: isDark ? 0.28 : 0.1),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
              // Progress ring with smooth animation and pulse effect
              AnimatedBuilder(
                animation: Listenable.merge([_animation, _pulseAnimation]),
                builder: (context, child) {
                  final pulseScale = _pulseAnimation.value;
                  return Transform.scale(
                    scale: pulseScale,
                    child: SizedBox(
                      width: widget.size,
                      height: widget.size,
                      child: CustomPaint(
                        painter: _ProgressRingPainter(
                          strokeWidth: strokeWidth,
                          progress: _animation.value,
                          trackColor: trackColor,
                          progressColor: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  );
                },
              ),
              // Time text (always LTR for timers) with tabular digits
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BidiSafeText(
                    widget.timeText,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      letterSpacing: -0.5,
                      fontFeatures: const [
                        ui.FontFeature.tabularFigures()
                      ], // Tabular/monospaced digits
                    ),
                    forceLTR: true, // Timers must always be LTR
                  ),
                  if (widget.isPaused) ...[
                    SizedBox(height: widget.size * 0.03),
                    Text(
                      AppLocalizations.of(context)!.paused,
                      style: TextStyle(
                        fontSize: fontSize * 0.33,
                        fontWeight: FontWeight.w600,
                        color: textColor.withValues(alpha: 0.6),
                        letterSpacing: widget._scaled(0.2),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Premium pause bottom sheet widget
class _PauseBottomSheet extends StatelessWidget {
  final VoidCallback onResume;
  final VoidCallback onEndWorkout;

  const _PauseBottomSheet({
    required this.onResume,
    required this.onEndWorkout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      bottom: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Pause icon in circular background
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.pause_rounded,
                      size: 32,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  Text(
                    l10n.pausedTitle,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  Text(
                    l10n.pausedSubtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: appColors.mutedText,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Primary button: Continue
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: onResume,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        l10n.resume,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Secondary button: End workout
                  SecondaryOutlinedButton(
                    onPressed: onEndWorkout,
                    borderRadius: AppTheme.buttonRadius,
                    borderColor: theme.colorScheme.outlineVariant,
                    child: Text(
                      l10n.endWorkout,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Premium end workout confirmation bottom sheet
class _EndWorkoutConfirmationBottomSheet extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const _EndWorkoutConfirmationBottomSheet({
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      top: false,
      bottom: true,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(32, 24, 32, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Warning/Stop icon in circular background
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.error.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.stop_circle_outlined,
                      size: 32,
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Title
                  Text(
                    l10n.endWorkoutQuestion,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  // Body text
                  Text(
                    l10n.endWorkoutConfirmationMessage,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      color: appColors.mutedText,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // Buttons row
                  Row(
                    children: [
                      // Cancel button (secondary)
                      Expanded(
                        child: SecondaryOutlinedButton(
                          onPressed: onCancel,
                          borderRadius: 999,
                          borderColor: theme.colorScheme.outlineVariant,
                          child: Text(
                            l10n.cancel,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // End button (destructive primary)
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.error,
                            foregroundColor: theme.colorScheme.onError,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            l10n.end,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
