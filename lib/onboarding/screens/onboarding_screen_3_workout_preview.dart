import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:valcue/l10n/app_localizations.dart';

import '../onboarding_strings.dart';
import '../widgets/onboarding_emphasis_text.dart';
import '../widgets/onboarding_theme.dart';

/// A faithful miniature of the real workout screen: same header, same pill
/// progress bar, same metric block, same chips, same ring. The point of this
/// page is "here is what you will be looking at", so it mirrors
/// `workout_screen.dart` rather than inventing its own layout.
class OnboardingScreen3WorkoutPreview extends StatefulWidget {
  const OnboardingScreen3WorkoutPreview({super.key});

  @override
  State<OnboardingScreen3WorkoutPreview> createState() =>
      _OnboardingScreen3WorkoutPreviewState();
}

class _OnboardingScreen3WorkoutPreviewState
    extends State<OnboardingScreen3WorkoutPreview>
    with SingleTickerProviderStateMixin {
  // The demo sits in interval 3 of the 6-interval plan shown one page earlier:
  // a 4-minute recovery walk at 5.0 km/h, with the 9.5 km/h run coming next.
  static const _intervalSeconds = 240;
  // Start the demo part-way into the interval (3:33 left of 4:00) so the ring
  // is already visibly drawn instead of sitting at a full circle.
  static const _startSecondsLeft = 213;
  static const _startFraction = _startSecondsLeft / _intervalSeconds;
  static const _routineSecondsBeforeThisInterval = 600; // 4 + 6 minutes
  static const _routineSeconds = 1800;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      // A touch faster than real time (1.5x): the countdown looks alive
      // without the digits blurring past.
      duration: const Duration(
        milliseconds: _intervalSeconds * 1000 * 2 ~/ 3,
      ),
    );
    _controller.reverse(from: _startFraction);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        _controller.reverse(from: _startFraction); // Loop back
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _clock(int totalSeconds) {
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final s = OnboardingStrings.of(context);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final intervalFraction = _controller.value;
        final intervalSecondsLeft =
            (intervalFraction * _intervalSeconds).ceil();
        final elapsed = _routineSecondsBeforeThisInterval +
            (_intervalSeconds - intervalSecondsLeft);
        final routineSecondsLeft = _routineSeconds - elapsed;

        return LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    OnboardingRichTitle(spans: s.s3TitleSpans()),
                    const SizedBox(height: 30),

                    // Routine header: total time left, and which interval.
                    _RoutineHeader(
                      totalRemaining: _clock(routineSecondsLeft),
                    ),
                    const SizedBox(height: 10),
                    _PillProgressBar(
                      progress: elapsed / _routineSeconds,
                      isDark: isDark,
                    ),

                    const SizedBox(height: 34),

                    // The metric block: label, big value, supporting chips.
                    Text(
                      '${l10n.current} ${l10n.speed}',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.3,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.56),
                      ),
                    ),
                    const SizedBox(height: 12),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '5.0 km/h',
                        style: TextStyle(
                          fontSize: 55,
                          height: 1.0,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.8,
                          color: theme.colorScheme.onSurface,
                          fontFeatures: const [ui.FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _DetailChip(
                          icon: Icons.arrow_outward_rounded,
                          text: s.chipNextSpeed('9.5 km/h'),
                          isAccent: true,
                          isDark: isDark,
                        ),
                        _DetailChip(
                          icon: Icons.terrain_rounded,
                          text: s.chipIncline('1.0%'),
                          isAccent: false,
                          isDark: isDark,
                        ),
                      ],
                    ),

                    const SizedBox(height: 34),
                    _SessionRing(
                      size: 154,
                      timeText: _clock(intervalSecondsLeft),
                      progress: intervalFraction,
                      isDark: isDark,
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _RoutineHeader extends StatelessWidget {
  final String totalRemaining;

  const _RoutineHeader({required this.totalRemaining});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 40,
      child: Center(
        child: Text(
          totalRemaining,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 28,
            height: 1.0,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.7,
            color: theme.colorScheme.onSurface,
            fontFeatures: const [ui.FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }
}

class _PillProgressBar extends StatelessWidget {
  final double progress;
  final bool isDark;

  const _PillProgressBar({required this.progress, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final trackColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : theme.colorScheme.onSurface.withValues(alpha: 0.06);

    return Container(
      width: double.infinity,
      height: 12,
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(999),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress.clamp(0.0, 1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    OnboardingTheme.primaryRed,
                    Color.lerp(
                          OnboardingTheme.primaryRed,
                          Colors.white,
                          isDark ? 0.08 : 0.18,
                        ) ??
                        OnboardingTheme.primaryRed,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isAccent;
  final bool isDark;

  const _DetailChip({
    required this.icon,
    required this.text,
    required this.isAccent,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fill = isAccent
        ? OnboardingTheme.primaryRed.withValues(alpha: isDark ? 0.08 : 0.04)
        : isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02);
    final borderColor = isAccent
        ? OnboardingTheme.primaryRed.withValues(alpha: isDark ? 0.55 : 0.28)
        : isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.10);
    final contentColor = isAccent
        ? OnboardingTheme.primaryRed
        : theme.colorScheme.onSurface.withValues(alpha: 0.84);

    return Container(
      constraints: const BoxConstraints(minHeight: 40),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 15,
            color: isAccent
                ? OnboardingTheme.primaryRed
                : theme.colorScheme.onSurface.withValues(alpha: 0.56),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.1,
                color: contentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionRing extends StatelessWidget {
  final double size;
  final String timeText;
  final double progress;
  final bool isDark;

  const _SessionRing({
    required this.size,
    required this.timeText,
    required this.progress,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strokeWidth = (size * 0.07).clamp(10.0, 14.0);
    final fontSize = (size * 0.18).clamp(24.0, 36.0);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          ),
          CustomPaint(
            size: Size(size, size),
            painter: _RingPainter(
              strokeWidth: strokeWidth,
              progress: progress,
              trackColor: theme.colorScheme.onSurface
                  .withValues(alpha: isDark ? 0.08 : 0.06),
            ),
          ),
          Text(
            timeText,
            textDirection: TextDirection.ltr,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
              color: theme.colorScheme.onSurface,
              fontFeatures: const [ui.FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double strokeWidth;
  final double progress;
  final Color trackColor;

  _RingPainter({
    required this.strokeWidth,
    required this.progress,
    required this.trackColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = trackColor
      ..strokeCap = StrokeCap.round;
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = OnboardingTheme.primaryRed
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, track);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5707963,
      progress.clamp(0.0, 1.0) * 6.2831853,
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
