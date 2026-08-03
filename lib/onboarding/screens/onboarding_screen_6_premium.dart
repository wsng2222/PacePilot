import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_theme.dart';
import '../onboarding_strings.dart';
import '../widgets/onboarding_emphasis_text.dart';
import '../widgets/onboarding_theme.dart';

class OnboardingScreen6Premium extends StatelessWidget {
  final VoidCallback onSelectPremium;
  final VoidCallback onSelectFree;

  const OnboardingScreen6Premium({
    super.key,
    required this.onSelectPremium,
    required this.onSelectFree,
  });

  @override
  Widget build(BuildContext context) {
    final s = OnboardingStrings.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                const SizedBox(height: 60),
                OnboardingRichTitle(spans: s.premiumTitleSpans()),
                const SizedBox(height: 34),

                // Benefits Container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF2C2C2E) : Colors.white,
                    borderRadius:
                        BorderRadius.circular(OnboardingTheme.radiusLarge),
                    border: Border.all(
                      color: isDark
                          ? const Color(0xFF3C3C3C)
                          : const Color(0xFFE5E5EA),
                      width: 0.8,
                    ),
                    boxShadow: [OnboardingTheme.mediumShadow],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '👑',
                          style: TextStyle(fontSize: 32),
                        ),
                      ),
                      const SizedBox(height: 20),
                      _BenefitRow(text: s.premiumBullet1()),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: 0.5,
                        color: isDark
                            ? const Color(0xFF3C3C3C)
                            : const Color(0xFFE5E5EA),
                      ),
                      const SizedBox(height: 16),
                      _BenefitRow(text: s.premiumBullet2()),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: 0.5,
                        color: isDark
                            ? const Color(0xFF3C3C3C)
                            : const Color(0xFFE5E5EA),
                      ),
                      const SizedBox(height: 16),
                      _BenefitRow(text: s.premiumBullet3()),
                    ],
                  ),
                ),
                const SizedBox(height: 36),

                // Action Buttons
                SizedBox(
                  width: double.infinity,
                  height: OnboardingTheme.ctaHeight,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.buttonRadius),
                      ),
                      elevation: 0,
                    ),
                    onPressed: onSelectPremium,
                    child: Text(
                      s.ctaStartPremium(),
                      style: GoogleFonts.lato(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onSelectFree,
                  child: Text(
                    s.ctaSkipPremium(),
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
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
}

class _BenefitRow extends StatelessWidget {
  final String text;

  const _BenefitRow({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          child: const Icon(
            Icons.check_circle_rounded,
            color: Colors.amber,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.4,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
