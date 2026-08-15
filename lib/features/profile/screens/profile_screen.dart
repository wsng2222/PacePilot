import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:valcue/l10n/app_localizations.dart';
import 'package:valcue/l10n/localized_format.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../../../app_settings/app_settings_provider.dart';
import '../../../app_shell/app_shell.dart';
import '../../../utils/app_shadows.dart';
import '../models/workout_session.dart';
import '../models/weight_entry.dart';
import '../providers/workout_history_provider.dart';
import '../providers/weight_tracker_provider.dart';
import '../models/achievement.dart';
import '../models/achievement_translations.dart';
import '../providers/achievement_provider.dart';
import '../../routines/models/machine_type.dart';
import '../../../widgets/app_dialog.dart';
import '../../../widgets/app_segmented_control.dart';
import '../../../widgets/app_bottom_sheet.dart';
import '../../../widgets/platform_icon.dart';

Color _segmentedSelectedBackground(BuildContext context) {
  return appSegmentedSelectedBackground(context);
}

SegmentedButtonThemeData _segmentedThemeData(
    BuildContext context, Color selectedBackground) {
  return appSegmentedThemeData(context, selectedBackground);
}

Color _weightSegmentSelectedBackground(BuildContext context) {
  return context.appColors.surfaceElevated;
}

SegmentedButtonThemeData _weightSegmentThemeData(
  BuildContext context,
  Color selectedBackground,
) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;
  final selectedForeground = isDark ? Colors.white : Colors.black87;
  final borderColor = theme.colorScheme.outline.withValues(alpha: 0.35);

  return SegmentedButtonThemeData(
    style: SegmentedButton.styleFrom(
      selectedBackgroundColor: selectedBackground,
      selectedForegroundColor: selectedForeground,
      foregroundColor: theme.colorScheme.onSurface,
      backgroundColor: theme.colorScheme.surface,
      side: BorderSide(color: borderColor),
      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    ),
  );
}

