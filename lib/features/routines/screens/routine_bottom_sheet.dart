import 'package:flutter/material.dart' hide Interval;
import 'package:flutter/cupertino.dart' hide Interval;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:valcue/l10n/app_localizations.dart';
import 'package:valcue/l10n/localized_format.dart';
import 'package:valcue/utils/responsive.dart';
import '../models/routine.dart';
import '../models/interval.dart';
import '../models/machine_type.dart';
import '../utils/reorder_utils.dart';
import '../../../app_settings/app_settings_provider.dart';
import '../storage/routine_provider.dart';
import '../../workout/screens/workout_screen.dart';
import '../../../theme/app_theme.dart';
import '../../membership/widgets/premium_bottom_sheet.dart';
import '../../../services/ad_service.dart';
import '../../../services/workout_live_activity_service.dart';
import '../../../services/workout_reminder_service.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/bottom_sheet_action_bar.dart';
import '../../../widgets/app_bottom_sheet.dart';
import '../../../widgets/platform_icon.dart';
import '../../../widgets/app_message.dart';
import '../../../utils/app_shadows.dart';
import 'package:share_plus/share_plus.dart';
import '../utils/routine_sharing.dart';
import '../widgets/qr_share_dialog.dart';
import '../../../services/analytics_service.dart';

class RoutineBottomSheet {
  /// Entry function to show routine sheet
  /// [routine] - existing routine (null if creating new)
  /// [initialEditing] - start in edit mode
  /// [isNew] - true if creating new routine
  /// [machineType] - required if creating new routine
  static void show(
    BuildContext context, {
    Routine? routine,
    bool initialEditing = false,
    bool isNew = false,
    MachineType? machineType,
  }) {
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);

    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: theme.colorScheme.shadow.withValues(alpha: 0.4),
      isDismissible: true,
      builder: (context) => _RoutineDetailSheetContent(
        routine: routine,
        initialEditing: initialEditing,
        isNew: isNew,
        machineType:
            machineType ?? routine?.machineType ?? MachineType.treadmill,
        settingsProvider: settingsProvider,
      ),
    );
  }
}

/// Embeddable version of the real routine editor used by the store capture
/// flow. It has the same UI as the modal sheet without mutating navigation.
class RoutineBottomSheetCapture extends StatelessWidget {
  final Routine routine;

  const RoutineBottomSheetCapture({
    super.key,
    required this.routine,
  });

  @override
  Widget build(BuildContext context) {
    return _RoutineDetailSheetContent(
      routine: routine,
      initialEditing: true,
      isNew: false,
      machineType: routine.machineType,
      settingsProvider: context.read<AppSettingsProvider>(),
    );
  }
}

class _RoutineDetailSheetContent extends StatefulWidget {
  final Routine? routine;
  final bool initialEditing;
  final bool isNew;
  final MachineType machineType;
  final AppSettingsProvider settingsProvider;

  const _RoutineDetailSheetContent({
    required this.routine,
    required this.initialEditing,
    required this.isNew,
    required this.machineType,
    required this.settingsProvider,
  });

  @override
  State<_RoutineDetailSheetContent> createState() =>
      _RoutineDetailSheetContentState();
}

