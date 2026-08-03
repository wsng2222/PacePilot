import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;
import 'app_settings_model.dart';
import 'app_settings_store.dart';
import '../services/purchase_service.dart';
import '../services/sound_service.dart';
import '../services/workout_live_activity_service.dart';
import '../services/workout_reminder_service.dart';
import '../l10n/supported_app_language.dart';

class AppSettingsProvider with ChangeNotifier {
  final AppSettingsStore _store;
  final Future<bool> Function() _requestWorkoutNotificationPermissions;
  final Future<bool> Function() _areLiveActivitiesEnabled;
  final Future<void> Function() _cancelWorkoutIntervalNotifications;
  final Future<void> Function() _cleanupLiveActivities;

  AppSettings _settings;
  bool _isLoading = false;
  int _backgroundCoachingMutationGeneration = 0;
  Future<void> _backgroundCoachingCleanupTail = Future<void>.value();
  Future<void> _settingsWriteTail = Future<void>.value();

  AppSettings get settings => _settings;
  bool get isLoading => _isLoading;

  String get language => _getResolvedLanguage();
  String get measurement => _settings.measurement;
  String get weightUnit => _settings.weightUnit;
  bool get isPremium => _settings.isPremium;
  bool get voiceGuideEnabled =>
      _settings.isPremium ? _settings.voiceGuideEnabled : false;
  bool get backgroundIntervalNotificationsEnabled => _settings.isPremium
      ? _settings.backgroundIntervalNotificationsEnabled
      : false;
  String get themeMode => _settings.themeMode;
  bool get soundEffectsEnabled => _settings.soundEffectsEnabled;
  bool get workoutReminderEnabled => _settings.workoutReminderEnabled;
  WorkoutDisplaySize get workoutDisplaySize => _settings.workoutDisplaySize;
  List<int> get workoutReminderWeekdays =>
      List<int>.unmodifiable(_settings.workoutReminderWeekdays);
  TimeOfDay get workoutReminderTime => TimeOfDay(
        hour: _settings.workoutReminderHour,
        minute: _settings.workoutReminderMinute,
      );

  // Countdown timing setting getter
  List<int> get voiceGuideCountdownTriggers =>
      List<int>.unmodifiable(_settings.voiceGuideCountdownTriggers);

  /// Resolve language: use device language if supported, otherwise fallback to English
  String _getResolvedLanguage() {
    final storedLanguage = _settings.language;
    if (storedLanguage != null) {
      final base = storedLanguage.toLowerCase().split(RegExp('[-_]')).first;
      if (base == 'no') return 'nb';
      if (SupportedAppLanguage.supports(base)) return base;
    }
    // Get device language
    final deviceLocale = ui.PlatformDispatcher.instance.locale;
    final deviceLang = deviceLocale.languageCode;

    // If device language is supported, use it; otherwise fallback to English
    if (SupportedAppLanguage.supports(deviceLang)) {
      return deviceLang;
    }
    return 'en'; // Fallback to English
  }

  /// Get current locale
  Locale get locale {
    return SupportedAppLanguage.fromCode(_getResolvedLanguage()).locale;
  }

