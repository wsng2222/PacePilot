import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/onboarding_emphasis_text.dart';
import '../widgets/onboarding_theme.dart';
import '../widgets/onboarding_treadmill_icon.dart';
import '../onboarding_strings.dart';

class OnboardingScreen1Welcome extends StatefulWidget {
  const OnboardingScreen1Welcome({
    super.key,
  });

  @override
  State<OnboardingScreen1Welcome> createState() =>
      _OnboardingScreen1WelcomeState();
}

class _OnboardingScreen1WelcomeState extends State<OnboardingScreen1Welcome>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: Container(
                    width: 148,
                    height: 148,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? OnboardingTheme.darkSelectedPink
                          : OnboardingTheme.selectedPink,
                    ),
                    child: const Center(
                      child: OnboardingTreadmillIcon(size: 88),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                OnboardingRichTitle(
                  spans: [EmphasisTextSpan(s.s1Title())],
                ),
                const SizedBox(height: 10),
                Text(
                  s.s1Subtitle(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    height: 1.45,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 44),
                const _IntervalBars(),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A small decorative bar chart hinting at alternating fast/slow intervals -
/// reinforces the "interval" identity from screen 1 without needing an asset.
class _IntervalBars extends StatelessWidget {
  const _IntervalBars();

  // Relative heights alternating low (walk) / high (run).
  static const _heights = [0.35, 0.85, 0.35, 1.0, 0.35, 0.7];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    const maxBarHeight = 56.0;

    return SizedBox(
      height: maxBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < _heights.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Container(
              width: 12,
              height: maxBarHeight * _heights[i],
              decoration: BoxDecoration(
                color: i.isOdd
                    ? OnboardingTheme.primaryRed
                    : (isDark
                        ? OnboardingTheme.darkGrayFill
                        : OnboardingTheme.lightGrayFill),
                borderRadius: BorderRadius.circular(6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
