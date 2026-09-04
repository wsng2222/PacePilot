import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valcue/services/review_prompt_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('dev.britannio.in_app_review');
  final requestedMethods = <String>[];

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    requestedMethods.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
      requestedMethods.add(call.method);
      if (call.method == 'isAvailable') return true;
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('does not prompt before the 3rd completed workout', () async {
    await ReviewPromptService.instance.maybeRequestReview(1);
    await ReviewPromptService.instance.maybeRequestReview(2);

    expect(requestedMethods, isEmpty);
  });

  test('prompts on the 3rd completed workout', () async {
    await ReviewPromptService.instance.maybeRequestReview(3);

    expect(requestedMethods, ['isAvailable', 'requestReview']);
  });

  test('does not prompt again shortly after the 3rd workout', () async {
    await ReviewPromptService.instance.maybeRequestReview(3);
    requestedMethods.clear();

    await ReviewPromptService.instance.maybeRequestReview(4);
    await ReviewPromptService.instance.maybeRequestReview(27);

    expect(requestedMethods, isEmpty);
  });

  test('prompts again after the repeat interval once the min gap has passed',
      () async {
    await ReviewPromptService.instance.maybeRequestReview(3);

    final prefs = await SharedPreferences.getInstance();
    final ninetyOneDaysAgo =
        DateTime.now().subtract(const Duration(days: 91));
    await prefs.setInt(
      'review_prompt_last_shown_at',
      ninetyOneDaysAgo.millisecondsSinceEpoch,
    );
    requestedMethods.clear();

    await ReviewPromptService.instance.maybeRequestReview(28);

    expect(requestedMethods, ['isAvailable', 'requestReview']);
  });

  test('never throws even if the platform channel is unavailable', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);

    await expectLater(
      ReviewPromptService.instance.maybeRequestReview(3),
      completes,
    );
  });
}