  AppSettingsProvider({
    AppSettingsStore? store,
    AppSettings? initialSettings,
    bool loadSettingsOnCreate = true,
    Future<bool> Function()? requestWorkoutNotificationPermissions,
    Future<bool> Function()? areLiveActivitiesEnabled,
    Future<void> Function()? cancelWorkoutIntervalNotifications,
    Future<void> Function()? cleanupLiveActivities,
  })  : _store = store ?? AppSettingsStore(),
        _settings = initialSettings ?? AppSettings.defaultSettings,
        _requestWorkoutNotificationPermissions =
            requestWorkoutNotificationPermissions ??
                WorkoutReminderService.instance.requestPermissions,
        _areLiveActivitiesEnabled = areLiveActivitiesEnabled ??
            WorkoutLiveActivityService.instance.areActivitiesEnabled,
        _cancelWorkoutIntervalNotifications =
            cancelWorkoutIntervalNotifications ??
                WorkoutReminderService
                    .instance.cancelWorkoutIntervalNotifications,
        _cleanupLiveActivities = cleanupLiveActivities ??
            WorkoutLiveActivityService.instance.cleanup {
    PurchaseService.instance.isPremiumListenable.addListener(
      _onEntitlementChanged,
    );
    if (loadSettingsOnCreate) {
      // loadSettings() applies the current entitlement itself once the
      // on-disk settings have finished loading, to avoid a race where this
      // synchronous check would otherwise be clobbered by the async load.
      loadSettings();
    } else {
      // No async load in flight (e.g. tests supplying initialSettings) -
      // safe to apply immediately.
      _onEntitlementChanged();
    }
  }

  /// Keeps [isPremium] in sync with the RevenueCat entitlement status.
  /// Runs whenever a purchase completes, a subscription renews/expires, or
  /// the SDK reports the initial cached customer info. A `null` value means
  /// the SDK hasn't resolved anything yet, so the local setting is left
  /// untouched rather than being coerced to non-premium.
  void _onEntitlementChanged() {
    final active = PurchaseService.instance.isPremiumListenable.value;
    if (active == null) return;
    if (active != _settings.isPremium) {
      updatePremium(active);
    }
  }

  /// Applies the current entitlement status to [_settings] in-memory,
  /// without triggering [updatePremium]'s save/notify side effects. Used
  /// right after loading settings from disk during [loadSettings].
  void _applyEntitlementStatusInPlace() {
    final active = PurchaseService.instance.isPremiumListenable.value;
    if (active == null) return;
    if (active != _settings.isPremium) {
      _settings = _settings.copyWith(
        isPremium: active,
        voiceGuideEnabled: active ? _settings.voiceGuideEnabled : false,
      );
    }
  }

  @override
  void dispose() {
    PurchaseService.instance.isPremiumListenable.removeListener(
      _onEntitlementChanged,
    );
    super.dispose();
  }

  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();
    _settings = await _store.loadSettings();
    _applyEntitlementStatusInPlace();
    // Sync sound service with loaded settings
    SoundService().setEnabled(_settings.soundEffectsEnabled);
    await _syncWorkoutReminder();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateLanguage(String language) async {
    final base = language.toLowerCase().split(RegExp('[-_]')).first;
    final normalized =
        base == 'no' ? 'nb' : SupportedAppLanguage.fromCode(base).code;
    _settings = _settings.copyWith(language: normalized);
    await _saveSettingsInOrder(_settings);
    await _syncWorkoutReminder();
    notifyListeners();
  }

  Future<void> resetLanguageToSystem() async {
    _settings = AppSettings(
      language: null,
      measurement: _settings.measurement,
      weightUnit: _settings.weightUnit,
      isPremium: _settings.isPremium,
      voiceGuideEnabled: _settings.voiceGuideEnabled,
      backgroundIntervalNotificationsEnabled:
          _settings.backgroundIntervalNotificationsEnabled,
      themeMode: _settings.themeMode,
      themeModeUserSet: _settings.themeModeUserSet,
      soundEffectsEnabled: _settings.soundEffectsEnabled,
      workoutReminderEnabled: _settings.workoutReminderEnabled,
      workoutReminderWeekdays:
          List<int>.from(_settings.workoutReminderWeekdays),
      workoutReminderHour: _settings.workoutReminderHour,
      workoutReminderMinute: _settings.workoutReminderMinute,
      workoutReminderMessage: _settings.workoutReminderMessage,
      workoutDisplaySize: _settings.workoutDisplaySize,
      voiceGuideCountdownTriggers:
          List<int>.from(_settings.voiceGuideCountdownTriggers),
    );
    await _saveSettingsInOrder(_settings);
    await _syncWorkoutReminder();
    notifyListeners();
  }

