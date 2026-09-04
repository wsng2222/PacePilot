import 'dart:async';
import 'package:flutter/material.dart' hide Interval;
import 'package:provider/provider.dart';
import 'package:valcue/l10n/app_localizations.dart';
import 'package:valcue/l10n/localized_format.dart';
import '../models/routine_template.dart';
import '../models/routine.dart';
import '../models/interval.dart';
import '../models/machine_type.dart';
import '../models/difficulty.dart';
import '../storage/routine_provider.dart';
import '../../../app_settings/app_settings_provider.dart';
import '../../../app_shell/app_shell.dart';
import '../../../widgets/bidi_safe_text.dart';
import '../../../theme/app_theme.dart';
import '../../membership/widgets/premium_bottom_sheet.dart';
import '../../../services/analytics_service.dart';
import '../../../widgets/app_bottom_sheet.dart';
import '../../../widgets/bottom_sheet_action_bar.dart';

enum _RoutinePreviewResult {
  saved,
  upgrade,
}

class RoutinePreviewSheet {
  static void _showSnack(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    // Intentionally disabled per request.
  }

  static void show(
    BuildContext context,
    RoutineTemplate template,
    AppSettingsProvider settingsProvider, {
    bool closeParentOnSave = true,
  }) {
    final theme = Theme.of(context);
    showModalBottomSheet<_RoutinePreviewResult>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: theme.colorScheme.shadow.withValues(alpha: 0.4),
      isDismissible: true,
      builder: (sheetContext) => _RoutinePreviewSheetContent(
        template: template,
        settingsProvider: settingsProvider,
      ),
    ).then((result) {
      if (!context.mounted || result == null) {
        return;
      }

      if (result == _RoutinePreviewResult.saved) {
        final l10n = AppLocalizations.of(context)!;
        _showSnack(context, l10n.routineSaved);
      }

      if (closeParentOnSave && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      if (result == _RoutinePreviewResult.upgrade) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!context.mounted) return;
          AppShell.navigateToPremiumTab();
        });
      }
    });
  }
}

class _ToastOverlay extends StatefulWidget {
  final String message;
  final Duration duration;
  final VoidCallback onDismissed;

