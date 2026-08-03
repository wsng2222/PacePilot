import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

void _debugLog(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}

/// RevenueCat API keys.
///
/// TODO: replace with the real public SDK keys from the RevenueCat dashboard
/// (Project settings -> API keys). These are safe to ship in the app binary.
const String _androidApiKey = 'YOUR_REVENUECAT_ANDROID_API_KEY';
const String _iosApiKey = 'YOUR_REVENUECAT_IOS_API_KEY';

/// Entitlement identifier configured in the RevenueCat dashboard
/// (Entitlements tab). All premium products should grant this entitlement.
const String premiumEntitlementId = 'premium';

enum PurchaseOutcome { success, cancelled, failed }

/// Wraps the RevenueCat SDK: configuration, offerings, purchases, restore,
/// and keeps [isPremiumListenable] in sync with the active entitlement.
class PurchaseService {
  PurchaseService._internal();
  static final PurchaseService instance = PurchaseService._internal();

  bool _configured = false;

  /// The user's premium entitlement status, or `null` if the SDK hasn't
  /// resolved any customer info yet (e.g. not configured, still loading, or
  /// running under `flutter test` with no platform channels). Callers must
  /// treat `null` as "unknown" and leave any locally persisted value alone -
  /// never coerce it to `false`.
  final ValueNotifier<bool?> isPremiumListenable = ValueNotifier<bool?>(null);

  bool get isConfigured => _configured;

  Future<void> init() async {
    if (_configured) return;

    final apiKey = Platform.isIOS ? _iosApiKey : _androidApiKey;

    await Purchases.setLogLevel(kDebugMode ? LogLevel.debug : LogLevel.error);
    await Purchases.configure(PurchasesConfiguration(apiKey));
    _configured = true;

    Purchases.addCustomerInfoUpdateListener(_handleCustomerInfo);
  }

  void _handleCustomerInfo(CustomerInfo info) {
    final active = info.entitlements.active.containsKey(premiumEntitlementId);
    _debugLog('PurchaseService: entitlement active = $active');
    isPremiumListenable.value = active;
  }

  /// Fetches the current default offering (configured in the RevenueCat
  /// dashboard) containing the monthly/annual/lifetime packages.
  Future<Offering?> getCurrentOffering() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current;
    } catch (e) {
      _debugLog('PurchaseService: failed to load offerings: $e');
      return null;
    }
  }

  /// Purchases [package]. Callers should only show an error message for
  /// [PurchaseOutcome.failed] - [PurchaseOutcome.cancelled] means the user
  /// backed out of the native purchase sheet and shouldn't see an error.
  Future<PurchaseOutcome> purchasePackage(Package package) async {
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      final active =
          result.customerInfo.entitlements.active.containsKey(
        premiumEntitlementId,
      );
      isPremiumListenable.value = active;
      return PurchaseOutcome.success;
    } on PlatformException catch (e) {
      final code = PurchasesErrorHelper.getErrorCode(e);
      if (code == PurchasesErrorCode.purchaseCancelledError) {
        _debugLog('PurchaseService: purchase cancelled by user');
        return PurchaseOutcome.cancelled;
      }
      _debugLog('PurchaseService: purchase failed: $e');
      return PurchaseOutcome.failed;
    } catch (e) {
      _debugLog('PurchaseService: purchase failed: $e');
      return PurchaseOutcome.failed;
    }
  }

  /// Restores previous purchases. Returns true if the premium entitlement is
  /// active afterwards.
  Future<bool> restorePurchases() async {
    try {
      final info = await Purchases.restorePurchases();
      final active = info.entitlements.active.containsKey(premiumEntitlementId);
      isPremiumListenable.value = active;
      return active;
    } catch (e) {
      _debugLog('PurchaseService: restore failed: $e');
      return false;
    }
  }
}
