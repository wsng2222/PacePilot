import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void _debugLog(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}

/// Gathers user consent required before requesting ads.
///
/// Two separate legal requirements are handled here:
/// - Google's User Messaging Platform (UMP): shows an EEA/UK consent form
///   when required so AdMob is allowed to serve ads to those users.
/// - iOS App Tracking Transparency (ATT): asks the user for permission to
///   access the IDFA, which AdMob uses for personalized ads on iOS 14.5+.
class ConsentService {
  ConsentService._();
  static final ConsentService instance = ConsentService._();

  /// Runs the UMP consent flow followed by the iOS ATT prompt.
  ///
  /// Returns whether ads can be requested afterwards. Safe to call even when
  /// consent isn't required (e.g. users outside the EEA/UK) - the UMP SDK
  /// simply completes without showing a form in that case.
  Future<bool> gatherConsent() async {
    final infoUpdateCompleter = Completer<void>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () {
        if (!infoUpdateCompleter.isCompleted) infoUpdateCompleter.complete();
      },
      (FormError error) {
        _debugLog(
            'ConsentService: requestConsentInfoUpdate failed: ${error.message}');
        if (!infoUpdateCompleter.isCompleted) infoUpdateCompleter.complete();
      },
    );
    await infoUpdateCompleter.future;

    try {
      await ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
        if (error != null) {
          _debugLog('ConsentService: consent form error: ${error.message}');
        }
      });
    } catch (e) {
      _debugLog('ConsentService: loadAndShowConsentFormIfRequired failed: $e');
    }

    await _requestTrackingAuthorizationIfNeeded();

    try {
      return await ConsentInformation.instance.canRequestAds();
    } catch (e) {
      _debugLog('ConsentService: canRequestAds failed: $e');
      return true;
    }
  }

  Future<void> _requestTrackingAuthorizationIfNeeded() async {
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (e) {
      _debugLog('ConsentService: ATT request failed: $e');
    }
  }

  /// Whether Settings should show a "Privacy options" entry so the user can
  /// revisit their EEA/UK consent choice (required by Google's UMP policy).
  Future<bool> isPrivacyOptionsRequired() async {
    try {
      final status = await ConsentInformation.instance
          .getPrivacyOptionsRequirementStatus();
      return status == PrivacyOptionsRequirementStatus.required;
    } catch (e) {
      return false;
    }
  }

  /// Shows the privacy options form so the user can change their consent.
  Future<void> showPrivacyOptionsForm() async {
    await ConsentForm.showPrivacyOptionsForm((FormError? error) {
      if (error != null) {
        _debugLog(
            'ConsentService: showPrivacyOptionsForm error: ${error.message}');
      }
    });
  }
}
