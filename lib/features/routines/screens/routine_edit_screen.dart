import 'package:flutter/material.dart' hide Interval;
import 'package:flutter/cupertino.dart' hide Interval;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:valcue/l10n/app_localizations.dart';
import 'package:valcue/l10n/localized_format.dart';
import '../models/routine.dart';
import '../models/interval.dart';
import '../models/machine_type.dart';
import '../storage/routine_provider.dart';
import '../../../app_settings/app_settings_provider.dart';
import '../widgets/routine_shared_widgets.dart';
import '../widgets/interval_edit_popup.dart';
import '../../membership/widgets/premium_bottom_sheet.dart';
import '../../../theme/app_theme.dart';
import '../../../services/analytics_service.dart';

class RoutineEditScreen extends StatefulWidget {
  final Routine? routine;
  final MachineType? machineType;

  const RoutineEditScreen({super.key, this.routine, this.machineType});

  @override
  State<RoutineEditScreen> createState() => _RoutineEditScreenState();
}

class _RoutineEditScreenState extends State<RoutineEditScreen> {
  late TextEditingController _nameController;
  late String _difficulty;
  late List<Interval> _intervals;
  late MachineType _machineType;
  String? _nameError;
  int? _selectedIntervalIndex;

  // Original values for comparison
  late String _originalName;
  late String _originalDifficulty;
  late List<Interval> _originalIntervals;

