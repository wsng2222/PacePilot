import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart'
    show CupertinoColors, CupertinoDynamicColor;
import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

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

    if (labels.isEmpty) return SizedBox(height: height);

    final safeIndex = selectedIndex.clamp(0, labels.length - 1);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final trackColor = CupertinoDynamicColor.resolve(
        CupertinoColors.tertiarySystemFill, context);
    final thumbColor = color ?? appSegmentedSelectedBackground(context);
    final selectedTextColor = isDark ? Colors.white : Colors.black87;
    final unselectedTextColor = context.appColors.mutedText;
    const trackPadding = 3.0;

    final segments = [
      for (var index = 0; index < labels.length; index++)
        _PillSegment(
          label: labels[index],
          selected: index == safeIndex,
          selectedColor: thumbColor,
          selectedTextColor: selectedTextColor,
          unselectedTextColor: unselectedTextColor,
          height: height - trackPadding * 2,
          expand: !shrinkWrap,
          onTap: () => onValueChanged(index),
        ),
    ];

    final row = shrinkWrap
        ? Row(mainAxisSize: MainAxisSize.min, children: segments)
        : Row(children: segments);

    final control = Container(
      height: height,
      padding: const EdgeInsets.all(trackPadding),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: shrinkWrap ? IntrinsicWidth(child: row) : row,
    );

    return shrinkWrap
        ? control
        : SizedBox(width: double.infinity, child: control);
  }
}

class _PillSegment extends StatelessWidget {
  const _PillSegment({
    required this.label,
    required this.selected,
    required this.selectedColor,
    required this.selectedTextColor,
    required this.unselectedTextColor,
    required this.height,
    required this.expand,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final Color selectedColor;
  final Color selectedTextColor;
  final Color unselectedTextColor;
  final double height;
  final bool expand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final content = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(height / 2),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? selectedTextColor : unselectedTextColor,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            softWrap: false,
          ),
        ),
      ),
    );

    return expand ? Expanded(child: content) : content;
  }
}