Widget _buildPlatformSegmentedControl({
  required Key key,
  required List<String> labels,
  required int selectedIndex,
  required ValueChanged<int> onValueChanged,
  required double height,
  bool shrinkWrap = false,
  Color? color,
}) {
  return AppSegmentedControl(
    key: key,
    labels: labels,
    selectedIndex: selectedIndex,
    onValueChanged: onValueChanged,
    height: height,
    shrinkWrap: shrinkWrap,
    color: color,
  );
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedMachineTab = 0; // 0: Treadmill, 1: Bike, 2: Stairmaster

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Header - same style as Settings screen
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(
                        alpha: 0.10,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      size: 22,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.myTab,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.lato(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.9,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Tabs: Workout History, Calendar, Achievements, Weight
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text(
                    AppLocalizations.of(context)!.historyTab,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Tab(
                  child: Text(
                    AppLocalizations.of(context)!.calendarTab,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Tab(
                  child: Text(
                    AchievementTranslations.getUiString(
                      'tab_achievements',
                      Localizations.localeOf(context).languageCode,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Tab(
                  child: Text(
                    AppLocalizations.of(context)!.weightTab,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: theme.extension<AppColors>()!.mutedText,
              indicatorColor: theme.colorScheme.primary,
              overlayColor: const WidgetStatePropertyAll(Colors.transparent),
              splashFactory: NoSplash.splashFactory,
            ),
            // Tab content
            Expanded(
              child: Consumer<AppSettingsProvider>(
                builder: (context, settingsProvider, child) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _WorkoutHistoryTab(
                        selectedMachineTab: _selectedMachineTab,
                        onMachineTabChanged: (i) =>
                            setState(() => _selectedMachineTab = i),
                      ),
                      const _CalendarTab(),
                      const _AchievementsTab(),
                      Stack(
                        children: [
                          const _WeightTab(),
                          if (!settingsProvider.isPremium)
                            _buildPremiumLockOverlay(context),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumLockOverlay(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned.fill(
      child: Container(
        color: theme.scaffoldBackgroundColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.local_fire_department,
                size: 80,
                color: theme.extension<AppColors>()!.mutedText,
              ),
              const SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.premium,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(context)!.premiumFeature,
                style: TextStyle(
                  fontSize: 16,
                  color: theme.extension<AppColors>()!.mutedText,
                ),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  AppShell.navigateToPremiumTab();
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: Text(
                  AppLocalizations.of(context)!.viewMembership,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
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

// Workout History Tab
class _WorkoutHistoryTab extends StatefulWidget {
  final int selectedMachineTab;
  final ValueChanged<int> onMachineTabChanged;

  const _WorkoutHistoryTab({
    required this.selectedMachineTab,
    required this.onMachineTabChanged,
  });

  @override
  State<_WorkoutHistoryTab> createState() => _WorkoutHistoryTabState();
}

class _WorkoutHistoryTabState extends State<_WorkoutHistoryTab> {
  int _selectedMachineTab = 0;

  @override
  void initState() {
    super.initState();
    _selectedMachineTab = widget.selectedMachineTab;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutHistoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final machineTypes = [
          MachineType.treadmill,
          MachineType.cycle,
          MachineType.stairmaster
        ];
        final selectedType = machineTypes[_selectedMachineTab];
        final allSessions = provider.getSessionsByMachineType(selectedType);

        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              // Machine type pill chips
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: _buildMachineTypePills(context, provider, machineTypes),
              ),
              // Content area
              Expanded(
                child: allSessions.isEmpty
                    ? _buildEmptyState(context, selectedType)
                    : _buildHistoryContent(
                        context, provider, selectedType, allSessions),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMachineTypePills(BuildContext context,
      WorkoutHistoryProvider provider, List<MachineType> machineTypes) {
    if (PlatformInfo.isIOS) {
      final titles = [
        AppLocalizations.of(context)!.treadmill,
        AppLocalizations.of(context)!.bike,
        AppLocalizations.of(context)!.stairmaster,
      ];
      final selectedIndex = _selectedMachineTab.clamp(0, titles.length - 1);
      final selectedBg = _segmentedSelectedBackground(context);
      final brightnessKey = Theme.of(context).brightness;
      final localeKey = Localizations.localeOf(context).toLanguageTag();

      return SegmentedButtonTheme(
        data: _segmentedThemeData(context, selectedBg),
        child: SizedBox(
          width: double.infinity,
          child: _buildPlatformSegmentedControl(
            key: ValueKey(
                'profile_machine_segment_${brightnessKey.name}_$localeKey'),
            labels: titles,
            selectedIndex: selectedIndex,
            onValueChanged: (index) {
              setState(() => _selectedMachineTab = index);
              widget.onMachineTabChanged(index);
            },
            height: 44,
            color: selectedBg,
          ),
        ),
      );
    }

    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final titles = [
      AppLocalizations.of(context)!.treadmill,
      AppLocalizations.of(context)!.bike,
      AppLocalizations.of(context)!.stairmaster,
    ];
    final items = [
      _MachineTabItem(icon: Icons.directions_run, label: titles[0]),
      _MachineTabItem(icon: Icons.pedal_bike, label: titles[1]),
      _MachineTabItem(icon: Icons.stairs, label: titles[2]),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        const outerPadding = 4.0;
        final innerWidth = (constraints.maxWidth - (outerPadding * 2))
            .clamp(0.0, double.infinity)
            .toDouble();
        final segmentWidth = innerWidth / items.length;

        return Container(
          padding: const EdgeInsets.all(outerPadding),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : appColors.border,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 240),
                curve: Curves.easeInOutCubic,
                left: segmentWidth * _selectedMachineTab,
                top: 0,
                bottom: 0,
                width: segmentWidth,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: appColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.04)
                          : Colors.black.withValues(alpha: 0.04),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isSelected = _selectedMachineTab == index;
                  final iconColor = isSelected
                      ? theme.colorScheme.primary
                      : appColors.mutedText;
                  final textColor = isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface.withValues(alpha: 0.5);
                  final fontWeight =
                      isSelected ? FontWeight.w700 : FontWeight.w600;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() => _selectedMachineTab = index);
                        widget.onMachineTabChanged(index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              item.icon,
                              size: 17,
                              color: iconColor,
                            ),
                            const SizedBox(width: 7),
                            Flexible(
                              child: Text(
                                item.label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: fontWeight,
                                  color: textColor,
                                  letterSpacing: -0.25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryContent(
      BuildContext context,
      WorkoutHistoryProvider provider,
      MachineType machineType,
      List<WorkoutSession> sessions) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Group sessions by date
    final groupedSessions = <DateTime, List<WorkoutSession>>{};
    for (final session in sessions) {
      final date = DateTime(
          session.dateTime.year, session.dateTime.month, session.dateTime.day);
      groupedSessions.putIfAbsent(date, () => []).add(session);
    }

    // Sort dates descending
    final sortedDates = groupedSessions.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    // Calculate this week's stats
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    final thisWeekSessions = sessions.where((s) {
      final date = DateTime(s.dateTime.year, s.dateTime.month, s.dateTime.day);
      return date.isAfter(weekStart.subtract(const Duration(days: 1))) &&
          date.isBefore(weekEnd.add(const Duration(days: 1)));
    }).toList();

    return Container(
      color: isDark ? Colors.black : Colors.white,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        children: [
          // This week summary card
          _buildWeekSummaryCard(context, thisWeekSessions, machineType),
          const SizedBox(height: 16),
          // Grouped history
          ...sortedDates.map((date) {
            final dateSessions = groupedSessions[date]!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 4,
                    bottom: 6,
                  ),
                  child: Text(
                    _formatDateHeader(date),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: theme.extension<AppColors>()!.mutedText,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
                ...dateSessions.map((session) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _SwipeRevealDelete(
                        key: Key(session.id),
                        itemId: 'session_${session.id}',
                        onDelete: () {
                          provider.deleteSession(session.id);
                        },
                        child: _WorkoutHistoryCard(session: session),
                      ),
                    )),
                const SizedBox(height: 12),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildWeekSummaryCard(BuildContext context,
      List<WorkoutSession> sessions, MachineType machineType) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final isMetric = settingsProvider.measurement == 'kmh';

    int totalSeconds = 0;
    double totalDistance = 0.0;
    for (final session in sessions) {
      totalSeconds += session.durationSeconds;
      if (session.distanceMeters != null) {
        totalDistance += session.distanceMeters!;
      }
    }

    String formatDuration(int seconds) {
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      final secs = seconds % 60;

      if (hours > 0) {
        return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
      }
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }

    String formatDistance(double meters) {
      if (isMetric) {
        // Keep metric distance formatting consistent across the app.
        if (meters >= 1000) {
          return '${LocalizedFormat.decimal(context, meters / 1000, decimalDigits: 2)} km';
        }
        return '${LocalizedFormat.decimal(context, meters, decimalDigits: 0)} m';
      } else {
        const metersPerMile = 1609.344;
        final miles = meters / metersPerMile;
        if (miles >= 0.1) {
          return '${LocalizedFormat.decimal(context, miles, decimalDigits: 2)} mi';
        }
        // Convert to feet for very small distances
        final feet = meters * 3.28084;
        return '${LocalizedFormat.decimal(context, feet, decimalDigits: 0)} ft';
      }
    }

    // Determine which metrics to show
    final showDistance =
        machineType == MachineType.treadmill && totalDistance > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.1)
              : context.appColors.border,
          width: 1,
        ),
        boxShadow: AppShadows.elevatedSoft,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.thisWeek,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _SummaryStat(
                  label: AppLocalizations.of(context)!.totalWorkoutTime,
                  value: formatDuration(totalSeconds),
                ),
              ),
              Expanded(
                child: _SummaryStat(
                  label: AppLocalizations.of(context)!.workouts,
                  value: '${sessions.length}',
                ),
              ),
              if (showDistance)
                Expanded(
                  child: _SummaryStat(
                    label: AppLocalizations.of(context)!.distance,
                    value: formatDistance(totalDistance),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return AppLocalizations.of(context)!.today;
    } else if (dateOnly == yesterday) {
      return AppLocalizations.of(context)!.yesterday;
    } else {
      return LocalizedFormat.mediumDate(context, date);
    }
  }

  Widget _buildEmptyState(BuildContext context, MachineType machineType) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_outlined,
              size: 48,
              color: appColors.mutedText,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noWorkoutsYet,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to Routine tab with specific machine type
                AppShell.navigateToRoutineTabWithMachineType(machineType);
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: Text(
                AppLocalizations.of(context)!.goToRoutines,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryStat extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryStat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: appColors.mutedText,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _WorkoutHistoryCard extends StatelessWidget {
  final WorkoutSession session;

  const _WorkoutHistoryCard({required this.session});

  String _getFriendlyRoutineName(
      String routineName, MachineType machineType, BuildContext context) {
    if (routineName.isEmpty || routineName.toLowerCase().contains('untitled')) {
      final l10n = AppLocalizations.of(context)!;
      switch (machineType) {
        case MachineType.treadmill:
          return l10n.treadmillSession;
        case MachineType.cycle:
          return l10n.bikeSession;
        case MachineType.stairmaster:
          return l10n.stairmasterSession;
      }
    }
    return routineName;
  }

  IconData _getMachineIcon(MachineType machineType) {
    switch (machineType) {
      case MachineType.treadmill:
        return Icons.directions_run;
      case MachineType.cycle:
        return Icons.pedal_bike;
      case MachineType.stairmaster:
        return Icons.stairs;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final isMetric = settingsProvider.measurement == 'kmh';
    final l10n = AppLocalizations.of(context)!;

    String formatDuration(int seconds) {
      final hours = seconds ~/ 3600;
      final minutes = (seconds % 3600) ~/ 60;
      final secs = seconds % 60;

      if (hours > 0) {
        return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
      }
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }

    String? formatDistance(double meters) {
      if (isMetric) {
        if (meters >= 1000) {
          return '${LocalizedFormat.decimal(context, meters / 1000, decimalDigits: 2)} km';
        }
        return '${LocalizedFormat.decimal(context, meters, decimalDigits: 0)} m';
      } else {
        const metersPerMile = 1609.344;
        final miles = meters / metersPerMile;
        if (miles >= 0.1) {
          return '${LocalizedFormat.decimal(context, miles, decimalDigits: 2)} mi';
        }
        final feet = meters * 3.28084;
        return '${LocalizedFormat.decimal(context, feet, decimalDigits: 0)} ft';
      }
    }

    // Calculate average speed for treadmill (if distance and time available)
    String? formatAverageSpeed() {
      if (session.machineType == MachineType.treadmill &&
          session.distanceMeters != null &&
          session.durationSeconds > 0) {
        final elapsedSeconds = session.elapsedMilliseconds != null &&
                session.elapsedMilliseconds! > 0
            ? session.elapsedMilliseconds! / 1000.0
            : session.durationSeconds.toDouble();
        final hours = elapsedSeconds / 3600.0;
        final speedKmh = (session.distanceMeters! / 1000.0) / hours;
        if (isMetric) {
          return l10n.averageSpeedKmh(
            LocalizedFormat.decimal(context, speedKmh),
          );
        } else {
          final speedMph = speedKmh / 1.609344;
          return l10n.averageSpeedMph(
            LocalizedFormat.decimal(context, speedMph),
          );
        }
      }
      return null;
    }

    String? formatMetric() {
      switch (session.machineType) {
        case MachineType.treadmill:
          return session.distanceMeters != null
              ? formatDistance(session.distanceMeters!)
              : null;
        case MachineType.cycle:
          return session.averageRpm != null
              ? l10n.averageRpmValue(
                  LocalizedFormat.decimal(
                    context,
                    session.averageRpm!.round(),
                    decimalDigits: 0,
                  ),
                )
              : null;
        case MachineType.stairmaster:
          return session.averageLevel != null
              ? l10n.averageLevelValue(
                  LocalizedFormat.decimal(context, session.averageLevel!),
                )
              : null;
      }
    }

    final friendlyName = _getFriendlyRoutineName(
        session.routineName, session.machineType, context);
    final avgSpeed = formatAverageSpeed();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: appColors.border,
          width: 1,
        ),
        boxShadow: AppShadows.elevatedSoft,
      ),
      child: Row(
        children: [
          // Leading icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getMachineIcon(session.machineType),
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friendlyName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      formatDuration(session.durationSeconds),
                      style: TextStyle(
                        fontSize: 14,
                        color: appColors.mutedText,
                      ),
                    ),
                    if (formatMetric() != null) ...[
                      Text(
                        '•',
                        style: TextStyle(color: appColors.mutedText),
                      ),
                      Text(
                        formatMetric()!,
                        style: TextStyle(
                          fontSize: 14,
                          color: appColors.mutedText,
                        ),
                      ),
                    ],
                    if (avgSpeed != null) ...[
                      Text(
                        '•',
                        style: TextStyle(color: appColors.mutedText),
                      ),
                      Text(
                        avgSpeed,
                        style: TextStyle(
                          fontSize: 14,
                          color: appColors.mutedText,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Heatmap of workouts for the last 20 weeks
class _ActivityHeatmap extends StatelessWidget {
  final List<WorkoutSession> sessions;

  const _ActivityHeatmap({required this.sessions});

  int _getWorkoutCountOnDate(DateTime date) {
    return sessions.where((s) {
      return s.dateTime.year == date.year &&
          s.dateTime.month == date.month &&
          s.dateTime.day == date.day;
    }).length;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appColors = theme.extension<AppColors>()!;
    final l10n = AppLocalizations.of(context)!;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // We want the last 20 weeks. Monday of the first week.
    final daysToSubtract = (today.weekday - 1) + (19 * 7);
    final startDate = today.subtract(Duration(days: daysToSubtract));

    const int cols = 20;
    const int rows = 7;

    Color getCellColor(DateTime date) {
      final count = _getWorkoutCountOnDate(date);
      if (count == 0) {
        return isDark
            ? Colors.white.withValues(alpha: 0.04)
            : Colors.grey.shade100;
      }
      final baseColor = theme.colorScheme.primary;
      if (count == 1) {
        return baseColor.withValues(alpha: 0.35);
      } else if (count == 2) {
        return baseColor.withValues(alpha: 0.65);
      } else {
        return baseColor;
      }
    }

    final columnWidgets = <Widget>[];

    for (int c = 0; c < cols; c++) {
      final cells = <Widget>[];
      for (int r = 0; r < rows; r++) {
        final cellDate = startDate.add(Duration(days: c * 7 + r));
        final isFuture = cellDate.isAfter(today);

        cells.add(
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.symmetric(vertical: 1.5),
            decoration: BoxDecoration(
              color: isFuture ? Colors.transparent : getCellColor(cellDate),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }

      final columnFirstDay = startDate.add(Duration(days: c * 7));
      Widget monthLabel = const SizedBox(height: 14);
      if (c == 0 || columnFirstDay.day <= 7) {
        final monthName =
            LocalizedFormat.monthAbbreviation(context, columnFirstDay);
        monthLabel = Padding(
          padding: const EdgeInsets.only(bottom: 2),
          child: Text(
            monthName,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.bold,
              color: appColors.mutedText,
            ),
          ),
        );
      }

      columnWidgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              monthLabel,
              ...cells,
            ],
          ),
        ),
      );
    }

    final weekdayLabelWidgets = <Widget>[
      const SizedBox(height: 14),
      for (int i = 0; i < 7; i++)
        SizedBox(
          height: 13,
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: (i % 2 == 0)
                ? Text(
                    switch (i) {
                      0 => l10n.mon.substring(0, 1),
                      2 => l10n.wed.substring(0, 1),
                      4 => l10n.fri.substring(0, 1),
                      6 => l10n.sun.substring(0, 1),
                      _ => '',
                    },
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: appColors.mutedText,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ),
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1C1C1E)
            : const Color.fromARGB(245, 245, 245, 245),
        borderRadius: BorderRadius.circular(20),
        border: isDark
            ? Border.all(
                color: Colors.white.withValues(alpha: 0.08),
                width: 1,
              )
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.trend,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: Directionality.of(context) == TextDirection.ltr,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: weekdayLabelWidgets,
                ),
                const SizedBox(width: 4),
                ...columnWidgets,
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Flexible(
                child: Text(
                  l10n.less,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 8, color: appColors.mutedText),
                ),
              ),
              const SizedBox(width: 4),
              for (int count = 0; count <= 3; count++)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: count == 0
                        ? (isDark
                            ? Colors.white.withValues(alpha: 0.04)
                            : Colors.grey.shade100)
                        : theme.colorScheme.primary.withValues(
                            alpha:
                                count == 1 ? 0.35 : (count == 2 ? 0.65 : 1.0)),
                    borderRadius: BorderRadius.circular(1.5),
                  ),
                ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  l10n.more,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 8, color: appColors.mutedText),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Calendar Tab
class _CalendarTab extends StatefulWidget {
  const _CalendarTab();

  @override
  State<_CalendarTab> createState() => _CalendarTabState();
}

class _CalendarTabState extends State<_CalendarTab> {
  DateTime _currentMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final isCurrentMonth =
        _currentMonth.year == now.year && _currentMonth.month == now.month;
    return Consumer<WorkoutHistoryProvider>(
      builder: (context, provider, child) {
        return Column(
          children: [
            _ActivityHeatmap(sessions: provider.sessions),
            const SizedBox(height: 8),
            // Month navigation
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    tooltip: l10n.previousMonth,
                    onPressed: () {
                      setState(() {
                        _currentMonth = DateTime(
                            _currentMonth.year, _currentMonth.month - 1);
                      });
                    },
                  ),
                  Flexible(
                    child: Text(
                      LocalizedFormat.yearMonth(context, _currentMonth),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const PlatformIcon(
                      cupertino: CupertinoIcons.chevron_right,
                      material: Icons.chevron_right,
                    ),
                    tooltip: l10n.nextMonth,
                    onPressed: isCurrentMonth
                        ? null
                        : () {
                            setState(() {
                              _currentMonth = DateTime(
                                  _currentMonth.year, _currentMonth.month + 1);
                            });
                          },
                  ),
                ],
              ),
            ),
            // Calendar grid
            Expanded(
              child: _buildCalendarGrid(context, provider),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCalendarGrid(
      BuildContext context, WorkoutHistoryProvider provider) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstWeekday = firstDay.weekday; // 1 = Monday, 7 = Sunday
    final daysInMonth = lastDay.day;

    // Weekday headers
    final l10n = AppLocalizations.of(context)!;
    final weekdays = <String>[
      l10n.mon,
      l10n.tue,
      l10n.wed,
      l10n.thu,
      l10n.fri,
      l10n.sat,
      l10n.sun,
    ];

    // Calculate workout days and rest days for the month (only up to today)
    final today = DateTime.now();
    int workoutDays = 0;
    int restDays = 0;

    // Only count days up to today if we're viewing the current month
    final lastDayToCount =
        (_currentMonth.year == today.year && _currentMonth.month == today.month)
            ? today.day
            : daysInMonth;

    for (int day = 1; day <= lastDayToCount; day++) {
      final date = DateTime(_currentMonth.year, _currentMonth.month, day);
      if (provider.hasWorkoutOnDate(date)) {
        workoutDays++;
      } else {
        restDays++;
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Weekday headers
          Row(
            children: weekdays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: appColors.mutedText,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          // Calendar days
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
              ),
              itemCount: firstWeekday - 1 + daysInMonth,
              itemBuilder: (context, index) {
                if (index < firstWeekday - 1) {
                  return const SizedBox.shrink();
                }

                final day = index - (firstWeekday - 1) + 1;
                final date =
                    DateTime(_currentMonth.year, _currentMonth.month, day);
                final hasWorkout = provider.hasWorkoutOnDate(date);

                return GestureDetector(
                  onTap: hasWorkout
                      ? () => _showDayWorkouts(context, provider, date)
                      : null,
                  child: Container(
                    decoration: BoxDecoration(
                      color: hasWorkout
                          ? theme.colorScheme.primary.withValues(alpha: 0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: hasWorkout
                          ? Border.all(
                              color: theme.colorScheme.primary,
                              width: 2,
                            )
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '$day',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              hasWorkout ? FontWeight.w600 : FontWeight.w400,
                          color: hasWorkout
                              ? theme.colorScheme.primary
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 0),
          // Statistics bar
          Center(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                color: appColors.surfaceElevated,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: theme.brightness == Brightness.dark
                      ? Colors.white.withValues(alpha: 0.08)
                      : appColors.border,
                ),
                boxShadow: AppShadows.elevatedSoft,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Workout days
                  Text(
                    AppLocalizations.of(context)!.workoutDays(
                      LocalizedFormat.decimal(
                        context,
                        workoutDays,
                        decimalDigits: 0,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                  // Divider
                  Container(
                    height: 20,
                    width: 1.2,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    color: theme.brightness == Brightness.dark
                        ? const Color(0xFF4C4C4C)
                        : const Color(0xFFCCCCCC),
                  ),
                  // Rest days
                  Text(
                    AppLocalizations.of(context)!.restDays(
                      LocalizedFormat.decimal(
                        context,
                        restDays,
                        decimalDigits: 0,
                      ),
                    ),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDayWorkouts(
      BuildContext context, WorkoutHistoryProvider provider, DateTime date) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (context) => _DayWorkoutsSheet(date: date),
    );
  }
}

class _DayWorkoutsSheet extends StatelessWidget {
  final DateTime date;

  const _DayWorkoutsSheet({required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appColors = theme.extension<AppColors>()!;

    return DraggableScrollableSheet(
      initialChildSize: 0.45,
      minChildSize: 0.45,
      maxChildSize: 0.92,
      expand: false,
      snap: true,
      snapSizes: const [0.45, 0.70, 0.92],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : theme.extension<AppColors>()!.border,
            ),
            boxShadow: AppShadows.elevatedSoft,
          ),
          child: Column(
            children: [
              // Drag handle
              const AppBottomSheetHandle(),
              // Header
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : appColors.border,
                      width: 1,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Date title
                    Text(
                      LocalizedFormat.longDate(context, date),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Consumer<WorkoutHistoryProvider>(
                  builder: (context, provider, child) {
                    final sessions = provider.getSessionsByDate(date);
                    if (sessions.isEmpty) {
                      return _buildEmptyState(context);
                    }
                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _SwipeRevealDelete(
                            key: Key(session.id),
                            itemId: 'calendar_session_${session.id}',
                            onDelete: () {
                              provider.deleteSession(session.id);
                            },
                            child: _DayWorkoutRow(session: session),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.fitness_center_outlined,
              size: 48,
              color: appColors.mutedText,
            ),
            const SizedBox(height: 16),
            Text(
              AppLocalizations.of(context)!.noWorkoutsYet,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.startAWorkoutToSeeItHere,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: appColors.mutedText,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                AppShell.navigateToRoutineTab();
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              ),
              child: Text(
                AppLocalizations.of(context)!.goToRoutines,
                style: GoogleFonts.lato(
                  fontWeight: FontWeight.w900,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwipeRevealDelete extends StatefulWidget {
  final String itemId;
  final Widget child;
  final VoidCallback onDelete;
  final double? buttonDiameter;
  final double? actionWidth;

  const _SwipeRevealDelete({
    super.key,
    required this.itemId,
    required this.child,
    required this.onDelete,
    this.buttonDiameter,
    this.actionWidth,
  });

  @override
  State<_SwipeRevealDelete> createState() => _SwipeRevealDeleteState();
}

class _SwipeRevealDeleteState extends State<_SwipeRevealDelete> {
  static const double _triggerOffset = 44;
  static final ValueNotifier<String?> _openItemId =
      ValueNotifier<String?>(null);
  double _dragOffset = 0;
  bool _isDragging = false;

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
    final openItemId = _openItemId.value;
    if (openItemId != widget.itemId && _dragOffset != 0) {
      setState(() {
        _dragOffset = 0;
      });
    }
  }

  void _handleDragUpdate(DragUpdateDetails details, double actionWidth) {
    if (_openItemId.value != widget.itemId) {
      _openItemId.value = widget.itemId;
    }
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final logicalDelta = isRtl ? -details.delta.dx : details.delta.dx;
    final nextOffset = (_dragOffset + logicalDelta).clamp(-actionWidth, 0.0);
    setState(() {
      _isDragging = true;
      _dragOffset = nextOffset;
    });
  }

  void _handleDragEnd(DragEndDetails details, double actionWidth) {
    final shouldOpen = _dragOffset.abs() > _triggerOffset;
    setState(() {
      _isDragging = false;
      _dragOffset = shouldOpen ? -actionWidth : 0;
    });
    _openItemId.value = shouldOpen ? widget.itemId : null;
  }

  void _close() {
    if (_dragOffset == 0) return;
    setState(() {
      _isDragging = false;
      _dragOffset = 0;
    });
    if (_openItemId.value == widget.itemId) {
      _openItemId.value = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonDiameter = widget.buttonDiameter ?? 52.0;
    final actionWidth = widget.actionWidth ?? (buttonDiameter + 20);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragUpdate: (details) =>
          _handleDragUpdate(details, actionWidth),
      onHorizontalDragEnd: (details) => _handleDragEnd(details, actionWidth),
      onTap: _close,
      child: Stack(
        children: [
          PositionedDirectional(
            top: 0,
            bottom: 0,
            end: 2,
            width: actionWidth,
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Container(
                width: buttonDiameter,
                height: buttonDiameter,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: widget.onDelete,
                    child: Center(
                      child: PlatformIcon(
                        cupertino: CupertinoIcons.trash,
                        material: Icons.delete_outline,
                        color: Colors.white,
                        size: buttonDiameter * 0.42,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedContainer(
            duration:
                _isDragging ? Duration.zero : const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(
              _dragOffset.clamp(-actionWidth, 0.0) *
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

class _DayWorkoutRow extends StatelessWidget {
  final WorkoutSession session;

  const _DayWorkoutRow({required this.session});

  String _getFriendlyRoutineName(
      String? routineName, MachineType machineType, BuildContext context) {
    if (routineName != null && routineName.isNotEmpty) {
      return routineName;
    }
    final l10n = AppLocalizations.of(context)!;
    switch (machineType) {
      case MachineType.treadmill:
        return l10n.treadmillWorkout;
      case MachineType.cycle:
        return l10n.bikeWorkout;
      case MachineType.stairmaster:
        return l10n.stairmasterWorkout;
    }
  }

  String formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final isMetric = settingsProvider.measurement == 'kmh';
    final l10n = AppLocalizations.of(context)!;

    String? formatDistance(double meters) {
      if (isMetric) {
        if (meters >= 1000) {
          return '${LocalizedFormat.decimal(context, meters / 1000, decimalDigits: 2)} km';
        }
        return '${LocalizedFormat.decimal(context, meters, decimalDigits: 0)} m';
      } else {
        const metersPerMile = 1609.344;
        final miles = meters / metersPerMile;
        if (miles >= 0.1) {
          return '${LocalizedFormat.decimal(context, miles, decimalDigits: 2)} mi';
        }
        final feet = meters * 3.28084;
        return '${LocalizedFormat.decimal(context, feet, decimalDigits: 0)} ft';
      }
    }

    String? formatAverageSpeed() {
      if (session.machineType == MachineType.treadmill &&
          session.distanceMeters != null &&
          session.durationSeconds > 0) {
        final elapsedSeconds = session.elapsedMilliseconds != null &&
                session.elapsedMilliseconds! > 0
            ? session.elapsedMilliseconds! / 1000.0
            : session.durationSeconds.toDouble();
        final hours = elapsedSeconds / 3600.0;
        final speedKmh = (session.distanceMeters! / 1000.0) / hours;
        if (isMetric) {
          return l10n.averageSpeedKmh(
            LocalizedFormat.decimal(context, speedKmh),
          );
        } else {
          final speedMph = speedKmh / 1.609344;
          return l10n.averageSpeedMph(
            LocalizedFormat.decimal(context, speedMph),
          );
        }
      }
      return null;
    }

    String? formatMetric() {
      switch (session.machineType) {
        case MachineType.treadmill:
          return session.distanceMeters != null
              ? formatDistance(session.distanceMeters!)
              : null;
        case MachineType.cycle:
          return session.averageRpm != null
              ? l10n.averageRpmValue(
                  LocalizedFormat.decimal(
                    context,
                    session.averageRpm!.round(),
                    decimalDigits: 0,
                  ),
                )
              : null;
        case MachineType.stairmaster:
          return session.averageLevel != null
              ? l10n.averageLevelValue(
                  LocalizedFormat.decimal(context, session.averageLevel!),
                )
              : null;
      }
    }

    final friendlyName = _getFriendlyRoutineName(
        session.routineName, session.machineType, context);
    final avgSpeed = formatAverageSpeed();
    final metric = formatMetric();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: appColors.border,
          width: 1,
        ),
        boxShadow: AppShadows.elevatedSoft,
      ),
      child: Row(
        children: [
          // Leading icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              _getMachineIcon(session.machineType),
              size: 20,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friendlyName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      formatDuration(session.durationSeconds),
                      style: TextStyle(
                        fontSize: 14,
                        color: appColors.mutedText,
                      ),
                    ),
                    if (metric != null) ...[
                      Text(
                        '•',
                        style: TextStyle(color: appColors.mutedText),
                      ),
                      Text(
                        metric,
                        style: TextStyle(
                          fontSize: 14,
                          color: appColors.mutedText,
                        ),
                      ),
                    ],
                    if (avgSpeed != null) ...[
                      Text(
                        '•',
                        style: TextStyle(color: appColors.mutedText),
                      ),
                      Text(
                        avgSpeed,
                        style: TextStyle(
                          fontSize: 14,
                          color: appColors.mutedText,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMachineIcon(MachineType machineType) {
    switch (machineType) {
      case MachineType.treadmill:
        return Icons.directions_run;
      case MachineType.cycle:
        return Icons.directions_bike;
      case MachineType.stairmaster:
        return Icons.stairs;
    }
  }
}

// Weight Tab
class _WeightTab extends StatefulWidget {
  const _WeightTab();

  @override
  State<_WeightTab> createState() => _WeightTabState();
}

class _WeightTabState extends State<_WeightTab> {
  final int _selectedTimeframe = 2; // 0: 7D, 1: 30D, 2: 90D, 3: ALL
  bool _showAllHistory = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<WeightTrackerProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Empty state - no entries at all
        if (provider.entries.isEmpty) {
          return Column(
            children: [
              Expanded(
                child: Center(
                  child: _buildEmptyState(context),
                ),
              ),
              // Sticky Record Button
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  border: Border(
                    top: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).padding.bottom > 0 ? 6 : 0,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showRecordWeightBottomSheet(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const PlatformIcon(
                            cupertino: CupertinoIcons.add,
                            material: Icons.add,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              AppLocalizations.of(context)!.recordWeight,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Summary Card with Record button
                    _WeightSummaryCard(
                      onRecordTap: () => _showRecordWeightBottomSheet(context),
                    ),
                    const SizedBox(height: 20),
                    // Weight Calendar
                    const _WeightCalendar(),
                    const SizedBox(height: 20),
                    // Trend Chart (only if 2+ entries - need at least 2 points to draw a line)
                    if (provider.entries.length >= 2) ...[
                      _WeightTrendChart(timeframe: _selectedTimeframe),
                      const SizedBox(height: 20),
                    ] else if (provider.entries.length == 1) ...[
                      _buildTrendEmptyState(context),
                      const SizedBox(height: 20),
                    ],
                    // History List
                    if (provider.entries.isNotEmpty)
                      _WeightHistoryList(
                        showAll: _showAllHistory,
                        onShowAll: () {
                          setState(() {
                            _showAllHistory = true;
                          });
                        },
                      ),
                    const SizedBox(height: 16), // Space for sticky button
                  ],
                ),
              ),
            ),
            // Sticky Record Button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.shade200,
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom > 0 ? 6 : 0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showRecordWeightBottomSheet(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const PlatformIcon(
                          cupertino: CupertinoIcons.add,
                          material: Icons.add,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.recordWeight,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.scale_outlined,
          size: 48,
          color: appColors.mutedText,
        ),
        const SizedBox(height: 14),
        Text(
          AppLocalizations.of(context)!.noWeightRecorded,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.startTrackingYourWeight,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: appColors.mutedText,
          ),
        ),
      ],
    );
  }

  Widget _buildTrendEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;

    return SizedBox(
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: appColors.border,
            width: 1,
          ),
          boxShadow: AppShadows.elevatedSoft,
        ),
        child: Column(
          children: [
            Icon(
              Icons.show_chart,
              size: 40,
              color: appColors.mutedText.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 12),
            Text(
              AppLocalizations.of(context)!.addOneMoreRecordToSeeTrend,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: appColors.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRecordWeightBottomSheet(BuildContext context) {
    _showRecordWeightBottomSheetHelper(context);
  }
}

/// Helper function to show weight recording/editing bottom sheet
void _showRecordWeightBottomSheetHelper(
  BuildContext context, {
  DateTime? initialDateTime,
  WeightEntry? editEntry,
}) {
  final settingsProvider =
      Provider.of<AppSettingsProvider>(context, listen: false);
  final provider = Provider.of<WeightTrackerProvider>(context, listen: false);
  final isWeightMetric = settingsProvider.weightUnit == 'kg';
  final weightController = TextEditingController();

  if (editEntry != null) {
    weightController.text = isWeightMetric
        ? LocalizedFormat.decimal(context, editEntry.weightKg)
        : LocalizedFormat.decimal(context, editEntry.weightKg * 2.20462);
  } else {
    final currentWeight = provider.currentWeight;
    if (currentWeight != null) {
      weightController.text = isWeightMetric
          ? LocalizedFormat.decimal(context, currentWeight.weightKg)
          : LocalizedFormat.decimal(
              context,
              currentWeight.weightKg * 2.20462,
            );
    }
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    isDismissible: true,
    builder: (context) => _RecordWeightBottomSheet(
      weightController: weightController,
      isMetric: isWeightMetric,
      initialDateTime: initialDateTime ?? editEntry?.dateTime,
      isEditing: editEntry != null,
      entryId: editEntry?.id,
    ),
  );
}

// Weight Summary Card - Unified card with current weight, delta, goal, progress bar
class _WeightSummaryCard extends StatelessWidget {
  final VoidCallback? onRecordTap;

  const _WeightSummaryCard({this.onRecordTap});

  @override
  Widget build(BuildContext context) {
    return Consumer2<WeightTrackerProvider, AppSettingsProvider>(
      builder: (context, provider, settingsProvider, child) {
        final theme = Theme.of(context);
        final appColors = theme.extension<AppColors>()!;
        final isDark = theme.brightness == Brightness.dark;
        final isWeightMetric = settingsProvider.weightUnit == 'kg';
        final localeName = LocalizedFormat.localeName(context);

        final currentWeight = provider.currentWeight;
        final weightChange = provider.getWeightChange();
        final goalWeight = provider.goalWeight;
        final toGoal = provider.getWeightToGoal();
        final l10n = AppLocalizations.of(context)!;

        // Empty state - should not happen as we handle it at tab level, but return empty widget as fallback
        if (currentWeight == null) {
          return const SizedBox.shrink();
        }

        // Calculate progress toward goal (0.0 to 1.0)
        // Use the oldest entry as starting weight, or null if only one entry (no progress to show)
        double? progress;
        if (goalWeight != null &&
            toGoal != null &&
            provider.entries.length > 1) {
          final startWeight = provider.entries.last.weightKg; // Oldest entry
          final current = currentWeight.weightKg;

          if (startWeight > goalWeight && current >= goalWeight) {
            // Weight loss goal: progress = how much lost / total to lose
            final totalToLose = startWeight - goalWeight;
            final lost = startWeight - current;
            progress = (lost / totalToLose).clamp(0.0, 1.0);
          } else if (startWeight < goalWeight && current <= goalWeight) {
            // Weight gain goal: progress = how much gained / total to gain
            final totalToGain = goalWeight - startWeight;
            final gained = current - startWeight;
            progress = (gained / totalToGain).clamp(0.0, 1.0);
          } else {
            // Goal already reached or passed
            progress = current <= goalWeight ? 1.0 : null;
          }
        }
        // If only one entry, progress remains null (will show gray bar only)

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : appColors.border,
              width: 1,
            ),
            boxShadow: AppShadows.elevatedSoft,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Weight (Hero) - Large number
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentWeight.formatWeight(
                            isWeightMetric,
                            localeName: localeName,
                          ),
                          style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                            letterSpacing: -1.5,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Delta + Goal in one row
                        Row(
                          children: [
                            // Delta indicator
                            if (weightChange != null) ...[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    weightChange < 0
                                        ? Icons.trending_down
                                        : Icons.trending_up,
                                    size: 14,
                                    color: weightChange < 0
                                        ? Colors.green
                                        : appColors.mutedText,
                                  ),
                                  const SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      '${weightChange > 0 ? '+' : ''}${WeightEntry(dateTime: DateTime.now(), weightKg: weightChange.abs()).formatWeight(isWeightMetric, localeName: localeName)}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: weightChange < 0
                                            ? Colors.green
                                            : appColors.mutedText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // Always show separator between delta and goal button
                              const SizedBox(width: 12),
                              Container(
                                width: 1,
                                height: 14,
                                color:
                                    appColors.mutedText.withValues(alpha: 0.3),
                              ),
                              const SizedBox(width: 12),
                            ],
                            // Goal pill
                            GestureDetector(
                              onTap: () => _showSetGoalBottomSheet(context),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color: goalWeight != null
                                      ? theme.colorScheme.primary
                                          .withValues(alpha: 0.1)
                                      : (isDark
                                          ? const Color(0xFF2C2C2E)
                                          : Colors.grey.shade100),
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: goalWeight != null
                                        ? theme.colorScheme.primary
                                            .withValues(alpha: 0.3)
                                        : (isDark
                                            ? Colors.white
                                                .withValues(alpha: 0.1)
                                            : Colors.grey.shade300),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      goalWeight != null
                                          ? Icons.flag
                                          : Icons.flag_outlined,
                                      size: 12,
                                      color: goalWeight != null
                                          ? theme.colorScheme.primary
                                          : appColors.mutedText,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        goalWeight != null
                                            ? WeightEntry(
                                                dateTime: DateTime.now(),
                                                weightKg: goalWeight,
                                              ).formatWeight(
                                                isWeightMetric,
                                                localeName: localeName,
                                              )
                                            : AppLocalizations.of(context)!
                                                .setGoal,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: goalWeight != null
                                              ? theme.colorScheme.primary
                                              : appColors.mutedText,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Goal indicator (only show if goal is set)
              if (goalWeight != null && toGoal != null) ...[
                const SizedBox(height: 16),
                Row(
                  children: [
                    Icon(
                      Icons.flag,
                      size: 14,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _goalSummary(
                          l10n: l10n,
                          goalWeight: WeightEntry(
                            dateTime: DateTime.now(),
                            weightKg: goalWeight,
                          ).formatWeight(
                            isWeightMetric,
                            localeName: localeName,
                          ),
                          difference: WeightEntry(
                            dateTime: DateTime.now(),
                            weightKg: toGoal.abs(),
                          ).formatWeight(
                            isWeightMetric,
                            localeName: localeName,
                          ),
                          toGoal: toGoal,
                        ),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: appColors.mutedText,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: progress, // null if only one entry (shows gray only)
                    minHeight: 8,
                    backgroundColor: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.grey.shade200,
                    valueColor: progress != null
                        ? AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.primary,
                          )
                        : AlwaysStoppedAnimation<Color>(
                            isDark
                                ? Colors.white.withValues(alpha: 0.1)
                                : Colors.grey.shade200,
                          ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showSetGoalBottomSheet(BuildContext context) {
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final provider = Provider.of<WeightTrackerProvider>(context, listen: false);
    final isWeightMetric = settingsProvider.weightUnit == 'kg';
    final goalWeightController = TextEditingController(
      text: provider.goalWeight != null
          ? (isWeightMetric
              ? LocalizedFormat.decimal(context, provider.goalWeight!)
              : LocalizedFormat.decimal(
                  context,
                  provider.goalWeight! * 2.20462,
                ))
          : '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (context) => _SetGoalBottomSheet(
        goalWeightController: goalWeightController,
        isMetric: isWeightMetric,
        currentWeight: provider.currentWeight,
      ),
    );
  }

  String _goalSummary({
    required AppLocalizations l10n,
    required String goalWeight,
    required String difference,
    required double toGoal,
  }) {
    if (toGoal.abs() < 0.1) {
      return l10n.goalAchievedSummary(goalWeight);
    }
    if (toGoal > 0) {
      return l10n.goalRemainingSummary(goalWeight, difference);
    }
    return l10n.goalExceededSummary(goalWeight, difference);
  }
}

// Weight Trend Chart - Sparkline with timeframe selector
class _WeightTrendChart extends StatefulWidget {
  final int timeframe; // 0: 7D, 1: 30D, 2: 90D, 3: ALL

  const _WeightTrendChart({required this.timeframe});

  @override
  State<_WeightTrendChart> createState() => _WeightTrendChartState();
}

class _WeightTrendChartState extends State<_WeightTrendChart> {
  late int _selectedTimeframe;
  int? _hoveredIndex;

  @override
  void initState() {
    super.initState();
    _selectedTimeframe = widget.timeframe;
  }

  void _updateHoveredIndex(double localX, double totalWidth, int entryCount) {
    if (entryCount < 2 || totalWidth <= 0) return;
    final availableWidth = totalWidth - 20.0;
    final painterX = (localX - 10.0).clamp(0.0, availableWidth);
    final stepX = availableWidth / (entryCount - 1);
    final calculatedIndex = (painterX / stepX).round().clamp(0, entryCount - 1);

    if (_hoveredIndex != calculatedIndex) {
      setState(() {
        _hoveredIndex = calculatedIndex;
      });
      HapticFeedback.selectionClick();
    }
  }

  void _clearHoveredIndex() {
    if (_hoveredIndex != null) {
      setState(() {
        _hoveredIndex = null;
      });
    }
  }

  Widget _buildTooltip(WeightEntry entry, double chartWidth, double chartHeight,
      int index, int entryCount) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final availableWidth = chartWidth - 20.0;
    final stepX = availableWidth / (entryCount - 1);
    final pointX = 10.0 + index * stepX;

    const tooltipWidth = 100.0;
    final leftPos =
        (pointX - tooltipWidth / 2).clamp(4.0, chartWidth - tooltipWidth - 4.0);

    final formattedDate = LocalizedFormat.monthDay(context, entry.dateTime);

    return Positioned(
      left: leftPos,
      top: -46,
      child: Container(
        width: tooltipWidth,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: context.appColors.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white.withValues(alpha: 0.12)
                : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${LocalizedFormat.decimal(context, entry.weightKg)} kg',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Theme.of(context).colorScheme.primary,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              formattedDate,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeightTrackerProvider>(
      builder: (context, provider, child) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final appColors = theme.extension<AppColors>()!;

        Widget buildHeader() {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  AppLocalizations.of(context)!.trend,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              Flexible(
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: PlatformInfo.isIOS
                      ? ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 240),
                          child: _TimeframeSelector(
                            selectedIndex: _selectedTimeframe,
                            onSelect: (index) {
                              setState(() {
                                _selectedTimeframe = index;
                              });
                            },
                          ),
                        )
                      : _TimeframeSelector(
                          selectedIndex: _selectedTimeframe,
                          onSelect: (index) {
                            setState(() {
                              _selectedTimeframe = index;
                            });
                          },
                        ),
                ),
              ),
            ],
          );
        }

        Widget buildTrendCard({required Widget body}) {
          return Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : appColors.border,
                width: 1,
              ),
              boxShadow: AppShadows.elevatedSoft,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildHeader(),
                const SizedBox(height: 16),
                body,
              ],
            ),
          );
        }

        // Filter entries by timeframe
        final now = DateTime.now();
        List<WeightEntry> chartEntries;
        switch (_selectedTimeframe) {
          case 0: // 7D
            final cutoff = now.subtract(const Duration(days: 7));
            chartEntries = provider.entries
                .where((e) => !e.dateTime.isBefore(cutoff))
                .toList()
                .reversed
                .toList();
            break;
          case 1: // 30D
            final cutoff = now.subtract(const Duration(days: 30));
            chartEntries = provider.entries
                .where((e) => !e.dateTime.isBefore(cutoff))
                .toList()
                .reversed
                .toList();
            break;
          case 2: // 90D
            final cutoff = now.subtract(const Duration(days: 90));
            chartEntries = provider.entries
                .where((e) => !e.dateTime.isBefore(cutoff))
                .toList()
                .reversed
                .toList();
            break;
          case 3: // ALL
          default:
            chartEntries = provider.entries.reversed.toList();
            break;
        }

        if (chartEntries.length < 2) {
          return buildTrendCard(
            body: SizedBox(
              height: 130,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.show_chart_rounded,
                      size: 34,
                      color: appColors.mutedText.withValues(alpha: 0.5),
                    ),
                    const SizedBox(height: 18),
                    Text(
                      AppLocalizations.of(context)!.addOneMoreRecordToSeeTrend,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: appColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final weights = chartEntries.map((e) => e.weightKg).toList();
        final minWeight = weights.reduce((a, b) => a < b ? a : b);
        final maxWeight = weights.reduce((a, b) => a > b ? a : b);
        final range = maxWeight - minWeight;
        final padding = range > 0 ? range * 0.1 : 1.0;

        return buildTrendCard(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LayoutBuilder(builder: (context, constraints) {
                final chartWidth = constraints.maxWidth;
                const chartHeight = 130.0;

                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    GestureDetector(
                      onHorizontalDragStart: (details) {
                        _updateHoveredIndex(details.localPosition.dx,
                            chartWidth, chartEntries.length);
                      },
                      onHorizontalDragUpdate: (details) {
                        _updateHoveredIndex(details.localPosition.dx,
                            chartWidth, chartEntries.length);
                      },
                      onHorizontalDragEnd: (details) {
                        _clearHoveredIndex();
                      },
                      onHorizontalDragCancel: () {
                        _clearHoveredIndex();
                      },
                      onTapDown: (details) {
                        _updateHoveredIndex(details.localPosition.dx,
                            chartWidth, chartEntries.length);
                      },
                      onTapUp: (details) {
                        Future.delayed(const Duration(seconds: 2), () {
                          if (mounted) {
                            _clearHoveredIndex();
                          }
                        });
                      },
                      onTapCancel: () {
                        _clearHoveredIndex();
                      },
                      child: Container(
                        height: chartHeight,
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 14),
                        decoration: BoxDecoration(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.03)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: CustomPaint(
                          painter: _WeightSparklinePainter(
                            entries: chartEntries,
                            minWeight: minWeight - padding,
                            maxWeight: maxWeight + padding,
                            color: theme.colorScheme.primary,
                            hoveredIndex: _hoveredIndex,
                            isDark: isDark,
                          ),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                    if (_hoveredIndex != null &&
                        _hoveredIndex! < chartEntries.length)
                      _buildTooltip(chartEntries[_hoveredIndex!], chartWidth,
                          chartHeight, _hoveredIndex!, chartEntries.length),
                  ],
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

class _TimeframeSelector extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const _TimeframeSelector({
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final labels = [
      AppLocalizations.of(context)!.timeframe7D,
      AppLocalizations.of(context)!.timeframe30D,
      AppLocalizations.of(context)!.timeframe90D,
      AppLocalizations.of(context)!.timeframeAll,
    ];

    if (!PlatformInfo.isIOS) {
      final theme = Theme.of(context);
      final appColors = theme.extension<AppColors>()!;
      return Row(
        children: labels.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          final isSelected = selectedIndex == index;
          return Flexible(
            child: GestureDetector(
              onTap: () => onSelect(index),
              child: Container(
                margin: const EdgeInsetsDirectional.only(start: 4),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : appColors.mutedText,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    }

    final selectedBg = _weightSegmentSelectedBackground(context);
    final brightnessKey = Theme.of(context).brightness;

    return SegmentedButtonTheme(
      data: _weightSegmentThemeData(context, selectedBg),
      child: _buildPlatformSegmentedControl(
        key: ValueKey('weight_timeframe_${brightnessKey.name}'),
        labels: labels,
        selectedIndex: selectedIndex,
        onValueChanged: onSelect,
        height: 32,
        shrinkWrap: true,
        color: selectedBg,
      ),
    );
  }
}

// Sparkline painter for weight trend
class _WeightSparklinePainter extends CustomPainter {
  final List<WeightEntry> entries;
  final double minWeight;
  final double maxWeight;
  final Color color;
  final int? hoveredIndex;
  final bool isDark;

  _WeightSparklinePainter({
    required this.entries,
    required this.minWeight,
    required this.maxWeight,
    required this.color,
    this.hoveredIndex,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (entries.isEmpty || entries.length == 1) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final stepX = size.width / (entries.length - 1);
    final weightRange = maxWeight - minWeight;

    // Draw horizontal grid bounds
    final gridPaint = Paint()
      ..color = (isDark ? Colors.white : Colors.black).withValues(alpha: 0.04)
      ..strokeWidth = 1.0;
    canvas.drawLine(Offset.zero, Offset(size.width, 0), gridPaint);
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), gridPaint);

    final points = <Offset>[];
    for (int i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final x = (i * stepX).toDouble();
      final normalizedWeight =
          weightRange > 0 ? (entry.weightKg - minWeight) / weightRange : 0.5;
      final y = (size.height - (normalizedWeight * size.height)).toDouble();
      points.add(Offset(x, y));
    }

    final path = Path();
    final fillPath = Path();

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      fillPath.moveTo(points.first.dx, size.height);
      fillPath.lineTo(points.first.dx, points.first.dy);

      for (int i = 0; i < points.length - 1; i++) {
        final p0 = points[i];
        final p1 = points[i + 1];

        final controlX1 = p0.dx + (p1.dx - p0.dx) / 2;
        final controlY1 = p0.dy;
        final controlX2 = p0.dx + (p1.dx - p0.dx) / 2;
        final controlY2 = p1.dy;

        path.cubicTo(controlX1, controlY1, controlX2, controlY2, p1.dx, p1.dy);
        fillPath.cubicTo(
            controlX1, controlY1, controlX2, controlY2, p1.dx, p1.dy);
      }

      fillPath.lineTo(points.last.dx, size.height);
      fillPath.close();
    }

    // Draw gradient fill under the sparkline
    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withValues(alpha: 0.22),
          color.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    // Draw main line path
    canvas.drawPath(path, paint);

    // Draw vertical guide line and hovered point indicator if active
    if (hoveredIndex != null && hoveredIndex! < entries.length) {
      final hX = (hoveredIndex! * stepX).toDouble();
      final hEntry = entries[hoveredIndex!];
      final hNormalizedWeight =
          weightRange > 0 ? (hEntry.weightKg - minWeight) / weightRange : 0.5;
      final hY = (size.height - (hNormalizedWeight * size.height)).toDouble();

      // Draw dashed vertical line
      final verticalLinePaint = Paint()
        ..color = color.withValues(alpha: 0.3)
        ..strokeWidth = 1.2
        ..style = PaintingStyle.stroke;

      const dashHeight = 4.0;
      const dashGap = 4.0;
      double startY = 0.0;
      while (startY < size.height) {
        canvas.drawLine(
          Offset(hX, startY),
          Offset(hX, (startY + dashHeight).clamp(0, size.height)),
          verticalLinePaint,
        );
        startY += dashHeight + dashGap;
      }

      // Draw circular indicator highlights
      final outerCirclePaint = Paint()
        ..color = color.withValues(alpha: 0.2)
        ..style = PaintingStyle.fill;
      final innerCirclePaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      final centerCirclePaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(hX, hY), 8.0, outerCirclePaint);
      canvas.drawCircle(Offset(hX, hY), 5.0, innerCirclePaint);
      canvas.drawCircle(Offset(hX, hY), 2.5, centerCirclePaint);
    } else {
      // Draw standard dot on the final coordinate
      final lastIdx = entries.length - 1;
      final lX = (lastIdx * stepX).toDouble();
      final lEntry = entries[lastIdx];
      final lNormalizedWeight =
          weightRange > 0 ? (lEntry.weightKg - minWeight) / weightRange : 0.5;
      final lY = (size.height - (lNormalizedWeight * size.height)).toDouble();

      final pointPaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(lX, lY), 4.0, pointPaint);
      canvas.drawCircle(Offset(lX, lY), 2.0, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(_WeightSparklinePainter oldDelegate) {
    return oldDelegate.entries != entries ||
        oldDelegate.minWeight != minWeight ||
        oldDelegate.maxWeight != maxWeight ||
        oldDelegate.hoveredIndex != hoveredIndex;
  }
}

// Weight History List with swipe actions
class _WeightHistoryList extends StatelessWidget {
  final bool showAll;
  final VoidCallback? onShowAll;

  const _WeightHistoryList({
    required this.showAll,
    this.onShowAll,
  });

  void _showEditWeightBottomSheet(BuildContext context, WeightEntry entry) {
    _showRecordWeightBottomSheetHelper(context, editEntry: entry);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WeightTrackerProvider, AppSettingsProvider>(
      builder: (context, provider, settingsProvider, child) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final isWeightMetric = settingsProvider.weightUnit == 'kg';

        final entriesToShow =
            showAll ? provider.entries : provider.entries.take(7).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.history,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                if (!showAll && provider.entries.length > 7)
                  TextButton(
                    onPressed: onShowAll,
                    child: Text(
                      AppLocalizations.of(context)!.seeAll,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ...entriesToShow.map((entry) {
              String formatDate(DateTime dateTime) {
                final now = DateTime.now();
                final today = DateTime(now.year, now.month, now.day);
                final yesterday = today.subtract(const Duration(days: 1));
                final dateOnly =
                    DateTime(dateTime.year, dateTime.month, dateTime.day);

                if (dateOnly == today) {
                  return AppLocalizations.of(context)!.today;
                } else if (dateOnly == yesterday) {
                  return AppLocalizations.of(context)!.yesterday;
                } else {
                  return LocalizedFormat.mediumDate(context, dateTime);
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _SwipeRevealDelete(
                  key: Key(entry.id),
                  itemId: 'weight_${entry.id}',
                  buttonDiameter: 44,
                  actionWidth: 60,
                  onDelete: () {
                    provider.deleteEntry(entry.id);
                  },
                  child: InkWell(
                    onTap: () => _showEditWeightBottomSheet(context, entry),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: isDark
                              ? Colors.white.withValues(alpha: 0.1)
                              : theme.extension<AppColors>()!.border,
                          width: 1,
                        ),
                        boxShadow: AppShadows.elevatedSoft,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              entry.formatWeight(
                                isWeightMetric,
                                localeName: LocalizedFormat.localeName(context),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Text(
                              formatDate(entry.dateTime),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.end,
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.extension<AppColors>()!.mutedText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

// Record Weight Bottom Sheet
class _RecordWeightBottomSheet extends StatefulWidget {
  final TextEditingController weightController;
  final bool isMetric;
  final DateTime? initialDateTime;
  final bool isEditing;
  final String? entryId;

  const _RecordWeightBottomSheet({
    required this.weightController,
    required this.isMetric,
    this.initialDateTime,
    this.isEditing = false,
    this.entryId,
  });

  @override
  State<_RecordWeightBottomSheet> createState() =>
      _RecordWeightBottomSheetState();
}

class _RecordWeightBottomSheetState extends State<_RecordWeightBottomSheet> {
  late TextEditingController _controller;
  bool _isValid = false;
  late DateTime _selectedDateTime;

  @override
  void initState() {
    super.initState();
    _controller = widget.weightController;
    _selectedDateTime = widget.initialDateTime ?? DateTime.now();
    _isValid = _controller.text.isNotEmpty;
    _controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    _controller.removeListener(_validateInput);
    super.dispose();
  }

  void _validateInput() {
    final text = _controller.text.trim();
    final weight = LocalizedFormat.tryParseDecimal(context, text);
    setState(() {
      _isValid =
          text.isNotEmpty && weight != null && weight > 0 && weight < 500;
    });
  }

  void _addQuickValue(double value) {
    final current =
        LocalizedFormat.tryParseDecimal(context, _controller.text) ?? 0;
    final newValue = (current + value).clamp(0.0, 500.0);
    setState(() {
      _controller.text = LocalizedFormat.decimal(context, newValue);
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();
    final initialDate =
        _selectedDateTime.isAfter(now) ? now : _selectedDateTime;
    var tempPicked = DateTime(
      initialDate.year,
      initialDate.month,
      initialDate.day,
    );

    final pickedDate = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final l10n = AppLocalizations.of(context)!;

        return SafeArea(
          top: false,
          child: AppBottomSheetFrame(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          style: TextButton.styleFrom(
                            foregroundColor:
                                theme.extension<AppColors>()!.mutedText,
                          ),
                          child: Text(l10n.cancel),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, tempPicked),
                          child: Text(l10n.done),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 260,
                    child: CupertinoTheme(
                      data: CupertinoThemeData(
                        brightness: isDark ? Brightness.dark : Brightness.light,
                        textTheme: CupertinoTextThemeData(
                          dateTimePickerTextStyle: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: tempPicked,
                        minimumDate: DateTime(2020),
                        maximumDate: now,
                        onDateTimeChanged: (value) {
                          tempPicked = DateTime(
                            value.year,
                            value.month,
                            value.day,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (pickedDate != null) {
      setState(() {
        // Set time to start of day (00:00:00)
        _selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
        );
      });
    }
  }

  void _save() {
    if (!_isValid) return;

    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final isMetric = settingsProvider.weightUnit == 'kg';
    final weightText = _controller.text.trim();
    final weight = LocalizedFormat.tryParseDecimal(context, weightText);
    if (weight != null && weight > 0) {
      final weightKg = isMetric ? weight : weight / 2.20462;
      final provider =
          Provider.of<WeightTrackerProvider>(context, listen: false);

      HapticFeedback.mediumImpact();

      if (widget.isEditing && widget.entryId != null) {
        // Update existing entry
        provider.updateEntry(
          widget.entryId!,
          WeightEntry(
            id: widget.entryId!,
            dateTime: _selectedDateTime,
            weightKg: weightKg,
          ),
        );
      } else {
        // Add new entry
        provider.addEntry(WeightEntry(
          dateTime: _selectedDateTime,
          weightKg: weightKg,
        ));
      }

      Navigator.pop(context);
    }
  }

  String _formatDateDisplay(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final l10n = AppLocalizations.of(context)!;
    if (dateOnly == today) {
      return l10n.today;
    } else if (dateOnly == today.subtract(const Duration(days: 1))) {
      return l10n.yesterday;
    } else {
      return LocalizedFormat.mediumDate(context, dateTime);
    }
  }

  String? _getLastWeightComparison(bool isMetric) {
    final provider = Provider.of<WeightTrackerProvider>(context, listen: false);
    if (provider.entries.length < 2) return null;

    final lastWeight = provider.entries[1].weightKg;
    final currentText = _controller.text.trim();
    final currentWeight = LocalizedFormat.tryParseDecimal(context, currentText);

    if (currentWeight == null || currentText.isEmpty) return null;

    final currentWeightKg = isMetric ? currentWeight : currentWeight / 2.20462;
    final difference = currentWeightKg - lastWeight;

    String formatWeight(double kg, bool isMetric) {
      if (isMetric) {
        return '${LocalizedFormat.decimal(context, kg)} kg';
      } else {
        return '${LocalizedFormat.decimal(context, kg * 2.20462)} lbs';
      }
    }

    final sign = difference > 0 ? '+' : '';
    final l10n = AppLocalizations.of(context)!;
    return '${l10n.last} ${formatWeight(lastWeight, isMetric)} → ${l10n.newLabel} ${formatWeight(currentWeightKg, isMetric)} ($sign${formatWeight(difference.abs(), isMetric)})';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settingsProvider, child) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final appColors = theme.extension<AppColors>()!;
        final isMetric = settingsProvider.weightUnit == 'kg';
        final lastComparison = _getLastWeightComparison(isMetric);

        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : appColors.border,
            ),
            boxShadow: AppShadows.elevatedSoft,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              const AppBottomSheetHandle(),
              // Header with title and close button
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.isEditing
                            ? AppLocalizations.of(context)!.editWeight
                            : AppLocalizations.of(context)!.recordWeight,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    PlatformInfo.isIOS
                        ? AdaptiveButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: CupertinoIcons.xmark,
                            iconColor: appColors.mutedText,
                            style: AdaptiveButtonStyle.glass,
                            size: AdaptiveButtonSize.small,
                            color: appColors.mutedText,
                            padding: const EdgeInsets.all(6),
                            minSize: const Size(32, 32),
                            borderRadius: BorderRadius.circular(999),
                            useSmoothRectangleBorder: false,
                          )
                        : IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: Icon(
                              Icons.close,
                              size: 24,
                              color: appColors.mutedText,
                            ),
                          ),
                  ],
                ),
              ),
              // Content area (scrollable)
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero input area
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Large number input
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              autofocus: true,
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                                letterSpacing: -1.5,
                                height: 1.0,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: isMetric ? '70.5' : '155.5',
                                hintStyle: TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.w700,
                                  color: appColors.mutedText
                                      .withValues(alpha: 0.3),
                                  letterSpacing: -1.5,
                                  height: 1.0,
                                ),
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Unit pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: appColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : appColors.border,
                              ),
                            ),
                            child: Text(
                              isMetric ? 'kg' : 'lbs',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: appColors.mutedText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Last weight comparison preview
                      if (lastComparison != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          lastComparison,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: appColors.mutedText,
                          ),
                        ),
                      ],
                      const SizedBox(height: 24),
                      // Date selector (premium list item style)
                      InkWell(
                        onTap: () => _selectDate(context),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: appColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : appColors.border,
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 18,
                                color: theme.colorScheme.primary,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _formatDateDisplay(_selectedDateTime),
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                              PlatformIcon(
                                cupertino: CupertinoIcons.chevron_right,
                                material: Icons.chevron_right,
                                color: appColors.mutedText,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Quick adjust chips (2-row grid)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.quickAdjust,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: appColors.mutedText,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          // First row: negative values
                          Row(
                            children: [
                              Expanded(
                                child: _QuickChip(
                                  label: '-1.0',
                                  onTap: () => _addQuickValue(-1.0),
                                  isNegative: true,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _QuickChip(
                                  label: '-0.5',
                                  onTap: () => _addQuickValue(-0.5),
                                  isNegative: true,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _QuickChip(
                                  label: '-0.2',
                                  onTap: () => _addQuickValue(-0.2),
                                  isNegative: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Second row: positive values
                          Row(
                            children: [
                              Expanded(
                                child: _QuickChip(
                                  label: '+0.2',
                                  onTap: () => _addQuickValue(0.2),
                                  isNegative: false,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _QuickChip(
                                  label: '+0.5',
                                  onTap: () => _addQuickValue(0.5),
                                  isNegative: false,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _QuickChip(
                                  label: '+1.0',
                                  onTap: () => _addQuickValue(1.0),
                                  isNegative: false,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Sticky Save button (above keyboard)
              Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isValid ? _save : null,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.save,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QuickChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool isNegative;

  const _QuickChip({
    required this.label,
    required this.onTap,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isNegative
              ? Colors.transparent
              : (isDark
                  ? const Color(0xFF2C2C2E)
                  : theme.colorScheme.primary.withValues(alpha: 0.08)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isNegative
                ? (isDark
                    ? Colors.white.withValues(alpha: 0.1)
                    : Colors.grey.shade300)
                : theme.colorScheme.primary.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: isNegative
                ? theme.colorScheme.onSurface
                : theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

// Set Goal Bottom Sheet
class _SetGoalBottomSheet extends StatefulWidget {
  final TextEditingController goalWeightController;
  final bool isMetric;
  final WeightEntry? currentWeight;

  const _SetGoalBottomSheet({
    required this.goalWeightController,
    required this.isMetric,
    this.currentWeight,
  });

  @override
  State<_SetGoalBottomSheet> createState() => _SetGoalBottomSheetState();
}

class _SetGoalBottomSheetState extends State<_SetGoalBottomSheet> {
  late TextEditingController _controller;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.goalWeightController;
    _isValid = _controller.text.isNotEmpty;
    _controller.addListener(_validateInput);
  }

  @override
  void dispose() {
    _controller.removeListener(_validateInput);
    super.dispose();
  }

  void _validateInput() {
    final text = _controller.text.trim();
    final weight = LocalizedFormat.tryParseDecimal(context, text);
    setState(() {
      _isValid =
          text.isNotEmpty && weight != null && weight > 0 && weight < 500;
    });
  }

  void _setPreset(double value) {
    setState(() {
      _controller.text = LocalizedFormat.decimal(context, value);
    });
  }

  void _save() {
    final settingsProvider =
        Provider.of<AppSettingsProvider>(context, listen: false);
    final isMetric = settingsProvider.weightUnit == 'kg';
    final provider = Provider.of<WeightTrackerProvider>(context, listen: false);
    final weightText = _controller.text.trim();

    if (weightText.isNotEmpty) {
      final weight = LocalizedFormat.tryParseDecimal(context, weightText);
      if (weight != null && weight > 0) {
        final weightKg = isMetric ? weight : weight / 2.20462;
        HapticFeedback.mediumImpact();
        provider.setGoalWeight(weightKg);
        Navigator.pop(context);
      }
    } else {
      provider.setGoalWeight(null);
      Navigator.pop(context);
    }
  }

  void _remove() {
    final provider = Provider.of<WeightTrackerProvider>(context, listen: false);
    HapticFeedback.mediumImpact();
    provider.setGoalWeight(null);
    Navigator.pop(context);
  }

  String? _getGoalHelperText(bool isMetric) {
    if (widget.currentWeight == null) return null;

    final currentText = _controller.text.trim();
    final goalWeight = LocalizedFormat.tryParseDecimal(context, currentText);

    if (goalWeight == null || currentText.isEmpty) return null;

    final goalWeightKg = isMetric ? goalWeight : goalWeight / 2.20462;
    final difference = goalWeightKg - widget.currentWeight!.weightKg;

    String formatWeight(double kg) {
      if (isMetric) {
        return '${LocalizedFormat.decimal(context, kg)} kg';
      } else {
        return '${LocalizedFormat.decimal(context, kg * 2.20462)} lbs';
      }
    }

    final l10n = AppLocalizations.of(context)!;
    if (difference.abs() < 0.1) {
      return l10n.goalMatchesCurrentWeight;
    } else if (difference < 0) {
      return l10n.youNeed(
          formatWeight(difference.abs()), formatWeight(goalWeightKg));
    } else {
      return l10n.youNeedPlus(
          formatWeight(difference), formatWeight(goalWeightKg));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettingsProvider>(
      builder: (context, settingsProvider, child) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final appColors = theme.extension<AppColors>()!;
        final isMetric = settingsProvider.weightUnit == 'kg';
        final provider =
            Provider.of<WeightTrackerProvider>(context, listen: false);
        final hasGoal = provider.goalWeight != null;
        final helperText = _getGoalHelperText(isMetric);

        // Calculate preset values based on current weight (relative to current)
        double? diff1, diff2, diff3;
        double? preset1, preset2, preset3;
        if (widget.currentWeight != null) {
          diff1 = -2.0;
          diff2 = -5.0;
          diff3 = -10.0;
          preset1 = widget.currentWeight!.weightKg + diff1;
          preset2 = widget.currentWeight!.weightKg + diff2;
          preset3 = widget.currentWeight!.weightKg + diff3;
        }

        return Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : appColors.border,
            ),
            boxShadow: AppShadows.elevatedSoft,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              const AppBottomSheetHandle(),
              // Header with title and close button
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(24, 16, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        AppLocalizations.of(context)!.setGoal,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const PlatformIcon(
                        cupertino: CupertinoIcons.xmark,
                        material: Icons.close,
                        size: 24,
                      ),
                      color: appColors.mutedText,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              // Content area (scrollable)
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero input area
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Large number input
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              autofocus: true,
                              style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.w700,
                                color: theme.colorScheme.onSurface,
                                letterSpacing: -1.5,
                                height: 1.0,
                              ),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: isMetric ? '65.0' : '143.0',
                                hintStyle: TextStyle(
                                  fontSize: 56,
                                  fontWeight: FontWeight.w700,
                                  color: appColors.mutedText
                                      .withValues(alpha: 0.3),
                                  letterSpacing: -1.5,
                                  height: 1.0,
                                ),
                                contentPadding: EdgeInsets.zero,
                                isDense: true,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Unit pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: appColors.surfaceElevated,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.08)
                                    : appColors.border,
                              ),
                            ),
                            child: Text(
                              isMetric ? 'kg' : 'lbs',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: appColors.mutedText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Helper text showing weight difference
                      if (helperText != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          helperText,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: appColors.mutedText,
                          ),
                        ),
                      ],
                      if (preset1 != null &&
                          preset2 != null &&
                          preset3 != null) ...[
                        const SizedBox(height: 24),
                        // Suggested goal chips
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.suggested,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: appColors.mutedText,
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Builder(
                              builder: (context) {
                                // Assign to local non-null variables for use in callbacks
                                final p1 = preset1!;
                                final p2 = preset2!;
                                final p3 = preset3!;
                                final d1 = diff1!;
                                final d2 = diff2!;
                                final d3 = diff3!;

                                String formatLabel(double diff, double preset) {
                                  final l10n = AppLocalizations.of(context)!;
                                  final displayedDiff =
                                      isMetric ? diff : diff * 2.20462;
                                  final value = LocalizedFormat.decimal(
                                    context,
                                    displayedDiff.abs(),
                                    decimalDigits: 0,
                                  );
                                  final sign = diff > 0
                                      ? '+'
                                      : diff < 0
                                          ? '-'
                                          : '';
                                  if (isMetric) {
                                    return '${l10n.current} $sign$value kg';
                                  } else {
                                    return '${l10n.current} $sign$value lbs';
                                  }
                                }

                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _QuickChip(
                                            label: formatLabel(d1, p1),
                                            onTap: () => _setPreset(
                                                isMetric ? p1 : p1 * 2.20462),
                                            isNegative: false,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: _QuickChip(
                                            label: formatLabel(d2, p2),
                                            onTap: () => _setPreset(
                                                isMetric ? p2 : p2 * 2.20462),
                                            isNegative: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      child: _QuickChip(
                                        label: formatLabel(d3, p3),
                                        onTap: () => _setPreset(
                                            isMetric ? p3 : p3 * 2.20462),
                                        isNegative: false,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // Sticky action area (Remove Goal + Save button)
              Container(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey.shade200,
                      width: 1,
                    ),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    children: [
                      if (hasGoal)
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            onPressed: _remove,
                            style: TextButton.styleFrom(
                              foregroundColor: appColors.danger,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child:
                                Text(AppLocalizations.of(context)!.removeGoal),
                          ),
                        ),
                      if (hasGoal) const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isValid ? _save : null,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.save,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MachineTabItem {
  final IconData icon;
  final String label;

  const _MachineTabItem({
    required this.icon,
    required this.label,
  });
}

class _WeightCalendar extends StatefulWidget {
  const _WeightCalendar();

  @override
  State<_WeightCalendar> createState() => _WeightCalendarState();
}

class _WeightCalendarState extends State<_WeightCalendar> {
  DateTime _currentMonth = DateTime.now();

  String _getWeightCalendarTitle(BuildContext context) {
    return AppLocalizations.of(context)!.weightCalendar;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<WeightTrackerProvider, AppSettingsProvider>(
      builder: (context, provider, settingsProvider, child) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final appColors = theme.extension<AppColors>()!;
        final isWeightMetric = settingsProvider.weightUnit == 'kg';
        final l10n = AppLocalizations.of(context)!;
        final now = DateTime.now();
        final isCurrentMonth =
            _currentMonth.year == now.year && _currentMonth.month == now.month;

        // Group entries by date (date only)
        final entriesByDate = <DateTime, WeightEntry>{};
        for (final entry in provider.entries) {
          final dateOnly = DateTime(
            entry.dateTime.year,
            entry.dateTime.month,
            entry.dateTime.day,
          );
          entriesByDate.putIfAbsent(dateOnly, () => entry);
        }

        final title = _getWeightCalendarTitle(context);

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.1)
                  : appColors.border,
              width: 1,
            ),
            boxShadow: AppShadows.elevatedSoft,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Title & Month Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left, size: 20),
                          tooltip: l10n.previousMonth,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              _currentMonth = DateTime(
                                _currentMonth.year,
                                _currentMonth.month - 1,
                              );
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            LocalizedFormat.yearMonth(context, _currentMonth),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const PlatformIcon(
                            cupertino: CupertinoIcons.chevron_right,
                            material: Icons.chevron_right,
                            size: 20,
                          ),
                          tooltip: l10n.nextMonth,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: isCurrentMonth
                              ? null
                              : () {
                                  setState(() {
                                    _currentMonth = DateTime(
                                      _currentMonth.year,
                                      _currentMonth.month + 1,
                                    );
                                  });
                                },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Weekday Headers
              _buildWeekdayHeaders(context, appColors),
              const SizedBox(height: 8),
              // Calendar Grid
              _buildCalendarGrid(
                context,
                provider,
                entriesByDate,
                isWeightMetric,
                theme,
                appColors,
                isDark,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWeekdayHeaders(BuildContext context, AppColors appColors) {
    final l10n = AppLocalizations.of(context)!;
    final weekdays = <String>[
      l10n.mon,
      l10n.tue,
      l10n.wed,
      l10n.thu,
      l10n.fri,
      l10n.sat,
      l10n.sun,
    ];

    return Row(
      children: weekdays.map((day) {
        return Expanded(
          child: Center(
            child: Text(
              day,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: appColors.mutedText,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCalendarGrid(
    BuildContext context,
    WeightTrackerProvider provider,
    Map<DateTime, WeightEntry> entriesByDate,
    bool isWeightMetric,
    ThemeData theme,
    AppColors appColors,
    bool isDark,
  ) {
    final firstDay = DateTime(_currentMonth.year, _currentMonth.month, 1);
    final lastDay = DateTime(_currentMonth.year, _currentMonth.month + 1, 0);
    final firstWeekday = firstDay.weekday; // 1 = Monday, 7 = Sunday
    final daysInMonth = lastDay.day;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 0.85,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
      ),
      itemCount: (firstWeekday - 1) + daysInMonth,
      itemBuilder: (context, index) {
        if (index < firstWeekday - 1) {
          return const SizedBox.shrink();
        }

        final day = index - (firstWeekday - 1) + 1;
        final date = DateTime(_currentMonth.year, _currentMonth.month, day);
        final entry = entriesByDate[date];
        final isToday = date == today;

        return _buildCalendarCell(
          context,
          date,
          day,
          entry,
          isToday,
          isWeightMetric,
          theme,
          appColors,
          isDark,
          provider,
        );
      },
    );
  }

  Widget _buildCalendarCell(
    BuildContext context,
    DateTime date,
    int day,
    WeightEntry? entry,
    bool isToday,
    bool isWeightMetric,
    ThemeData theme,
    AppColors appColors,
    bool isDark,
    WeightTrackerProvider provider,
  ) {
    final hasEntry = entry != null;

    return GestureDetector(
      onTap: () {
        if (hasEntry) {
          _showCellOptions(context, entry, provider);
        } else {
          _showRecordWeightBottomSheetHelper(context, initialDateTime: date);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: hasEntry
              ? theme.colorScheme.primary.withValues(alpha: 0.12)
              : isToday
                  ? (isDark
                      ? Colors.white.withValues(alpha: 0.05)
                      : Colors.grey.shade100)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasEntry
                ? theme.colorScheme.primary.withValues(alpha: 0.35)
                : isToday
                    ? theme.colorScheme.primary.withValues(alpha: 0.5)
                    : isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : Colors.grey.shade200,
            width: isToday ? 1.5 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              LocalizedFormat.decimal(context, day, decimalDigits: 0),
              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    isToday || hasEntry ? FontWeight.bold : FontWeight.normal,
                color: isToday
                    ? theme.colorScheme.primary
                    : hasEntry
                        ? theme.colorScheme.onSurface
                        : isDark
                            ? Colors.white70
                            : Colors.black87,
              ),
            ),
            if (hasEntry) ...[
              const SizedBox(height: 2),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  isWeightMetric
                      ? LocalizedFormat.decimal(context, entry.weightKg)
                      : LocalizedFormat.decimal(
                          context,
                          entry.weightKg * 2.20462,
                        ),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ] else ...[
              const SizedBox(height: 2),
              Text(
                '+',
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white30 : Colors.black26,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showCellOptions(
    BuildContext context,
    WeightEntry entry,
    WeightTrackerProvider provider,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? const Color(0xFF1C1C1E)
                : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    LocalizedFormat.mediumDate(context, entry.dateTime),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.edit_outlined),
                  title: Text(l10n.edit),
                  onTap: () {
                    Navigator.pop(context);
                    _showRecordWeightBottomSheetHelper(context,
                        editEntry: entry);
                  },
                ),
                ListTile(
                  leading: const PlatformIcon(
                    cupertino: CupertinoIcons.trash,
                    material: Icons.delete_outline,
                    color: Colors.red,
                  ),
                  title: Text(
                    l10n.delete,
                    style: const TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmDelete(context, entry, provider);
                  },
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmDelete(
    BuildContext context,
    WeightEntry entry,
    WeightTrackerProvider provider,
  ) {
    final l10n = AppLocalizations.of(context)!;
    HapticFeedback.mediumImpact();
    showAppDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AppDialog(
          icon: platformIconData(
            cupertino: CupertinoIcons.trash,
            material: Icons.delete_outline_rounded,
          ),
          iconColor: Theme.of(dialogContext).colorScheme.error,
          title: l10n.weightDeleteTitle,
          message: l10n.weightDeleteConfirm,
          actions: [
            AppDialogAction(
              label: l10n.cancel,
              style: AppDialogActionStyle.secondary,
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            AppDialogAction(
              label: l10n.delete,
              style: AppDialogActionStyle.destructive,
              onPressed: () {
                Navigator.of(dialogContext).pop();
                provider.deleteEntry(entry.id);
                HapticFeedback.lightImpact();
              },
            ),
          ],
        );
      },
    );
  }
}

class _AchievementsTab extends StatefulWidget {
  const _AchievementsTab();

  @override
  State<_AchievementsTab> createState() => _AchievementsTabState();
}

class _AchievementsTabState extends State<_AchievementsTab> {
  int _filterIndex = 0; // 0: All, 1: Unlocked, 2: Locked

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final langCode = Localizations.localeOf(context).languageCode;

    return Consumer<AchievementProvider>(
      builder: (context, provider, child) {
        final achievements = provider.achievements;
        if (achievements.isEmpty) {
          return Center(
            child: Text(
              AchievementTranslations.getUiString('no_achievements', langCode),
              style: TextStyle(color: appColors.mutedText),
            ),
          );
        }

        // Apply filters
        List<Achievement> filtered = achievements;
        if (_filterIndex == 1) {
          filtered = achievements.where((a) => a.isUnlocked).toList();
        } else if (_filterIndex == 2) {
          filtered = achievements.where((a) => !a.isUnlocked).toList();
        }

        // Count unlocked
        final unlockedCount = achievements.where((a) => a.isUnlocked).length;
        final totalCount = achievements.length;
        final completionRate =
            totalCount > 0 ? unlockedCount / totalCount : 0.0;

        // Custom User Title based on unlock count
        String userTitle = '';
        if (completionRate == 1.0) {
          userTitle =
              AchievementTranslations.getUiString('grand_master', langCode);
        } else if (completionRate >= 0.7) {
          userTitle =
              AchievementTranslations.getUiString('pace_master', langCode);
        } else if (completionRate >= 0.4) {
          userTitle =
              AchievementTranslations.getUiString('pro_runner', langCode);
        } else if (completionRate >= 0.1) {
          userTitle =
              AchievementTranslations.getUiString('active_beginner', langCode);
        } else {
          userTitle = AchievementTranslations.getUiString('trainee', langCode);
        }

        return Column(
          children: [
            const SizedBox(height: 16),
            // Premium Header stats card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.08),
                      theme.colorScheme.secondary.withValues(alpha: 0.03),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: theme.colorScheme.primary.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    // Circular Progress
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 70,
                          height: 70,
                          child: CircularProgressIndicator(
                            value: completionRate,
                            strokeWidth: 6,
                            backgroundColor: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary),
                          ),
                        ),
                        Text(
                          LocalizedFormat.percent(context, completionRate),
                          style: GoogleFonts.outfit(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userTitle,
                            style: GoogleFonts.outfit(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            AchievementTranslations.getUiString(
                              'unlocked_x_of_y',
                              langCode,
                              {
                                'unlocked': LocalizedFormat.decimal(
                                  context,
                                  unlockedCount,
                                  decimalDigits: 0,
                                ),
                                'total': LocalizedFormat.decimal(
                                  context,
                                  totalCount,
                                  decimalDigits: 0,
                                ),
                              },
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              color: appColors.mutedText,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // completion text
                          Text(
                            AchievementTranslations.getUiString(
                                'collect_desc', langCode),
                            style: TextStyle(
                              fontSize: 11,
                              color: appColors.mutedText.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Elegant Pill Filters
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  _buildFilterButton(
                      0,
                      AchievementTranslations.getUiString(
                          'filter_all', langCode)),
                  const SizedBox(width: 8),
                  _buildFilterButton(
                      1,
                      AchievementTranslations.getUiString(
                          'filter_unlocked', langCode)),
                  const SizedBox(width: 8),
                  _buildFilterButton(
                      2,
                      AchievementTranslations.getUiString(
                          'filter_locked', langCode)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Premium Grid Layout
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        AchievementTranslations.getUiString(
                            'no_matching', langCode),
                        style: TextStyle(color: appColors.mutedText),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final ach = filtered[index];
                        return _buildAchievementListCard(
                            context, ach, appColors, langCode);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterButton(int index, String label) {
    final theme = Theme.of(context);
    final isSelected = _filterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterIndex = index;
        });
        HapticFeedback.lightImpact();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : theme.extension<AppColors>()!.border,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementListCard(
    BuildContext context,
    Achievement ach,
    AppColors appColors,
    String langCode,
  ) {
    final theme = Theme.of(context);
    final title = ach.getTitle(langCode);
    final desc = ach.getDescription(langCode);

    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        _showAchievementDetails(context, ach, langCode);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: ach.isUnlocked
              ? theme.colorScheme.surface
              : appColors.surfaceElevated.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ach.isUnlocked
                ? ach.gradientColors[0].withValues(alpha: 0.35)
                : appColors.border.withValues(alpha: 0.7),
            width: ach.isUnlocked ? 1.5 : 1.0,
          ),
          boxShadow: ach.isUnlocked
              ? [
                  BoxShadow(
                    color: ach.gradientColors[0].withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Badge icon circle
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: ach.isUnlocked
                        ? ach.gradientColors
                        : [Colors.grey.shade300, Colors.grey.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: ach.isUnlocked
                      ? [
                          BoxShadow(
                            color:
                                ach.gradientColors[0].withValues(alpha: 0.35),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : null,
                ),
                child: Icon(
                  ach.isUnlocked ? ach.icon : Icons.lock_outline,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              // Texts
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: GoogleFonts.outfit(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ach.isUnlocked
                                  ? theme.colorScheme.onSurface
                                  : appColors.mutedText,
                            ),
                          ),
                        ),
                        if (ach.isUnlocked && ach.unlockedAt != null)
                          Flexible(
                            child: Text(
                              _formatUnlockDateSimple(
                                  ach.unlockedAt!, langCode),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 11,
                                color: appColors.mutedText,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: ach.isUnlocked
                            ? theme.colorScheme.onSurface.withValues(alpha: 0.8)
                            : appColors.mutedText.withValues(alpha: 0.7),
                      ),
                    ),
                    if (!ach.isUnlocked) ...[
                      const SizedBox(height: 10),
                      // Progress Bar
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: ach.progress,
                                minHeight: 5,
                                backgroundColor: theme.colorScheme.primary
                                    .withValues(alpha: 0.1),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.colorScheme.primary
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _formatProgressShort(ach, langCode),
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatUnlockDateSimple(DateTime dt, String langCode) {
    return LocalizedFormat.abbreviatedMonthDay(context, dt);
  }

  void _showAchievementDetails(
      BuildContext context, Achievement ach, String langCode) {
    final theme = Theme.of(context);
    final appColors = theme.extension<AppColors>()!;
    final title = ach.getTitle(langCode);
    final desc = ach.getDescription(langCode);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return AppBottomSheetFrame(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 28),
                // Big icon with gradient glow
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: ach.isUnlocked
                          ? ach.gradientColors
                          : [Colors.grey.shade300, Colors.grey.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: ach.isUnlocked
                        ? [
                            BoxShadow(
                              color:
                                  ach.gradientColors[0].withValues(alpha: 0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            )
                          ]
                        : null,
                  ),
                  child: Icon(
                    ach.isUnlocked ? ach.icon : Icons.lock_outline,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
                const SizedBox(height: 24),
                // Title
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 10),
                // Description
                Text(
                  desc,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: appColors.mutedText,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                // Unlock detail card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: appColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: appColors.border),
                  ),
                  child: Column(
                    children: [
                      if (ach.isUnlocked && ach.unlockedAt != null) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                AchievementTranslations.getUiString(
                                    'unlock_date', langCode),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: appColors.mutedText, fontSize: 13),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                _formatUnlockDateDetailed(
                                    ach.unlockedAt!, langCode),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                AchievementTranslations.getUiString(
                                    'progress_label', langCode),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: appColors.mutedText, fontSize: 13),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                LocalizedFormat.percent(context, ach.progress),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: ach.progress,
                            minHeight: 6,
                            backgroundColor: theme.colorScheme.primary
                                .withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.primary),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                AchievementTranslations.getUiString(
                                    'current_value_label', langCode),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    color: appColors.mutedText, fontSize: 12),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                _formatProgressTextDetailed(ach, langCode),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.end,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                // Close button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AchievementTranslations.getUiString('close', langCode),
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatUnlockDateDetailed(DateTime dt, String langCode) {
    return LocalizedFormat.mediumDate(context, dt);
  }

  String _achievementValueWithUnit(
    String value,
    String unit,
    String langCode,
  ) {
    return const {'ja', 'ko', 'zh'}.contains(langCode)
        ? '$value$unit'
        : '$value $unit';
  }

  String _formatProgressShort(Achievement ach, String langCode) {
    final id = ach.id;
    if (id.startsWith('treadmill_dist_') ||
        id == 'treadmill_marathon' ||
        id.startsWith('cycle_dist_')) {
      final cur = ach.currentValue.toDouble();
      final target = ach.targetValue.toDouble();
      return '${LocalizedFormat.decimal(context, cur)} / ${LocalizedFormat.decimal(context, target, decimalDigits: 0)} km';
    }
    if (id.startsWith('treadmill_5k') ||
        id.startsWith('treadmill_10k') ||
        id.startsWith('treadmill_half_marathon')) {
      final cur = ach.currentValue.toDouble();
      final target = ach.targetValue.toDouble();
      return '${LocalizedFormat.decimal(context, cur)} / ${LocalizedFormat.decimal(context, target, decimalDigits: 0)} km';
    }
    if (id.startsWith('treadmill_speed_')) {
      return '${LocalizedFormat.decimal(context, ach.currentValue)} / ${LocalizedFormat.decimal(context, ach.targetValue, decimalDigits: 0)} km/h';
    }
    if (id.startsWith('cycle_rpm')) {
      return '${LocalizedFormat.decimal(context, ach.currentValue, decimalDigits: 0)}/${LocalizedFormat.decimal(context, ach.targetValue, decimalDigits: 0)}';
    }
    if (id.startsWith('stairmaster_level')) {
      return '${LocalizedFormat.decimal(context, ach.currentValue, decimalDigits: 0)}/${LocalizedFormat.decimal(context, ach.targetValue, decimalDigits: 0)}';
    }
    if (id.startsWith('duration_')) {
      final current = LocalizedFormat.decimal(
        context,
        ach.currentValue,
        decimalDigits: 0,
      );
      final target = LocalizedFormat.decimal(
        context,
        ach.targetValue,
        decimalDigits: 0,
      );
      final unit = AchievementTranslations.getUiString('min', langCode);
      return '$current/${_achievementValueWithUnit(target, unit, langCode)}';
    }
    if (id.startsWith('total_duration_') ||
        id.startsWith('stairmaster_time_')) {
      final current = LocalizedFormat.decimal(context, ach.currentValue);
      final target = LocalizedFormat.decimal(
        context,
        ach.targetValue,
        decimalDigits: 0,
      );
      final unit = AchievementTranslations.getUiString('hours', langCode);
      return '$current / ${_achievementValueWithUnit(target, unit, langCode)}';
    }
    return '${LocalizedFormat.decimal(context, ach.currentValue, decimalDigits: 0)}/${LocalizedFormat.decimal(context, ach.targetValue, decimalDigits: 0)}';
  }

  String _formatProgressTextDetailed(Achievement ach, String langCode) {
    final id = ach.id;
    if (id.startsWith('treadmill_dist_') ||
        id == 'treadmill_marathon' ||
        id.startsWith('cycle_dist_') ||
        id.startsWith('treadmill_5k') ||
        id.startsWith('treadmill_10k') ||
        id.startsWith('treadmill_half_marathon')) {
      final cur = LocalizedFormat.decimal(
        context,
        ach.currentValue,
        decimalDigits: 2,
      );
      final target = LocalizedFormat.decimal(
        context,
        ach.targetValue,
        decimalDigits: 0,
      );
      return '$cur km / $target km';
    }
    if (id.startsWith('treadmill_speed_')) {
      return '${LocalizedFormat.decimal(context, ach.currentValue, decimalDigits: 2)} km/h / ${LocalizedFormat.decimal(context, ach.targetValue, decimalDigits: 0)} km/h';
    }
    if (id.startsWith('cycle_rpm')) {
      final l10n = AppLocalizations.of(context)!;
      final current = LocalizedFormat.decimal(
        context,
        ach.currentValue,
        decimalDigits: 0,
      );
      final target = LocalizedFormat.decimal(
        context,
        ach.targetValue,
        decimalDigits: 0,
      );
      return '${l10n.rpmValue(current)} / ${l10n.rpmValue(target)}';
    }
    if (id.startsWith('stairmaster_level')) {
      final l10n = AppLocalizations.of(context)!;
      final current = LocalizedFormat.decimal(
        context,
        ach.currentValue,
        decimalDigits: 0,
      );
      final target = LocalizedFormat.decimal(
        context,
        ach.targetValue,
        decimalDigits: 0,
      );
      return '${l10n.levelColon(current)} / ${l10n.levelColon(target)}';
    }
    if (id.startsWith('duration_')) {
      final current = LocalizedFormat.decimal(
        context,
        ach.currentValue,
        decimalDigits: 0,
      );
      final target = LocalizedFormat.decimal(
        context,
        ach.targetValue,
        decimalDigits: 0,
      );
      final unit = AchievementTranslations.getUiString('min', langCode);
      return '${_achievementValueWithUnit(current, unit, langCode)} / '
          '${_achievementValueWithUnit(target, unit, langCode)}';
    }
    if (id.startsWith('total_duration_') ||
        id.startsWith('stairmaster_time_')) {
      final current = LocalizedFormat.decimal(context, ach.currentValue);
      final target = LocalizedFormat.decimal(
        context,
        ach.targetValue,
        decimalDigits: 0,
      );
      final unit = AchievementTranslations.getUiString('hours', langCode);
      return '${_achievementValueWithUnit(current, unit, langCode)} / '
          '${_achievementValueWithUnit(target, unit, langCode)}';
    }
    return '${LocalizedFormat.decimal(context, ach.currentValue, decimalDigits: 0)} / ${LocalizedFormat.decimal(context, ach.targetValue, decimalDigits: 0)}';
  }
}