class _RoutineDetailSheetContentState
    extends State<_RoutineDetailSheetContent> {
  static const Duration _intervalRemoveAnimationDuration =
      Duration(milliseconds: 240);

  late bool _isEditing;
  late TextEditingController _nameController;
  late String _difficulty;
  late List<Interval> _intervals;
  late MachineType _machineType;
  bool _isDeleting = false;
  bool _isReordering = false;
  String? _nameError;
  final Set<String> _enteringIntervalIds = <String>{};
  final Set<String> _removingIntervalIds = <String>{};
  final GlobalKey _shareButtonKey = GlobalKey();

  // Original routine for cancel (deep copy)
  late Routine? _originalRoutine;
  // Draft routine (deep copy) for editing
  Routine? _draftRoutine;

  @override
  void initState() {
    super.initState();
    _isEditing = widget.initialEditing;

    if (widget.routine != null) {
      // Create deep copy of original routine
      _originalRoutine = widget.routine!.deepCopy();
      _draftRoutine = widget.routine!.deepCopy();
      _nameController = TextEditingController(text: _draftRoutine!.name);
      _difficulty = _draftRoutine!.difficulty;
      _intervals = _draftRoutine!.intervals.toList(); // Already deep copied
      _machineType = _draftRoutine!.machineType;

      // DRIFT GUARD: Log snapshot when opening edit
      _logIntervalSnapshot('OPEN_EDIT', _intervals);
    } else {
      _originalRoutine = null;
      _draftRoutine = null;
      // Will be updated in didChangeDependencies with localized text
      _nameController = TextEditingController();
      // Default to Korean value, will be updated in didChangeDependencies if needed
      // But we store Korean values anyway, so this is fine
      _difficulty = '쉬움';
      _intervals = [];
      _machineType = widget.machineType;
    }

    // Add listener to validate name on change (only in edit mode)
    if (_isEditing) {
      _nameController.addListener(_validateName);
      // Don't call _validateName here as it needs context
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Now we can safely access AppLocalizations
    if (_originalRoutine == null && _nameController.text.isEmpty) {
      _nameController.text = AppLocalizations.of(context)!.unnamedRoutine;
    }
    // Validate if editing (listener already added in initState)
    if (_isEditing) {
      _validateName();
    }
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateName);
    _nameController.dispose();
    super.dispose();
  }

  void _validateName() {
    if (!_isEditing) return;
    final trimmed = _nameController.text.trim();
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;
    setState(() {
      if (trimmed.isEmpty) {
        _nameError = l10n.nameRequired;
      } else if (trimmed.length > 50) {
        _nameError = l10n.nameMaxLength;
      } else {
        _nameError = null;
      }
    });
  }

  bool get _isNameValid {
    final trimmed = _nameController.text.trim();
    return trimmed.isNotEmpty && trimmed.length <= 50;
  }

  bool get _canReorderIntervals => _intervals.length > 1;

  /// Build current routine from state - READ ONLY, NO MUTATIONS
  /// This is called in build() and must never mutate intervals or any state
  Routine _buildCurrentRoutine() {
    String name = _nameController.text.trim().isEmpty
        ? AppLocalizations.of(context)!.unnamedRoutine
        : _nameController.text.trim();

    // Enforce storage limit (100 chars for backward compatibility)
    if (name.length > 100) {
      name = name.substring(0, 100);
      assert(() {
        return true;
      }());
    }

    // Create new Routine with current intervals - intervals are immutable so safe to pass
    // NO mutations happen here - just reading from _intervals
    return Routine(
      id: widget.routine?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      difficulty: _difficulty,
      intervals:
          _intervals, // Pass by reference is safe - Interval is immutable
      machineType: _machineType,
    );
  }

  /// DRIFT GUARD: Log interval snapshot for debugging
  void _logIntervalSnapshot(String stage, List<Interval> intervals) {
    if (stage.isEmpty && intervals.isEmpty) return;
  }

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool _areAllIntervalsValid() {
    if (_intervals.isEmpty) return false;
    if (!_isNameValid) return false;

    for (final interval in _intervals) {
      // Duration must be >= 1 second
      if (interval.durationSeconds < 1 || interval.durationSeconds > 10800) {
        return false;
      }

      switch (_machineType) {
        case MachineType.treadmill:
          // Speed must be > 0
          if (interval.speedKmh == null ||
              interval.speedKmh! <= 0 ||
              interval.speedKmh! > 25.0) {
            return false;
          }
          // Grade must be >= 0
          if (interval.grade == null ||
              interval.grade! < 0 ||
              interval.grade! > 15.0) {
            return false;
          }
          break;
        case MachineType.cycle:
          if (interval.rpm == null ||
              interval.rpm! < 30 ||
              interval.rpm! > 200) {
            return false;
          }
          if (interval.resistance == null ||
              interval.resistance! < 1 ||
              interval.resistance! > 20) {
            return false;
          }
          break;
        case MachineType.stairmaster:
          if (interval.level == null ||
              interval.level! < 1 ||
              interval.level! > 20) {
            return false;
          }
          // SPM validation removed
          break;
      }
    }

    return true;
  }

  void _toggleEditMode() {
    if (_isEditing) {
      // Cancel button pressed - discard draft and revert to original values or close if new
      if (widget.isNew || _originalRoutine == null) {
        // New routine - close sheet on cancel
        Navigator.pop(context);
        return;
      } else {
        // Existing routine - discard draft and revert to original deep copy
        if (!mounted) return;
        setState(() {
          _draftRoutine = _originalRoutine!.deepCopy();
          _nameController.text = _draftRoutine!.name;
          _difficulty = _draftRoutine!.difficulty;
          _intervals = _draftRoutine!.intervals.toList();
          _machineType = _draftRoutine!.machineType;
          _isReordering = false;
          _enteringIntervalIds.clear();
          _removingIntervalIds.clear();
          _isEditing = false;
          _nameError = null;
        });
        _nameController.removeListener(_validateName);
        // DRIFT GUARD: Log after cancel
        _logIntervalSnapshot('CANCEL_EDIT', _intervals);
      }
    } else {
      // Enter edit mode - create deep copy draft
      if (!mounted) return;
      setState(() {
        // Use _originalRoutine if available (updated after save), otherwise use widget.routine
        final sourceRoutine = _originalRoutine ?? widget.routine;
        if (sourceRoutine != null) {
          _draftRoutine = sourceRoutine.deepCopy();
          _intervals = _draftRoutine!.intervals.toList();
        }
        _isReordering = false;
        _enteringIntervalIds.clear();
        _removingIntervalIds.clear();
        _isEditing = true;
      });
      _nameController.addListener(_validateName);
      _validateName();
      // DRIFT GUARD: Log when entering edit mode
      if (_originalRoutine != null || widget.routine != null) {
        _logIntervalSnapshot('ENTER_EDIT', _intervals);
      }
    }
  }

  void _showDifficultyPicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => _DifficultyPickerSheet(
        currentDifficulty: _difficulty,
        onSelected: (difficulty) {
          if (!mounted) return;
          setState(() {
            _difficulty = difficulty;
          });
        },
      ),
    );
  }

  String _generateIntervalId([int seed = 0]) {
    return '${DateTime.now().millisecondsSinceEpoch}_${_intervals.length}_${seed}_${DateTime.now().microsecondsSinceEpoch}';
  }

  Interval _buildDefaultInterval({String? id}) {
    switch (_machineType) {
      case MachineType.treadmill:
        return Interval.treadmill(
          id: id,
          durationSeconds: 300,
          speedKmh: 5.0,
          grade: 0.0,
        );
      case MachineType.cycle:
        return Interval.cycle(
          id: id,
          durationSeconds: 300,
          rpm: 60,
          resistance: 5,
        );
      case MachineType.stairmaster:
        return Interval.stairmaster(
          id: id,
          durationSeconds: 300,
          level: 5,
        );
    }
  }

  Interval _cloneIntervalWithNewId(Interval interval, {int seed = 0}) {
    return interval.copyWith(id: _generateIntervalId(seed));
  }

  void _insertIntervalsWithAnimation(
    List<Interval> intervalsToInsert, {
    int? atIndex,
    required String logStage,
  }) {
    if (intervalsToInsert.isEmpty) {
      return;
    }

    final intervalIds =
        intervalsToInsert.map((interval) => interval.id).toSet();

    setState(() {
      if (atIndex == null) {
        _intervals.addAll(intervalsToInsert);
      } else {
        _intervals.insertAll(atIndex, intervalsToInsert);
      }
      _enteringIntervalIds.addAll(intervalIds);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _enteringIntervalIds.removeAll(intervalIds);
      });
    });

    _logIntervalSnapshot(logStage, _intervals);
  }

  void _addInterval() {
    _insertIntervalsWithAnimation(
      [_buildDefaultInterval(id: _generateIntervalId())],
      logStage: 'ADD_INTERVAL',
    );
  }

  void _duplicateIntervalBelow(String intervalId) {
    final index =
        _intervals.indexWhere((interval) => interval.id == intervalId);
    if (index < 0) return;

    final clone = _cloneIntervalWithNewId(_intervals[index], seed: index + 1);
    _insertIntervalsWithAnimation(
      [clone],
      atIndex: index + 1,
      logStage: 'DUPLICATE_INTERVAL_BELOW',
    );
  }

  void _repeatTailPattern({
    required int patternLength,
    required int repeatCount,
  }) {
    if (_intervals.isEmpty || patternLength < 1 || repeatCount < 1) {
      return;
    }

    final safePatternLength = patternLength.clamp(1, _intervals.length);
    final pattern = List<Interval>.from(
      _intervals.sublist(_intervals.length - safePatternLength),
    );

    final clones = <Interval>[];
    for (int copyIndex = 0; copyIndex < repeatCount; copyIndex++) {
      for (int itemIndex = 0; itemIndex < pattern.length; itemIndex++) {
        final seed = (copyIndex * 100) + itemIndex;
        clones.add(
          _cloneIntervalWithNewId(pattern[itemIndex], seed: seed),
        );
      }
    }

    _insertIntervalsWithAnimation(
      clones,
      logStage: 'REPEAT_TAIL_PATTERN',
    );
  }

  void _showRepeatPatternPicker() {
    if (_intervals.isEmpty) {
      _addInterval();
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final maxPatternLength = _intervals.length.clamp(1, 6);
    final patternLengths =
        List<int>.generate(maxPatternLength, (index) => index + 1);
    final repeatCounts = List<int>.generate(10, (index) => index + 1);

    int tempPatternLength = patternLengths.length >= 2 ? 2 : 1;
    int tempRepeatCount = 3;
    final initialPatternIndex = patternLengths.indexOf(tempPatternLength);
    final initialRepeatIndex = repeatCounts.indexOf(tempRepeatCount);

    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (context) => Container(
        height: 320,
        padding: const EdgeInsets.only(top: 6),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CupertinoButton(
                        child: Text(
                          l10n.cancel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      l10n.repeatPattern,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CupertinoButton(
                        child: Text(
                          l10n.done,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _repeatTailPattern(
                            patternLength: tempPatternLength,
                            repeatCount: tempRepeatCount,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.patternLength,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        l10n.repeatCount,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: initialPatternIndex >= 0
                              ? initialPatternIndex
                              : 0,
                        ),
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          tempPatternLength = patternLengths[index];
                        },
                        children: patternLengths.map((length) {
                          return Center(
                            child: Text(
                              LocalizedFormat.decimal(
                                context,
                                length,
                                decimalDigits: 0,
                              ),
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem:
                              initialRepeatIndex >= 0 ? initialRepeatIndex : 0,
                        ),
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          tempRepeatCount = repeatCounts[index];
                        },
                        children: repeatCounts.map((count) {
                          return Center(
                            child: Text(
                              LocalizedFormat.decimal(
                                context,
                                count,
                                decimalDigits: 0,
                              ),
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteInterval(String intervalId) async {
    if (_removingIntervalIds.contains(intervalId)) {
      return;
    }

    setState(() {
      _enteringIntervalIds.remove(intervalId);
      _removingIntervalIds.add(intervalId);
    });

    await Future<void>.delayed(_intervalRemoveAnimationDuration);

    if (!mounted || !_removingIntervalIds.contains(intervalId)) {
      return;
    }

    setState(() {
      _removingIntervalIds.remove(intervalId);
      _intervals.removeWhere((i) => i.id == intervalId);
      if (!_canReorderIntervals) {
        _isReordering = false;
      }
    });
    // DRIFT GUARD: Log after deleting interval
    _logIntervalSnapshot('DELETE_INTERVAL', _intervals);
  }

  void _updateIntervalById(String intervalId, Interval updatedInterval) {
    setState(() {
      final index = _intervals.indexWhere((i) => i.id == intervalId);
      if (index >= 0) {
        _intervals[index] = updatedInterval;
        // Debug: Log interval update
        // DRIFT GUARD: Log after updating interval
        _logIntervalSnapshot('UPDATE_INTERVAL', _intervals);
      }
    });
  }

  void _reorderIntervals(int oldIndex, int newIndex) {
    if (oldIndex == newIndex) {
      return;
    }

    setState(() {
      _intervals = reorderItems(_intervals, oldIndex, newIndex);
    });
    _logIntervalSnapshot('REORDER_INTERVALS', _intervals);
  }

  void _toggleReorderMode() {
    if (!_canReorderIntervals) {
      return;
    }

    setState(() {
      _isReordering = !_isReordering;
    });
  }

  void _showFreeLimitSheet() {
    final l10n = AppLocalizations.of(context)!;

    PremiumBottomSheet.show(
      context,
      title: l10n.premiumMembership,
      bulletItems: [
        l10n.routineLimitBenefit1,
        l10n.routineLimitBenefit2,
        l10n.routineLimitBenefit3,
      ],
    );
  }

  Future<void> _saveRoutine() async {
    final l10n = AppLocalizations.of(context)!;
    // Validate name first
    final trimmedName = _nameController.text.trim();
    if (trimmedName.isEmpty) {
      setState(() {
        _nameError = l10n.nameRequired;
      });
      return;
    }
    if (trimmedName.length > 50) {
      setState(() {
        _nameError = l10n.nameMaxLength;
      });
      return;
    }

    if (_intervals.isEmpty) {
      showAppMessage(context, l10n.minIntervalsRequired,
          type: AppMessageType.error);
      return;
    }

    // Validate all intervals have valid values
    for (final interval in _intervals) {
      if (interval.durationSeconds < 1) {
        showAppMessage(context, l10n.intervalMinDuration,
            type: AppMessageType.error);
        return;
      }
      if (interval.durationSeconds > 10800) {
        // 3 hours max
        showAppMessage(context, l10n.intervalMaxDuration,
            type: AppMessageType.error);
        return;
      }

      switch (_machineType) {
        case MachineType.treadmill:
          if (interval.speedKmh == null ||
              interval.speedKmh! <= 0 ||
              interval.speedKmh! > 25.0) {
            showAppMessage(context, l10n.speedRange,
                type: AppMessageType.error);
            return;
          }
          if (interval.grade == null ||
              interval.grade! < 0 ||
              interval.grade! > 15.0) {
            showAppMessage(context, l10n.inclineRange,
                type: AppMessageType.error);
            return;
          }
          break;
        case MachineType.cycle:
          if (interval.rpm == null ||
              interval.rpm! < 30 ||
              interval.rpm! > 200) {
            showAppMessage(context, l10n.rpmRange, type: AppMessageType.error);
            return;
          }
          if (interval.resistance == null ||
              interval.resistance! < 1 ||
              interval.resistance! > 20) {
            showAppMessage(context, l10n.resistanceRange,
                type: AppMessageType.error);
            return;
          }
          break;
        case MachineType.stairmaster:
          if (interval.level == null ||
              interval.level! < 1 ||
              interval.level! > 20) {
            showAppMessage(context, l10n.levelRange,
                type: AppMessageType.error);
            return;
          }
          // SPM validation removed
          break;
      }
    }

    HapticFeedback.mediumImpact();
    final provider = Provider.of<RoutineProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);

    final routine = _buildCurrentRoutine();

    // DRIFT GUARD: Log snapshot before save
    _logIntervalSnapshot('BEFORE_SAVE', routine.intervals);

    if (widget.isNew || widget.routine == null) {
      // Check free limit when adding new treadmill routine
      if (_machineType == MachineType.treadmill &&
          !settingsProvider.isPremium &&
          provider.routines
                  .where((r) => r.machineType == MachineType.treadmill)
                  .length >=
              2) {
        _showFreeLimitSheet();
        return;
      }
      await provider.addRoutine(routine);
      AnalyticsService.instance.logEvent(
        'routine_added',
        {
          'source': 'manual',
          'machine_type': routine.machineType.name,
          'interval_count': routine.intervals.length,
        },
      );
      // Close sheet after creating new routine
      if (mounted) {
        Navigator.pop(context);
      }
    } else {
      await provider.updateRoutine(routine);

      // DRIFT GUARD: After save, reload and verify
      await provider.loadRoutines();
      final savedRoutine =
          provider.routines.firstWhere((r) => r.id == routine.id);
      _logIntervalSnapshot('AFTER_SAVE_RELOAD', savedRoutine.intervals);

      // Return to view mode after updating existing routine
      if (mounted) {
        setState(() {
          _isEditing = false;
          _isReordering = false;
          _originalRoutine = savedRoutine.deepCopy();
          _draftRoutine = savedRoutine.deepCopy();
          _intervals = _draftRoutine!.intervals.toList();
        });
      }
    }
  }

  Future<void> _startWorkout() async {
    final routine = _buildCurrentRoutine();

    // Check if user is premium - premium users don't see ads
    final isPremium = widget.settingsProvider.isPremium;

    if (isPremium) {
      final navigator = Navigator.of(context);
      var notificationsAuthorized = false;
      if (widget.settingsProvider.backgroundIntervalNotificationsEnabled) {
        notificationsAuthorized =
            await WorkoutReminderService.instance.requestPermissions();
        if (!notificationsAuthorized) {
          final liveActivitiesEnabled =
              await WorkoutLiveActivityService.instance.areActivitiesEnabled();
          if (!liveActivitiesEnabled) {
            await widget.settingsProvider
                .updateBackgroundIntervalNotifications(false);
          }
        }
      }
      if (!mounted) return;
      // Premium user: close bottom sheet and navigate directly without ads
      navigator.pop();
      navigator.push(
        MaterialPageRoute(
          builder: (context) => WorkoutScreen(
            routine: routine,
            backgroundNotificationsAuthorized: notificationsAuthorized,
          ),
        ),
      );
      return;
    }

    // Save navigator context before closing bottom sheet
    final navigatorContext = Navigator.of(context, rootNavigator: true);

    // Show interstitial ad if available, then navigate to workout
    // Don't close bottom sheet yet - close it when ad is dismissed
    final adService = AdService();
    final wasAdShown = adService.showAd(
      onAdClosed: () {
        // Close bottom sheet and navigate to workout screen
        if (mounted) {
          Navigator.pop(context); // Close bottom sheet
        }
        // Use root navigator to push workout screen
        navigatorContext.push(
          MaterialPageRoute(
            builder: (context) => WorkoutScreen(routine: routine),
          ),
        );
      },
    );

    // If ad wasn't shown, close bottom sheet and navigate immediately
    if (!wasAdShown) {
      if (mounted) {
        Navigator.pop(context); // Close bottom sheet
      }
      navigatorContext.push(
        MaterialPageRoute(
          builder: (context) => WorkoutScreen(routine: routine),
        ),
      );
    }
  }

  void _showDeleteConfirmation() {
    if (_isDeleting || widget.routine == null || widget.routine!.id.isEmpty) {
      return;
    }

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final baseTextStyle = theme.textTheme.bodyMedium;
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: DefaultTextStyle.merge(
          style: baseTextStyle?.copyWith(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
            decoration: TextDecoration.none,
          ),
          child: Text(l10n.deleteRoutineTitle),
        ),
        message: DefaultTextStyle.merge(
          style: baseTextStyle?.copyWith(
            fontSize: 13,
            color: context.appColors.mutedText,
            decoration: TextDecoration.none,
          ),
          child: Text(l10n.deleteRoutineMessage),
        ),
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
              _deleteRoutine();
            },
            child: DefaultTextStyle.merge(
              style: baseTextStyle?.copyWith(
                color: context.appColors.danger,
                decoration: TextDecoration.none,
              ),
              child: Text(l10n.delete),
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: DefaultTextStyle.merge(
            style: baseTextStyle?.copyWith(decoration: TextDecoration.none),
            child: Text(l10n.cancel),
          ),
        ),
      ),
    );
  }

  Future<void> _deleteRoutine() async {
    if (_isDeleting || widget.routine == null || widget.routine!.id.isEmpty) {
      return;
    }

    HapticFeedback.mediumImpact();
    setState(() {
      _isDeleting = true;
    });

    try {
      final provider = Provider.of<RoutineProvider>(context, listen: false);
      await provider.deleteRoutine(widget.routine!.id);

      if (!mounted) return;

      // Close bottom sheet
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isDeleting = false;
      });

      final l10n = AppLocalizations.of(context)!;
      showAppMessage(context, l10n.deleteError, type: AppMessageType.error);
    }
  }

  void _shareRoutine() {
    final routine = widget.routine;
    if (routine == null) return;

    final l10n = AppLocalizations.of(context)!;

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              Navigator.pop(context); // Close action sheet
              final l10n = AppLocalizations.of(context)!;
              final shareLink = await RoutineSharing.generateShareLink(routine);
              final message = l10n.shareRoutineMessage(routine.name, shareLink);

              final box = _shareButtonKey.currentContext?.findRenderObject()
                  as RenderBox?;
              Rect? shareOrigin;
              if (box != null) {
                shareOrigin = box.localToGlobal(Offset.zero) & box.size;
              }

              await Share.share(
                message,
                sharePositionOrigin: shareOrigin,
              );
              AnalyticsService.instance.logEvent(
                'routine_shared',
                {
                  'method': 'system_share',
                  'machine_type': routine.machineType.name,
                },
              );
            },
            child: Text(l10n.shareRoutine),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context); // Close action sheet
              QrShareDialog.show(context, routine);
            },
            child: Text(l10n.shareViaQrCode),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
      ),
    );
  }

  Widget _buildSheetHeader(
    Routine currentRoutine,
    String totalDurationFormatted,
    Color layeredSurfaceColor,
  ) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Column(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 52,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 56),
                    child: _isEditing
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Center(
                                  child: SizedBox(
                                    width: 260,
                                    child: TextField(
                                      controller: _nameController,
                                      textAlign: TextAlign.center,
                                      maxLines: 1,
                                      maxLength: 50,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(50),
                                      ],
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: _nameError != null
                                            ? theme.colorScheme.error
                                            : theme.colorScheme.onSurface,
                                        letterSpacing: -0.5,
                                      ),
                                      decoration: const InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                        counterText: '',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 180,
                                child: Container(
                                  height: 1.25,
                                  margin: const EdgeInsets.only(bottom: 2),
                                  decoration: BoxDecoration(
                                    color: _nameError != null
                                        ? theme.colorScheme.error
                                        : theme.colorScheme.onSurface
                                            .withValues(alpha: 0.22),
                                    borderRadius: BorderRadius.circular(999),
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Text(
                            currentRoutine.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                              letterSpacing: -0.5,
                            ),
                          ),
                  ),
                  if (!_isEditing && widget.routine != null && !widget.isNew)
                    Positioned(
                      left: 16,
                      top: 0,
                      bottom: 0,
                      child: CupertinoButton(
                        key: _shareButtonKey,
                        padding: EdgeInsets.zero,
                        onPressed: _shareRoutine,
                        minimumSize: const Size(32, 32),
                        child: Icon(
                          CupertinoIcons.share,
                          color: theme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  if (!_isEditing && widget.routine != null && !widget.isNew)
                    Positioned(
                      right: 16,
                      top: 0,
                      bottom: 0,
                      child: _isDeleting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: _showDeleteConfirmation,
                              minimumSize: const Size(32, 32),
                              child: Icon(
                                CupertinoIcons.trash,
                                color: theme.colorScheme.error,
                                size: 20,
                              ),
                            ),
                    ),
                ],
              ),
            ),
            if (_isEditing && _nameError != null)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  _nameError!,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.colorScheme.error,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          totalDurationFormatted,
          style: TextStyle(
            fontSize: 56,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
            letterSpacing: -1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        _isEditing
            ? GestureDetector(
                onTap: _showDifficultyPicker,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: layeredSurfaceColor,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: theme.brightness == Brightness.dark
                          ? Colors.white.withValues(alpha: 0.08)
                          : appColors.border,
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.difficultyColon(
                        _getLocalizedDifficulty(context, _difficulty)),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: layeredSurfaceColor,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.08)
                        : appColors.border,
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.difficultyColon(
                      _getLocalizedDifficulty(
                          context, currentRoutine.difficulty)),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.2,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
        const SizedBox(height: 24),
        if (_isEditing && _intervals.isNotEmpty) ...[
          _buildQuickToolsCard(),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  Widget _buildEmptyIntervalsState() {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.noIntervals,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: appColors.mutedText,
              ),
            ),
          ),
          IconButton(
            onPressed: _addInterval,
            icon: const Icon(Icons.add_circle_outline),
            color: theme.colorScheme.primary,
            tooltip: AppLocalizations.of(context)!.addInterval,
          ),
        ],
      ),
    );
  }

  Widget _buildAddIntervalButton() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton.icon(
            onPressed: _addInterval,
            icon: Icon(Icons.add_circle_outline,
                color: theme.colorScheme.primary),
            label: Text(
              AppLocalizations.of(context)!.addInterval,
              style: TextStyle(color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReorderProxy(
    Widget child,
    int index,
    Animation<double> animation,
  ) {
    return child;
  }

  Widget _buildIntervalsSliver() {
    if (_intervals.isEmpty && _isEditing) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverToBoxAdapter(child: _buildEmptyIntervalsState()),
      );
    }

    if (_isEditing && _isReordering) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverReorderableList(
          itemBuilder: (context, index) {
            final interval = _intervals[index];
            return _buildIntervalRow(
              interval,
              _machineType,
              widget.settingsProvider,
              reorderIndex: index,
            );
          },
          itemCount: _intervals.length,
          onReorder: _reorderIntervals,
          proxyDecorator: _buildReorderProxy,
        ),
      );
    }

    if (_isEditing) {
      return SliverPadding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final interval = _intervals[index];
            return _buildIntervalRow(
              interval,
              _machineType,
              widget.settingsProvider,
            );
          }, childCount: _intervals.length),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final interval = _intervals[index];
          return _buildIntervalRow(
            interval,
            _machineType,
            widget.settingsProvider,
          );
        }, childCount: _intervals.length),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // CRITICAL: build() must be PURE - NO mutations, NO setState, NO side effects
    // Only read from state and build UI
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.9;
    final currentRoutine =
        _buildCurrentRoutine(); // Read-only, creates new Routine
    // ALWAYS compute total from current _intervals list (never use cached routine.totalDurationSeconds)
    final totalDuration =
        _intervals.fold(0, (sum, interval) => sum + interval.durationSeconds);
    final totalDurationFormatted = _formatDuration(totalDuration);

    final theme = Theme.of(context);
    final appColors = context.appColors;
    final layeredSurfaceColor = theme.brightness == Brightness.dark
        ? appColors.surfaceElevated
        : const Color(0xFFF2F2F7);
    return AppBottomSheetFrame(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Content
          Flexible(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                  sliver: SliverToBoxAdapter(
                    child: _buildSheetHeader(
                      currentRoutine,
                      totalDurationFormatted,
                      layeredSurfaceColor,
                    ),
                  ),
                ),
                _buildIntervalsSliver(),
                if (_isEditing && !_isReordering && _intervals.isNotEmpty)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                    sliver:
                        SliverToBoxAdapter(child: _buildAddIntervalButton()),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          ),
          BottomSheetActionBar(
            secondaryLabel: _isEditing
                ? AppLocalizations.of(context)!.cancel
                : AppLocalizations.of(context)!.editRoutine,
            primaryLabel: _isEditing
                ? AppLocalizations.of(context)!.save
                : AppLocalizations.of(context)!.start,
            onSecondaryPressed: _toggleEditMode,
            onPrimaryPressed: (_isEditing && !_areAllIntervalsValid())
                ? null
                : (_isEditing ? _saveRoutine : _startWorkout),
          ),
        ],
      ),
    );
  }

  Widget _buildIntervalRow(Interval interval, MachineType machineType,
      AppSettingsProvider settingsProvider,
      {int? reorderIndex}) {
    final isReorderingRow = reorderIndex != null;

    return _EditableIntervalRow(
      key: ValueKey(interval.id), // Stable key based on interval ID
      interval: interval,
      machineType: machineType,
      settingsProvider: settingsProvider,
      reorderIndex: reorderIndex,
      isEditing: _isEditing,
      isEntering: _enteringIntervalIds.contains(interval.id),
      isRemoving: _removingIntervalIds.contains(interval.id),
      onUpdate: (updatedInterval) =>
          _updateIntervalById(interval.id, updatedInterval),
      onDuplicate: _isEditing && !isReorderingRow
          ? () => _duplicateIntervalBelow(interval.id)
          : null,
      onDelete: _isEditing && !isReorderingRow
          ? () => _deleteInterval(interval.id)
          : null,
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF3C3C3C) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : appColors.border,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickToolsCard() {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final l10n = AppLocalizations.of(context)!;
    final isDark = theme.brightness == Brightness.dark;
    final layeredSurfaceColor =
        isDark ? appColors.surfaceElevated : const Color(0xFFF2F2F7);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: layeredSurfaceColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color:
              isDark ? Colors.white.withValues(alpha: 0.08) : appColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isReordering ? l10n.reorderMode : l10n.quickTools,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.82),
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 10),
          if (_isReordering) ...[
            Text(
              l10n.reorderModeHint,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.72),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.check_rounded,
                    label: l10n.done,
                    onTap: _toggleReorderMode,
                  ),
                ),
              ],
            ),
          ] else
            Row(
              children: [
                Expanded(
                  child: _buildQuickActionButton(
                    icon: Icons.repeat,
                    label: l10n.repeatPattern,
                    onTap: _showRepeatPatternPicker,
                  ),
                ),
                if (_canReorderIntervals) const SizedBox(width: 8),
                if (_canReorderIntervals)
                  Expanded(
                    child: _buildQuickActionButton(
                      icon: Icons.reorder_rounded,
                      label: l10n.reorderIntervals,
                      onTap: _toggleReorderMode,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  String _getLocalizedDifficulty(
      BuildContext context, String storedDifficulty) {
    final l10n = AppLocalizations.of(context)!;
    final difficultyStorageValues = ['쉬움', '중간', '높음'];
    final difficultyDisplayValues = [l10n.easy, l10n.medium, l10n.hard];

    final index = difficultyStorageValues.indexOf(storedDifficulty);
    if (index >= 0 && index < difficultyDisplayValues.length) {
      return difficultyDisplayValues[index];
    }
    // Fallback to stored value if not found
    return storedDifficulty;
  }
}

class _DifficultyPickerSheet extends StatelessWidget {
  final String currentDifficulty;
  final Function(String) onSelected;

  const _DifficultyPickerSheet({
    required this.currentDifficulty,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final difficultyDisplayValues = [l10n.easy, l10n.medium, l10n.hard];
    final difficultyStorageValues = ['쉬움', '중간', '높음'];
    var initialIndex = difficultyStorageValues.indexOf(currentDifficulty);
    if (initialIndex < 0) {
      // Fallback if stored value doesn't match
      initialIndex = 0;
    }

    return Container(
      height: 260,
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: AppShadows.elevatedSoft,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            const AppBottomSheetHandle(),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                        minimumSize: const Size(0, 0),
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      AppLocalizations.of(context)!.selectDifficulty,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        decoration: TextDecoration.none,
                        decorationColor: Colors.transparent,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.pop(context),
                        minimumSize: const Size(0, 0),
                        child: Text(
                          AppLocalizations.of(context)!.done,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                scrollController: FixedExtentScrollController(
                  initialItem: initialIndex >= 0 ? initialIndex : 0,
                ),
                itemExtent: 40,
                onSelectedItemChanged: (index) {
                  // Map display index back to storage value
                  onSelected(difficultyStorageValues[index]);
                },
                children: difficultyDisplayValues.map((difficulty) {
                  return Center(
                    child: Text(
                      difficulty,
                      style: TextStyle(
                        fontSize: 20,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditableIntervalRow extends StatefulWidget {
  static const Duration removalAnimationDuration = Duration(milliseconds: 240);

  final Interval interval;
  final MachineType machineType;
  final AppSettingsProvider settingsProvider;
  final int? reorderIndex;
  final bool isEditing;
  final bool isEntering;
  final bool isRemoving;
  final Function(Interval) onUpdate;
  final VoidCallback? onDuplicate;
  final VoidCallback? onDelete;

  const _EditableIntervalRow({
    super.key,
    required this.interval,
    required this.machineType,
    required this.settingsProvider,
    this.reorderIndex,
    required this.isEditing,
    this.isEntering = false,
    this.isRemoving = false,
    required this.onUpdate,
    this.onDuplicate,
    this.onDelete,
  });

  @override
  State<_EditableIntervalRow> createState() => _EditableIntervalRowState();
}

class _EditableIntervalRowState extends State<_EditableIntervalRow>
    with SingleTickerProviderStateMixin {
  // State values for pickers
  late int _durationMinutes;
  late int _durationSeconds;
  late double
      _speedKmh; // Double (preserve 1 decimal) - stores value in user's selected unit (mph or km/h)
  late double _grade; // Double (preserve 1 decimal)
  late int _rpm;
  late int _resistance;
  late int _level;
  late final AnimationController _visibilityController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _sizeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool get _isVisible => !widget.isEntering && !widget.isRemoving;

  @override
  void initState() {
    super.initState();
    _visibilityController = AnimationController(
      vsync: this,
      duration: _EditableIntervalRow.removalAnimationDuration,
      value: _isVisible ? 1 : 0,
    );
    final curved = CurvedAnimation(
      parent: _visibilityController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _visibilityController,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInOutCubic,
    );
    _sizeAnimation = curved;
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(curved);
    _initializeValues();
  }

  void _initializeValues() {
    final totalSeconds = widget.interval.durationSeconds;
    _durationMinutes = totalSeconds ~/ 60;
    _durationSeconds = totalSeconds % 60;

    // Ensure minimum duration of 1 second
    if (_durationMinutes == 0 && _durationSeconds == 0) {
      _durationSeconds = 1;
    }

    switch (widget.machineType) {
      case MachineType.treadmill:
        // Initialize from stored km/h and convert to user's selected unit for display/editing
        final storedSpeedKmh = widget.interval.speedKmh ?? 5.0;
        if (widget.settingsProvider.measurement == 'mph') {
          // Convert km/h to mph for user's selected unit
          _speedKmh = storedSpeedKmh * 0.621371;
        } else {
          _speedKmh = storedSpeedKmh;
        }
        _grade = widget.interval.grade ?? 0.0;
        // Ensure speed > 0
        if (_speedKmh <= 0) {
          _speedKmh = widget.settingsProvider.measurement == 'mph'
              ? (5.0 * 0.621371)
              : 5.0;
        }
        break;
      case MachineType.cycle:
        _rpm = widget.interval.rpm ?? 60;
        _resistance = widget.interval.resistance ?? 5;
        break;
      case MachineType.stairmaster:
        _level = widget.interval.level ?? 5;
        break;
    }

    // Don't call _updateInterval() here - it triggers parent setState during initState/didUpdateWidget
    // Only update when user actually changes values via pickers
  }

  @override
  void didUpdateWidget(_EditableIntervalRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update values when interval changes externally
    // Use WidgetsBinding to defer update to avoid setState during build
    if (oldWidget.interval != widget.interval) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _initializeValues();
        }
      });
    }

    final wasVisible = !oldWidget.isEntering && !oldWidget.isRemoving;
    if (wasVisible != _isVisible) {
      if (_isVisible) {
        _visibilityController.forward();
      } else {
        _visibilityController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _visibilityController.dispose();
    super.dispose();
  }

  void _updateInterval() {
    if (!widget.isEditing) return;

    final totalSeconds = _durationMinutes * 60 + _durationSeconds;
    // Ensure minimum duration of 1 second
    if (totalSeconds < 1) return;
    if (totalSeconds > 10800) return; // Max 3 hours

    // Use copyWith with doubles for speed/grade
    Interval updatedInterval;
    switch (widget.machineType) {
      case MachineType.treadmill:
        // Ensure speed > 0
        if (_speedKmh <= 0) return;
        // Convert from user's selected unit to km/h for storage (always store in km/h)
        final speedKmh = widget.settingsProvider.measurement == 'mph'
            ? _speedKmh / 0.621371 // Convert mph to km/h
            : _speedKmh;
        updatedInterval = widget.interval.copyWith(
          durationSeconds: totalSeconds,
          speedKmh: speedKmh.clamp(0.5, 25.0),
          grade: _grade.clamp(0.0, 15.0),
        );
        break;
      case MachineType.cycle:
        updatedInterval = widget.interval.copyWith(
          durationSeconds: totalSeconds,
          rpm: _rpm.clamp(30, 200),
          resistance: _resistance.clamp(1, 20),
        );
        break;
      case MachineType.stairmaster:
        updatedInterval = widget.interval.copyWith(
          durationSeconds: totalSeconds,
          level: _level.clamp(1, 20),
        );
        break;
    }

    widget.onUpdate(updatedInterval);
  }

  String _getPill1Text() {
    final l10n = AppLocalizations.of(context)!;
    switch (widget.machineType) {
      case MachineType.treadmill:
        return widget.settingsProvider
            .formatSpeed(widget.interval.speedKmh ?? 0.0);
      case MachineType.cycle:
        return l10n.rpmValue(
          LocalizedFormat.decimal(
            context,
            widget.interval.rpm ?? 0,
            decimalDigits: 0,
          ),
        );
      case MachineType.stairmaster:
        return l10n.levelColon(
          LocalizedFormat.decimal(
            context,
            widget.interval.level ?? 0,
            decimalDigits: 0,
          ),
        );
    }
  }

  String _getPill2Text() {
    final l10n = AppLocalizations.of(context)!;
    switch (widget.machineType) {
      case MachineType.treadmill:
        return '${LocalizedFormat.decimal(context, widget.interval.grade ?? 0)}%';
      case MachineType.cycle:
        return l10n.resistanceColon(
          LocalizedFormat.decimal(
            context,
            widget.interval.resistance ?? 0,
            decimalDigits: 0,
          ),
        );
      case MachineType.stairmaster:
        return ''; // SPM removed
    }
  }

  void _showDurationPicker(BuildContext context) {
    // CRITICAL: Initialize picker from ACTUAL interval duration (single source of truth)
    final intervalTotalSeconds = widget.interval.durationSeconds;
    final initialMinutes = intervalTotalSeconds ~/ 60;
    final initialSeconds = intervalTotalSeconds % 60;
    final safeMinutes = initialMinutes;
    final safeSeconds =
        (initialMinutes == 0 && initialSeconds == 0) ? 1 : initialSeconds;

    // Local temp values - DO NOT mutate model during scrolling
    int tempMinutes = safeMinutes;
    int tempSeconds = safeSeconds;

    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true, // Allow tap outside to dismiss (cancel)
      builder: (context) => AppCompactPickerSheetFrame(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CupertinoButton(
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          // Cancel: DO NOT commit changes, just close
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      AppLocalizations.of(context)!.duration,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CupertinoButton(
                        child: Text(
                          AppLocalizations.of(context)!.done,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          // Done: Commit temp values to model
                          Navigator.pop(context);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                _durationMinutes = tempMinutes;
                                _durationSeconds = tempSeconds;
                                // Ensure minimum of 1 second
                                if (_durationMinutes == 0 &&
                                    _durationSeconds == 0) {
                                  _durationSeconds = 1;
                                }
                                _updateInterval();
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.ms,
                  minuteInterval: 1,
                  secondInterval: 1,
                  initialTimerDuration: Duration(
                    minutes: safeMinutes,
                    seconds: safeSeconds,
                  ),
                  onTimerDurationChanged: (Duration duration) {
                    // Update ONLY temp values during scrolling - DO NOT mutate model
                    tempMinutes = duration.inMinutes;
                    tempSeconds = duration.inSeconds % 60;
                    if (tempMinutes == 0 && tempSeconds == 0) {
                      tempSeconds = 1;
                    }
                    // DO NOT call _updateInterval() here - only update on Done
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSpeedPicker(BuildContext context) {
    // Initialize picker from current _speedKmh (which is in user's selected unit)
    final currentSpeed = _speedKmh;

    // Generate speed values in user's selected unit (0.5 step increments)
    final List<double> speedValues;
    if (widget.settingsProvider.measurement == 'mph') {
      // Generate mph values: 0.5 to 15.5 mph (equivalent to 0.5-25.0 km/h) in 0.5 steps
      speedValues =
          List.generate(31, (i) => 0.5 + (i * 0.5)); // 0.5, 1.0, 1.5, ..., 15.5
    } else {
      // Generate km/h values: 0.5 to 25.0 km/h in 0.5 steps
      speedValues =
          List.generate(50, (i) => 0.5 + (i * 0.5)); // 0.5, 1.0, 1.5, ..., 25.0
    }

    final initialIndex = speedValues.indexWhere((s) => s >= currentSpeed);
    final selectedIndex = initialIndex >= 0 ? initialIndex : 0;

    // Local temp value - DO NOT mutate model during scrolling (in user's selected unit)
    double tempSpeed = currentSpeed;

    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true, // Allow tap outside to dismiss (cancel)
      builder: (context) => AppCompactPickerSheetFrame(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CupertinoButton(
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          // Cancel: DO NOT commit changes, just close
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${AppLocalizations.of(context)!.speed} ${widget.settingsProvider.measurement == 'mph' ? '(mph)' : '(km/h)'}',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CupertinoButton(
                        child: Text(
                          AppLocalizations.of(context)!.done,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          // Done: Commit temp value to model (in user's selected unit)
                          Navigator.pop(context);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                _speedKmh = tempSpeed;
                                _updateInterval();
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController:
                      FixedExtentScrollController(initialItem: selectedIndex),
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    // Update ONLY temp value during scrolling - DO NOT mutate model (in user's selected unit)
                    tempSpeed = speedValues[index];
                    // DO NOT call _updateInterval() here - only update on Done
                  },
                  children: speedValues.map((speed) {
                    return Center(
                      child: Text(
                        LocalizedFormat.decimal(context, speed),
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showGradePicker(BuildContext context) {
    // CRITICAL: Initialize picker from ACTUAL interval grade (single source of truth)
    final intervalGrade = widget.interval.grade ?? 0.0;
    // Generate grade values: 0.0 to 15.0 in 0.5 steps
    final gradeValues =
        List.generate(31, (i) => i * 0.5); // 0.0, 0.5, 1.0, ..., 15.0
    final initialIndex = gradeValues.indexWhere((g) => g >= intervalGrade);
    final selectedIndex = initialIndex >= 0 ? initialIndex : 0;

    // Local temp value - DO NOT mutate model during scrolling
    double tempGrade = intervalGrade;

    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true, // Allow tap outside to dismiss (cancel)
      builder: (context) => AppCompactPickerSheetFrame(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CupertinoButton(
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          // Cancel: DO NOT commit changes, just close
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      AppLocalizations.of(context)!.incline,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CupertinoButton(
                        child: Text(
                          AppLocalizations.of(context)!.done,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          // Done: Commit temp value to model
                          Navigator.pop(context);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                _grade = tempGrade;
                                _updateInterval();
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController:
                      FixedExtentScrollController(initialItem: selectedIndex),
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    // Update ONLY temp value during scrolling - DO NOT mutate model
                    tempGrade = gradeValues[index];
                    // DO NOT call _updateInterval() here - only update on Done
                  },
                  children: gradeValues.map((grade) {
                    return Center(
                      child: Text(
                        LocalizedFormat.decimal(context, grade),
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRpmPicker(BuildContext context) {
    // CRITICAL: Initialize picker from ACTUAL interval rpm (single source of truth)
    final intervalRpm = widget.interval.rpm ?? 60;
    // Generate RPM values in steps of 5: 30, 35, 40, ..., 195, 200
    final rpms =
        List.generate(35, (i) => 30 + i * 5); // 30 to 200 in steps of 5
    // Round to nearest 5-step value
    final roundedRpm = ((intervalRpm / 5).round() * 5).clamp(30, 200);
    final initialIndex = rpms.indexWhere((r) => r >= roundedRpm);
    final selectedIndex = initialIndex >= 0 ? initialIndex : 0;

    // Local temp value - DO NOT mutate model during scrolling
    int tempRpm = intervalRpm;

    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (context) => AppCompactPickerSheetFrame(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CupertinoButton(
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              AppLocalizations.of(context)!.rpm,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onSurface,
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(28, 28),
                            onPressed: () => _showRpmInfoSheet(context),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.06),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.info,
                                size: 14,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CupertinoButton(
                        child: Text(
                          AppLocalizations.of(context)!.done,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                _rpm = tempRpm;
                                _updateInterval();
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController:
                      FixedExtentScrollController(initialItem: selectedIndex),
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    // Update ONLY temp value during scrolling - DO NOT mutate model
                    tempRpm = rpms[index];
                  },
                  children: rpms.map((rpm) {
                    return Center(
                      child: Text(
                        LocalizedFormat.decimal(
                          context,
                          rpm,
                          decimalDigits: 0,
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRpmInfoSheet(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showAppDialog<void>(
      context: context,
      builder: (dialogContext) => AppDialog(
        icon: CupertinoIcons.info,
        title: l10n.rpm,
        message: l10n.rpmInfoDescription,
        actions: [
          AppDialogAction(
            label: l10n.done,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      ),
    );
  }

  void _showResistancePicker(BuildContext context) {
    // CRITICAL: Initialize picker from ACTUAL interval resistance (single source of truth)
    final intervalResistance = widget.interval.resistance ?? 5;
    final resistances = List.generate(20, (i) => i + 1); // 1 to 20
    final initialIndex = resistances.indexWhere((r) => r >= intervalResistance);
    final selectedIndex = initialIndex >= 0 ? initialIndex : 0;

    // Local temp value - DO NOT mutate model during scrolling
    int tempResistance = intervalResistance;

    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (context) => AppCompactPickerSheetFrame(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CupertinoButton(
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      AppLocalizations.of(context)!.resistance,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CupertinoButton(
                        child: Text(
                          AppLocalizations.of(context)!.done,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                _resistance = tempResistance;
                                _updateInterval();
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController:
                      FixedExtentScrollController(initialItem: selectedIndex),
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    // Update ONLY temp value during scrolling - DO NOT mutate model
                    tempResistance = resistances[index];
                  },
                  children: resistances.map((resistance) {
                    return Center(
                      child: Text(
                        LocalizedFormat.decimal(
                          context,
                          resistance,
                          decimalDigits: 0,
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLevelPicker(BuildContext context) {
    // CRITICAL: Initialize picker from ACTUAL interval level (single source of truth)
    final intervalLevel = widget.interval.level ?? 5;
    final levels = List.generate(20, (i) => i + 1); // 1 to 20
    final initialIndex = levels.indexWhere((l) => l >= intervalLevel);
    final selectedIndex = initialIndex >= 0 ? initialIndex : 0;

    // Local temp value - DO NOT mutate model during scrolling
    int tempLevel = intervalLevel;

    showCupertinoModalPopup(
      context: context,
      barrierDismissible: true,
      builder: (context) => AppCompactPickerSheetFrame(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: CupertinoButton(
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      AppLocalizations.of(context)!.level,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: CupertinoButton(
                        child: Text(
                          AppLocalizations.of(context)!.done,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) {
                              setState(() {
                                _level = tempLevel;
                                _updateInterval();
                              });
                            }
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: CupertinoPicker(
                  scrollController:
                      FixedExtentScrollController(initialItem: selectedIndex),
                  itemExtent: 40,
                  onSelectedItemChanged: (int index) {
                    // Update ONLY temp value during scrolling - DO NOT mutate model
                    tempLevel = levels[index];
                  },
                  children: levels.map((level) {
                    return Center(
                      child: Text(
                        LocalizedFormat.decimal(
                          context,
                          level,
                          decimalDigits: 0,
                        ),
                        style: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // _showSpmPicker removed - SPM feature removed

  String _getEditableField1Text() {
    final l10n = AppLocalizations.of(context)!;
    switch (widget.machineType) {
      case MachineType.treadmill:
        final value = LocalizedFormat.decimal(context, _speedKmh);
        final unit =
            widget.settingsProvider.measurement == 'mph' ? 'mph' : 'km/h';
        return '$value $unit';
      case MachineType.cycle:
        return l10n.rpmValue(
          LocalizedFormat.decimal(context, _rpm, decimalDigits: 0),
        );
      case MachineType.stairmaster:
        return l10n.levelColon(
          LocalizedFormat.decimal(context, _level, decimalDigits: 0),
        );
    }
  }

  String _getEditableField2Text() {
    final l10n = AppLocalizations.of(context)!;
    switch (widget.machineType) {
      case MachineType.treadmill:
        return '${LocalizedFormat.decimal(context, _grade)}%';
      case MachineType.cycle:
        return l10n.resistanceColon(
          LocalizedFormat.decimal(
            context,
            _resistance,
            decimalDigits: 0,
          ),
        );
      case MachineType.stairmaster:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final layeredSurfaceColor =
        isDark ? appColors.surfaceElevated : const Color(0xFFF2F2F7);
    final chipSurfaceColor = isDark ? const Color(0xFF3C3C3C) : Colors.white;
    final chipTextStyle = TextStyle(
      fontSize: 14 * ResponsiveUtils.getFontScale(context),
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.onSurface,
    );

    Widget buildChipLabel(String text) {
      return FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          text,
          maxLines: 1,
          softWrap: false,
          style: chipTextStyle,
        ),
      );
    }

    Widget buildChipContainer({
      required Widget child,
      VoidCallback? onTap,
    }) {
      final chip = Container(
        width: double.infinity,
        padding: ResponsiveUtils.getChipPadding(context),
        decoration: BoxDecoration(
          color: chipSurfaceColor,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(child: child),
      );

      if (onTap == null) {
        return chip;
      }

      return GestureDetector(
        onTap: onTap,
        child: chip,
      );
    }

    // Build chips for VIEW and EDIT modes
    Widget durationChip;
    Widget field1Chip;
    Widget? field2Chip; // Nullable for Stairmaster (SPM removed)

    if (widget.isEditing) {
      // EDIT mode: tappable chips that open pickers
      durationChip = buildChipContainer(
        onTap: () => _showDurationPicker(context),
        child: buildChipLabel(
          '${_durationMinutes.toString().padLeft(2, '0')}:${_durationSeconds.toString().padLeft(2, '0')}',
        ),
      );

      field1Chip = buildChipContainer(
        onTap: () {
          if (widget.machineType == MachineType.treadmill) {
            _showSpeedPicker(context);
          } else if (widget.machineType == MachineType.cycle) {
            _showRpmPicker(context);
          } else {
            _showLevelPicker(context);
          }
        },
        child: buildChipLabel(_getEditableField1Text()),
      );

      // Field2 chip - only for Treadmill and Cycle (SPM removed for Stairmaster)
      if (widget.machineType != MachineType.stairmaster) {
        field2Chip = buildChipContainer(
          onTap: () {
            if (widget.machineType == MachineType.treadmill) {
              _showGradePicker(context);
            } else if (widget.machineType == MachineType.cycle) {
              _showResistancePicker(context);
            }
          },
          child: buildChipLabel(_getEditableField2Text()),
        );
      } else {
        field2Chip = null; // SPM removed for Stairmaster
      }
    } else {
      // VIEW mode: read-only chips
      durationChip = buildChipContainer(
        child: buildChipLabel(widget.interval.durationFormatted),
      );

      field1Chip = buildChipContainer(
        child: buildChipLabel(_getPill1Text()),
      );

      if (widget.machineType != MachineType.stairmaster) {
        field2Chip = buildChipContainer(
          child: buildChipLabel(_getPill2Text()),
        );
      } else {
        field2Chip = null; // SPM removed for Stairmaster
      }
    }

    final chipRow = Row(
      children: [
        Expanded(flex: field2Chip != null ? 30 : 36, child: durationChip),
        const SizedBox(width: 6),
        Expanded(flex: 35, child: field1Chip),
        if (field2Chip != null) ...[
          const SizedBox(width: 6),
          Expanded(flex: 35, child: field2Chip),
        ],
      ],
    );

    final rowContent = Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: layeredSurfaceColor,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.08)
                : appColors.border,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: chipRow,
            ),
            if (widget.reorderIndex != null ||
                widget.onDuplicate != null ||
                widget.onDelete != null) ...[
              const SizedBox(width: 10),
              Container(
                width: 1,
                height: 28,
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : appColors.border,
              ),
              const SizedBox(width: 2),
              if (widget.reorderIndex != null)
                ReorderableDragStartListener(
                  index: widget.reorderIndex!,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.grab,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.drag_indicator_rounded,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.56,
                        ),
                        size: 22,
                      ),
                    ),
                  ),
                ),
              if (widget.onDuplicate != null)
                Tooltip(
                  message: l10n.duplicate,
                  child: GestureDetector(
                    onTap: widget.onDuplicate,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.content_copy_outlined,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              if (widget.onDelete != null)
                Tooltip(
                  message: l10n.delete,
                  child: GestureDetector(
                    onTap: widget.onDelete,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: PlatformIcon(
                        cupertino: CupertinoIcons.trash,
                        material: Icons.delete_outline,
                        color: theme.colorScheme.error,
                        size: 22,
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );

    return IgnorePointer(
      ignoring: widget.isRemoving || widget.isEntering,
      child: SizeTransition(
        sizeFactor: _sizeAnimation,
        axisAlignment: -1,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: rowContent,
          ),
        ),
      ),
    );
  }
}
