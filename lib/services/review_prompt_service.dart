import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/debug_log.dart';

/// Decides when it's a good moment to ask for an App Store / Play Store
/// review, and hands off to the OS-native review sheet.
///
/// The OS itself throttles how often the native sheet can actually appear
/// (e.g. Apple allows at most a few prompts per year regardless of how often
/// we call `requestReview`), so this only needs to avoid asking at obviously
/// bad moments (a user's very first workout) and asking too frequently on
/// our end.
class ReviewPromptService {
  ReviewPromptService._();

  static final ReviewPromptService instance = ReviewPromptService._();

  static const String _lastShownAtKey = 'review_prompt_last_shown_at';
  static const String _promptCountKey = 'review_prompt_shown_count';

  static const int _firstPromptAtWorkoutCount = 3;
  static const int _repeatPromptEveryWorkouts = 25;
  static const Duration _minGapBetweenPrompts = Duration(days: 90);

  /// Call after a workout is successfully saved. [completedWorkoutCount] is
  /// the total number of workouts the user has completed so far, including
  /// this one.
  Future<void> maybeRequestReview(int completedWorkoutCount) async {
    try {
      if (!_isEligibleWorkoutCount(completedWorkoutCount)) return;

      final prefs = await SharedPreferences.getInstance();
      final lastShownMillis = prefs.getInt(_lastShownAtKey);
      if (lastShownMillis != null) {
        final lastShown = DateTime.fromMillisecondsSinceEpoch(lastShownMillis);
        if (DateTime.now().difference(lastShown) < _minGapBetweenPrompts) {
          return;
        }
      }

      final inAppReview = InAppReview.instance;
      if (!await inAppReview.isAvailable()) return;

      await inAppReview.requestReview();

      final count = prefs.getInt(_promptCountKey) ?? 0;
      await prefs.setInt(_promptCountKey, count + 1);
      await prefs.setInt(
        _lastShownAtKey,
        DateTime.now().millisecondsSinceEpoch,
      );
    } catch (e) {
      debugLog('[ReviewPromptService] Failed to request review: $e');
    }
  }

  bool _isEligibleWorkoutCount(int completedWorkoutCount) {
    if (completedWorkoutCount < _firstPromptAtWorkoutCount) return false;
    if (completedWorkoutCount == _firstPromptAtWorkoutCount) return true;
    return (completedWorkoutCount - _firstPromptAtWorkoutCount) %
            _repeatPromptEveryWorkouts ==
        0;
  }
}
