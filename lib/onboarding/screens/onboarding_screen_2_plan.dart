import 'package:flutter/material.dart';

import '../onboarding_strings.dart';
import '../widgets/onboarding_emphasis_text.dart';
import '../widgets/onboarding_theme.dart';

class OnboardingScreen2Plan extends StatefulWidget {
  const OnboardingScreen2Plan({super.key});

  @override
  State<OnboardingScreen2Plan> createState() => _OnboardingScreen2PlanState();
}

class _OnboardingScreen2PlanState extends State<OnboardingScreen2Plan>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = OnboardingStrings.of(context);
    final reduceMotion = MediaQuery.disableAnimationsOf(context);
    final animation = reduceMotion
        ? const AlwaysStoppedAnimation<double>(1)
        : CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                const SizedBox(height: 54),
                OnboardingRichTitle(spans: strings.s2TitleSpans()),
                const SizedBox(height: 30),
                _PlanOverview(strings: strings, animation: animation),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlanOverview extends StatelessWidget {
  final OnboardingStrings strings;
  final Animation<double> animation;

  const _PlanOverview({required this.strings, required this.animation});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    // 2:3 walk-to-run, the same ratio screen 2 just taught, repeated 3 times.
    final intervals = [
      _PlanIntervalData(
        title: strings.planRecoveryWalkLabel(),
        minutes: 4,
        durationLabel: strings.planMinutesLabel(4),
        speed: '5.0 km/h',
        isRun: false,
      ),
      _PlanIntervalData(
        title: strings.planFastRunLabel(),
        minutes: 6,
        durationLabel: strings.planMinutesLabel(6),
        speed: '9.0 km/h',
        isRun: true,
      ),
      _PlanIntervalData(
        title: strings.planRecoveryWalkLabel(),
        minutes: 4,
        durationLabel: strings.planMinutesLabel(4),
        speed: '5.0 km/h',
        isRun: false,
      ),
      _PlanIntervalData(
        title: strings.planFastRunLabel(),
        minutes: 6,
        durationLabel: strings.planMinutesLabel(6),
        speed: '9.5 km/h',
        isRun: true,
      ),
      _PlanIntervalData(
        title: strings.planRecoveryWalkLabel(),
        minutes: 4,
        durationLabel: strings.planMinutesLabel(4),
        speed: '5.0 km/h',
        isRun: false,
      ),
      _PlanIntervalData(
        title: strings.planFinishRunLabel(),
        minutes: 6,
        durationLabel: strings.planMinutesLabel(6),
        speed: '10.0 km/h',
        isRun: true,
      ),
    ];
    // Derived, so the headline total can never drift from the segments.
    final totalMinutes = intervals.fold<int>(0, (sum, i) => sum + i.minutes);

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    strings.planTotalWorkoutTimeLabel(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.2,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.44),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    strings.planTotalMinutesLabel(totalMinutes),
                    style: TextStyle(
                      fontSize: 34,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.0,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDark
                    ? OnboardingTheme.darkGrayFill
                    : const Color(0xFFF2F2F7),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                strings.planIntervalCountLabel(intervals.length),
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.70),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _AnimatedTimeline(intervals: intervals, animation: animation),
        const SizedBox(height: 22),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? OnboardingTheme.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(OnboardingTheme.radiusLarge),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.09)
                  : const Color(0xFFE8E8EC),
            ),
            boxShadow: [OnboardingTheme.mediumShadow],
          ),
          child: Column(
            children: List.generate(intervals.length, (index) {
              final start = 0.18 + index * 0.10;
              final end = (start + 0.34).clamp(0.0, 1.0);
              final rowAnimation = CurvedAnimation(
                parent: animation,
                curve: Interval(start, end, curve: Curves.easeOutCubic),
              );
              return Column(
                children: [
                  _AnimatedPlanRow(
                    index: index,
                    data: intervals[index],
                    label: strings.planIntervalLabel(index + 1),
                    animation: rowAnimation,
                  ),
                  if (index != intervals.length - 1)
                    Divider(
                      height: 1,
                      indent: 48,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.07),
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _AnimatedTimeline extends StatelessWidget {
  final List<_PlanIntervalData> intervals;
  final Animation<double> animation;

  const _AnimatedTimeline({required this.intervals, required this.animation});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 18,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Stack(
              fit: StackFit.expand,
              children: [
                ColoredBox(
                  color: isDark
                      ? OnboardingTheme.darkGrayFill
                      : const Color(0xFFE8E8EC),
                ),
                ClipRect(
                  clipper: _TimelineRevealClipper(animation.value),
                  child: child,
                ),
              ],
            );
          },
          child: Row(
            children: List.generate(intervals.length, (index) {
              final interval = intervals[index];
              return Expanded(
                flex: interval.flex,
                child: Container(
                  margin: EdgeInsets.only(
                    right: index == intervals.length - 1 ? 0 : 3,
                  ),
                  color: interval.isRun
                      ? OnboardingTheme.primaryRed
                      : (isDark
                          ? const Color(0xFF5A5A5E)
                          : const Color(0xFFCACACF)),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _TimelineRevealClipper extends CustomClipper<Rect> {
  final double progress;

  const _TimelineRevealClipper(this.progress);

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width * progress, size.height);
  }

  @override
  bool shouldReclip(_TimelineRevealClipper oldClipper) {
    return oldClipper.progress != progress;
  }
}

class _AnimatedPlanRow extends StatelessWidget {
  final int index;
  final _PlanIntervalData data;
  final String label;
  final Animation<double> animation;

  const _AnimatedPlanRow({
    required this.index,
    required this.data,
    required this.label,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(16 * (1 - animation.value), 0),
            child: child,
          ),
        );
      },
      child: _PlanRow(index: index, data: data, label: label),
    );
  }
}

class _PlanRow extends StatelessWidget {
  final int index;
  final _PlanIntervalData data;
  final String label;

  const _PlanRow({
    required this.index,
    required this.data,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accent = data.isRun
        ? OnboardingTheme.primaryRed
        : theme.colorScheme.onSurface.withValues(alpha: 0.46);

    return Semantics(
      label: '$label, ${data.title}, ${data.durationLabel}, ${data.speed}',
      excludeSemantics: true,
      child: SizedBox(
        height: 66,
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: data.isRun
                    ? OnboardingTheme.primaryRed.withValues(
                        alpha: isDark ? 0.18 : 0.09,
                      )
                    : (isDark
                        ? OnboardingTheme.darkGrayFill
                        : const Color(0xFFF1F1F4)),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: accent,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.25,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.38),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  data.durationLabel,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  data.speed,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: accent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanIntervalData {
  final String title;
  final int minutes;
  final String durationLabel;
  final String speed;
  final bool isRun;

  const _PlanIntervalData({
    required this.title,
    required this.minutes,
    required this.durationLabel,
    required this.speed,
    required this.isRun,
  });

  /// The timeline bar is proportional to each segment's length.
  int get flex => minutes;
}
