import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../onboarding_strings.dart';
import '../widgets/onboarding_emphasis_text.dart';
import '../widgets/onboarding_theme.dart';

class OnboardingScreen2AiIntro extends StatefulWidget {
  const OnboardingScreen2AiIntro({super.key});

  @override
  State<OnboardingScreen2AiIntro> createState() =>
      _OnboardingScreen2AiIntroState();
}

class _OnboardingScreen2AiIntroState extends State<OnboardingScreen2AiIntro>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flowController;

  @override
  void initState() {
    super.initState();
    _flowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _flowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = OnboardingStrings.of(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final reduceMotion = MediaQuery.disableAnimationsOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                const SizedBox(height: 60),
                OnboardingRichTitle(spans: s.aiIntroTitleSpans()),
                const SizedBox(height: 18),
                Text(
                  s.aiIntroBody(),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    height: 1.45,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
                const SizedBox(height: 34),
                AnimatedBuilder(
                  animation: _flowController,
                  builder: (context, _) {
                    return _AiGenerationFlow(
                      progress: reduceMotion ? 0.82 : _flowController.value,
                      isDark: isDark,
                      strings: s,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AiGenerationFlow extends StatelessWidget {
  final double progress;
  final bool isDark;
  final OnboardingStrings strings;

  const _AiGenerationFlow({
    required this.progress,
    required this.isDark,
    required this.strings,
  });

  @override
  Widget build(BuildContext context) {
    final firstFlow = Curves.easeInOutCubic.transform(
      (progress / 0.42).clamp(0.0, 1.0),
    );
    final secondFlow = Curves.easeInOutCubic.transform(
      ((progress - 0.42) / 0.42).clamp(0.0, 1.0),
    );

    return Semantics(
      label: strings.aiGenerationSemantics(),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _InputChip(
                  icon: Icons.directions_run_rounded,
                  label: strings.aiTreadmillLabel(),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InputChip(
                  icon: Icons.timer_outlined,
                  label: strings.planMinutesLabel(30),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _InputChip(
                  icon: Icons.speed_rounded,
                  label: strings.levelIntermediateTitle(),
                  isDark: isDark,
                ),
              ),
            ],
          ),
          _FlowConnector(progress: firstFlow, isDark: isDark),
          _AiCore(
            isDark: isDark,
            strings: strings,
            activity: _aiActivity(progress),
          ),
          _FlowConnector(progress: secondFlow, isDark: isDark),
          _GeneratedRoutineCard(
            isDark: isDark,
            strings: strings,
            reveal: secondFlow,
          ),
        ],
      ),
    );
  }

  double _aiActivity(double value) {
    if (value < 0.28 || value > 0.76) return 0;
    final local = (value - 0.28) / 0.48;
    return 1 - (2 * local - 1).abs();
  }
}

class _InputChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isDark;

  const _InputChip({
    required this.icon,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final neutralBorder =
        isDark ? Colors.white.withValues(alpha: 0.10) : const Color(0xFFE5E5EA);

    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: neutralBorder,
          width: 1,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 17,
            color: OnboardingTheme.primaryRed,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.lato(
                fontSize: 12.5,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.15,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowConnector extends StatelessWidget {
  final double progress;
  final bool isDark;

  const _FlowConnector({required this.progress, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 30,
      child: CustomPaint(
        painter: _FlowConnectorPainter(
          progress: progress,
          trackColor: isDark
              ? Colors.white.withValues(alpha: 0.12)
              : const Color(0xFFE4E4E9),
        ),
      ),
    );
  }
}

class _FlowConnectorPainter extends CustomPainter {
  final double progress;
  final Color trackColor;

  _FlowConnectorPainter({required this.progress, required this.trackColor});

  @override
  void paint(Canvas canvas, Size size) {
    final x = size.width / 2;
    const top = Offset(12, 2);
    final bottom = Offset(x, size.height - 2);
    final track = Paint()
      ..color = trackColor
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    final active = Paint()
      ..color = OnboardingTheme.primaryRed
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(top, bottom, track);
    if (progress <= 0) return;

    final activeBottom = Offset(x, 2 + (size.height - 4) * progress);
    canvas.drawLine(top, activeBottom, active);
    canvas.drawCircle(activeBottom, 3.2, active);
  }

  @override
  bool shouldRepaint(covariant _FlowConnectorPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor;
  }
}

class _AiCore extends StatelessWidget {
  final bool isDark;
  final OnboardingStrings strings;
  final double activity;

  const _AiCore({
    required this.isDark,
    required this.strings,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final glow = 0.10 + activity * 0.12;

    return Container(
      height: 62,
      padding: const EdgeInsets.symmetric(horizontal: 17),
      decoration: BoxDecoration(
        color: OnboardingTheme.primaryRed.withValues(
          alpha: isDark ? 0.13 : 0.055,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: OnboardingTheme.primaryRed.withValues(alpha: 0.20 + glow),
        ),
        boxShadow: [
          BoxShadow(
            color: OnboardingTheme.primaryRed.withValues(alpha: glow),
            blurRadius: 18 + activity * 8,
            spreadRadius: -5,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: OnboardingTheme.primaryRed,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Valcue Coach',
                style: GoogleFonts.lato(
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                strings.aiCoreStatus(),
                style: GoogleFonts.lato(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _GeneratedRoutineCard extends StatelessWidget {
  final bool isDark;
  final OnboardingStrings strings;
  final double reveal;

  const _GeneratedRoutineCard({
    required this.isDark,
    required this.strings,
    required this.reveal,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = Color.lerp(
      isDark ? Colors.white.withValues(alpha: 0.10) : const Color(0xFFE5E5EA),
      OnboardingTheme.primaryRed.withValues(alpha: 0.32),
      reveal,
    )!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 15),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
        borderRadius: BorderRadius.circular(OnboardingTheme.radiusMedium),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.07),
            blurRadius: 20,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: OnboardingTheme.primaryRed.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 20,
                  color: OnboardingTheme.primaryRed,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.aiCustomRoutineLabel(),
                      style: GoogleFonts.lato(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${strings.aiTreadmillLabel()} · '
                      '${strings.levelIntermediateTitle()}',
                      style: GoogleFonts.lato(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color:
                            theme.colorScheme.onSurface.withValues(alpha: 0.45),
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: Text(
                  strings.planMinutesLabel(30),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: OnboardingTheme.primaryRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: SizedBox(
              height: 11,
              child: Row(
                children: List.generate(12, (index) {
                  final isRun = index.isOdd;
                  return Expanded(
                    flex: isRun ? 3 : 2,
                    child: Container(
                      margin: EdgeInsetsDirectional.only(
                        end: index == 11 ? 0 : 2,
                      ),
                      color: isRun
                          ? OnboardingTheme.primaryRed
                          : (isDark
                              ? const Color(0xFF4A4A4E)
                              : const Color(0xFFD9D9DE)),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _LegendDot(
                color:
                    isDark ? const Color(0xFF4A4A4E) : const Color(0xFFD9D9DE),
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  strings.aiWalkMinutesLabel(2),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _legendStyle(theme),
                ),
              ),
              const SizedBox(width: 12),
              const _LegendDot(color: OnboardingTheme.primaryRed),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  strings.aiRunMinutesLabel(3),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: _legendStyle(theme),
                ),
              ),
              const Spacer(),
              Flexible(
                child: Text(
                  strings.aiSetCountLabel(6),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  TextStyle _legendStyle(ThemeData theme) {
    return GoogleFonts.lato(
      fontSize: 11.5,
      fontWeight: FontWeight.w700,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.56),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;

  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 7,
      height: 7,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