  Future<void> updateMeasurement(String measurement) async {
    _settings = _settings.copyWith(measurement: measurement);
    await _saveSettingsInOrder(_settings);
    notifyListeners();
  }

  Future<void> updateWeightUnit(String weightUnit) async {
    _settings = _settings.copyWith(weightUnit: weightUnit);
    await _saveSettingsInOrder(_settings);
    notifyListeners();
  }

  Future<void> updateWorkoutDisplaySize(WorkoutDisplaySize size) async {
    if (_settings.workoutDisplaySize == size) return;
    _settings = _settings.copyWith(workoutDisplaySize: size);
    notifyListeners();
    await _saveSettingsInOrder(_settings);
  }

  Future<void> updatePremium(bool isPremium) async {
    if (!isPremium) {
      // Invalidate an in-flight enable before it can commit after entitlement
      // revocation. The preference itself is preserved for a future renewal.
      _backgroundCoachingMutationGeneration++;
    }

    _settings = _settings.copyWith(
      isPremium: isPremium,
      voiceGuideEnabled: isPremium ? _settings.voiceGuideEnabled : false,
    );
    final settingsSnapshot = _settings;
    notifyListeners();

    final save = _saveSettingsInOrder(settingsSnapshot);
    if (!isPremium) {
      final cleanup = _queueBackgroundCoachingCleanup();
      await Future.wait<void>([save, cleanup]);
      return;
    }
    await save;
  }

  Future<void> updateVoiceGuide(bool enabled) async {
    if (!_settings.isPremium && enabled) {
      return; // Cannot enable voice guide without premium
    }
    _settings = _settings.copyWith(voiceGuideEnabled: enabled);
    await _saveSettingsInOrder(_settings);
    notifyListeners();
  }

  Future<void> updateVoiceGuideCountdownTriggers(List<int> triggers) async {
    final sortedTriggers = List<int>.from(triggers)..sort();
    _settings = _settings.copyWith(voiceGuideCountdownTriggers: sortedTriggers);
    await _saveSettingsInOrder(_settings);
    notifyListeners();
  }

  Future<bool> updateBackgroundIntervalNotifications(bool enabled) async {
    final generation = ++_backgroundCoachingMutationGeneration;

    if (enabled) {
      if (!_settings.isPremium) return false;

      // Live Activity is the primary iOS surface. Notification permission is
      // still requested so local alerts are ready if Live Activity is
      // unavailable or fails when a workout starts.
      final liveActivitiesEnabled =
          await _readCapability(_areLiveActivitiesEnabled);
      if (!_isCurrentBackgroundEnable(generation)) return true;

      final notificationsGranted = await _readCapability(
        _requestWorkoutNotificationPermissions,
      );
      if (!_isCurrentBackgroundEnable(generation)) return true;

      if (!notificationsGranted && !liveActivitiesEnabled) return false;

      // A preceding OFF may still be cleaning native state. Never publish a
      // newer ON until that cleanup has completed.
      await _backgroundCoachingCleanupTail;
      if (!_isCurrentBackgroundEnable(generation)) return true;

      _settings = _settings.copyWith(
        backgroundIntervalNotificationsEnabled: true,
      );
      final settingsSnapshot = _settings;
      notifyListeners();
      await _saveSettingsInOrder(settingsSnapshot);
      return true;
    }

    _settings = _settings.copyWith(
      backgroundIntervalNotificationsEnabled: false,
    );
    final settingsSnapshot = _settings;
    notifyListeners();
    final save = _saveSettingsInOrder(settingsSnapshot);
    final cleanup = _queueBackgroundCoachingCleanup();
    await Future.wait<void>([save, cleanup]);
    return true;
  }

  bool _isCurrentBackgroundEnable(int generation) {
    return generation == _backgroundCoachingMutationGeneration &&
        _settings.isPremium;
  }

