import 'dart:async';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:valcue/l10n/app_localizations.dart';
import 'package:valcue/l10n/localized_format.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import '../../../app_settings/app_settings_provider.dart';
import '../../../app_settings/app_settings_model.dart';
import '../../membership/widgets/premium_gate_modal.dart';
import '../../membership/models/premium_feature.dart';
import '../../../theme/app_theme.dart';
import '../../../screenshot/store_screenshot_capture_screen.dart';
import '../../../utils/app_shadows.dart';
import '../../../widgets/workout_reminder_time_picker_sheet.dart';
import '../../../services/analytics_service.dart';
import '../../../widgets/app_segmented_control.dart';
import '../../../widgets/app_bottom_sheet.dart';
import '../../../widgets/platform_icon.dart';
import '../../../widgets/app_message.dart';
import '../../../widgets/bottom_sheet_action_bar.dart';
import '../../../l10n/supported_app_language.dart';
import '../../../services/consent_service.dart';
import 'workout_display_size_preview_screen.dart';

Color _segmentedSelectedBackground(BuildContext context) {
  return appSegmentedSelectedBackground(context);
}

Color _segmentedTrackBackground(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  return isDark ? const Color(0xFF1C1C1E) : const Color(0xFFF2F2F7);
}

List<BoxShadow>? _settingsCardShadow(BuildContext context) {
  return AppShadows.elevatedSoft;
}

List<BoxShadow>? _segmentedThumbShadow(
  BuildContext context, {
  required double alpha,
  required double blurRadius,
  required Offset offset,
}) {
  return [
    BoxShadow(
      color: Theme.of(context).colorScheme.shadow.withValues(alpha: alpha),
      blurRadius: blurRadius,
      offset: offset,
    ),
  ];
}

SegmentedButtonThemeData _segmentedThemeData(
  BuildContext context,
  Color selectedBackground,
) {
  return appSegmentedThemeData(context, selectedBackground);
}

Widget _buildPlatformSegmentedControl({
  required Key key,
  required List<String> labels,
  required int selectedIndex,
  required ValueChanged<int> onValueChanged,
  required double height,
  Color? color,
  bool shrinkWrap = false,
}) {
  return AppSegmentedControl(
    key: key,
    labels: labels,
    selectedIndex: selectedIndex,
    onValueChanged: onValueChanged,
    height: height,
    color: color,
    shrinkWrap: shrinkWrap,
  );
}

Widget _buildPlatformSwitch({
  required BuildContext context,
  required bool value,
  required ValueChanged<bool> onChanged,
}) {
  return CupertinoSwitch(
    value: value,
    onChanged: onChanged,
    activeTrackColor: Theme.of(context).colorScheme.primary,
  );
}

/// iOS-like grouped settings section container
class SettingsSection extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;

  const SettingsSection({
    super.key,
    required this.children,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface : appColors.surfaceElevated,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color:
              isDark ? Colors.white.withValues(alpha: 0.08) : appColors.border,
        ),
        boxShadow: _settingsCardShadow(context),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

/// Individual settings row with icon, title, subtitle, and trailing widget
class SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;

  const SettingsRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    final content = Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Icon with circle background
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              size: 20,
              color: iconColor,
            ),
          ),
          const SizedBox(width: 16),
          // Title and subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (subtitle != null && subtitle!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 13,
                      color: appColors.mutedText,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Trailing widget
          if (trailing != null) trailing!,
        ],
      ),
    );

    return Column(
      children: [
        onTap != null
            ? InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(24),
                child: content,
              )
            : content,
        if (showDivider)
          Divider(
            height: 1,
            thickness: 1,
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.25),
            indent: 72,
          ),
      ],
    );
  }
}

