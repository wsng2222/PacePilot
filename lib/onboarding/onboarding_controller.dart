import 'package:flutter/foundation.dart';

import '../app_settings/app_settings_provider.dart';
import 'onboarding_storage.dart';

class OnboardingController extends ChangeNotifier {
  OnboardingController({
    this.initialPage = 0,
  })  : currentPage = initialPage,
        level = OnboardingLevel.intermediate,
        speedUnit = SpeedUnit.kmh,
        weightUnit = WeightUnit.kg;

  final int initialPage;

  int currentPage;
  OnboardingLevel level;
  SpeedUnit speedUnit;
  WeightUnit weightUnit;

  bool get isLastPage => currentPage >= 9;

  void setPage(int page) {
    if (page == currentPage) return;
    currentPage = page;
    notifyListeners();
  }

  void selectLevel(OnboardingLevel value) {
    if (value == level) return;
    level = value;
    notifyListeners();
  }

  void selectSpeedUnit(SpeedUnit value) {
    if (value == speedUnit) return;
    speedUnit = value;
    notifyListeners();
  }

  void selectWeightUnit(WeightUnit value) {
    if (value == weightUnit) return;
    weightUnit = value;
    notifyListeners();
  }

  Future<void> complete(AppSettingsProvider settingsProvider) async {
    await OnboardingStorage.setLevel(level);
    await OnboardingStorage.setSpeedUnit(speedUnit);
    await OnboardingStorage.setWeightUnit(weightUnit);
    await OnboardingStorage.setComplete(true);

    // Apply unit selections to app settings immediately.
    await settingsProvider
        .updateMeasurement(speedUnit == SpeedUnit.kmh ? 'kmh' : 'mph');
    await settingsProvider
        .updateWeightUnit(weightUnit == WeightUnit.kg ? 'kg' : 'lbs');
  }
}