  @override
  void initState() {
    super.initState();
    if (widget.routine != null) {
      _nameController = TextEditingController(text: widget.routine!.name);
      _difficulty = widget.routine!.difficulty;
      _machineType = widget.routine!.machineType;

      // Deep copy intervals - create a NEW list with NEW interval objects
      // Do NOT reuse the same list reference
      _intervals = List<Interval>.from(
        widget.routine!.intervals.map((interval) {
          switch (_machineType) {
            case MachineType.treadmill:
              return Interval.treadmill(
                id: interval.id,
                durationSeconds: interval.durationSeconds,
                speedKmh: interval.speedKmh ?? 5.0,
                grade: interval.grade ?? 0.0,
              );
            case MachineType.cycle:
              return Interval.cycle(
                id: interval.id,
                durationSeconds: interval.durationSeconds,
                rpm: interval.rpm ?? 60,
                resistance: interval.resistance ?? 5,
              );
            case MachineType.stairmaster:
              return Interval.stairmaster(
                id: interval.id,
                durationSeconds: interval.durationSeconds,
                level: interval.level ?? 5,
              );
          }
        }),
      );

      // Store original values for comparison (also deep copy)
      _originalName = widget.routine!.name;
      _originalDifficulty = widget.routine!.difficulty;
      _originalIntervals = List<Interval>.from(
        _intervals.map((i) {
          switch (_machineType) {
            case MachineType.treadmill:
              return Interval.treadmill(
                id: i.id,
                durationSeconds: i.durationSeconds,
                speedKmh: i.speedKmh ?? 5.0,
                grade: i.grade ?? 0.0,
              );
            case MachineType.cycle:
              return Interval.cycle(
                id: i.id,
                durationSeconds: i.durationSeconds,
                rpm: i.rpm ?? 60,
                resistance: i.resistance ?? 5,
              );
            case MachineType.stairmaster:
              return Interval.stairmaster(
                id: i.id,
                durationSeconds: i.durationSeconds,
                level: i.level ?? 5,
              );
          }
        }),
      );
    } else {
      _nameController = TextEditingController();
      _difficulty = '쉬움';
      _intervals = [];
      _machineType = widget.machineType ?? MachineType.treadmill;

      // Default intervals for new routine
      _addInterval();
      if (_machineType == MachineType.treadmill) {
        _addInterval(); // Add second interval for treadmill
      }

      _originalName = '';
      _originalDifficulty = '쉬움';
      _originalIntervals = [];
    }

    _nameController.addListener(_validateName);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.routine == null && _nameController.text.isEmpty) {
      final unnamedRoutine = AppLocalizations.of(context)!.unnamedRoutine;
      _nameController.text = unnamedRoutine;
      _originalName = unnamedRoutine;
    }
    _validateName();
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateName);
    _nameController.dispose();
    super.dispose();
  }

  void _validateName() {
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

  bool get _hasChanges {
    if (widget.routine == null) {
      // New routine: valid if name is valid and has intervals
      return _isNameValid && _intervals.isNotEmpty;
    }

    // Existing routine: check if anything changed
    if (_nameController.text.trim() != _originalName) return true;
    if (_difficulty != _originalDifficulty) return true;
    if (_intervals.length != _originalIntervals.length) return true;

    // Compare intervals
    for (int i = 0; i < _intervals.length; i++) {
      if (i >= _originalIntervals.length) return true;
      final current = _intervals[i];
      final original = _originalIntervals[i];

      if (current.durationSeconds != original.durationSeconds) return true;
      if (current.speedKmh != original.speedKmh) return true;
      if (current.grade != original.grade) return true;
      if (current.rpm != original.rpm) return true;
      if (current.resistance != original.resistance) return true;
      if (current.level != original.level) return true;
    }

    return false;
  }

  int _calculateTotalDuration() {
    return _intervals.fold(
        0, (sum, interval) => sum + interval.durationSeconds);
  }

  void _addInterval() {
    setState(() {
      // DEBUG: Log before adding interval

      switch (_machineType) {
        case MachineType.treadmill:
          _intervals.add(Interval.treadmill(
            durationSeconds: 300, // 5 minutes
            speedKmh: 5.0,
            grade: 0.0,
          ));
          break;
        case MachineType.cycle:
          _intervals.add(Interval.cycle(
            durationSeconds: 300, // 5 minutes
            rpm: 60,
            resistance: 5,
          ));
          break;
        case MachineType.stairmaster:
          _intervals.add(Interval.stairmaster(
            durationSeconds: 300, // 5 minutes
            level: 5,
          ));
          break;
      }
    });
  }

  void _deleteInterval(int index) {
    setState(() {
      _intervals.removeAt(index);

      if (_selectedIntervalIndex == index) {
        _selectedIntervalIndex = null;
      } else if (_selectedIntervalIndex != null &&
          _selectedIntervalIndex! > index) {
        _selectedIntervalIndex = _selectedIntervalIndex! - 1;
      }
    });
  }

  void _onIntervalTap(int index) {
    setState(() {
      _selectedIntervalIndex = index;
    });

    final interval = _intervals[index];
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);

    // Show field selection popup first
    _showFieldSelectionPopup(index, interval, settingsProvider);
  }

  void _showFieldSelectionPopup(
      int index, Interval interval, AppSettingsProvider settingsProvider) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        color: theme.colorScheme.surface,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    IntervalEditPopup.show(
                      context,
                      interval: interval,
                      machineType: _machineType,
                      field: IntervalEditField.duration,
                      onSave: (updated) => _updateInterval(index, updated),
                    );
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    l10n.timeMinutes.split('(')[0].trim(),
                    style: TextStyle(
                      fontSize: 16,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              if (_machineType == MachineType.treadmill) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      IntervalEditPopup.show(
                        context,
                        interval: interval,
                        machineType: _machineType,
                        field: IntervalEditField.speed,
                        onSave: (updated) => _updateInterval(index, updated),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      l10n.speed,
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      IntervalEditPopup.show(
                        context,
                        interval: interval,
                        machineType: _machineType,
                        field: IntervalEditField.incline,
                        onSave: (updated) => _updateInterval(index, updated),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      l10n.incline,
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ] else if (_machineType == MachineType.cycle) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      IntervalEditPopup.show(
                        context,
                        interval: interval,
                        machineType: _machineType,
                        field: IntervalEditField.rpm,
                        onSave: (updated) => _updateInterval(index, updated),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      l10n.rpm,
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      IntervalEditPopup.show(
                        context,
                        interval: interval,
                        machineType: _machineType,
                        field: IntervalEditField.resistance,
                        onSave: (updated) => _updateInterval(index, updated),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      l10n.level,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ] else if (_machineType == MachineType.stairmaster) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      IntervalEditPopup.show(
                        context,
                        interval: interval,
                        machineType: _machineType,
                        field: IntervalEditField.level,
                        onSave: (updated) => _updateInterval(index, updated),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      l10n.level,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedIntervalIndex = null;
                    });
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF0F0F0),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      l10n.cancel,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF666666),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateInterval(int index, Interval updatedInterval) {
    setState(() {
      final oldInterval = _intervals[index];
      if (oldInterval.groupId != null) {
        final groupId = oldInterval.groupId;
        final repeatCount = oldInterval.repeatCount ?? 1;

        final groupIndices = <int>[];
        for (int i = 0; i < _intervals.length; i++) {
          if (_intervals[i].groupId == groupId) {
            groupIndices.add(i);
          }
        }

        if (groupIndices.isNotEmpty) {
          final uniqueCount = (groupIndices.length / repeatCount).ceil();
          final firstIndex = groupIndices.first;
          final relativeOffset = (index - firstIndex) % uniqueCount;

          for (int r = 0; r < repeatCount; r++) {
            final targetIdx = firstIndex + relativeOffset + (r * uniqueCount);
            if (targetIdx < _intervals.length &&
                _intervals[targetIdx].groupId == groupId) {
              _intervals[targetIdx] = updatedInterval.copyWith(
                id: _intervals[targetIdx].id,
              );
            }
          }
        }
      } else {
        _intervals[index] = updatedInterval;
      }
      _selectedIntervalIndex = null;
    });
  }

  void _addRepeatBlock() {
    final l10n = AppLocalizations.of(context)!;
    final title = l10n.addRepeatBlock;

    showCupertinoModalPopup(
        context: context,
        builder: (context) {
          final theme = Theme.of(context);
          int selectedRepeats = 3;

          return StatefulBuilder(builder: (context, setDialogState) {
            return Container(
              height: 280,
              padding: const EdgeInsets.only(top: 6),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: theme.dividerColor,
                            width: 0.5,
                          ),
                        ),
                      ),
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
                                  style: const TextStyle(fontSize: 17),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              title,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: CupertinoButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  Navigator.pop(context);
                                  _insertRepeatBlock(selectedRepeats);
                                },
                                minimumSize: const Size(0, 0),
                                child: Text(
                                  AppLocalizations.of(context)!.addInterval,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.primary,
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
                          initialItem: selectedRepeats - 2,
                        ),
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          setDialogState(() {
                            selectedRepeats = index + 2;
                          });
                        },
                        children: List.generate(9, (index) {
                          final count = index + 2;
                          return Center(
                            child: Text(
                              l10n.repeatTimes(
                                LocalizedFormat.decimal(
                                  context,
                                  count,
                                  decimalDigits: 0,
                                ),
                              ),
                              style: const TextStyle(fontSize: 20),
                            ),
                          );
                        }),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }

  void _insertRepeatBlock(int repeatCount) {
    final groupId = 'group_${DateTime.now().millisecondsSinceEpoch}';
    final List<Interval> blockIntervals = [];

    switch (_machineType) {
      case MachineType.treadmill:
        blockIntervals.add(Interval.treadmill(
          id: '${groupId}_run',
          durationSeconds: 60,
          speedKmh: 8.0,
          grade: 0.0,
          groupId: groupId,
          repeatCount: repeatCount,
        ));
        blockIntervals.add(Interval.treadmill(
          id: '${groupId}_walk',
          durationSeconds: 60,
          speedKmh: 4.0,
          grade: 0.0,
          groupId: groupId,
          repeatCount: repeatCount,
        ));
        break;
      case MachineType.cycle:
        blockIntervals.add(Interval.cycle(
          id: '${groupId}_high',
          durationSeconds: 60,
          rpm: 80,
          resistance: 10,
          groupId: groupId,
          repeatCount: repeatCount,
        ));
        blockIntervals.add(Interval.cycle(
          id: '${groupId}_low',
          durationSeconds: 60,
          rpm: 60,
          resistance: 4,
          groupId: groupId,
          repeatCount: repeatCount,
        ));
        break;
      case MachineType.stairmaster:
        blockIntervals.add(Interval.stairmaster(
          id: '${groupId}_high',
          durationSeconds: 60,
          level: 8,
          groupId: groupId,
          repeatCount: repeatCount,
        ));
        blockIntervals.add(Interval.stairmaster(
          id: '${groupId}_low',
          durationSeconds: 60,
          level: 4,
          groupId: groupId,
          repeatCount: repeatCount,
        ));
        break;
    }

    final List<Interval> finalGroupedList = [];
    for (int r = 0; r < repeatCount; r++) {
      for (final interval in blockIntervals) {
        finalGroupedList.add(interval.copyWith(
          id: '${interval.id}_rep_$r',
        ));
      }
    }

    setState(() {
      _intervals.addAll(finalGroupedList);
    });
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

    return storedDifficulty;
  }

  void _showDifficultyPicker(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final difficultyStorageValues = ['쉬움', '중간', '높음'];
    final difficultyDisplayValues = [l10n.easy, l10n.medium, l10n.hard];
    final currentIndex = difficultyStorageValues.indexOf(_difficulty);

    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return Container(
          height: 260,
          padding: const EdgeInsets.only(top: 6),
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: theme.dividerColor,
                        width: 0.5,
                      ),
                    ),
                  ),
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
                              l10n.cancel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          l10n.difficulty,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
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
                              l10n.done,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.primary,
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
                      initialItem: currentIndex >= 0 ? currentIndex : 0,
                    ),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      setState(() {
                        _difficulty = difficultyStorageValues[index];
                      });
                    },
                    children: difficultyDisplayValues.map((difficulty) {
                      return Center(
                        child: Text(
                          difficulty,
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveRoutine() async {
    if (!_isNameValid || _intervals.isEmpty) return;

    final provider = Provider.of<RoutineProvider>(context, listen: false);
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final name = _nameController.text.trim();

    if (widget.routine != null) {
      // Check free limit when updating treadmill routine
      if (_machineType == MachineType.treadmill &&
          !settingsProvider.isPremium &&
          provider.routines
                  .where((r) => r.machineType == MachineType.treadmill)
                  .length >=
              2 &&
          widget.routine!.machineType != MachineType.treadmill) {
        _showFreeLimitSheet(context);
        return;
      }

      final updatedRoutine = Routine(
        id: widget.routine!.id,
        name: name,
        difficulty: _difficulty,
        intervals: _intervals,
        machineType: _machineType,
      );
      await provider.updateRoutine(updatedRoutine);
    } else {
      // Check free limit when adding new treadmill routine
      if (_machineType == MachineType.treadmill &&
          !settingsProvider.isPremium &&
          provider.routines
                  .where((r) => r.machineType == MachineType.treadmill)
                  .length >=
              2) {
        _showFreeLimitSheet(context);
        return;
      }

      final newRoutine = Routine(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        difficulty: _difficulty,
        intervals: _intervals,
        machineType: _machineType,
      );
      await provider.addRoutine(newRoutine);
      AnalyticsService.instance.logEvent(
        'routine_added',
        {
          'source': 'manual',
          'machine_type': newRoutine.machineType.name,
          'interval_count': newRoutine.intervals.length,
        },
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }

  void _showFreeLimitSheet(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final totalDuration = _calculateTotalDuration();
    final isDark = theme.brightness == Brightness.dark;

    return CupertinoTheme(
      data: CupertinoThemeData(
        brightness: theme.brightness,
        primaryColor: theme.colorScheme.primary,
        barBackgroundColor: theme.colorScheme.surface,
        scaffoldBackgroundColor: theme.scaffoldBackgroundColor,
      ),
      child: CupertinoPageScaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        navigationBar: CupertinoNavigationBar(
          leading: CupertinoNavigationBarBackButton(
            onPressed: () => Navigator.pop(context),
          ),
          middle: Text(AppLocalizations.of(context)!.routineEdit),
          backgroundColor: theme.colorScheme.surface,
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor,
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          bottom: true,
          child: Column(
            children: [
              // Header
              RoutineHeader(
                title: _nameController.text.isEmpty
                    ? AppLocalizations.of(context)!.unnamedRoutine
                    : _nameController.text,
                totalDurationSeconds: totalDuration,
                intervalCount: _intervals.length,
                difficulty: _difficulty,
                isEditing: true,
              ),
              // Name and difficulty section
              CupertinoListSection.insetGrouped(
                margin: EdgeInsets.zero,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CupertinoListTile(
                        title: Text(AppLocalizations.of(context)!.name),
                        trailing: SizedBox(
                          width: 200,
                          child: CupertinoTextField(
                            controller: _nameController,
                            placeholder:
                                AppLocalizations.of(context)!.unnamedRoutine,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 8,
                            ),
                            decoration: null,
                            style: TextStyle(
                              fontSize: 17,
                              color: _nameError != null
                                  ? theme.colorScheme.error
                                  : theme.colorScheme.onSurface,
                            ),
                            textAlign: TextAlign.end,
                            maxLength: 50,
                            maxLengthEnforcement: MaxLengthEnforcement.enforced,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                          ),
                        ),
                      ),
                      if (_nameError != null)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, top: 4, bottom: 8),
                          child: Text(
                            _nameError!,
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                    ],
                  ),
                  CupertinoListTile(
                    title: Text(
                      AppLocalizations.of(context)!.difficulty,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 160),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              _getLocalizedDifficulty(context, _difficulty),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 17,
                                color: theme.extension<AppColors>()!.mutedText,
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            CupertinoIcons.chevron_right,
                            size: 16,
                            color: theme.extension<AppColors>()!.mutedText,
                          ),
                        ],
                      ),
                    ),
                    onTap: () => _showDifficultyPicker(context),
                  ),
                ],
              ),
              // Intervals list
              Expanded(
                child: SingleChildScrollView(
                  child: IntervalList(
                    intervals: _intervals,
                    machineType: _machineType,
                    settingsProvider: settingsProvider,
                    isEditable: true,
                    onIntervalTap: _onIntervalTap,
                    onIntervalDelete: _deleteInterval,
                    selectedIndex: _selectedIntervalIndex,
                    onAddInterval: _addInterval,
                    onAddRepeatBlock: _addRepeatBlock,
                  ),
                ),
              ),
              // Save button
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  border: Border(
                    top: BorderSide(
                      color: theme.dividerColor,
                      width: 0.5,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      onPressed:
                          (_isNameValid && _intervals.isNotEmpty && _hasChanges)
                              ? _saveRoutine
                              : null,
                      color: theme.colorScheme.primary,
                      disabledColor: isDark
                          ? const Color(0xFF2C2C2E)
                          : theme.extension<AppColors>()!.mutedText,
                      borderRadius: BorderRadius.circular(12),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      child: Text(
                        AppLocalizations.of(context)!.save,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