/// Unit Setting row with title and embedded segmented control
class UnitSegmentRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String value;
  final Function(String) onChanged;
  final List<String>? options; // Custom options (e.g., ['kg', 'lbs'])
  final List<String>? labels; // Custom labels for display

  const UnitSegmentRow({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.onChanged,
    this.options,
    this.labels,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Title row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Segmented control
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(72, 0, 16, 12),
          child: _buildSegmentedControl(
            context: context,
            value: value,
            onChanged: onChanged,
            options: options,
            labels: labels,
          ),
        ),
      ],
    );
  }

  Widget _buildSegmentedControl({
    required BuildContext context,
    required String value,
    required Function(String) onChanged,
    List<String>? options,
    List<String>? labels,
  }) {
    return UnitSegmentRow._buildSegmentedControlStatic(
      context: context,
      value: value,
      onChanged: onChanged,
      options: options,
      labels: labels,
    );
  }

  static Widget _buildSegmentedControlStatic({
    required BuildContext context,
    required String value,
    required Function(String) onChanged,
    List<String>? options,
    List<String>? labels,
  }) {
    final segmentOptions = options ?? ['kmh', 'mph'];
    final segmentLabels = labels ??
        [
          AppLocalizations.of(context)!.kmh,
          AppLocalizations.of(context)!.mph,
        ];

    final resolvedLabels = segmentLabels.length == segmentOptions.length
        ? segmentLabels
        : segmentOptions;
    final selectedIndex = segmentOptions.indexOf(value);
    final safeIndex = selectedIndex >= 0 ? selectedIndex : 0;
    final selectedBg = _segmentedSelectedBackground(context);
    final brightnessKey = Theme.of(context).brightness;
    if (PlatformInfo.isIOS) {
      return SegmentedButtonTheme(
        data: _segmentedThemeData(context, selectedBg),
        child: SizedBox(
          width: double.infinity,
          child: _buildPlatformSegmentedControl(
            key: ValueKey(
              'unit_segment_${brightnessKey.name}_${resolvedLabels.join('|')}',
            ),
            labels: resolvedLabels,
            selectedIndex: safeIndex,
            onValueChanged: (index) {
              if (index < 0 || index >= segmentOptions.length) return;
              onChanged(segmentOptions[index]);
            },
            height: 36,
            color: selectedBg,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final segmentWidth = constraints.maxWidth / segmentOptions.length;
        final textDirection = Directionality.of(context);
        final theme = Theme.of(context);
        final appColors = context.appColors;
        final trackBackground = _segmentedTrackBackground(context);

        final thumbLeft = textDirection == TextDirection.ltr
            ? (safeIndex * segmentWidth)
            : ((segmentOptions.length - 1 - safeIndex) * segmentWidth);
        final thumbRight = textDirection == TextDirection.rtl
            ? (safeIndex * segmentWidth)
            : null;

        return Container(
          height: 36,
          decoration: BoxDecoration(
            color: trackBackground,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                left: textDirection == TextDirection.ltr ? thumbLeft : null,
                right: thumbRight,
                top: 0,
                bottom: 0,
                width: segmentWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: _segmentedSelectedBackground(context),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: _segmentedThumbShadow(
                      context,
                      alpha: 0.1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ),
                ),
              ),
              Row(
                textDirection: textDirection,
                children: segmentOptions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final option = entry.value;
                  final label = index < segmentLabels.length
                      ? segmentLabels[index]
                      : option;
                  final isSelected = safeIndex == index;

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged(option),
                      child: SizedBox(
                        width: double.infinity,
                        height: 36,
                        child: Center(
                          child: Text(
                            label,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? theme.colorScheme.onSurface
                                  : appColors.mutedText,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Premium Theme Mode row with title and embedded segmented control (2 segments: light/dark)
class ThemeSegmentRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final String value;
  final Function(String) onChanged;

  const ThemeSegmentRow({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        // Title row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  icon,
                  size: 20,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        PlatformInfo.isIOS
            ? Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(72, 0, 16, 12),
                child: _buildSegmentedControl(
                  context: context,
                  value: value,
                  onChanged: onChanged,
                ),
              )
            : Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(72, 0, 16, 12),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: _segmentedTrackBackground(context),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: theme.brightness == Brightness.light
                          ? theme.colorScheme.outlineVariant
                              .withValues(alpha: 0.35)
                          : Colors.white.withValues(alpha: 0.1),
                      width: 1,
                    ),
                    boxShadow: _segmentedThumbShadow(
                      context,
                      alpha: 0.05,
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ),
                  child: _buildSegmentedControl(
                    context: context,
                    value: value,
                    onChanged: onChanged,
                  ),
                ),
              ),
      ],
    );
  }

  Widget _buildSegmentedControl({
    required BuildContext context,
    required String value,
    required Function(String) onChanged,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final displayValue = value == 'system' ? 'light' : value;
    final selectedBg = _segmentedSelectedBackground(context);
    final brightnessKey = Theme.of(context).brightness;
    final localeKey = Localizations.localeOf(context).toLanguageTag();
    if (PlatformInfo.isIOS) {
      return SegmentedButtonTheme(
        data: _segmentedThemeData(context, selectedBg),
        child: SizedBox(
          width: double.infinity,
          child: _buildPlatformSegmentedControl(
            key: ValueKey('theme_segment_${brightnessKey.name}_$localeKey'),
            labels: [l10n.light, l10n.dark],
            selectedIndex: displayValue == 'light' ? 0 : 1,
            onValueChanged: (index) {
              onChanged(index == 0 ? 'light' : 'dark');
            },
            height: 44,
            color: selectedBg,
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final segmentWidth = (constraints.maxWidth - 4) / 2;
        final textDirection = Directionality.of(context);
        final theme = Theme.of(context);
        final appColors = context.appColors;

        final isLightSelected = displayValue == 'light';
        final thumbLeft = textDirection == TextDirection.ltr
            ? (isLightSelected ? 0.0 : segmentWidth + 4)
            : (isLightSelected ? segmentWidth + 4 : 0.0);
        final thumbRight = textDirection == TextDirection.rtl
            ? (isLightSelected ? 0.0 : segmentWidth + 4)
            : null;

        return SizedBox(
          height: 44,
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOutCubic,
                left: textDirection == TextDirection.ltr ? thumbLeft : null,
                right: thumbRight,
                top: 0,
                bottom: 0,
                width: segmentWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: _segmentedSelectedBackground(context),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: _segmentedThumbShadow(
                      context,
                      alpha: 0.15,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ),
                ),
              ),
              Row(
                textDirection: textDirection,
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged('light'),
                      child: Container(
                        width: double.infinity,
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.sun_max_fill,
                              size: 16,
                              color: displayValue == 'light'
                                  ? theme.colorScheme.onSurface
                                  : appColors.mutedText,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                l10n.light,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: displayValue == 'light'
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  color: displayValue == 'light'
                                      ? theme.colorScheme.onSurface
                                      : appColors.mutedText,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => onChanged('dark'),
                      child: Container(
                        width: double.infinity,
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.moon_fill,
                              size: 16,
                              color: displayValue == 'dark'
                                  ? theme.colorScheme.onSurface
                                  : appColors.mutedText,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                l10n.dark,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: displayValue == 'dark'
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  color: displayValue == 'dark'
                                      ? theme.colorScheme.onSurface
                                      : appColors.mutedText,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Timer? _aboutTapResetTimer;
  int _aboutTapCount = 0;
  String _appVersionLabel = '...';
  bool _showAdPrivacyOptions = false;
  static const List<int> _weekdayOrder = <int>[
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
    DateTime.sunday,
  ];

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    _loadAdPrivacyOptionsAvailability();
  }

  Future<void> _loadAdPrivacyOptionsAvailability() async {
    final isRequired = await ConsentService.instance.isPrivacyOptionsRequired();
    if (!mounted) return;
    setState(() {
      _showAdPrivacyOptions = isRequired;
    });
  }

  @override
  void dispose() {
    _aboutTapResetTimer?.cancel();
    _premiumHoldTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadAppVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;

      setState(() {
        _appVersionLabel = info.version;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _appVersionLabel = 'unknown';
      });
    }
  }

  /// Hidden entry point for store screenshots: 30 taps on the "About" row.
  Timer? _premiumHoldTimer;

  void _registerAboutTap() {
    _aboutTapCount++;
    _aboutTapResetTimer?.cancel();

    if (_aboutTapCount >= 30) {
      _aboutTapCount = 0;
      _showStoreScreenshotCapture();
      return;
    }

    // Stop tapping for a moment and the count starts over.
    _aboutTapResetTimer = Timer(const Duration(seconds: 1), () {
      _aboutTapCount = 0;
      _aboutTapResetTimer = null;
    });
  }

  // Hidden dev switch: hold the About row for 5 seconds to flip premium on or
  // off locally, so paid features can be checked without a real purchase. The
  // long-press recognizer fires at 500ms, so the rest of the wait is here.
  static const _premiumHoldDuration = Duration(milliseconds: 4500);

  void _startPremiumHold() {
    _premiumHoldTimer?.cancel();
    _premiumHoldTimer = Timer(_premiumHoldDuration, _togglePremiumOverride);
  }

  void _cancelPremiumHold() {
    _premiumHoldTimer?.cancel();
    _premiumHoldTimer = null;
  }

  Future<void> _togglePremiumOverride() async {
    _premiumHoldTimer = null;
    if (!mounted) return;

    final provider = context.read<AppSettingsProvider>();
    final enable = !provider.isPremium;
    HapticFeedback.heavyImpact();
    await provider.updatePremium(enable);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(
          enable
              ? 'Valcue Premium ON (local test override)'
              : 'Valcue Premium OFF',
        ),
      ),
    );
  }

  void _showStoreScreenshotCapture() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const StoreScreenshotCaptureScreen(),
      ),
    );
  }

  String _weekdayLabel(BuildContext context, int weekday) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final date = DateTime(2024, 1, weekday);
    return intl.DateFormat.E(locale).format(date);
  }

  String _formatReminderTime(BuildContext context, TimeOfDay time) {
    return MaterialLocalizations.of(context).formatTimeOfDay(
      time,
      alwaysUse24HourFormat: false,
    );
  }

  String _weekdaySummary(BuildContext context, List<int> weekdays) {
    if (weekdays.length == 7) {
      return AppLocalizations.of(context)!.workoutReminderEveryDay;
    }
    return weekdays.map((day) => _weekdayLabel(context, day)).join(', ');
  }

  String _reminderSubtitle(BuildContext context, AppSettingsProvider provider) {
    if (!provider.workoutReminderEnabled) {
      return AppLocalizations.of(context)!.workoutReminderOff;
    }

    return '${_weekdaySummary(context, provider.workoutReminderWeekdays)}  '
        '${_formatReminderTime(context, provider.workoutReminderTime)}';
  }

  String _workoutDisplaySizeLabel(
    BuildContext context,
    WorkoutDisplaySize size,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return switch (size) {
      WorkoutDisplaySize.standard => l10n.workoutDisplaySizeStandard,
      WorkoutDisplaySize.large => l10n.workoutDisplaySizeLarge,
      WorkoutDisplaySize.extraLarge => l10n.workoutDisplaySizeExtraLarge,
    };
  }

  Future<void> _pickReminderTime(
    BuildContext context,
    AppSettingsProvider provider,
  ) async {
    final picked = await showWorkoutReminderTimePickerSheet(
      context: context,
      initialTime: provider.workoutReminderTime,
    );
    if (picked == null) return;
    await provider.updateWorkoutReminderTime(picked);
  }

  Widget _buildWeekdayChips(
    BuildContext context,
    AppSettingsProvider provider,
  ) {
    final selectedDays = provider.workoutReminderWeekdays.toSet();
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 56),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: appColors.surfaceElevated,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : appColors.border,
                ),
              ),
              child: Row(
                children: List.generate(_weekdayOrder.length * 2 - 1, (index) {
                  if (index.isOdd) {
                    return const SizedBox(width: 6);
                  }

                  final weekday = _weekdayOrder[index ~/ 2];
                  final isSelected = selectedDays.contains(weekday);
                  final label = _weekdayLabel(context, weekday);

                  return Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        final updated = Set<int>.from(selectedDays);
                        if (isSelected) {
                          if (updated.length == 1) return;
                          updated.remove(weekday);
                        } else {
                          updated.add(weekday);
                        }
                        provider
                            .updateWorkoutReminderWeekdays(updated.toList());
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        curve: Curves.easeOutCubic,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: isSelected
                              ? theme.colorScheme.primary
                              : theme.colorScheme.surface,
                          border: Border.all(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.outlineVariant
                                    .withValues(alpha: 0.55),
                            width: 1.2,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: theme.colorScheme.primary
                                        .withValues(alpha: 0.18),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight:
                                isSelected ? FontWeight.w800 : FontWeight.w600,
                            color: isSelected
                                ? theme.colorScheme.onPrimary
                                : theme.colorScheme.onSurface,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: Consumer<AppSettingsProvider>(
          builder: (context, provider, child) {
            return CustomScrollView(
              slivers: [
                // Top header area
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
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
                            Icons.settings,
                            size: 22,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.settingsTitle,
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
                ),
                // Settings sections
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      // Theme Mode section (with segmented control)
                      SettingsSection(
                        children: [
                          ThemeSegmentRow(
                            icon: Icons.palette,
                            iconColor: Colors.indigo,
                            title: AppLocalizations.of(context)!.themeMode,
                            value: provider.themeMode,
                            onChanged: (value) =>
                                provider.updateThemeMode(value),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Unit Setting section (with segmented control)
                      SettingsSection(
                        children: [
                          UnitSegmentRow(
                            icon: Icons.speed,
                            iconColor: Colors.purple,
                            title: AppLocalizations.of(context)!.unitSetting,
                            value: provider.measurement,
                            onChanged: (value) =>
                                provider.updateMeasurement(value),
                          ),
                          // Weight Unit Setting (options only, same section)
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              72,
                              0,
                              16,
                              16,
                            ),
                            child: UnitSegmentRow._buildSegmentedControlStatic(
                              context: context,
                              value: provider.weightUnit,
                              onChanged: (value) =>
                                  provider.updateWeightUnit(value),
                              options: const ['kg', 'lbs'],
                              labels: const ['kg', 'lbs'],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      SettingsSection(
                        children: [
                          SettingsRow(
                            icon: Icons.text_increase_rounded,
                            iconColor: Colors.teal,
                            title: AppLocalizations.of(context)!
                                .workoutDisplaySizeTitle,
                            subtitle: _workoutDisplaySizeLabel(
                              context,
                              provider.workoutDisplaySize,
                            ),
                            trailing: PlatformIcon(
                              cupertino: CupertinoIcons.chevron_right,
                              material: Icons.chevron_right,
                              size: 20,
                              color: context.appColors.mutedText,
                            ),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const WorkoutDisplaySizePreviewScreen(),
                              ),
                            ),
                            showDivider: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Voice Guide section
                      SettingsSection(
                        children: [
                          SettingsRow(
                            icon: Icons.volume_up,
                            iconColor: Colors.green,
                            title: AppLocalizations.of(context)!.voiceGuide,
                            onTap: provider.isPremium
                                ? null
                                : () {
                                    PremiumGateModal.show(
                                      context,
                                      PremiumFeature.voiceGuide,
                                    );
                                  },
                            trailing: IgnorePointer(
                              ignoring: !provider.isPremium,
                              child: Opacity(
                                opacity: provider.isPremium ? 1.0 : 0.5,
                                child: _buildPlatformSwitch(
                                  context: context,
                                  value: provider.voiceGuideEnabled,
                                  onChanged: (value) {
                                    if (!provider.isPremium) return;
                                    provider.updateVoiceGuide(value);
                                  },
                                ),
                              ),
                            ),
                          ),
                          if (provider.voiceGuideEnabled &&
                              provider.isPremium) ...[
                            Builder(builder: (context) {
                              final l10n = AppLocalizations.of(context)!;
                              return SettingsRow(
                                icon: Icons.timer_outlined,
                                iconColor: Colors.amber,
                                title: l10n.countdownTiming,
                                subtitle:
                                    provider.voiceGuideCountdownTriggers.isEmpty
                                        ? l10n.noAnnouncements
                                        : LocalizedFormat.compactList(
                                            context,
                                            provider.voiceGuideCountdownTriggers
                                                .map(
                                              (seconds) => l10n.secondsShort(
                                                LocalizedFormat.decimal(
                                                  context,
                                                  seconds,
                                                  decimalDigits: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                onTap: () => _showCountdownTriggersPicker(
                                    context, provider),
                              );
                            }),
                          ],
                          SettingsRow(
                            icon: Icons.monitor_heart_outlined,
                            iconColor: Colors.indigoAccent,
                            title: AppLocalizations.of(context)!
                                .backgroundIntervalNotificationsTitle,
                            subtitle: AppLocalizations.of(context)!
                                .backgroundIntervalNotificationsSubtitle,
                            onTap: provider.isPremium
                                ? null
                                : () {
                                    PremiumGateModal.show(
                                      context,
                                      PremiumFeature
                                          .backgroundIntervalNotifications,
                                    );
                                  },
                            trailing: IgnorePointer(
                              ignoring: !provider.isPremium,
                              child: Opacity(
                                opacity: provider.isPremium ? 1.0 : 0.5,
                                child: _buildPlatformSwitch(
                                  context: context,
                                  value: provider
                                      .backgroundIntervalNotificationsEnabled,
                                  onChanged: (enabled) async {
                                    if (!provider.isPremium) return;
                                    final success = await provider
                                        .updateBackgroundIntervalNotifications(
                                      enabled,
                                    );
                                    if (success && enabled) {
                                      AnalyticsService.instance.logEvent(
                                        'notification_enabled',
                                        {'feature': 'background_intervals'},
                                      );
                                    }
                                    if (success || !mounted) return;
                                    showAppMessage(
                                      this.context,
                                      AppLocalizations.of(this.context)!
                                          .workoutReminderPermissionRequired,
                                      type: AppMessageType.error,
                                    );
                                  },
                                ),
                              ),
                            ),
                            showDivider: false,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Sound Effects section
                      SettingsSection(
                        children: [
                          SettingsRow(
                            icon: Icons.music_note,
                            iconColor: Colors.orange,
                            title: AppLocalizations.of(context)!.soundEffects,
                            trailing: _buildPlatformSwitch(
                              context: context,
                              value: provider.soundEffectsEnabled,
                              onChanged: (value) {
                                provider.updateSoundEffects(value);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Workout reminder section
                      SettingsSection(
                        children: [
                          SettingsRow(
                            icon: Icons.notifications_active_outlined,
                            iconColor: Colors.redAccent,
                            title: AppLocalizations.of(context)!
                                .workoutReminderTitle,
                            subtitle: _reminderSubtitle(context, provider),
                            trailing: _buildPlatformSwitch(
                              context: context,
                              value: provider.workoutReminderEnabled,
                              onChanged: (enabled) async {
                                final success =
                                    await provider.updateWorkoutReminderEnabled(
                                  enabled,
                                );
                                if (success && enabled) {
                                  AnalyticsService.instance.logEvent(
                                    'notification_enabled',
                                    {'feature': 'workout_reminder'},
                                  );
                                }
                                if (success) return;
                                if (!mounted) return;
                                showAppMessage(
                                  this.context,
                                  AppLocalizations.of(this.context)!
                                      .workoutReminderPermissionRequired,
                                  type: AppMessageType.error,
                                );
                              },
                            ),
                            showDivider: false,
                          ),
                          if (provider.workoutReminderEnabled)
                            _buildWeekdayChips(context, provider),
                          if (provider.workoutReminderEnabled)
                            SettingsRow(
                              icon: Icons.schedule,
                              iconColor: Colors.teal,
                              title: AppLocalizations.of(context)!
                                  .workoutReminderTimeLabel,
                              subtitle: _formatReminderTime(
                                context,
                                provider.workoutReminderTime,
                              ),
                              trailing: PlatformIcon(
                                cupertino: CupertinoIcons.chevron_right,
                                material: Icons.chevron_right,
                                size: 20,
                                color: context.appColors.mutedText,
                              ),
                              onTap: () => _pickReminderTime(context, provider),
                              showDivider: false,
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      // Language section
                      SettingsSection(
                        children: [
                          SettingsRow(
                            icon: Icons.language,
                            iconColor: Colors.blue,
                            title: AppLocalizations.of(context)!.language,
                            subtitle: provider.settings.language == null
                                ? AppLocalizations.of(context)!.system
                                : _getLanguageDisplayName(
                                    context, provider.language),
                            trailing: PlatformIcon(
                              cupertino: CupertinoIcons.chevron_right,
                              material: Icons.chevron_right,
                              size: 20,
                              color: context.appColors.mutedText,
                            ),
                            onTap: () =>
                                _showLanguageSelector(context, provider),
                          ),
                        ],
                      ),
                      if (_showAdPrivacyOptions) ...[
                        const SizedBox(height: 4),
                        SettingsSection(
                          children: [
                            SettingsRow(
                              icon: Icons.privacy_tip_outlined,
                              iconColor: Colors.indigo,
                              title: AppLocalizations.of(context)!
                                  .adPrivacyOptions,
                              trailing: PlatformIcon(
                                cupertino: CupertinoIcons.chevron_right,
                                material: Icons.chevron_right,
                                size: 20,
                                color: context.appColors.mutedText,
                              ),
                              onTap: () => ConsentService.instance
                                  .showPrivacyOptionsForm(),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 4),
                      // About section
                      GestureDetector(
                        onTap: _registerAboutTap,
                        onLongPressStart: (_) => _startPremiumHold(),
                        onLongPressEnd: (_) => _cancelPremiumHold(),
                        onLongPressCancel: _cancelPremiumHold,
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.dark
                                ? theme.colorScheme.surface
                                : context.appColors.surfaceElevated,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: theme.brightness == Brightness.dark
                                  ? Colors.white.withValues(alpha: 0.08)
                                  : context.appColors.border,
                            ),
                            boxShadow: _settingsCardShadow(context),
                          ),
                          child: SettingsRow(
                            icon: Icons.info_outline,
                            iconColor: Colors.grey,
                            title: AppLocalizations.of(context)!.about,
                            subtitle: AppLocalizations.of(context)!.version(
                              _appVersionLabel,
                            ),
                            showDivider: false,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getLanguageDisplayName(BuildContext context, String languageCode) {
    final language = SupportedAppLanguage.fromCode(languageCode);
    return '${language.flagEmoji} ${language.nativeName}';
  }

  void _showLanguageSelector(
      BuildContext context, AppSettingsProvider provider) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    final languageOptions = SupportedAppLanguage.codesInDisplayOrder;

    // Index 0 = System, 1..N = specific languages
    final isSystem = provider.settings.language == null;
    int selectedIndex =
        isSystem ? 0 : 1 + languageOptions.indexOf(provider.settings.language!);
    if (selectedIndex <= 0 && !isSystem) selectedIndex = 1;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: theme.colorScheme.shadow.withValues(alpha: 0.4),
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return SafeArea(
              top: false,
              bottom: true,
              child: AppBottomSheetFrame(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Fixed header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
                      child: Text(
                        l10n.selectLanguage,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    // Picker
                    SizedBox(
                      height: 200,
                      child: CupertinoPicker(
                        scrollController: FixedExtentScrollController(
                          initialItem: selectedIndex,
                        ),
                        itemExtent: 40,
                        onSelectedItemChanged: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        children: [
                          Center(
                            child: Text(
                              '📱 ${l10n.system}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          ...languageOptions.map((langCode) {
                            final language =
                                SupportedAppLanguage.fromCode(langCode);
                            final displayName =
                                '${language.flagEmoji} ${language.nativeName}';
                            return Center(
                              child: Text(
                                displayName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    BottomSheetPrimaryActionBar(
                      label: l10n.done,
                      onPressed: () {
                        if (selectedIndex == 0) {
                          provider.resetLanguageToSystem();
                        } else {
                          provider.updateLanguage(
                            languageOptions[selectedIndex - 1],
                          );
                        }
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCountdownTriggersPicker(
      BuildContext context, AppSettingsProvider provider) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final availableSeconds = [5, 10, 20, 30];

    showCupertinoModalPopup(
      context: context,
      builder: (context) => StatefulBuilder(builder: (context, setModalState) {
        final currentTriggers = provider.voiceGuideCountdownTriggers;
        return CupertinoActionSheet(
          title: Text(l10n.selectCountdownTimings),
          message: Text(l10n.countdownTimingMessage),
          actions: availableSeconds.map((sec) {
            final isSelected = currentTriggers.contains(sec);
            return CupertinoActionSheetAction(
              onPressed: () {
                final newTriggers = List<int>.from(currentTriggers);
                if (isSelected) {
                  newTriggers.remove(sec);
                } else {
                  newTriggers.add(sec);
                }
                provider.updateVoiceGuideCountdownTriggers(newTriggers);
                setModalState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      l10n.secondsLeft(
                        LocalizedFormat.decimal(
                          context,
                          sec,
                          decimalDigits: 0,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : (theme.brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black87),
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    PlatformIcon(
                      cupertino: CupertinoIcons.checkmark_alt,
                      material: Icons.check,
                      size: 18,
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.done),
          ),
        );
      }),
    );
  }
}

class SettingsSliderRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final double value;
  final double min;
  final double max;
  final String displayValue;
  final ValueChanged<double> onChanged;
  final bool showDivider;

  const SettingsSliderRow({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.displayValue,
    required this.onChanged,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: -0.3,
                  ),
                ),
              ),
              Flexible(
                child: Text(
                  displayValue,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: appColors.mutedText,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 56, top: 4),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 4.0,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 8.0),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 16.0),
              ),
              child: Slider(
                value: value,
                min: min,
                max: max,
                activeColor: theme.colorScheme.primary,
                inactiveColor: appColors.border,
                onChanged: onChanged,
              ),
            ),
          ),
          if (showDivider)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 56, top: 12),
              child: Divider(
                  height: 0.5, thickness: 0.5, color: theme.dividerColor),
            ),
        ],
      ),
    );
  }
}
