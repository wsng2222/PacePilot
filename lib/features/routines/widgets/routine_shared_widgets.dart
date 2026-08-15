import 'package:flutter/cupertino.dart' hide Interval;
import 'package:flutter/material.dart' hide Interval;
import 'package:valcue/l10n/app_localizations.dart';
import 'package:valcue/l10n/localized_format.dart';
import '../models/interval.dart';
import '../models/machine_type.dart';
import '../../../app_settings/app_settings_provider.dart';
import 'metric_chip_group.dart' as metric_chip;

/// Shared header widget for routine screens
class RoutineHeader extends StatelessWidget {
  final String title;
  final int totalDurationSeconds;
  final int intervalCount;
  final String difficulty;
  final bool isEditing;
  final VoidCallback? onOverflowTap;

  const RoutineHeader({
    super.key,
    required this.title,
    required this.totalDurationSeconds,
    required this.intervalCount,
    required this.difficulty,
    this.isEditing = false,
    this.onOverflowTap,
  });

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

  String _formatDuration(int totalSeconds) {
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;
    final seconds = totalSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final localizedDifficulty = _getLocalizedDifficulty(context, difficulty);
    final durationText = _formatDuration(totalDurationSeconds);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.routineHeaderSummary(
                    durationText,
                    intervalCount,
                    LocalizedFormat.decimal(
                      context,
                      intervalCount,
                      decimalDigits: 0,
                    ),
                    localizedDifficulty,
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
          if (onOverflowTap != null)
            Semantics(
              label: AppLocalizations.of(context)!.more,
              button: true,
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onOverflowTap,
                minimumSize: const Size(0, 0),
                child: Icon(
                  CupertinoIcons.ellipsis_circle,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  size: 24,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Shared interval row widget
class IntervalRow extends StatelessWidget {
  final Interval interval;
  final MachineType machineType;
  final AppSettingsProvider settingsProvider;
  final bool isEditable;
  final VoidCallback? onTap;
  final bool isSelected;

  const IntervalRow({
    super.key,
    required this.interval,
    required this.machineType,
    required this.settingsProvider,
    this.isEditable = false,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    String value1;
    String value2;

    switch (machineType) {
      case MachineType.treadmill:
        value1 = settingsProvider.formatSpeed(interval.speedKmh ?? 0.0);
        value2 = '${LocalizedFormat.decimal(context, interval.grade ?? 0)}%';
        break;
      case MachineType.cycle:
        value1 = l10n.rpmValue(
          LocalizedFormat.decimal(
            context,
            interval.rpm ?? 0,
            decimalDigits: 0,
          ),
        );
        value2 = l10n.resistanceColon(
          LocalizedFormat.decimal(
            context,
            interval.resistance ?? 0,
            decimalDigits: 0,
          ),
        );
        break;
      case MachineType.stairmaster:
        value1 = l10n.levelColon(
          LocalizedFormat.decimal(
            context,
            interval.level ?? 0,
            decimalDigits: 0,
          ),
        );
        value2 = '';
        break;
    }

    final backgroundColor = isSelected
        ? theme.colorScheme.primary.withValues(alpha: 0.1)
        : Colors.transparent;

    // Build chip items for MetricChipGroup
    final chipItems = <String>[
      interval.durationFormatted,
      value1,
      if (value2.isNotEmpty) value2,
    ];

    return GestureDetector(
      onTap: isEditable ? onTap : null,
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Center(
          child: metric_chip.MetricChipGroup(items: chipItems),
        ),
      ),
    );
  }
}

class _IntervalGroupItem {
  final String? groupId;
  final int? repeatCount;
  final List<int> originalIndices;
  final List<Interval> intervals;

  _IntervalGroupItem({
    this.groupId,
    this.repeatCount,
    required this.originalIndices,
    required this.intervals,
  });
}

List<_IntervalGroupItem> _groupIntervals(List<Interval> flatList) {
  final groups = <_IntervalGroupItem>[];
  if (flatList.isEmpty) return groups;

  String? currentGroupId = flatList[0].groupId;
  int? currentRepeatCount = flatList[0].repeatCount;
  var currentIndices = <int>[0];
  var currentIntervals = <Interval>[flatList[0]];

  for (int i = 1; i < flatList.length; i++) {
    final interval = flatList[i];
    if (interval.groupId != null && interval.groupId == currentGroupId) {
      currentIndices.add(i);
      currentIntervals.add(interval);
    } else {
      groups.add(_IntervalGroupItem(
        groupId: currentGroupId,
        repeatCount: currentRepeatCount,
        originalIndices: currentIndices,
        intervals: currentIntervals,
      ));
      currentGroupId = interval.groupId;
      currentRepeatCount = interval.repeatCount;
      currentIndices = [i];
      currentIntervals = [interval];
    }
  }

  groups.add(_IntervalGroupItem(
    groupId: currentGroupId,
    repeatCount: currentRepeatCount,
    originalIndices: currentIndices,
    intervals: currentIntervals,
  ));

  return groups;
}

/// Shared interval list widget
class IntervalList extends StatelessWidget {
  final List<Interval> intervals;
  final MachineType machineType;
  final AppSettingsProvider settingsProvider;
  final bool isEditable;
  final Function(int)? onIntervalTap;
  final Function(int)? onIntervalDelete;
  final int? selectedIndex;
  final VoidCallback? onAddInterval;
  final VoidCallback?
      onAddRepeatBlock; // Optional callback for repeat block button

  const IntervalList({
    super.key,
    required this.intervals,
    required this.machineType,
    required this.settingsProvider,
    this.isEditable = false,
    this.onIntervalTap,
    this.onIntervalDelete,
    this.selectedIndex,
    this.onAddInterval,
    this.onAddRepeatBlock,
  });

  Widget _buildGroupCard(BuildContext context, _IntervalGroupItem group) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final repeatCount = group.repeatCount ?? 1;
    final uniqueCount = (group.intervals.length / repeatCount)
        .ceil()
        .clamp(1, group.intervals.length);

    final uniqueIntervals = group.intervals.sublist(0, uniqueCount);
    final uniqueIndices = group.originalIndices.sublist(0, uniqueCount);

    final l10n = AppLocalizations.of(context)!;
    final sessionLabel = l10n.sessionRepeatBlock;
    final repeatLabel = l10n.repeatTimes(
      LocalizedFormat.decimal(
        context,
        repeatCount,
        decimalDigits: 0,
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E22) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.35),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  CupertinoIcons.repeat,
                  size: 16,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    '$sessionLabel ($repeatLabel)',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                const Spacer(),
                if (isEditable && onIntervalDelete != null)
                  GestureDetector(
                    onTap: () {
                      for (int i = group.originalIndices.length - 1;
                          i >= 0;
                          i--) {
                        onIntervalDelete!(group.originalIndices[i]);
                      }
                    },
                    child: Icon(
                      CupertinoIcons.trash,
                      size: 16,
                      color: theme.colorScheme.error.withValues(alpha: 0.8),
                    ),
                  ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: uniqueIntervals.length,
            itemBuilder: (context, idx) {
              final interval = uniqueIntervals[idx];
              final originalIndex = uniqueIndices[idx];

              Widget row = IntervalRow(
                interval: interval,
                machineType: machineType,
                settingsProvider: settingsProvider,
                isEditable: isEditable,
                onTap: onIntervalTap != null
                    ? () => onIntervalTap!(originalIndex)
                    : null,
                isSelected: selectedIndex == originalIndex,
              );

              if (idx < uniqueIntervals.length - 1) {
                row = Column(
                  children: [
                    row,
                    Divider(
                      height: 0.5,
                      color: theme.dividerColor,
                      indent: 16,
                      endIndent: 16,
                    ),
                  ],
                );
              }
              return row;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final addRepeatBlockLabel = l10n.addRepeatBlock;

    if (intervals.isEmpty && !isEditable) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Text(
            l10n.noIntervals,
            style: TextStyle(
              fontSize: 16,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ),
      );
    }

    final groups = _groupIntervals(intervals);

    return Column(
      children: [
        ...groups.map((group) {
          if (group.groupId != null) {
            if (isEditable && onIntervalDelete != null) {
              return _IntervalSwipeDelete(
                key: Key('group_${group.groupId}'),
                itemId: group.groupId!,
                onDelete: () {
                  for (int i = group.originalIndices.length - 1; i >= 0; i--) {
                    onIntervalDelete!(group.originalIndices[i]);
                  }
                },
                child: _buildGroupCard(context, group),
              );
            } else {
              return _buildGroupCard(context, group);
            }
          } else {
            // Render individual intervals
            return Column(
              children: group.intervals.asMap().entries.map((entry) {
                final localIdx = entry.key;
                final interval = entry.value;
                final originalIndex = group.originalIndices[localIdx];

                if (isEditable && onIntervalDelete != null) {
                  return _IntervalSwipeDelete(
                    key: Key('interval_${interval.id}'),
                    itemId: interval.id,
                    onDelete: () => onIntervalDelete!(originalIndex),
                    child: IntervalRow(
                      interval: interval,
                      machineType: machineType,
                      settingsProvider: settingsProvider,
                      isEditable: isEditable,
                      onTap: onIntervalTap != null
                          ? () => onIntervalTap!(originalIndex)
                          : null,
                      isSelected: selectedIndex == originalIndex,
                    ),
                  );
                } else {
                  return IntervalRow(
                    interval: interval,
                    machineType: machineType,
                    settingsProvider: settingsProvider,
                    isEditable: isEditable,
                    onTap: onIntervalTap != null
                        ? () => onIntervalTap!(originalIndex)
                        : null,
                    isSelected: selectedIndex == originalIndex,
                  );
                }
              }).toList(),
            );
          }
        }),
        // Add interval footer (only in editable mode)
        if (isEditable && (onAddInterval != null || onAddRepeatBlock != null))
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor,
                  width: 0.5,
                ),
              ),
            ),
            child: Column(
              children: [
                if (onAddInterval != null)
                  CupertinoListTile(
                    leading: Icon(
                      CupertinoIcons.add_circled,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    title: Text(
                      l10n.addInterval,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    onTap: onAddInterval,
                  ),
                if (onAddRepeatBlock != null) ...[
                  Divider(
                    height: 0.5,
                    color: theme.dividerColor,
                    indent: 16,
                  ),
                  CupertinoListTile(
                    leading: Icon(
                      CupertinoIcons.repeat,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
                    title: Text(
                      addRepeatBlockLabel,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    onTap: onAddRepeatBlock,
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _IntervalSwipeDelete extends StatefulWidget {
  final String itemId;
  final Widget child;
  final VoidCallback onDelete;

  const _IntervalSwipeDelete({
    super.key,
    required this.itemId,
    required this.child,
    required this.onDelete,
  });

  @override
  State<_IntervalSwipeDelete> createState() => _IntervalSwipeDeleteState();
}

class _IntervalSwipeDeleteState extends State<_IntervalSwipeDelete> {
  static const double _triggerOffset = 44;
  static const double _actionWidth = 76;
  static final ValueNotifier<String?> _openItemId =
      ValueNotifier<String?>(null);
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _openItemId.addListener(_handleOpenItemChanged);
  }

  @override
  void dispose() {
    _openItemId.removeListener(_handleOpenItemChanged);
    super.dispose();
  }

  void _handleOpenItemChanged() {
    if (!mounted) return;
    if (_openItemId.value != widget.itemId && _dragOffset != 0) {
      setState(() {
        _dragOffset = 0;
      });
    }
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_openItemId.value != widget.itemId) {
      _openItemId.value = widget.itemId;
    }

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final logicalDelta = isRtl ? -details.delta.dx : details.delta.dx;
    final nextOffset = (_dragOffset + logicalDelta).clamp(-_actionWidth, 0.0);
    setState(() {
      _dragOffset = nextOffset;
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final shouldOpen = _dragOffset.abs() > _triggerOffset;
    setState(() {
      _dragOffset = shouldOpen ? -_actionWidth : 0;
    });
    _openItemId.value = shouldOpen ? widget.itemId : null;
  }

  void _close() {
    if (_dragOffset == 0) return;
    setState(() {
      _dragOffset = 0;
    });
    if (_openItemId.value == widget.itemId) {
      _openItemId.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      onTap: _close,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Container(
                width: _actionWidth,
                color: CupertinoColors.destructiveRed,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: widget.onDelete,
                  child: const Icon(
                    CupertinoIcons.delete,
                    color: CupertinoColors.white,
                  ),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(
              _dragOffset *
                  (Directionality.of(context) == TextDirection.rtl ? -1 : 1),
              0,
              0,
            ),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
