class CustomRoutineUnits {
  const CustomRoutineUnits._();

  static const double milesPerKilometer = 0.621371192237334;
  static const double poundsPerKilogram = 2.2046226218487757;

  static double distanceForDisplay(
    double distanceKm, {
    required bool useMiles,
  }) {
    return useMiles ? distanceKm * milesPerKilometer : distanceKm;
  }

  static double distanceToKilometers(
    double displayDistance, {
    required bool useMiles,
  }) {
    return useMiles ? displayDistance / milesPerKilometer : displayDistance;
  }

  static double weightForDisplay(
    double weightKg, {
    required bool usePounds,
  }) {
    return usePounds ? weightKg * poundsPerKilogram : weightKg;
  }

  static double weightToKilograms(
    double displayWeight, {
    required bool usePounds,
  }) {
    return usePounds ? displayWeight / poundsPerKilogram : displayWeight;
  }
}
