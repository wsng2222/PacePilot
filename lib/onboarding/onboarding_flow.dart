import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_settings/app_settings_provider.dart';
import '../services/analytics_service.dart';
import 'onboarding_controller.dart';
import 'onboarding_storage.dart';
import 'onboarding_strings.dart';
import 'screens/onboarding_screen_1_welcome.dart';
import 'screens/onboarding_screen_2_interval_explainer.dart';
import 'screens/onboarding_screen_2_plan.dart';
import 'screens/onboarding_screen_2_ai_intro.dart';
import 'screens/onboarding_screen_3_workout_preview.dart';
import 'screens/onboarding_screen_4_history.dart';
import 'screens/onboarding_screen_4_reminder.dart';
import 'screens/onboarding_screen_5_level.dart';
import 'screens/onboarding_screen_6_units.dart';
import 'screens/onboarding_screen_7_start.dart';
import 'widgets/onboarding_cta_button.dart';
import 'widgets/onboarding_theme.dart';

class OnboardingGate extends StatefulWidget {
  final Widget home;
  final bool forceShowOnboarding;

  const OnboardingGate({
    super.key,
    required this.home,
    this.forceShowOnboarding = false,
  });

  @override
  State<OnboardingGate> createState() => _OnboardingGateState();
}

class _OnboardingGateState extends State<OnboardingGate> {
  bool? _isComplete;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final complete = await OnboardingStorage.isComplete();
    if (!mounted) return;
    setState(() => _isComplete = complete);
  }

  void _markCompleteInMemory() {
    if (!mounted) return;
    setState(() => _isComplete = true);
  }

  void _handleFinished() {
    _markCompleteInMemory();
    // When onboarding was launched explicitly (e.g., Easter egg), pop the route.
    if (widget.forceShowOnboarding && Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isComplete == null) {
      return Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const Center(
          child: SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (_isComplete == true && !widget.forceShowOnboarding) return widget.home;
    return OnboardingFlow(onFinished: _handleFinished);
  }
}

class OnboardingFlow extends StatefulWidget {
  final VoidCallback onFinished;

  const OnboardingFlow({
    super.key,
    required this.onFinished,
  });

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  late final PageController _pageController;
  late final OnboardingController _controller;
  bool _didInitDefaults = false;
  int _intervalExplainerStep = 0; // internal steps for screen 2
  int? _quizSelectedOption;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _controller = OnboardingController()
      // Defaults required by spec.
      ..selectLevel(OnboardingLevel.intermediate)
      ..selectSpeedUnit(SpeedUnit.kmh)
      ..selectWeightUnit(WeightUnit.kg);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didInitDefaults) return;
    _didInitDefaults = true;
    _initFromStorageAndLocale();
  }

  Future<void> _initFromStorageAndLocale() async {
    final storedLevel = await OnboardingStorage.getLevel();
    final storedSpeed = await OnboardingStorage.getSpeedUnit();
    final storedWeight = await OnboardingStorage.getWeightUnit();

    if (!mounted) return;

    if (storedLevel != null) {
      _controller.selectLevel(storedLevel);
    } else {
      _controller.selectLevel(OnboardingLevel.intermediate);
    }

    // Metric is the default everywhere, regardless of the device region; the
    // user picks imperial on this screen if they want it.
    if (storedSpeed != null) {
      _controller.selectSpeedUnit(storedSpeed);
    } else {
      _controller.selectSpeedUnit(SpeedUnit.kmh);
    }

    if (storedWeight != null) {
      _controller.selectWeightUnit(storedWeight);
    } else {
      _controller.selectWeightUnit(WeightUnit.kg);
    }

    // Log initial page view.
    AnalyticsService.instance.logEvent(
      'onboarding_page_viewed',
      {'pageIndex': _controller.currentPage},
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _goTo(int page) async {
    _controller.setPage(page);
    if (!_pageController.hasClients) return;
    await _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
    );
  }

  void _handleBack() {
    final pageIndex = _controller.currentPage;
    if (pageIndex == 1 && _intervalExplainerStep > 0) {
      setState(() {
        _intervalExplainerStep--;
      });
      return;
    }
    if (pageIndex > 0) {
      _goTo(pageIndex - 1);
    }
  }

  Future<void> _next() async {
    // Pages are fixed at 11 (0..10). Keep this in sync with `pages` below.
    final nextPage = (_controller.currentPage + 1).clamp(0, 10);
    AnalyticsService.instance.logEvent(
      'onboarding_next_tapped',
      {'pageIndex': _controller.currentPage},
    );
    await _goTo(nextPage);
  }

  Future<void> _complete() async {
    final settings = context.read<AppSettingsProvider>();
    await _controller.complete(settings);
    AnalyticsService.instance.logEvent('onboarding_completed');
    widget.onFinished();
  }

  String _ctaLabelForPage(int page) {
    final s = OnboardingStrings.of(context);
    switch (page) {
      case 0:
        return s.ctaStart();
      default:
        // Last page (index 10) uses finish label.
        return page == 10 ? s.ctaFinish() : s.ctaNext();
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const OnboardingScreen1Welcome(),
      OnboardingScreen2IntervalExplainer(
        step: _intervalExplainerStep,
        selectedOption: _quizSelectedOption,
        onOptionSelected: (idx) {
          setState(() {
            _quizSelectedOption = idx;
          });
        },
      ),
      const OnboardingScreen2Plan(),
      const OnboardingScreen2AiIntro(),
      const OnboardingScreen3WorkoutPreview(),
      const OnboardingScreen4History(),
      OnboardingScreen4Reminder(onNext: _next),
      OnboardingScreen5Level(controller: _controller),
      OnboardingScreen6Units(controller: _controller),
      const OnboardingScreen7Start(),
    ];

    final lastIndex = pages.length - 1;

    return PopScope(
      canPop: _controller.currentPage == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop || _controller.currentPage <= 0) return;
        _handleBack();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final pageIndex = _controller.currentPage;
          final theme = Theme.of(context);
          return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  _ProgressHeader(
                    index: pageIndex,
                    total: pages.length,
                    onBack: _handleBack,
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: OnboardingTheme.horizontalPadding,
                      ),
                      child: PageView.builder(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (idx) {
                          setState(() {
                            if (idx == 1) {
                              _intervalExplainerStep = 0;
                            }
                          });
                          _controller.setPage(idx);
                          AnalyticsService.instance.logEvent(
                            'onboarding_page_viewed',
                            {'pageIndex': idx},
                          );
                        },
                        itemCount: pages.length,
                        itemBuilder: (context, index) {
                          return _PageTransition(
                            controller: _pageController,
                            index: index,
                            child: pages[index],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: (pageIndex == 6)
                ? null
                : OnboardingCtaButton(
                    text: _ctaLabelForPage(pageIndex),
                    onPressed: (pageIndex == 1 &&
                            _intervalExplainerStep == 0 &&
                            _quizSelectedOption == null)
                        ? null
                        : () {
                            // Screen 2 has internal steps (tap-through) before moving on.
                            if (pageIndex == 1 && _intervalExplainerStep < 7) {
                              setState(() {
                                _intervalExplainerStep =
                                    (_intervalExplainerStep + 1).clamp(0, 7);
                              });
                              return;
                            }
                            if (pageIndex == lastIndex) {
                              _complete();
                            } else {
                              _next();
                            }
                          },
                  ),
          );
        },
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  final int index;
  final int total;
  final VoidCallback? onBack;

  const _ProgressHeader({
    required this.index,
    required this.total,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            // Dots alone carry the progress; the "n/total" label said the same
            // thing twice and ate vertical space.
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(total, (i) {
                final active = i == index;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 16 : 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: active
                        ? OnboardingTheme.primaryRed
                        : (isDark
                            ? OnboardingTheme.darkGrayFill
                            : OnboardingTheme.lightGrayFill),
                    borderRadius: BorderRadius.circular(99),
                  ),
                );
              }),
            ),
          ],
        ),
        if (index > 0 && onBack != null)
          Positioned(
            left: 16,
            child: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              onPressed: onBack,
            ),
          ),
      ],
    );
  }
}

class _PageTransition extends StatelessWidget {
  final PageController controller;
  final int index;
  final Widget child;

  const _PageTransition({
    required this.controller,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        double page = 0;
        if (controller.hasClients && controller.position.haveDimensions) {
          page = controller.page ?? controller.initialPage.toDouble();
        }
        final t = (page - index).abs().clamp(0.0, 1.0);
        final opacity = 1.0 - (0.18 * t);
        final dy = 10.0 * t;
        final scale = 1.0 - (0.02 * t);

        return Opacity(
          opacity: opacity,
          child: Transform.translate(
            offset: Offset(0, dy),
            child: Transform.scale(
              scale: scale,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
