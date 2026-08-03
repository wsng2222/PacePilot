import 'package:shared_preferences/shared_preferences.dart';

enum OnboardingLevel {
  beginner,
  intermediate,
  advanced,
}

enum SpeedUnit {
  kmh,
  mph,
}

enum WeightUnit {
  kg,
  lbs,
}

class OnboardingStorage {
  // New keys (requested)
  static const _kOnboardingCompleted = 'onboardingCompleted';
  static const _kSelectedFitnessLevel = 'selectedFitnessLevel';
  static const _kSpeedUnit = 'speedUnit';
  static const _kWeightUnit = 'weightUnit';

  // Backward-compat keys (previous implementation)
  static const _kOnboardingCompleteLegacy = 'onboarding_complete';
  static const _kOnboardingLevelLegacy = 'onboarding_level';
  static const _kSpeedUnitLegacy = 'speed_unit';
  static const _kWeightUnitLegacy = 'weight_unit';

  static Future<bool> isComplete() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_kOnboardingCompleted) ??
        prefs.getBool(_kOnboardingCompleteLegacy) ??
        false;
  }

  static Future<void> setComplete(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kOnboardingCompleted, value);
    // Keep legacy in sync (safe for older builds).
    await prefs.setBool(_kOnboardingCompleteLegacy, value);
  }

  static Future<void> setLevel(OnboardingLevel level) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSelectedFitnessLevel, level.name);
    await prefs.setString(_kOnboardingLevelLegacy, level.name);
  }

  static Future<OnboardingLevel?> getLevel() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kSelectedFitnessLevel) ??
        prefs.getString(_kOnboardingLevelLegacy);
    if (raw == null) return null;
    return OnboardingLevel.values
        .cast<OnboardingLevel?>()
        .firstWhere((e) => e?.name == raw, orElse: () => null);
  }

  static Future<void> setSpeedUnit(SpeedUnit unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kSpeedUnit, unit.name);
    await prefs.setString(_kSpeedUnitLegacy, unit.name);
  }

  static Future<SpeedUnit?> getSpeedUnit() async {
    final prefs = await SharedPreferences.getInstance();
    final raw =
        prefs.getString(_kSpeedUnit) ?? prefs.getString(_kSpeedUnitLegacy);
    if (raw == null) return null;
    return SpeedUnit.values
        .cast<SpeedUnit?>()
        .firstWhere((e) => e?.name == raw, orElse: () => null);
  }

  static Future<void> setWeightUnit(WeightUnit unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kWeightUnit, unit.name);
    await prefs.setString(_kWeightUnitLegacy, unit.name);
  }

  static Future<WeightUnit?> getWeightUnit() async {
    final prefs = await SharedPreferences.getInstance();
    final raw =
        prefs.getString(_kWeightUnit) ?? prefs.getString(_kWeightUnitLegacy);
    if (raw == null) return null;
    return WeightUnit.values
        .cast<WeightUnit?>()
        .firstWhere((e) => e?.name == raw, orElse: () => null);
  }

  static const _kLastEnteredWeightKg = 'last_entered_weight_kg';

  static Future<void> setSavedWeightKg(double weightKg) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_kLastEnteredWeightKg, weightKg);
  }

  static Future<double?> getSavedWeightKg() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_kLastEnteredWeightKg);
  }
}