  const _ToastOverlay({
    required this.message,
    required this.duration,
    required this.onDismissed,
  });

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay> {
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });

    _timer = Timer(widget.duration, () {
      if (!mounted) {
        return;
      }
      setState(() {
        _visible = false;
      });
      const fadeOut = Duration(milliseconds: 200);
      Timer(fadeOut, () {
        if (mounted) {
          widget.onDismissed();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final snackTheme = theme.snackBarTheme;
    final media = MediaQuery.of(context);
    final behavior = snackTheme.behavior ?? SnackBarBehavior.fixed;
    final isFloating = behavior == SnackBarBehavior.floating;
    final margin = snackTheme.insetPadding ??
        const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 10.0);
    final padding = EdgeInsets.symmetric(
      horizontal: isFloating ? 16.0 : 24.0,
      vertical: 14.0,
    );
    final width = snackTheme.width;
    final elevation = snackTheme.elevation ?? 6.0;
    final backgroundColor =
        snackTheme.backgroundColor ?? theme.colorScheme.inverseSurface;
    final textStyle = snackTheme.contentTextStyle ??
        theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onInverseSurface,
        );
    final shape = snackTheme.shape ??
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        );

    final bottomOffset = media.padding.bottom +
        media.viewInsets.bottom +
        (isFloating ? margin.bottom : 0);
    final left = isFloating ? margin.left : 0.0;
    final right = isFloating ? margin.right : 0.0;

    Widget toast = Material(
      color: backgroundColor,
      elevation: elevation,
      shape: shape,
      child: Padding(
        padding: padding,
        child: Text(
          widget.message,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );

    if (isFloating && width != null) {
      toast = Align(
        alignment: Alignment.bottomCenter,
        child: SizedBox(width: width, child: toast),
      );
    }

    return Positioned(
      left: left,
      right: right,
      bottom: bottomOffset,
      child: IgnorePointer(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          opacity: _visible ? 1.0 : 0.0,
          child: AnimatedSlide(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            offset: _visible ? Offset.zero : const Offset(0, 0.05),
            child: toast,
          ),
        ),
      ),
    );
  }
}

class _RoutinePreviewSheetContent extends StatelessWidget {
  final RoutineTemplate template;
  final AppSettingsProvider settingsProvider;

  const _RoutinePreviewSheetContent({
    required this.template,
    required this.settingsProvider,
  });

  String _getLocalizedTitle(AppLocalizations l10n) {
    try {
      switch (template.titleKey) {
        // Treadmill
        case 'template_treadmill_beginner_1_title':
          return l10n.templateTreadmillBeginner1Title;
        case 'template_treadmill_beginner_2_title':
          return l10n.templateTreadmillBeginner2Title;
        case 'template_treadmill_intermediate_1_title':
          return l10n.templateTreadmillIntermediate1Title;
        case 'template_treadmill_intermediate_2_title':
          return l10n.templateTreadmillIntermediate2Title;
        case 'template_treadmill_advanced_1_title':
          return l10n.templateTreadmillAdvanced1Title;
        case 'template_treadmill_advanced_2_title':
          return l10n.templateTreadmillAdvanced2Title;
        // Cycle
        case 'template_cycle_beginner_1_title':
          return l10n.templateCycleBeginner1Title;
        case 'template_cycle_beginner_2_title':
          return l10n.templateCycleBeginner2Title;
        case 'template_cycle_intermediate_1_title':
          return l10n.templateCycleIntermediate1Title;
        case 'template_cycle_intermediate_2_title':
          return l10n.templateCycleIntermediate2Title;
        case 'template_cycle_advanced_1_title':
          return l10n.templateCycleAdvanced1Title;
        case 'template_cycle_advanced_2_title':
          return l10n.templateCycleAdvanced2Title;
        // Stairmaster
        case 'template_stairmaster_beginner_1_title':
          return l10n.templateStairmasterBeginner1Title;
        case 'template_stairmaster_beginner_2_title':
          return l10n.templateStairmasterBeginner2Title;
        case 'template_stairmaster_intermediate_1_title':
          return l10n.templateStairmasterIntermediate1Title;
        case 'template_stairmaster_intermediate_2_title':
          return l10n.templateStairmasterIntermediate2Title;
        case 'template_stairmaster_advanced_1_title':
          return l10n.templateStairmasterAdvanced1Title;
        case 'template_stairmaster_advanced_2_title':
          return l10n.templateStairmasterAdvanced2Title;
        // Legacy support (backward compatibility)
        case 'template_treadmill_beginner_title':
          return l10n.templateTreadmillBeginner1Title;
        case 'template_treadmill_intermediate_title':
          return l10n.templateTreadmillIntermediate1Title;
        case 'template_treadmill_advanced_title':
          return l10n.templateTreadmillAdvanced1Title;
        case 'template_cycle_beginner_title':
          return l10n.templateCycleBeginner1Title;
        case 'template_cycle_intermediate_title':
          return l10n.templateCycleIntermediate1Title;
        case 'template_cycle_advanced_title':
          return l10n.templateCycleAdvanced1Title;
        case 'template_stairmaster_beginner_title':
          return l10n.templateStairmasterBeginner1Title;
        case 'template_stairmaster_intermediate_title':
          return l10n.templateStairmasterIntermediate1Title;
        case 'template_stairmaster_advanced_title':
          return l10n.templateStairmasterAdvanced1Title;
        default:
          return l10n.unnamedRoutine;
      }
    } catch (e) {
      return l10n.unnamedRoutine;
    }
  }

  String _getLocalizedSubtitle(AppLocalizations l10n) {
    try {
      switch (template.subtitleKey) {
        // Treadmill
        case 'template_treadmill_beginner_1_subtitle':
          return l10n.templateTreadmillBeginner1Subtitle;
        case 'template_treadmill_beginner_2_subtitle':
          return l10n.templateTreadmillBeginner2Subtitle;
        case 'template_treadmill_intermediate_1_subtitle':
          return l10n.templateTreadmillIntermediate1Subtitle;
        case 'template_treadmill_intermediate_2_subtitle':
          return l10n.templateTreadmillIntermediate2Subtitle;
        case 'template_treadmill_advanced_1_subtitle':
          return l10n.templateTreadmillAdvanced1Subtitle;
        case 'template_treadmill_advanced_2_subtitle':
          return l10n.templateTreadmillAdvanced2Subtitle;
        // Cycle
        case 'template_cycle_beginner_1_subtitle':
          return l10n.templateCycleBeginner1Subtitle;
        case 'template_cycle_beginner_2_subtitle':
          return l10n.templateCycleBeginner2Subtitle;
        case 'template_cycle_intermediate_1_subtitle':
          return l10n.templateCycleIntermediate1Subtitle;
        case 'template_cycle_intermediate_2_subtitle':
          return l10n.templateCycleIntermediate2Subtitle;
        case 'template_cycle_advanced_1_subtitle':
          return l10n.templateCycleAdvanced1Subtitle;
        case 'template_cycle_advanced_2_subtitle':
          return l10n.templateCycleAdvanced2Subtitle;
        // Stairmaster
        case 'template_stairmaster_beginner_1_subtitle':
          return l10n.templateStairmasterBeginner1Subtitle;
        case 'template_stairmaster_beginner_2_subtitle':
          return l10n.templateStairmasterBeginner2Subtitle;
        case 'template_stairmaster_intermediate_1_subtitle':
          return l10n.templateStairmasterIntermediate1Subtitle;
        case 'template_stairmaster_intermediate_2_subtitle':
          return l10n.templateStairmasterIntermediate2Subtitle;
        case 'template_stairmaster_advanced_1_subtitle':
          return l10n.templateStairmasterAdvanced1Subtitle;
        case 'template_stairmaster_advanced_2_subtitle':
          return l10n.templateStairmasterAdvanced2Subtitle;
        // Legacy support (backward compatibility)
        case 'template_treadmill_beginner_subtitle':
          return l10n.templateTreadmillBeginner1Subtitle;
        case 'template_treadmill_intermediate_subtitle':
          return l10n.templateTreadmillIntermediate1Subtitle;
        case 'template_treadmill_advanced_subtitle':
          return l10n.templateTreadmillAdvanced1Subtitle;
        case 'template_cycle_beginner_subtitle':
          return l10n.templateCycleBeginner1Subtitle;
        case 'template_cycle_intermediate_subtitle':
          return l10n.templateCycleIntermediate1Subtitle;
        case 'template_cycle_advanced_subtitle':
          return l10n.templateCycleAdvanced1Subtitle;
        case 'template_stairmaster_beginner_subtitle':
          return l10n.templateStairmasterBeginner1Subtitle;
        case 'template_stairmaster_intermediate_subtitle':
          return l10n.templateStairmasterIntermediate1Subtitle;
        case 'template_stairmaster_advanced_subtitle':
          return l10n.templateStairmasterAdvanced1Subtitle;
        default:
          return '';
      }
    } catch (e) {
      return '';
    }
  }

  String _getDifficultyText(AppLocalizations l10n, Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.beginner:
        return l10n.beginner;
      case Difficulty.intermediate:
        return l10n.intermediate;
      case Difficulty.advanced:
        return l10n.advanced;
    }
  }

  IconData _getMachineIcon(MachineType machineType) {
    switch (machineType) {
      case MachineType.treadmill:
        return Icons.directions_run;
      case MachineType.cycle:
        return Icons.pedal_bike;
      case MachineType.stairmaster:
        return Icons.stairs_rounded;
    }
  }

  bool _isTemplateSaved(RoutineProvider provider) {
    return provider.routines.any(
      (r) => r.source == 'recommended' && r.templateId == template.id,
    );
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
      onPrimary: () {
        // Close premium sheet first
        Navigator.pop(context);
        // Close preview sheet on next frame to avoid double-pop glitches
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (context.mounted) {
            Navigator.pop(context, _RoutinePreviewResult.upgrade);
          }
        });
      },
    );
  }

  Future<void> _saveTemplate(BuildContext context) async {
    final provider = Provider.of<RoutineProvider>(context, listen: false);
    final l10n = AppLocalizations.of(context)!;

    // Check if already saved
    if (_isTemplateSaved(provider)) {
      if (context.mounted) {
        RoutinePreviewSheet._showSnack(
          context,
          l10n.routineAlreadySaved,
          duration: const Duration(seconds: 1),
        );
        Navigator.pop(context);
      }
      return;
    }

    // Check free limit when saving treadmill routine
    if (template.machineType == MachineType.treadmill &&
        !settingsProvider.isPremium &&
        provider.routines
                .where((r) => r.machineType == MachineType.treadmill)
                .length >=
            2) {
      _showFreeLimitSheet(context);
      return;
    }

    // Create routine from template
    // IMPORTANT: Generate stable, unique IDs for each interval
    // Use routine ID + index to ensure uniqueness and stability
    final routineId = DateTime.now().millisecondsSinceEpoch.toString();
    final intervals = template.intervals.asMap().entries.map((entry) {
      final index = entry.key;
      final i = entry.value;
      // Generate stable ID: routineId_index (e.g., "1234567890_0", "1234567890_1")
      final stableId = '${routineId}_$index';

      if (template.machineType == MachineType.treadmill) {
        return Interval.treadmill(
          id: stableId, // Use stable ID based on routine ID and index
          durationSeconds: i.durationSeconds,
          speedKmh: i.speedKmh!,
          grade: i.grade!,
        );
      } else if (template.machineType == MachineType.cycle) {
        return Interval.cycle(
          id: stableId, // Use stable ID based on routine ID and index
          durationSeconds: i.durationSeconds,
          rpm: i.rpm!,
          resistance: i.resistance!,
        );
      } else {
        return Interval.stairmaster(
          id: stableId, // Use stable ID based on routine ID and index
          durationSeconds: i.durationSeconds,
          level: i.level!,
        );
      }
    }).toList();

    final title = _getLocalizedTitle(l10n);

    final routine = Routine(
      id: routineId, // Use the same ID that was used for interval IDs
      name: title,
      difficulty: template.difficulty.toJson(),
      intervals: intervals,
      machineType: template.machineType,
      source: 'recommended',
      templateId: template.id,
    );

    // Save routine
    await provider.addRoutine(routine);
    AnalyticsService.instance.logEvent(
      'routine_added',
      {
        'source': 'recommended',
        'machine_type': routine.machineType.name,
        'interval_count': routine.intervals.length,
      },
    );

    if (context.mounted) {
      // Close the bottom sheet and return result to parent
      Navigator.pop(context, _RoutinePreviewResult.saved);
    }
  }

  Widget _buildIntervalRow(
    BuildContext context,
    Interval interval,
    MachineType machineType,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    final layeredSurfaceColor =
        isDark ? appColors.surfaceElevated : const Color(0xFFF2F2F7);
    final chipSurfaceColor = isDark ? const Color(0xFF3C3C3C) : Colors.white;
    String? pill1Text;
    String? pill2Text;

    switch (machineType) {
      case MachineType.treadmill:
        if (interval.speedKmh != null && interval.grade != null) {
          pill1Text = settingsProvider.formatSpeed(interval.speedKmh!);
          pill2Text = l10n.inclineValue(
            LocalizedFormat.decimal(context, interval.grade!),
          );
        }
        break;
      case MachineType.cycle:
        if (interval.rpm != null && interval.resistance != null) {
          pill1Text = l10n.rpmValue(
            LocalizedFormat.decimal(
              context,
              interval.rpm!,
              decimalDigits: 0,
            ),
          );
          pill2Text = l10n.resistanceColon(
            LocalizedFormat.decimal(
              context,
              interval.resistance!,
              decimalDigits: 0,
            ),
          );
        }
        break;
      case MachineType.stairmaster:
        if (interval.level != null) {
          pill1Text = l10n.levelColon(
            LocalizedFormat.decimal(
              context,
              interval.level!,
              decimalDigits: 0,
            ),
          );
          pill2Text = null;
        }
        break;
    }

    return Padding(
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
        child: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: chipSurfaceColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: BidiSafeText(
                    interval.durationFormatted,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                    forceLTR: true,
                  ),
                ),
                if (pill1Text != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: chipSurfaceColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: BidiSafeText(
                      pill1Text,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      forceLTR: true,
                    ),
                  ),
                ],
                if (pill2Text != null) ...[
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: chipSurfaceColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: BidiSafeText(
                      pill2Text,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface,
                      ),
                      forceLTR: true,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final maxHeight = mediaQuery.size.height * 0.9;
    final l10n = AppLocalizations.of(context)!;
    final provider = Provider.of<RoutineProvider>(context);
    final isSaved = _isTemplateSaved(provider);
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return AppBottomSheetFrame(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Content (scrollable)
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getMachineIcon(template.machineType),
                          size: 16,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            _getDifficultyText(l10n, template.difficulty),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.primary,
                              letterSpacing: -0.1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Title
                  Text(
                    _getLocalizedTitle(l10n),
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -0.7,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Subtitle
                  if (_getLocalizedSubtitle(l10n).isNotEmpty)
                    Text(
                      _getLocalizedSubtitle(l10n),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: appColors.mutedText,
                        letterSpacing: -0.2,
                      ),
                    ),
                  if (_getLocalizedSubtitle(l10n).isNotEmpty)
                    const SizedBox(height: 16),
                  // Total duration (always LTR for timers)
                  BidiSafeText(
                    template.totalDurationFormatted,
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface,
                      letterSpacing: -1.2,
                    ),
                    forceLTR: true, // Timers must always be LTR
                  ),
                  const SizedBox(height: 24),
                  // Interval rows
                  ...template.intervals.map((interval) {
                    return _buildIntervalRow(
                      context,
                      interval,
                      template.machineType,
                    );
                  }),
                  // Bottom padding for save button
                  SizedBox(height: MediaQuery.of(context).padding.bottom),
                ],
              ),
            ),
          ),
          BottomSheetPrimaryActionBar(
            label: isSaved ? l10n.saved : l10n.saveRoutine,
            onPressed: isSaved ? null : () => _saveTemplate(context),
          ),
        ],
      ),
    );
  }
}
