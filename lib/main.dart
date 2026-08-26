import 'dart:async';

import 'package:adaptive_platform_ui/adaptive_platform_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:valcue/l10n/app_localizations.dart';
import 'package:valcue/l10n/supported_app_language.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'app_shell/app_shell.dart';
import 'app_settings/app_settings_provider.dart';
import 'features/routines/storage/routine_provider.dart';
import 'features/profile/providers/workout_history_provider.dart';
import 'features/profile/providers/weight_tracker_provider.dart';
import 'features/profile/providers/achievement_provider.dart';
import 'theme/app_theme.dart';
import 'services/sound_service.dart';
import 'services/ad_service.dart';
import 'services/purchase_service.dart';
import 'services/app_error_service.dart';
import 'services/voice_guide_service.dart';
import 'services/workout_live_activity_service.dart';
import 'services/workout_reminder_service.dart';
import 'services/analytics_service.dart';
import 'onboarding/onboarding_flow.dart';
import 'firebase_options.dart';

const _appDisplayName = 'Valcue';

void _debugLog(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await AppErrorService.instance.init();
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      unawaited(
        AppErrorService.instance.recordFlutterError(details, fatal: true),
      );
    };
    WidgetsBinding.instance.platformDispatcher.onError = (error, stack) {
      unawaited(
        AppErrorService.instance.recordError(
          error,
          stack,
          source: 'platform',
          fatal: true,
        ),
      );
      return true;
    };

    await _bootstrapApp();
  }, (error, stack) {
    unawaited(
      AppErrorService.instance.recordError(
        error,
        stack,
        source: 'zone',
        fatal: true,
      ),
    );
  });
}

Future<void> _bootstrapApp() async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await AnalyticsService.instance.init();
  } catch (error, stack) {
    await AppErrorService.instance.recordError(
      error,
      stack,
      source: 'firebase_bootstrap',
      fatal: false,
    );
  }

  // Hide Android system navigation bar with maximum intensity
  const platform = MethodChannel('com.nogic.valcue/system');
  try {
    await platform.invokeMethod('hideSystemUI');
  } catch (e) {
    _debugLog('Failed to hide system UI via platform channel: $e');
  }

  // Flutter-side backup: Hide Android system navigation bar completely
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Initialize sound service
  await SoundService().init();
  await WorkoutReminderService.instance.init();
  await WorkoutLiveActivityService.instance.cleanup();

  // Initialize RevenueCat (with error handling - app should still work if
  // purchases are unavailable, e.g. no network on first launch)
  try {
    await PurchaseService.instance.init();
  } catch (e) {
    _debugLog('RevenueCat initialization failed: $e');
  }

  // Initialize Google Mobile Ads (with error handling)
  try {
    _debugLog('Initializing Google Mobile Ads...');
    await MobileAds.instance.initialize();
    _debugLog('Google Mobile Ads initialized successfully');
    // Preload interstitial ad for workout start
    _debugLog('Preloading interstitial ad...');
    AdService().loadAd();
  } catch (e) {
    // If ad initialization fails, app should still work
    // Ads are optional for testing
    _debugLog('Ad initialization failed: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettingsProvider()),
        ChangeNotifierProvider(create: (_) => RoutineProvider()),
        ChangeNotifierProvider(create: (_) => WorkoutHistoryProvider()),
        ChangeNotifierProvider(create: (_) => WeightTrackerProvider()),
        ChangeNotifierProxyProvider<WorkoutHistoryProvider,
            AchievementProvider>(
          create: (context) => AchievementProvider(
            Provider.of<WorkoutHistoryProvider>(context, listen: false),
          ),
          update: (context, historyProvider, previous) {
            if (previous == null) {
              return AchievementProvider(historyProvider);
            }
            previous.updateHistoryProvider(historyProvider);
            return previous;
          },
        ),
      ],
      child: Consumer<AppSettingsProvider>(
        builder: (context, settingsProvider, child) {
          const localizationsDelegates = [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ];
          final supportedLocales = SupportedAppLanguage.locales;
          final lightTheme = AppTheme.forLocale(
            AppTheme.lightTheme,
            settingsProvider.locale,
          );
          final darkTheme = AppTheme.forLocale(
            AppTheme.darkTheme,
            settingsProvider.locale,
          );
          final home = OnboardingGate(
            home: AppShell(key: AppShell.globalKey),
          );

          Widget appBuilder({required Widget? child}) {
            final themeMode = settingsProvider.themeModeEnum;
            final platformBrightness = MediaQuery.platformBrightnessOf(context);
            final isDark = themeMode == ThemeMode.dark ||
                (themeMode == ThemeMode.system &&
                    platformBrightness == Brightness.dark);
            final materialTheme = isDark ? darkTheme : lightTheme;

            // IMPORTANT: This builder runs under Localizations, so we can safely
            // read locale and react to runtime changes.
            final originalMediaQuery = MediaQuery.of(context);
            final actualWidth = originalMediaQuery.size.width;
            final actualHeight = originalMediaQuery.size.height;

            // baseline 가로 해상도 (기기 너비가 375보다 작으면 비율 축소)
            const double baselineWidth = 375.0;
            final double scale =
                (actualWidth > 0 && actualWidth < baselineWidth)
                    ? actualWidth / baselineWidth
                    : 1.0;

            // 시스템 글자 크기를 아무리 키워도 앱 레이아웃이 깨지지 않도록
            // 최대 1.3배까지만 허용한다.
            final clampedTextScaler =
                originalMediaQuery.textScaler.clamp(maxScaleFactor: 1.3);

            final mediaQueryData = originalMediaQuery.copyWith(
              textScaler: clampedTextScaler,
              size: scale < 1.0
                  ? Size(baselineWidth, actualHeight / scale)
                  : originalMediaQuery.size,
              padding: scale < 1.0
                  ? originalMediaQuery.padding * (1 / scale)
                  : originalMediaQuery.padding,
              viewInsets: scale < 1.0
                  ? originalMediaQuery.viewInsets * (1 / scale)
                  : originalMediaQuery.viewInsets,
              viewPadding: scale < 1.0
                  ? originalMediaQuery.viewPadding * (1 / scale)
                  : originalMediaQuery.viewPadding,
            );

            Widget mainContent = Theme(
              data: materialTheme,
              child: HeroMode(
                enabled: false,
                child: ScaffoldMessenger(
                  child: _VoiceGuideBootstrap(
                    voiceEnabled: settingsProvider.voiceGuideEnabled,
                    child: child ?? const SizedBox.shrink(),
                  ),
                ),
              ),
            );

            if (scale < 1.0) {
              mainContent = FractionallySizedBox(
                widthFactor: 1 / scale,
                heightFactor: 1 / scale,
                alignment: AlignmentDirectional.topStart,
                child: Transform.scale(
                  scale: scale,
                  alignment: AlignmentDirectional.topStart,
                  child: mainContent,
                ),
              );
            }

            return MediaQuery(
              data: mediaQueryData,
              child: mainContent,
            );
          }

          if (PlatformInfo.isIOS) {
            return AdaptiveApp(
              title: _appDisplayName,
              themeMode: settingsProvider.themeModeEnum,
              materialLightTheme: lightTheme,
              materialDarkTheme: darkTheme,
              cupertinoLightTheme: const CupertinoThemeData(
                brightness: Brightness.light,
              ),
              cupertinoDarkTheme: const CupertinoThemeData(
                brightness: Brightness.dark,
              ),
              builder: (context, child) => appBuilder(child: child),
              localizationsDelegates: localizationsDelegates,
              supportedLocales: supportedLocales,
              locale: settingsProvider.locale,
              home: home,
            );
          }

          return MaterialApp(
            title: _appDisplayName,
            themeMode: settingsProvider.themeModeEnum,
            theme: lightTheme,
            darkTheme: darkTheme,
            builder: (context, child) => appBuilder(child: child),
            localizationsDelegates: localizationsDelegates,
            supportedLocales: supportedLocales,
            locale: settingsProvider.locale,
            home: home,
          );
        },
      ),
    );
  }
}

