import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'bounceable.dart';

/// Secondary outlined button with no shadow, only border
/// Uses Bounceable wrapper for premium tactile press feedback
class SecondaryOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? borderColor;

  const SecondaryOutlinedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.padding,
    this.borderRadius = AppTheme.buttonRadius,
    this.backgroundColor,
    this.foregroundColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Premium modern color palette
    final bgColor = backgroundColor ??
        (isDark
            ? const Color(0xFF1C1C1E)
                .withValues(alpha: 0.4) // Subtle translucent dark blend
            : Colors.white);
    final fgColor = foregroundColor ?? theme.colorScheme.onSurface;
    final border = borderColor ??
        (isDark
            ? Colors.white
                .withValues(alpha: 0.08) // Soft translucent border in dark mode
            : const Color(0xFFE5E5EA)); // Minimal light border

    return Bounceable(
      onTap: onPressed,
      child: Container(
        width: width,
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: border,
            width: 1.0,
          ),
        ),
        child: Center(
          child: DefaultTextStyle(
            style: TextStyle(
              color: fgColor,
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Secondary outlined icon button with no shadow, only border
/// Uses Bounceable wrapper for premium tactile press feedback
class SecondaryOutlinedIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final Color? borderColor;

  const SecondaryOutlinedIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.size = 44.0,
    this.backgroundColor,
    this.iconColor,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Default colors
    final bgColor = backgroundColor ??
        (isDark
            ? const Color(0xFF1C1C1E).withValues(alpha: 0.4)
            : Colors.grey.shade50);
    final iconClr = iconColor ?? theme.colorScheme.onSurface;
    final border = borderColor ??
        (isDark
            ? Colors.white.withValues(alpha: 0.08)
            : const Color(0xFFE5E5EA));

    return Opacity(
      opacity: onPressed == null ? 0.5 : 1.0,
      child: Bounceable(
        onTap: onPressed,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: bgColor,
            border: Border.all(
              color: border,
              width: 1.0,
            ),
          ),
          child: Center(
            child: IconTheme(
              data: IconThemeData(color: iconClr),
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