  Future<bool> _readCapability(Future<bool> Function() read) async {
    try {
      return await read();
    } catch (_) {
      return false;
    }
  }

  Future<void> _saveSettingsInOrder(AppSettings settings) {
    final operation =
        _settingsWriteTail.then((_) => _store.saveSettings(settings));
    _settingsWriteTail = operation.then<void>(
      (_) {},
      onError: (Object _, StackTrace __) {},
    );
    return operation;
  }

  Future<void> _queueBackgroundCoachingCleanup() {
    final operation = _backgroundCoachingCleanupTail.then((_) async {
      try {
        await _cancelWorkoutIntervalNotifications();
      } finally {
        await _cleanupLiveActivities();
      }
    });
    _backgroundCoachingCleanupTail = operation.then<void>(
      (_) {},
      onError: (Object _, StackTrace __) {},
    );
    return operation;
  }

  Future<void> updateThemeMode(String themeMode) async {
    _settings = _settings.copyWith(themeMode: themeMode);
    await _saveSettingsInOrder(_settings);
    notifyListeners();
  }

  Future<void> updateSoundEffects(bool enabled) async {
    _settings = _settings.copyWith(soundEffectsEnabled: enabled);
    await _saveSettingsInOrder(_settings);
    // Sync sound service with updated setting
    SoundService().setEnabled(enabled);
    notifyListeners();
  }

  Future<bool> updateWorkoutReminderEnabled(bool enabled) async {
    if (enabled) {
      final granted =
          await WorkoutReminderService.instance.requestPermissions();
      if (!granted) {
        return false;
      }
    }

    _settings = _settings.copyWith(workoutReminderEnabled: enabled);
    await _saveSettingsInOrder(_settings);
    await _syncWorkoutReminder();
    notifyListeners();
    return true;
  }

  Future<void> updateWorkoutReminderWeekdays(List<int> weekdays) async {
    final normalized = weekdays
        .where((day) => day >= DateTime.monday && day <= DateTime.sunday)
        .toSet()
        .toList()
      ..sort();
    if (normalized.isEmpty) return;

    _settings = _settings.copyWith(workoutReminderWeekdays: normalized);
    await _saveSettingsInOrder(_settings);
    await _syncWorkoutReminder();
    notifyListeners();
  }

  Future<void> updateWorkoutReminderTime(TimeOfDay time) async {
    _settings = _settings.copyWith(
      workoutReminderHour: time.hour,
      workoutReminderMinute: time.minute,
    );
    await _saveSettingsInOrder(_settings);
    await _syncWorkoutReminder();
    notifyListeners();
  }

  /// Get ThemeMode enum from stored string value
  /// Only supports 'light' and 'dark' (system option removed)
  ThemeMode get themeModeEnum {
    switch (_settings.themeMode) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
      default:
        return ThemeMode.light;
    }
  }

  /// Format speed for DISPLAY ONLY - NEVER save this formatted string back to storage
  /// Storage always uses speedX10 (int) in base units (km/h)
  /// This method converts km/h to mph for display if needed, but does NOT mutate stored values
  String formatSpeed(double speedKmh) {
    final formatter = NumberFormat.decimalPattern(locale.toLanguageTag())
      ..minimumFractionDigits = 1
      ..maximumFractionDigits = 1;
    if (_settings.measurement == 'mph') {
      // Convert to mph for display ONLY - storage remains in km/h (speedX10)
      final mph = speedKmh * 0.621371;
      return '${formatter.format(mph)} mph';
    }
    return '${formatter.format(speedKmh)} km/h';
  }

  Future<void> _syncWorkoutReminder() async {
    await WorkoutReminderService.instance.syncSchedule(
      enabled: _settings.workoutReminderEnabled,
      weekdays: _settings.workoutReminderWeekdays,
      hour: _settings.workoutReminderHour,
      minute: _settings.workoutReminderMinute,
      languageCode: _getResolvedLanguage(),
    );
  }
}
