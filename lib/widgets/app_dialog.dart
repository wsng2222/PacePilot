import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

enum AppDialogActionStyle { primary, secondary, destructive }

class AppDialogAction {
  final String label;
  final VoidCallback onPressed;
  final AppDialogActionStyle style;

  const AppDialogAction({
    required this.label,
    required this.onPressed,
    this.style = AppDialogActionStyle.primary,
  });
}

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.42),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (context, _, __) => SafeArea(
      child: Center(child: builder(context)),
    ),
    transitionBuilder: (context, animation, _, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.96, end: 1).animate(curved),
          child: child,
        ),
      );
    },
  );
}

class AppDialog extends StatelessWidget {
  final String title;
  final String? message;
  final IconData? icon;
  final Color? iconColor;
  final Widget? content;
  final List<AppDialogAction> actions;
  final bool showCloseButton;

  const AppDialog({
    super.key,
    required this.title,
    this.message,
    this.icon,
    this.iconColor,
    this.content,
    this.actions = const [],
    this.showCloseButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final accent = iconColor ?? theme.colorScheme.primary;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final safePadding = MediaQuery.paddingOf(context);
    final maxHeight = screenHeight - safePadding.top - safePadding.bottom - 48;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(maxWidth: 360, maxHeight: maxHeight),
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: appColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: theme.brightness == Brightness.dark ? 0.38 : 0.16,
              ),
              blurRadius: 32,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: accent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, size: 21, color: accent),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.35,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
                if (showCloseButton) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    visualDensity: VisualDensity.compact,
                    tooltip:
                        MaterialLocalizations.of(context).closeButtonTooltip,
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: appColors.mutedText,
                    ),
                  ),
                ],
              ],
            ),
            if (message != null || content != null) ...[
              const SizedBox(height: 18),
              Flexible(
                fit: FlexFit.loose,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (message != null)
                        Text(
                          message!,
                          style: TextStyle(
                            fontSize: 15,
                            height: 1.5,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.72),
                          ),
                        ),
                      if (message != null && content != null)
                        const SizedBox(height: 18),
                      if (content != null) content!,
                    ],
                  ),
                ),
              ),
            ],
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 22),
              _AppDialogActions(actions: actions),
            ],
          ],
        ),
      ),
    );
  }
}

class _AppDialogActions extends StatelessWidget {
  final List<AppDialogAction> actions;

  const _AppDialogActions({required this.actions});

  @override
  Widget build(BuildContext context) {
    if (actions.length == 1) {
      return SizedBox(
        height: 50,
        child: _AppDialogButton(action: actions.first),
      );
    }

    return Row(
      children: [
        for (var index = 0; index < actions.length; index++) ...[
          if (index > 0) const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 50,
              child: _AppDialogButton(action: actions[index]),
            ),
          ),
        ],
      ],
    );
  }
}

class _AppDialogButton extends StatelessWidget {
  final AppDialogAction action;

  const _AppDialogButton({required this.action});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appColors = context.appColors;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
    );
    final child = Text(
      action.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
    );

    switch (action.style) {
      case AppDialogActionStyle.secondary:
        return OutlinedButton(
          onPressed: action.onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: theme.colorScheme.onSurface,
            side: BorderSide(color: appColors.border),
            shape: shape,
          ),
          child: child,
        );
      case AppDialogActionStyle.destructive:
        return ElevatedButton(
          onPressed: action.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            elevation: 0,
            shape: shape,
          ),
          child: child,
        );
      case AppDialogActionStyle.primary:
        return ElevatedButton(
          onPressed: action.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            elevation: 0,
            shape: shape,
          ),
          child: child,
        );
    }
  }
}
