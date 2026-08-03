import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';

Color appSegmentedSelectedBackground(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF2C2C2E)
      : Colors.white;
}

SegmentedButtonThemeData appSegmentedThemeData(
  BuildContext context,
  Color selectedBackground, {
  TextStyle? textStyle,
  EdgeInsetsGeometry? padding,
}) {
  final theme = Theme.of(context);
  final isDark = theme.brightness == Brightness.dark;

  return SegmentedButtonThemeData(
    style: SegmentedButton.styleFrom(
      selectedBackgroundColor: selectedBackground,
      selectedForegroundColor: isDark ? Colors.white : Colors.black87,
      foregroundColor: theme.colorScheme.onSurface,
      backgroundColor: theme.colorScheme.surface,
      side: BorderSide(
        color: theme.colorScheme.outline.withValues(alpha: 0.35),
      ),
      textStyle: textStyle,
      padding: padding,
    ),
  );
}

class AppSegmentedControl extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onValueChanged;
  final double height;
  final bool shrinkWrap;
  final Color? color;

  const AppSegmentedControl({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onValueChanged,
    required this.height,
    this.shrinkWrap = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (PlatformInfo.isIOS) {
      return AdaptiveSegmentedControl(
        labels: labels,
        selectedIndex: selectedIndex,
        onValueChanged: onValueChanged,
        height: height,
        shrinkWrap: shrinkWrap,
        color: color,
      );
    }

    final safeIndex =
        labels.isEmpty ? 0 : selectedIndex.clamp(0, labels.length - 1);
    return SizedBox(
      width: shrinkWrap ? null : double.infinity,
      height: height,
      child: SegmentedButton<int>(
        segments: [
          for (var index = 0; index < labels.length; index++)
            ButtonSegment<int>(
              value: index,
              label: Text(
                labels[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
              ),
            ),
        ],
        selected: labels.isEmpty ? const <int>{} : {safeIndex},
        showSelectedIcon: false,
        onSelectionChanged: (selection) {
          if (selection.isNotEmpty) onValueChanged(selection.first);
        },
      ),
    );
  }
}
