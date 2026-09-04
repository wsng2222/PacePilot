import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _debugLog(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}

/// Service for managing interstitial ads shown before a workout starts.
///
/// Debug/profile builds always use Google's official test ad unit IDs so
/// development never risks invalid-traffic clicks on real ad units. Release
/// builds use the real ad unit IDs below.
class AdService {
  static final AdService _instance = AdService._internal();
  factory AdService() => _instance;
  AdService._internal();

  InterstitialAd? _interstitialAd;
  bool _isAdReady = false;
  bool _isLoading = false;

  // Only show an ad on every Nth workout finish, so people who train several
  // times in a row aren't hit with an ad at the end of every single one.
  static const String _finishAdCounterKey = 'ad_post_workout_counter';
  static const int _showPostWorkoutAdEveryNTimes = 3;

  /// Whether a post-workout ad should be shown this time. Advances a
  /// persistent counter each call and returns true every Nth call.
  Future<bool> shouldShowPostWorkoutAd() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final count = (prefs.getInt(_finishAdCounterKey) ?? 0) + 1;
      await prefs.setInt(_finishAdCounterKey, count);
      return count % _showPostWorkoutAdEveryNTimes == 0;
    } catch (e) {
      _debugLog('AdService: Exception while checking post-workout ad cadence: $e');
      return false;
    }
  }

  // Google's official test ad unit IDs - used for all non-release builds.
  static const String _androidTestAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _iosTestAdUnitId =
      'ca-app-pub-3940256099942544/4411468910';

  // Real interstitial ad unit IDs (AdMob console -> Ad units).
  static const String _androidReleaseAdUnitId =
      'ca-app-pub-2346389501280855/8946165264';
  static const String _iosReleaseAdUnitId =
      'ca-app-pub-2346389501280855/8804402292';

  /// Get the appropriate ad unit ID based on platform and build mode
  String get _adUnitId {
    if (kDebugMode || kProfileMode) {
      return Platform.isIOS ? _iosTestAdUnitId : _androidTestAdUnitId;
    }
    return Platform.isIOS ? _iosReleaseAdUnitId : _androidReleaseAdUnitId;
  }

  /// Check if an ad is ready to be shown
  bool get isAdReady => _isAdReady && _interstitialAd != null;

  /// Preload an interstitial ad
  /// This should be called early (e.g., in app initialization or screen initState)
  void loadAd() {
    // Prevent multiple simultaneous loads
    if (_isLoading || _isAdReady) {
      _debugLog(
          'AdService: Skipping load - isLoading: $_isLoading, isAdReady: $_isAdReady');
      return;
    }

    try {
      _isLoading = true;
      _isAdReady = false;
      _debugLog('AdService: Loading ad with unit ID: $_adUnitId');

      InterstitialAd.load(
        adUnitId: _adUnitId,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            _debugLog('AdService: Ad loaded successfully!');
            _interstitialAd = ad;
            _isAdReady = true;
            _isLoading = false;
            // Don't set callbacks here - they will be set in showAd()
          },
          onAdFailedToLoad: (LoadAdError error) {
            _debugLog(
                'AdService: Ad failed to load: ${error.code} - ${error.message}');
            // Ad failed to load - this is expected sometimes
            // Just reset state and allow workout to proceed without ad
            _interstitialAd = null;
            _isAdReady = false;
            _isLoading = false;
            // Don't retry immediately to avoid spam
          },
        ),
      );
    } catch (e) {
      _debugLog('AdService: Exception while loading ad: $e');
      // If ad loading fails completely, just reset state
      // App should continue to work without ads
      _interstitialAd = null;
      _isAdReady = false;
      _isLoading = false;
    }
  }

  /// Show the interstitial ad if ready
  ///
  /// Returns true if ad was shown, false if ad was not ready or failed to show.
  /// The [onAdClosed] callback is called when the ad is dismissed or fails to show.
  bool showAd({VoidCallback? onAdClosed}) {
    _debugLog(
        'AdService: showAd called - isAdReady: $isAdReady, _interstitialAd: ${_interstitialAd != null}');

    if (!isAdReady || _interstitialAd == null) {
      _debugLog('AdService: Ad not ready, proceeding without ad');
      // Ad not ready, call callback immediately to proceed with workout
      onAdClosed?.call();
      return false;
    }

    try {
      final ad = _interstitialAd;
      if (ad != null) {
        _debugLog('AdService: Attempting to show ad');

        // Store the callback to ensure it's called
        final callback = onAdClosed;

        // Set callback for when ad is closed - MUST be set before show()
        ad.fullScreenContentCallback = FullScreenContentCallback(
          onAdDismissedFullScreenContent: (InterstitialAd ad) {
            _debugLog('AdService: Ad dismissed in showAd - calling onAdClosed');
            ad.dispose();
            _interstitialAd = null;
            _isAdReady = false;
            // Call the callback to navigate to workout
            if (callback != null) {
              callback();
            }
            // Preload next ad
            loadAd();
          },
          onAdFailedToShowFullScreenContent:
              (InterstitialAd ad, AdError error) {
            _debugLog(
                'AdService: Ad failed to show in showAd: ${error.message} - calling onAdClosed');
            ad.dispose();
            _interstitialAd = null;
            _isAdReady = false;
            // Call the callback to navigate to workout even if ad failed
            if (callback != null) {
              callback();
            }
            // Preload next ad
            loadAd();
          },
          onAdShowedFullScreenContent: (InterstitialAd ad) {
            _debugLog('AdService: Ad showed in showAd');
          },
        );

        // Show the ad
        ad.show();
        _debugLog('AdService: ad.show() called');
        return true;
      }
    } catch (e) {
      _debugLog('AdService: Exception while showing ad: $e');
      // If anything goes wrong, ensure workout can proceed
      _interstitialAd?.dispose();
      _interstitialAd = null;
      _isAdReady = false;
    }

    // If we get here, ad wasn't shown - proceed with workout
    _debugLog('AdService: Ad was not shown, proceeding without ad');
    onAdClosed?.call();
    return false;
  }

  /// Dispose of the current ad (if any)
  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isAdReady = false;
    _isLoading = false;
  }
}
