import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding_strings.dart';
import '../widgets/onboarding_emphasis_text.dart';
import '../widgets/onboarding_theme.dart';

class OnboardingScreen2IntervalExplainer extends StatelessWidget {
  final int step; // 0..7 (0 = comparison, 1-7 = interval steps)
  final int? selectedOption;
  final ValueChanged<int>? onOptionSelected;

  const OnboardingScreen2IntervalExplainer({
    super.key,
    required this.step,
    this.selectedOption,
    this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final s = OnboardingStrings.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Prevent layout "jumping" as steps add more text: the content box is
        // always the full page height (so it never resizes between steps), with
        // a floor so short screens scroll instead of squashing.
        final contentHeight =
            constraints.maxHeight < 520.0 ? 520.0 : constraints.maxHeight;

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(
              child: SizedBox(
                height: contentHeight,
                // IMPORTANT: only animate when switching from comparison -> interval,
                // not for each step within the interval page (so the icon stays still).
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeInCubic,
                  transitionBuilder: (child, anim) {
                    final fade = CurvedAnimation(
                      parent: anim,
                      curve: const Interval(0.0, 0.85, curve: Curves.easeOut),
                    );
                    final slide = Tween<Offset>(
                      begin: const Offset(0, 0.06),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
                    );
                    return FadeTransition(
                      opacity: fade,
                      child: SlideTransition(position: slide, child: child),
                    );
                  },
                  child: step == 0
                      ? _ComparisonStep(
                          strings: s,
                          key: const ValueKey('cmp'),
                          selectedOption: selectedOption,
                          onOptionSelected: onOptionSelected,
                        )
                      : _IntervalsStep(
                          // Keep key stable so AnimatedSwitcher does NOT animate
                          // when step changes (icon stays fixed).
                          key: const ValueKey('intervals'),
                          strings: s,
                          step: step,
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ComparisonStep extends StatefulWidget {
  final OnboardingStrings strings;
  final int? selectedOption;
  final ValueChanged<int>? onOptionSelected;

  const _ComparisonStep({
    super.key,
    required this.strings,
    this.selectedOption,
    this.onOptionSelected,
  });

  @override
  State<_ComparisonStep> createState() => _ComparisonStepState();
}

class _ComparisonStepState extends State<_ComparisonStep> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedOption = widget.selectedOption;

    return Column(
      children: [
        // Leftover height is split above/below the block (slightly more below,
        // which reads as optically centred) instead of stretching the cards.
        const Spacer(flex: 3),
        Text(
          widget.strings.ex2Question(),
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.8,
            color: theme.colorScheme.onSurface,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 28),
        // Cards size to their own content and match the taller one, so the gap
        // above the divider stays constant instead of stretching to fill a
        // fixed height (which left a hole on one-line languages).
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: _CompareChoiceCard(
                  titleSpans: widget.strings.ex2WalkTitleSpans(),
                  intensity: 2,
                  isRun: false,
                  isDark: isDark,
                  isSelected: selectedOption == 0,
                  onTap: () => widget.onOptionSelected?.call(0),
                  intensityLabel: widget.strings.ex2IntensityLabel(),
                ),
              ),
              SizedBox(
                width: 42,
                child: Center(
                  child: Text(
                    'VS',
                    style: GoogleFonts.lato(
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: _CompareChoiceCard(
                  titleSpans: widget.strings.ex2RunTitleSpans(),
                  intensity: 5,
                  isRun: true,
                  isDark: isDark,
                  isSelected: selectedOption == 1,
                  onTap: () => widget.onOptionSelected?.call(1),
                  intensityLabel: widget.strings.ex2IntensityLabel(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 180),
          child: Row(
            key: ValueKey(selectedOption),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (selectedOption != null) ...[
                const Icon(
                  Icons.check_circle_rounded,
                  size: 16,
                  color: OnboardingTheme.primaryRed,
                ),
                const SizedBox(width: 6),
              ],
              Flexible(
                child: Text(
                  selectedOption == null
                      ? widget.strings.ex2ChoosePrompt()
                      : widget.strings.ex2ChoiceSaved(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: selectedOption == null
                        ? theme.colorScheme.onSurface.withValues(alpha: 0.42)
                        : OnboardingTheme.primaryRed,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(flex: 4),
      ],
    );
  }
}

class _CompareChoiceCard extends StatelessWidget {
  final List<EmphasisTextSpan> titleSpans;
  final int intensity;
  final bool isRun;
  final bool isDark;
  final bool isSelected;
  final VoidCallback onTap;
  final String intensityLabel;

  const _CompareChoiceCard({
    required this.titleSpans,
    required this.intensity,
    required this.isRun,
    required this.isDark,
    required this.isSelected,
    required this.onTap,
    required this.intensityLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final neutralBorder =
        isDark ? Colors.white.withValues(alpha: 0.10) : const Color(0xFFE5E5EA);
    final baseSurface = isDark ? OnboardingTheme.darkSurface : Colors.white;
    final duration = titleSpans.first.text.trim();
    final activitySpans = titleSpans.skip(1);

    return Semantics(
      button: true,
      selected: isSelected,
      label: titleSpans.map((span) => span.text).join(),
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(OnboardingTheme.radiusMedium),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutCubic,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color.alphaBlend(
                      OnboardingTheme.primaryRed
                          .withValues(alpha: isDark ? 0.16 : 0.05),
                      baseSurface,
                    )
                  : baseSurface,
              borderRadius: BorderRadius.circular(OnboardingTheme.radiusMedium),
              border: Border.all(
                color: isSelected ? OnboardingTheme.primaryRed : neutralBorder,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: isSelected
                      ? OnboardingTheme.primaryRed
                          .withValues(alpha: isDark ? 0.28 : 0.18)
                      : Colors.black.withValues(alpha: isDark ? 0.16 : 0.055),
                  blurRadius: isSelected ? 20 : 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  duration,
                  maxLines: 1,
                  style: GoogleFonts.lato(
                    fontSize: 31,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1.0,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 13),
                Text.rich(
                  TextSpan(
                    children: activitySpans
                        .map(
                          (span) => TextSpan(
                            text: span.text,
                            style: GoogleFonts.lato(
                              fontSize: 19,
                              height: 1.2,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.4,
                              color: span.isRed
                                  ? (isSelected
                                      ? OnboardingTheme.primaryRed
                                      : theme.colorScheme.onSurface
                                          .withValues(alpha: 0.54))
                                  : theme.colorScheme.onSurface,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 24),
                Divider(
                  height: 1,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.08),
                ),
                const SizedBox(height: 13),
                Text(
                  intensityLabel,
                  style: GoogleFonts.lato(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.42),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(5, (index) {
                    final isActive = index < intensity;
                    return Expanded(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        height: 7,
                        margin: EdgeInsetsDirectional.only(
                          end: index == 4 ? 0 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isActive
                                  ? OnboardingTheme.primaryRed
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.08))
                              : (isActive
                                  ? theme.colorScheme.onSurface
                                      .withValues(alpha: 0.38)
                                  : theme.colorScheme.onSurface
                                      .withValues(alpha: 0.05)),
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 14),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 23,
                  height: 23,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? OnboardingTheme.primaryRed
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? OnboardingTheme.primaryRed
                          : theme.colorScheme.onSurface.withValues(alpha: 0.18),
                      width: 1.4,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          size: 15,
                          color: Colors.white,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IntervalsStep extends StatelessWidget {
  final OnboardingStrings strings;
  final int step; // 1..7

  const _IntervalsStep({
    super.key,
    required this.strings,
    required this.step,
  });

  @override
  Widget build(BuildContext context) {
    // step mapping:
    // 1: line1
    // 2: line1+line2
    // 3: +line3
    // 4: +line4
    // 5: dots (appear one-by-one automatically)
    // 6: show "이렇게 30분씩,"
    // 7: show "이게 더 잘 빠집니다" (in addition to line 1)
    final showCount = step.clamp(1, 4);
    final lines = strings.ex2IntervalLines();
    return LayoutBuilder(
      builder: (context, constraints) {
        // Stay top-anchored (revealing a line must not shove the earlier ones
        // around), but pick the top gap so the *finished* block lands centred
        // instead of hugging the header with a hole underneath.
        const finalBlockHeight = 340.0;
        final topGap =
            ((constraints.maxHeight - finalBlockHeight) / 2).clamp(40.0, 150.0);

        return Column(
          children: [
            SizedBox(height: topGap),

            // Staggered reveal: each line animates in when it becomes visible.
            // Walk lines stay dark, run lines are red, so the alternating
            // slow/fast rhythm is visible at a glance. Line order is identical
            // in every language: 0 and 2 walk, 1 and 3 run.
            for (int i = 0; i < 4; i++) ...[
              _Reveal(
                visible: i < showCount,
                child: _Line(
                  text: lines[i],
                  isRunLine: i.isOdd,
                ),
              ),
              const SizedBox(height: 8),
            ],

            _Reveal(
              // Keep dots visible after they appear (do not disappear on next tap).
              visible: step >= 5,
              child: const _AnimatedDots(),
            ),
            // Extra breathing room so the answer reads as a conclusion rather
            // than a fifth item in the list.
            const SizedBox(height: 26),
            _Reveal(
              visible: step >= 6,
              child: _Final(
                line1: strings.ex2FinalLine1Spans(),
                line2: strings.ex2FinalLine2Spans(),
                showSecondLine: step >= 7,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Reveal extends StatelessWidget {
  final bool visible;
  final Widget child;

  const _Reveal({
    required this.visible,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 420),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, anim) {
        final curved =
            CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        final fade = CurvedAnimation(
          parent: anim,
          curve: const Interval(0.15, 1.0, curve: Curves.easeOut),
        );
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.22),
          end: Offset.zero,
        ).animate(curved);
        return SizeTransition(
          sizeFactor: curved,
          axisAlignment: -1.0, // grow from top, prevents icon movement
          child: FadeTransition(
            opacity: fade,
            child: SlideTransition(position: slide, child: child),
          ),
        );
      },
      child: visible ? child : const SizedBox.shrink(),
    );
  }
}

class _Line extends StatelessWidget {
  final String text;
  final bool isRunLine;

  const _Line({
    required this.text,
    required this.isRunLine,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OnboardingRichTitle(
        spans: [EmphasisTextSpan(text, isRed: isRunLine)],
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _Final extends StatelessWidget {
  final List<EmphasisTextSpan> line1;
  final List<EmphasisTextSpan> line2;
  final bool showSecondLine;

  const _Final({
    required this.line1,
    required this.line2,
    required this.showSecondLine,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OnboardingRichTitle(spans: line1, fontSize: 30),
        ),
        const SizedBox(height: 2),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 360),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, anim) {
            final curved =
                CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
            final fade = CurvedAnimation(
              parent: anim,
              curve: const Interval(0.15, 1.0, curve: Curves.easeOut),
            );
            final slide = Tween<Offset>(
              begin: const Offset(0, 0.18),
              end: Offset.zero,
            ).animate(curved);
            return FadeTransition(
              opacity: fade,
              child: SlideTransition(position: slide, child: child),
            );
          },
          child: showSecondLine
              ? SizedBox(
                  key: const ValueKey('final2'),
                  width: double.infinity,
                  child: OnboardingRichTitle(spans: line2, fontSize: 30),
                )
              : const SizedBox(key: ValueKey('empty')),
        ),
      ],
    );
  }
}

class _AnimatedDots extends StatefulWidget {
  const _AnimatedDots();

  @override
  State<_AnimatedDots> createState() => _AnimatedDotsState();
}

class _AnimatedDotsState extends State<_AnimatedDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _a1;
  late final Animation<double> _a2;
  late final Animation<double> _a3;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _a1 = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
    );
    _a2 = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.25, 0.6, curve: Curves.easeOutCubic),
    );
    _a3 = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.5, 0.85, curve: Curves.easeOutCubic),
    );
    _c.forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _Dot(anim: _a1),
          const SizedBox(height: 2),
          _Dot(anim: _a2),
          const SizedBox(height: 2),
          _Dot(anim: _a3),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Animation<double> anim;
  const _Dot({required this.anim});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.25),
          end: Offset.zero,
        ).animate(anim),
        child: Text(
          '.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _IntervalChartVisualizer extends StatefulWidget {
  final int step;

  const _IntervalChartVisualizer({required this.step});

  @override
  State<_IntervalChartVisualizer> createState() =>
      _IntervalChartVisualizerState();
}

class _IntervalChartVisualizerState extends State<_IntervalChartVisualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late Animation<double> _animation;
  int _prevStep = 1;

  @override
  void initState() {
    super.initState();
    _prevStep = widget.step;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    _controller.forward(from: 0.0);
  }

  @override
  void didUpdateWidget(covariant _IntervalChartVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.step != widget.step) {
      _prevStep = oldWidget.step;
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        return Container(
          width: double.infinity,
          height: 120,
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? const Color(0xFF1C1C1E)
                : const Color(0xFFF9F9F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: theme.brightness == Brightness.dark
                  ? const Color(0xFF2C2C2E)
                  : const Color(0xFFE5E5EA),
              width: 0.8,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CustomPaint(
              painter: _IntervalChartPainter(
                step: widget.step,
                prevStep: _prevStep,
                animValue: _animation.value,
                isDark: theme.brightness == Brightness.dark,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _IntervalChartPainter extends CustomPainter {
  final int step;
  final int prevStep;
  final double animValue;
  final bool isDark;

  _IntervalChartPainter({
    required this.step,
    required this.prevStep,
    required this.animValue,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    // Define colors
    const walkStartColor = Color(0xFF00C6FF);
    const walkEndColor = Color(0xFF0072FF);
    const runStartColor = Color(0xFFFF416C);
    const runEndColor = Color(0xFFFF4B2B);

    final walkPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [walkStartColor, walkEndColor],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    final runPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [runStartColor, runEndColor],
      ).createShader(Rect.fromLTWH(0, 0, width, height));

    // Helpers to draw rounded rect blocks at the bottom
    void drawBlock(
        double left, double right, double targetHeight, Paint paint) {
      if (left >= right) return;
      final rect = RRect.fromRectAndCorners(
        Rect.fromLTRB(left, height - targetHeight, right, height),
        topLeft: const Radius.circular(8),
        topRight: const Radius.circular(8),
      );

      // Draw glow shadow
      canvas.save();
      final glowPaint = Paint()
        ..color = (paint.shader == null)
            ? Colors.grey.withValues(alpha: 0.1)
            : const Color(0xFFFF4B2B).withValues(alpha: 0.15)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);
      canvas.drawRRect(rect, glowPaint);
      canvas.restore();

      canvas.drawRRect(rect, paint);
    }

    if (step <= 4) {
      // 4 blocks mode
      final blockWidths = [0.25, 0.30, 0.20, 0.25];
      final heights = [
        0.35 * height,
        0.85 * height,
        0.35 * height,
        0.85 * height
      ];
      final paints = [walkPaint, runPaint, walkPaint, runPaint];

      double currentX = 0;
      for (int i = 0; i < 4; i++) {
        final bWidth = blockWidths[i] * width;
        final startX = currentX;
        final endX = currentX + bWidth;
        currentX = endX;

        // Determine actual height based on step and animation
        double actualHeight = 0;
        if (i < step - 1) {
          // Previously completed blocks
          actualHeight = heights[i];
        } else if (i == step - 1) {
          // Currently animating block
          if (prevStep < step) {
            actualHeight = heights[i] * animValue;
          } else {
            actualHeight = heights[i];
          }
        }

        drawBlock(startX, endX, actualHeight, paints[i]);
      }
    } else {
      // Step 5, 6, 7: Zoomed out, repeating wave (e.g. 6 cycles)
      const totalCycles = 6;
      final cycleWidth = width / totalCycles;
      final walkW = cycleWidth * 0.4;
      final walkH = 0.35 * height;
      final runH = 0.85 * height;

      for (int i = 0; i < totalCycles; i++) {
        final cycleStartX = i * cycleWidth;
        // Walk block
        drawBlock(
          cycleStartX,
          cycleStartX + walkW,
          walkH,
          walkPaint,
        );
        // Run block
        drawBlock(
          cycleStartX + walkW,
          cycleStartX + cycleWidth,
          runH,
          runPaint,
        );
      }

      // Step 7: Steady cardio contrast line
      if (step >= 7) {
        final linePaint = Paint()
          ..color = isDark
              ? Colors.white.withValues(alpha: 0.35)
              : Colors.black.withValues(alpha: 0.35)
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke;

        // Draw dashed line
        const dashWidth = 8.0;
        const dashSpace = 5.0;
        double startX = 0;
        final yVal = height - (0.45 * height);

        // Animate line fading in
        final double opacity = (prevStep < 7) ? animValue : 1.0;
        linePaint.color =
            linePaint.color.withValues(alpha: linePaint.color.a * opacity);

        while (startX < width) {
          canvas.drawLine(
            Offset(startX, yVal),
            Offset((startX + dashWidth).clamp(0, width), yVal),
            linePaint,
          );
          startX += dashWidth + dashSpace;
        }

        // Draw a small text for steady state label if space allows
        final textPainter = TextPainter(
          text: TextSpan(
            text: 'Steady State',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: linePaint.color,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        textPainter.paint(canvas, Offset(12, yVal - 14));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _IntervalChartPainter oldDelegate) {
    return oldDelegate.step != step ||
        oldDelegate.animValue != animValue ||
        oldDelegate.isDark != isDark;
  }
}
