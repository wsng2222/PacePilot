import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:valcue/l10n/app_localizations.dart';
import 'package:valcue/l10n/localized_format.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart' as intl;
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../features/routines/screens/routine_list_screen.dart';
import '../features/routines/models/machine_type.dart';
import '../features/settings/screens/settings_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/routines/utils/routine_sharing.dart';
import '../app_settings/app_settings_provider.dart';
import '../ui/glass/liquid_glass_pill_navbar.dart';
import '../theme/app_theme.dart';
import '../utils/app_shadows.dart';
import '../widgets/bounceable.dart';
import '../services/analytics_service.dart';
import '../services/purchase_service.dart';
import '../widgets/app_message.dart';

const _privacyPolicyUri =
    'https://wsng2222.github.io/Valcue/privacy-policy.html';
const _termsOfServiceUri =
    'https://wsng2222.github.io/Valcue/terms-of-service.html';

Future<void> _openPrivacyPolicy(BuildContext context) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final errorMessage = AppLocalizations.of(context)!.unableToOpenPrivacyPolicy;
  final uri = Uri.parse(_privacyPolicyUri).replace(
    queryParameters: {
      'lang': Localizations.localeOf(context).languageCode,
    },
  );
  final launched = await launchUrl(uri);

  if (!launched) {
    messenger?.showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

Future<void> _openTermsOfService(BuildContext context) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final errorMessage = AppLocalizations.of(context)!.unableToOpenLink;
  final uri = Uri.parse(_termsOfServiceUri).replace(
    queryParameters: {
      'lang': Localizations.localeOf(context).languageCode,
    },
  );
  final launched = await launchUrl(uri);

  if (!launched) {
    messenger?.showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class AppShell extends StatefulWidget {
  final int initialIndex;
  final bool enableClipboardChecks;

  const AppShell({
    super.key,
    this.initialIndex = 1,
    this.enableClipboardChecks = true,
  });

  @override
  State<AppShell> createState() => _AppShellState();

  // Global key to access AppShell state from anywhere
  static final GlobalKey<State<AppShell>> globalKey =
      GlobalKey<State<AppShell>>();

  static _AppShellState? _currentShellState() {
    final state = globalKey.currentState;
    if (state is _AppShellState) {
      return state;
    }
    return null;
  }

  // Method to navigate to Premium tab (index 0)
  static void navigateToPremiumTab() {
    // Try to navigate immediately
    final state = _currentShellState();
    if (state != null) {
      state._changeTab(0);
      return;
    }

    // If state is not available, try again after a short delay
    // This handles cases where the widget tree is still building
    Future.delayed(const Duration(milliseconds: 100), () {
      final retryState = _currentShellState();
      if (retryState != null) {
        retryState._changeTab(0);
      }
    });
  }

  // Method to navigate to Routine tab (index 1)
  static void navigateToRoutineTab() {
    final state = _currentShellState();
    if (state != null) {
      state._changeTab(1);
      return;
    }

    Future.delayed(const Duration(milliseconds: 100), () {
      final retryState = _currentShellState();
      if (retryState != null) {
        retryState._changeTab(1);
      }
    });
  }

  // Method to navigate to Routine tab with specific machine type
  static void navigateToRoutineTabWithMachineType(MachineType machineType) {
    // Set the target machine type before navigating
    RoutineListScreen.targetMachineType = machineType;

    final state = _currentShellState();
    if (state != null) {
      state._changeTab(1);
      // If RoutineListScreen is already built, navigate immediately
      RoutineListScreen.navigateToMachineTypeIfReady(machineType);
      return;
    }

    // If state is null, set target and navigate when ready
    Future.microtask(() {
      final retryState = _currentShellState();
      if (retryState != null) {
        retryState._changeTab(1);
        RoutineListScreen.navigateToMachineTypeIfReady(machineType);
      }
    });
  }
}

class _AppShellState extends State<AppShell> with WidgetsBindingObserver {
  late int _currentIndex;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 3);
    _screens = [
      const _PremiumScreen(),
      RoutineListScreen(
        key: widget.enableClipboardChecks ? RoutineListScreen.globalKey : null,
      ),
      const SettingsScreen(),
      const ProfileScreen(),
    ];
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.enableClipboardChecks) {
        _checkClipboard();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.enableClipboardChecks && state == AppLifecycleState.resumed) {
      _checkClipboard();
    }
  }

  Future<void> _checkClipboard() async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    await RoutineSharing.checkClipboardAndImport(context);
  }

  void _changeTab(int index) {
    if (index == 0 && _currentIndex != 0) {
      AnalyticsService.instance.logEvent(
        'paywall_viewed',
        {'source': 'premium_tab'},
      );
    }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isIOS = PlatformInfo.isIOS;
    final useSfSymbols = isIOS && PlatformInfo.isIOS26OrHigher();
    final useNativeBottomBar = isIOS && PlatformInfo.isIOS26OrHigher();
    final bottomSafePadding = MediaQuery.of(context).padding.bottom;
    const nativeTabBarHeight = 56.0;
    final bodyBottomPadding =
        useNativeBottomBar ? (nativeTabBarHeight + bottomSafePadding) : 0.0;

    dynamic navIcon(String iosSymbol, IconData fallback) {
      return useSfSymbols ? iosSymbol : fallback;
    }

    final body = IndexedStack(
      index: _currentIndex,
      children: _screens,
    );

    if (isIOS) {
      return AdaptiveScaffold(
        minimizeBehavior: TabBarMinimizeBehavior.never,
        body: Padding(
          padding: EdgeInsets.only(bottom: bodyBottomPadding),
          child: body,
        ),
        bottomNavigationBar: AdaptiveBottomNavigationBar(
          selectedIndex: _currentIndex,
          onTap: _changeTab,
          useNativeBottomBar: useNativeBottomBar,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor:
              theme.colorScheme.onSurface.withValues(alpha: 0.65),
          items: [
            AdaptiveNavigationDestination(
              icon: navIcon('flame', Icons.local_fire_department_outlined),
              selectedIcon: navIcon('flame.fill', Icons.local_fire_department),
              label: l10n.premiumTab,
            ),
            AdaptiveNavigationDestination(
              icon: navIcon('figure.run', Icons.directions_run_outlined),
              selectedIcon: navIcon('figure.run', Icons.directions_run),
              label: l10n.routineTab,
            ),
            AdaptiveNavigationDestination(
              icon: navIcon('gearshape', Icons.settings_outlined),
              selectedIcon: navIcon('gearshape.fill', Icons.settings),
              label: l10n.settingsTab,
            ),
            AdaptiveNavigationDestination(
              icon: navIcon('person', Icons.person_outline),
              selectedIcon: navIcon('person.fill', Icons.person),
              label: l10n.myTab,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: SafeArea(
        top: false,
        bottom: false,
        child: Consumer<AppSettingsProvider>(
          builder: (context, settingsProvider, child) {
            const bottomMargin = 12.0;

            return LiquidGlassPillNavBar(
              currentIndex: _currentIndex,
              onTap: _changeTab,
              bottomMargin: bottomMargin,
              items: [
                LiquidGlassNavItem(
                  icon: Icons.local_fire_department,
                  label: l10n.premiumTab,
                ),
                LiquidGlassNavItem(
                  icon: Icons.directions_run,
                  label: l10n.routineTab,
                ),
                LiquidGlassNavItem(
                  icon: Icons.settings,
                  label: l10n.settingsTab,
                ),
                const LiquidGlassNavItem(
                  icon: Icons.person,
                  label: '',
                  iconSize: 28.0,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PremiumScreen extends StatefulWidget {
  const _PremiumScreen();

  @override
  State<_PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<_PremiumScreen> {
  late final _PlanSelectionNotifier _selectionNotifier;
  Offering? _offering;
  bool _purchaseInProgress = false;

  @override
  void initState() {
    super.initState();
    _selectionNotifier = _PlanSelectionNotifier();
    _loadOffering();
  }

  Future<void> _loadOffering() async {
    final offering = await PurchaseService.instance.getCurrentOffering();
    if (!mounted) return;
    setState(() {
      _offering = offering;
    });
  }

  Package? _packageForPlan(PlanType plan) {
    switch (plan) {
      case PlanType.monthly:
        return _offering?.monthly;
      case PlanType.yearly:
        return _offering?.annual;
      case PlanType.lifetime:
        return _offering?.lifetime;
    }
  }

  @override
  void dispose() {
    _selectionNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Column(
              children: [
                const _PremiumHeroCard(),
                const SizedBox(height: 20),
                _PlanSelector(
                  selectionNotifier: _selectionNotifier,
                  offering: _offering,
                ),
                const SizedBox(height: 24),
                const _BenefitsList(),
                const SizedBox(height: 28),
                _SupportingLine(selectionNotifier: _selectionNotifier),
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;

                    // TEST BUILD ONLY: grants premium directly instead of
                    // running a real RevenueCat purchase. Remove this bypass
                    // and restore the purchasePackage() flow below once real
                    // API keys are set in purchase_service.dart.
                    const testBypassPurchase = true;

                    Future<void> onPurchase() async {
                      final plan = _selectionNotifier.value;
                      AnalyticsService.instance.logEvent(
                        'premium_clicked',
                        {
                          'source': 'premium_tab',
                          'plan': plan.name,
                        },
                      );

                      if (testBypassPurchase) {
                        PurchaseService.instance.isPremiumListenable.value =
                            true;
                        AnalyticsService.instance.logEvent(
                          'premium_purchased',
                          {
                            'source': 'premium_tab',
                            'plan': plan.name,
                            'product_id': 'test_bypass',
                          },
                        );
                        return;
                      }

                      // ignore: dead_code
                      final package = _packageForPlan(plan);
                      if (package == null) {
                        showAppMessage(
                          context,
                          l10n.plansUnavailable,
                          type: AppMessageType.error,
                        );
                        return;
                      }

                      AnalyticsService.instance.logEvent(
                        'premium_purchase_started',
                        {
                          'source': 'premium_tab',
                          'plan': plan.name,
                          'product_id': package.storeProduct.identifier,
                        },
                      );

                      setState(() => _purchaseInProgress = true);
                      final outcome = await PurchaseService.instance
                          .purchasePackage(package);
                      if (!mounted) return;
                      setState(() => _purchaseInProgress = false);

                      switch (outcome) {
                        case PurchaseOutcome.success:
                          AnalyticsService.instance.logEvent(
                            'premium_purchased',
                            {
                              'source': 'premium_tab',
                              'plan': plan.name,
                              'product_id': package.storeProduct.identifier,
                            },
                          );
                          break;
                        case PurchaseOutcome.cancelled:
                          break;
                        case PurchaseOutcome.failed:
                          if (!context.mounted) return;
                          showAppMessage(
                            context,
                            l10n.purchaseFailed,
                            type: AppMessageType.error,
                          );
                          break;
                      }
                    }

                    final buttonLabel = _purchaseInProgress
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                theme.colorScheme.onPrimary,
                              ),
                            ),
                          )
                        : Text(
                            l10n.startPremium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.lato(
                              fontSize: 19,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              letterSpacing: -0.4,
                              color: theme.colorScheme.onPrimary,
                            ),
                          );

                    return Bounceable(
                      onTap: _purchaseInProgress ? null : onPurchase,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(AppTheme.buttonRadius),
                          boxShadow: [
                            BoxShadow(
                              color: theme.colorScheme.primary.withValues(
                                alpha: 0.28,
                              ),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          child: IgnorePointer(
                            child: PlatformInfo.isIOS
                                ? AdaptiveButton.child(
                                    onPressed: () {},
                                    color: theme.colorScheme.primary,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    borderRadius: BorderRadius.circular(
                                        AppTheme.buttonRadius),
                                    child: Center(child: buttonLabel),
                                  )
                                : ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          theme.colorScheme.primary,
                                      foregroundColor:
                                          theme.colorScheme.onPrimary,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            AppTheme.buttonRadius),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: Center(child: buttonLabel),
                                  ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    final isDark = theme.brightness == Brightness.dark;
                    final secondaryText = isDark
                        ? Colors.white.withValues(alpha: 0.72)
                        : theme.extension<AppColors>()!.mutedText;
                    final tertiaryText = isDark
                        ? Colors.white.withValues(alpha: 0.42)
                        : theme.extension<AppColors>()!.mutedText.withValues(
                              alpha: 0.85,
                            );
                    return Column(
                      children: [
                        Text(
                          l10n.cancelAnytime,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: secondaryText,
                            letterSpacing: -0.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.cancelAnytimeKeepAccess,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: secondaryText,
                            letterSpacing: -0.1,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.autoRenewableSubscription,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: tertiaryText,
                            letterSpacing: -0.05,
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 24),
                Builder(
                  builder: (context) {
                    final l10n = AppLocalizations.of(context)!;
                    final isDark = theme.brightness == Brightness.dark;
                    final separatorColor = isDark
                        ? Colors.white.withValues(alpha: 0.32)
                        : theme.extension<AppColors>()!.mutedText.withValues(
                              alpha: 0.6,
                            );
                    return Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _FooterLink(
                          text: l10n.terms,
                          onTap: () async {
                            await _openTermsOfService(context);
                          },
                        ),
                        Text(
                          ' • ',
                          style: TextStyle(
                            fontSize: 13,
                            color: separatorColor,
                          ),
                        ),
                        _FooterLink(
                          text: l10n.privacy,
                          onTap: () async {
                            await _openPrivacyPolicy(context);
                          },
                        ),
                        Text(
                          ' • ',
                          style: TextStyle(
                            fontSize: 13,
                            color: separatorColor,
                          ),
                        ),
                        _FooterLink(
                          text: l10n.restore,
                          onTap: () async {
                            final restored =
                                await PurchaseService.instance
                                    .restorePurchases();
                            if (!context.mounted) return;
                            showAppMessage(
                              context,
                              restored
                                  ? l10n.restoreSuccess
                                  : l10n.restoreNothingToRestore,
                              type: restored
                                  ? AppMessageType.success
                                  : AppMessageType.error,
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PremiumHeroCard extends StatelessWidget {
  const _PremiumHeroCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 0),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(
                alpha: 0.10,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_fire_department,
              size: 22,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            l10n.premiumTab,
            style: GoogleFonts.lato(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: theme.colorScheme.onSurface,
              letterSpacing: -0.9,
            ),
          ),
        ],
      ),
    );
  }
}

// Supporting line above CTA button
class _SupportingLine extends StatelessWidget {
  final _PlanSelectionNotifier selectionNotifier;

  const _SupportingLine({required this.selectionNotifier});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appColors = theme.extension<AppColors>()!;

    return ValueListenableBuilder<PlanType>(
      valueListenable: selectionNotifier,
      builder: (context, selectedPlan, child) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            selectedPlan == PlanType.yearly
                ? l10n.mostChosen
                : l10n.canChangeAnytime,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.72)
                  : appColors.mutedText,
              letterSpacing: -0.1,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}

// Enum for plan selection
enum PlanType { monthly, yearly, lifetime }

// Shared state for plan selection
class _PlanSelectionNotifier extends ValueNotifier<PlanType> {
  _PlanSelectionNotifier() : super(PlanType.yearly); // Default to yearly
}

// Plan selector with Monthly, Yearly, and Lifetime options
class _PlanSelector extends StatefulWidget {
  final _PlanSelectionNotifier? selectionNotifier;
  final Offering? offering;

  const _PlanSelector({this.selectionNotifier, this.offering});

  @override
  State<_PlanSelector> createState() => _PlanSelectorState();
}

class _PlanSelectorState extends State<_PlanSelector> {
  late _PlanSelectionNotifier _notifier;
  late PlanType _selectedPlan;
  @override
  void initState() {
    super.initState();
    _notifier = widget.selectionNotifier ?? _PlanSelectionNotifier();
    _selectedPlan = _notifier.value;
    _notifier.addListener(_onSelectionChanged);
  }

  @override
  void dispose() {
    if (widget.selectionNotifier == null) {
      _notifier.dispose();
    } else {
      _notifier.removeListener(_onSelectionChanged);
    }
    super.dispose();
  }

  void _onSelectionChanged() {
    setState(() {
      _selectedPlan = _notifier.value;
    });
  }

  // Placeholder pricing shown before RevenueCat offerings finish loading (or
  // if the "default" offering isn't configured yet in the dashboard).
  static const double _placeholderMonthlyPrice = 1900.0; // KRW
  static const double _placeholderYearlyPrice = 5900.0; // KRW
  static const double _placeholderLifetimePrice = 19900.0; // KRW

  String _placeholderFormattedPrice(BuildContext context, double price) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    return intl.NumberFormat.simpleCurrency(
      locale: locale,
      name: 'KRW',
      decimalDigits: 0,
    ).format(price);
  }

  /// Real price if the package loaded from RevenueCat, otherwise the
  /// placeholder KRW price so the paywall still renders something sane.
  String _priceFor(BuildContext context, Package? package, double placeholder) {
    final storeProduct = package?.storeProduct;
    if (storeProduct != null) return storeProduct.priceString;
    return _placeholderFormattedPrice(context, placeholder);
  }

  double _priceValueFor(Package? package, double placeholder) {
    return package?.storeProduct.price ?? placeholder;
  }

  int? _savingsPercent({
    required double periodMonths,
    required double periodPrice,
    required double monthlyPrice,
  }) {
    final monthlyTotal = monthlyPrice * periodMonths;
    if (monthlyTotal <= 0) return null;
    final percent = ((monthlyTotal - periodPrice) / monthlyTotal * 100).round();
    return percent > 0 ? percent : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final offering = widget.offering;

    final monthlyPackage = offering?.monthly;
    final yearlyPackage = offering?.annual;
    final lifetimePackage = offering?.lifetime;

    final monthlyPriceValue =
        _priceValueFor(monthlyPackage, _placeholderMonthlyPrice);
    final yearlyPriceValue =
        _priceValueFor(yearlyPackage, _placeholderYearlyPrice);
    final lifetimePriceValue =
        _priceValueFor(lifetimePackage, _placeholderLifetimePrice);

    return Column(
      children: [
        // Monthly plan (first option)
        _PlanCard(
          title: l10n.monthly,
          price: _priceFor(context, monthlyPackage, _placeholderMonthlyPrice),
          period: l10n.perMonth,
          isSelected: _selectedPlan == PlanType.monthly,
          isPrimary: false,
          onTap: () {
            _notifier.value = PlanType.monthly;
          },
        ),
        const SizedBox(height: 14),
        // Yearly plan (second option)
        Stack(
          clipBehavior: Clip.none,
          children: [
            _PlanCard(
              title: l10n.yearly,
              price: _priceFor(context, yearlyPackage, _placeholderYearlyPrice),
              period: l10n.perYear,
              isSelected: _selectedPlan == PlanType.yearly,
              savingsPercent: _savingsPercent(
                periodMonths: 12,
                periodPrice: yearlyPriceValue,
                monthlyPrice: monthlyPriceValue,
              ),
              isPrimary: true,
              onTap: () {
                _notifier.value = PlanType.yearly;
              },
            ),
          ],
        ),
        const SizedBox(height: 14),
        // Lifetime plan (third option)
        Stack(
          clipBehavior: Clip.none,
          children: [
            _PlanCard(
              title: l10n.lifetime,
              price:
                  _priceFor(context, lifetimePackage, _placeholderLifetimePrice),
              period: l10n.oneTime,
              isSelected: _selectedPlan == PlanType.lifetime,
              savingsPercent: _savingsPercent(
                periodMonths: 12 * 5, // Compare to 5 years of monthly billing
                periodPrice: lifetimePriceValue,
                monthlyPrice: monthlyPriceValue,
              ),
              isPrimary: true,
              onTap: () {
                _notifier.value = PlanType.lifetime;
              },
            ),
          ],
        ),
      ],
    );
  }
}

// Individual plan card
class _PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String period;
  final bool isSelected;
  final int? savingsPercent;
  final bool isPrimary;
  final VoidCallback onTap;

  const _PlanCard({
    required this.title,
    required this.price,
    required this.period,
    required this.isSelected,
    this.savingsPercent,
    this.isPrimary = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appColors = theme.extension<AppColors>()!;
    final cardPadding = isPrimary ? 24.0 : 20.0;
    final baseColor = isDark
        ? (isSelected ? appColors.surfaceElevated : theme.colorScheme.surface)
        : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.9)
                : (isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : appColors.border),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.12),
                    blurRadius: 22,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ]
              : AppShadows.elevatedSoft,
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : Colors.white.withValues(alpha: 0.28),
                  width: 1.8,
                ),
                color:
                    isSelected ? theme.colorScheme.primary : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: theme.colorScheme.onPrimary,
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: isPrimary ? 18 : 17,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                            letterSpacing: -0.45,
                          ),
                        ),
                      ),
                      if (savingsPercent != null) ...[
                        const SizedBox(width: 8),
                        Builder(
                          builder: (context) {
                            final l10n = AppLocalizations.of(context)!;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                l10n.savePercent(
                                  LocalizedFormat.percent(
                                    context,
                                    savingsPercent! / 100,
                                  ),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: theme.colorScheme.primary,
                                  letterSpacing: -0.15,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Flexible(
                        child: Text(
                          price,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.lato(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.onSurface,
                            letterSpacing: -0.8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          period,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.52)
                                : appColors.mutedText,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Benefits list widget with loss-aversion wording
class _BenefitsList extends StatelessWidget {
  const _BenefitsList();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appColors = theme.extension<AppColors>()!;
    final benefits = [
      _BenefitItem(
        icon: Icons.record_voice_over,
        text: l10n.benefitVoiceCoaching,
      ),
      _BenefitItem(
        icon: Icons.notifications_active_outlined,
        text: l10n.benefitBackgroundIntervalNotifications,
      ),
      _BenefitItem(
        icon: Icons.fitness_center,
        text: l10n.benefitCycleStairmasterRoutines,
      ),
      _BenefitItem(
        icon: Icons.bookmark_added,
        text: l10n.benefitUnlimitedRoutinesNew,
      ),
      _BenefitItem(
        icon: Icons.monitor_weight,
        text: l10n.benefitWeightFeature,
      ),
      _BenefitItem(
        icon: Icons.do_not_disturb_alt,
        text: l10n.benefitNoAdsFocus,
      ),
      _BenefitItem(
        icon: Icons.auto_awesome,
        text: l10n.benefitFutureFeaturesNew,
      ),
    ];

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111317) : Colors.white,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : appColors.border,
            ),
            boxShadow: AppShadows.elevatedSoft,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          child: Column(
            children: [
              for (int i = 0; i < benefits.length; i++) ...[
                _BenefitListItem(item: benefits[i]),
                if (i < benefits.length - 1)
                  Divider(
                    height: 1,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.08)
                        : appColors.border,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _BenefitItem {
  final IconData icon;
  final String text;

  const _BenefitItem({
    required this.icon,
    required this.text,
  });
}

class _BenefitListItem extends StatelessWidget {
  final _BenefitItem item;

  const _BenefitListItem({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0x19FF453A)
                  : theme.colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item.icon,
              size: 18,
              color: const Color(0xFFFF5A52),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                item.text,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                  letterSpacing: -0.3,
                  height: 1.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Footer link widget
class _FooterLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const _FooterLink({
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appColors = theme.extension<AppColors>()!;

    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark
              ? Colors.white.withValues(alpha: 0.6)
              : appColors.mutedText,
          letterSpacing: -0.05,
        ),
      ),
    );
  }
}