/// Bootstraps VoiceGuideService and keeps it in sync with:
/// - runtime locale switching
/// - settings toggle (voiceEnabled)
class _VoiceGuideBootstrap extends StatefulWidget {
  final bool voiceEnabled;
  final Widget child;

  const _VoiceGuideBootstrap({
    required this.voiceEnabled,
    required this.child,
  });

  @override
  State<_VoiceGuideBootstrap> createState() => _VoiceGuideBootstrapState();
}

class _VoiceGuideBootstrapState extends State<_VoiceGuideBootstrap>
    with WidgetsBindingObserver {
  Locale? _lastLocale;
  bool? _lastEnabled;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _hideSystemUI();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
    const platform = MethodChannel('com.nogic.valcue/system');
    platform.invokeMethod('hideSystemUI').catchError((e) {
      _debugLog('Failed to hide system UI: $e');
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _hideSystemUI();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(covariant _VoiceGuideBootstrap oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _sync() {
    final locale = Localizations.maybeLocaleOf(context) ?? const Locale('en');
    final enabled = widget.voiceEnabled;

    // Avoid redundant async calls on rebuilds.
    final localeChanged =
        _lastLocale?.toLanguageTag() != locale.toLanguageTag();
    final enabledChanged = _lastEnabled != enabled;

    if (_lastLocale == null || _lastEnabled == null) {
      _lastLocale = locale;
      _lastEnabled = enabled;
      VoiceGuideService.instance.init(
        locale: locale,
        voiceEnabled: enabled,
      );
      return;
    }

    if (localeChanged || enabledChanged) {
      _lastLocale = locale;
      _lastEnabled = enabled;
      VoiceGuideService.instance.init(
        locale: locale,
        voiceEnabled: enabled,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
