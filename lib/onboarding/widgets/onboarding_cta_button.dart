import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'onboarding_theme.dart';

class OnboardingCtaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const OnboardingCtaButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onPrimary = theme.colorScheme.onPrimary;
    final isEnabled = onPressed != null;

    final btnBg = isEnabled
        ? OnboardingTheme.primaryRed
        : theme.colorScheme.onSurface.withValues(alpha: 0.12);
    final btnFg = isEnabled
        ? onPrimary
        : theme.colorScheme.onSurface.withValues(alpha: 0.38);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          OnboardingTheme.horizontalPadding,
          12,
          OnboardingTheme.horizontalPadding,
          16, // Increased from 14 for better safe-area padding on Android
        ),
        child: SizedBox(
          width: double.infinity,
          height: OnboardingTheme.ctaHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              boxShadow: isEnabled ? [OnboardingTheme.subtleShadow] : null,
            ),
            child: ElevatedButton(
              onPressed: isEnabled
                  ? () {
                      HapticFeedback.lightImpact();
                      onPressed?.call();
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: btnBg,
                disabledBackgroundColor: btnBg,
                foregroundColor: btnFg,
                disabledForegroundColor: btnFg,
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ).copyWith(
                overlayColor: WidgetStatePropertyAll(
                  btnFg.withValues(alpha: 0.12),
                ),
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.2,
                      color: btnFg,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
