import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:valcue/features/profile/models/achievement_translations.dart';
import 'package:valcue/l10n/app_localizations.dart';
import 'package:valcue/l10n/supported_app_language.dart';

void main() {
  const expectedCodes = <String>[
    'en',
    'es',
    'fr',
    'de',
    'it',
    'nl',
    'da',
    'nb',
    'ru',
    'pt',
    'ja',
    'zh',
    'ko',
    'vi',
    'ar',
    'th',
  ];

  Map<String, String> loadMessages(String code) {
    final file = File('lib/l10n/app_$code.arb');
    final json = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
    return <String, String>{
      for (final entry in json.entries)
        if (!entry.key.startsWith('@')) entry.key: entry.value as String,
    };
  }

  Set<String> placeholders(String message) => RegExp(r'\{([A-Za-z]\w*)')
      .allMatches(message)
      .map((match) => match.group(1)!)
      .toSet();

  test('the canonical catalog exposes exactly the 16 product languages', () {
    // The catalog's display order is a product choice (it groups languages by
    // script), so assert on membership rather than on a fixed sequence.
    expect(SupportedAppLanguage.codesInDisplayOrder,
        unorderedEquals(expectedCodes));
    expect(SupportedAppLanguage.codesInDisplayOrder,
        hasLength(expectedCodes.length));
    expect(SupportedAppLanguage.all, hasLength(expectedCodes.length));
    expect(SupportedAppLanguage.locales, hasLength(expectedCodes.length));

    for (final language in SupportedAppLanguage.all) {
      expect(AppLocalizations.delegate.isSupported(language.locale), isTrue);
      expect(
        lookupAppLocalizations(language.locale).localeName,
        language.code,
      );
    }
  });

  test('every ARB has exact key and placeholder parity with English', () {
    final english = loadMessages('en');
    expect(english, isNotEmpty);

    for (final code in expectedCodes.where((code) => code != 'en')) {
      final localized = loadMessages(code);
      expect(
        localized.keys.toSet(),
        english.keys.toSet(),
        reason: 'Message-key mismatch in app_$code.arb',
      );

      for (final key in english.keys) {
        if (english[key]!.isNotEmpty) {
          expect(
            localized[key]!.trim(),
            isNotEmpty,
            reason: 'Empty translation for $key in app_$code.arb',
          );
        }
        expect(
          placeholders(localized[key]!),
          placeholders(english[key]!),
          reason: 'Placeholder mismatch for $key in app_$code.arb',
        );
      }

      final identicalCount = localized.entries
          .where((entry) => entry.value == english[entry.key])
          .length;
      expect(
        identicalCount / english.length,
        lessThan(0.15),
        reason: 'Too much untranslated English remains in app_$code.arb',
      );
    }
  });

  test(
      'known cross-language leakage and rejected literal translations stay out',
      () {
    final messages = <String, String>{
      for (final code in expectedCodes)
        code: loadMessages(code).values.join('\n'),
    };

    expect(messages['ja'], isNot(matches(RegExp(r'[가-힣]'))));
    expect(messages['de'], isNot(contains('Rolltreppe')));
    expect(messages['fr'], isNot(matches(RegExp('Hors-pair|escalateur'))));
    expect(messages['zh'], isNot(matches(RegExp('例程|例行程序|您'))));
    expect(
      messages['vi'],
      isNot(matches(RegExp(r'\broutine\b|Thói quen', caseSensitive: false))),
    );
    expect(
      messages['pt'],
      isNot(matches(RegExp(
        r'\b(utilizador(?:es)?|ecrã|ficheiro|passadeira|apagar)\b',
        caseSensitive: false,
      ))),
    );
  });

  test('every achievement and achievement UI string is localized', () {
    final providerSource =
        File('lib/features/profile/providers/achievement_provider.dart')
            .readAsStringSync();
    final achievementIds = RegExp(r"id: '([^']+)'")
        .allMatches(providerSource)
        .map((match) => match.group(1)!)
        .toSet();
    expect(achievementIds, hasLength(56));

    const uiKeys = <String>{
      'grand_master',
      'pace_master',
      'pro_runner',
      'active_beginner',
      'trainee',
      'unlocked_x_of_y',
      'collect_desc',
      'filter_all',
      'filter_unlocked',
      'filter_locked',
      'no_matching',
      'no_achievements',
      'current_progress',
      'unlocked_at',
      'awesome',
      'celebration_title',
      'celebration_desc',
      'status_unlocked',
      'status_locked',
      'unlock_date',
      'progress_label',
      'current_value_label',
      'close',
      'min',
      'hours',
      'tab_achievements',
    };

    String allAchievementCopy(String code) => [
          for (final id in achievementIds)
            AchievementTranslations.getTitle(id, code),
          for (final id in achievementIds)
            AchievementTranslations.getDescription(id, code),
          for (final key in uiKeys)
            AchievementTranslations.getUiString(key, code),
        ].join('\n');

    final englishTitles = {
      for (final id in achievementIds)
        id: AchievementTranslations.getTitle(id, 'en'),
    };
    final englishDescriptions = {
      for (final id in achievementIds)
        id: AchievementTranslations.getDescription(id, 'en'),
    };
    final englishUi = {
      for (final key in uiKeys)
        key: AchievementTranslations.getUiString(key, 'en'),
    };

    for (final code in expectedCodes) {
      for (final id in achievementIds) {
        expect(
          AchievementTranslations.getTitle(id, code).trim(),
          isNot(anyOf(isEmpty, id)),
          reason: 'Missing achievement title $id in $code',
        );
        expect(
          AchievementTranslations.getDescription(id, code).trim(),
          isNotEmpty,
          reason: 'Missing achievement description $id in $code',
        );
      }
      for (final key in uiKeys) {
        final localized = AchievementTranslations.getUiString(key, code);
        expect(
          localized.trim(),
          isNotEmpty,
          reason: 'Missing achievement UI string $key in $code',
        );
        expect(
          placeholders(localized),
          placeholders(englishUi[key]!),
          reason: 'Achievement UI placeholder mismatch for $key in $code',
        );
      }

      if (code != 'en') {
        final identicalCount = achievementIds.where((id) {
          return AchievementTranslations.getTitle(id, code) ==
                  englishTitles[id] ||
              AchievementTranslations.getDescription(id, code) ==
                  englishDescriptions[id];
        }).length;
        expect(
          identicalCount / achievementIds.length,
          lessThan(0.15),
          reason: 'Achievement copy in $code is falling back to English',
        );
      }
    }

    final forbiddenScripts = <String, RegExp>{
      for (final code in [
        'en',
        'es',
        'fr',
        'de',
        'it',
        'nl',
        'da',
        'nb',
        'pt',
        'vi',
      ])
        code: RegExp(r'[가-힣ぁ-んァ-ン一-龯ء-يА-Яа-яก-๙]'),
      'ar': RegExp(r'[가-힣ぁ-んァ-ン一-龯А-Яа-яก-๙]'),
      'ru': RegExp(r'[가-힣ぁ-んァ-ン一-龯ء-يก-๙]'),
      'ja': RegExp(r'[가-힣ء-يА-Яа-яก-๙]'),
      'zh': RegExp(r'[가-힣ぁ-んァ-ンء-يА-Яа-яก-๙]'),
      'ko': RegExp(r'[ぁ-んァ-ンء-يА-Яа-яก-๙]'),
      'th': RegExp(r'[가-힣ぁ-んァ-ン一-龯ء-يА-Яа-я]'),
    };
    for (final entry in forbiddenScripts.entries) {
      expect(
        allAchievementCopy(entry.key),
        isNot(matches(entry.value)),
        reason: 'Foreign-script leakage in achievement copy for ${entry.key}',
      );
    }
    expect(
      allAchievementCopy('zh'),
      isNot(matches(RegExp(r'\b(or|and|the)\b', caseSensitive: false))),
    );
  });

  test('every onboarding literal catalog contains all 16 languages', () {
    final source =
        File('lib/onboarding/onboarding_strings.dart').readAsStringSync();
    final catalogStarts = RegExp(r"\{\s*'ko':").allMatches(source).toList();
    expect(catalogStarts.length, greaterThanOrEqualTo(60));

    for (var catalogIndex = 0;
        catalogIndex < catalogStarts.length;
        catalogIndex++) {
      final start = catalogStarts[catalogIndex].start;
      var depth = 0;
      var end = start;
      for (var index = start; index < source.length; index++) {
        if (source[index] == '{') depth++;
        if (source[index] == '}') depth--;
        if (depth == 0) {
          end = index + 1;
          break;
        }
      }
      final catalog = source.substring(start, end);
      for (final code in expectedCodes) {
        expect(
          catalog,
          contains("'$code':"),
          reason: 'Onboarding catalog $catalogIndex is missing $code',
        );
      }
    }

    final highlightMethod = source.substring(
      source.indexOf('ex2IntervalHighlightSpans'),
      source.indexOf('ex2FinalLine1Spans'),
    );
    for (final code in expectedCodes) {
      expect(
        highlightMethod,
        contains("case '$code':"),
        reason: 'Interval emphasis copy is missing $code',
      );
    }
  });

  test('voice and notification catalogs contain all 16 languages', () {
    String mapBody(String source, String marker) {
      final markerIndex = source.indexOf(marker);
      expect(markerIndex, isNonNegative, reason: 'Missing catalog $marker');
      final start = source.indexOf('{', markerIndex);
      var depth = 0;
      for (var index = start; index < source.length; index++) {
        if (source[index] == '{') depth++;
        if (source[index] == '}') depth--;
        if (depth == 0) return source.substring(start, index + 1);
      }
      fail('Unclosed catalog $marker');
    }

    final voiceSource =
        File('lib/services/voice_guide_service.dart').readAsStringSync();
    final reminderSource =
        File('lib/services/workout_reminder_service.dart').readAsStringSync();
    final catalogs = <String, String>{
      'voice templates': mapBody(voiceSource, '_templates ='),
      'TTS locale fallbacks': mapBody(voiceSource, '_ttsLanguageFallbacks ='),
      'notification channels': mapBody(reminderSource, '_channelCopy ='),
      'reminder messages': mapBody(reminderSource, '_defaultMessages ='),
    };

    for (final catalog in catalogs.entries) {
      for (final code in expectedCodes) {
        expect(
          catalog.value,
          contains("'$code':"),
          reason: '${catalog.key} is missing $code',
        );
      }
    }
  });

  // The privacy policy and terms pages now live in the standalone Nogic site
  // (see commit 6e8280d), so their language coverage is checked over there.
  test('web and iOS native surfaces cover all 16 languages', () {
    final webIndex = File('web/index.html').readAsStringSync();
    const iosDirectories = <String, String>{
      'en': 'en',
      'es': 'es',
      'fr': 'fr',
      'de': 'de',
      'it': 'it',
      'nl': 'nl',
      'da': 'da',
      'nb': 'nb',
      'ru': 'ru',
      'pt': 'pt-BR',
      'ja': 'ja',
      'zh': 'zh-Hans',
      'ko': 'ko',
      'vi': 'vi',
      'ar': 'ar',
      'th': 'th',
    };

    for (final code in expectedCodes) {
      expect(
        RegExp("\\b$code:\\s*'").hasMatch(webIndex),
        isTrue,
        reason: 'Web metadata is missing $code',
      );

      final nativeFile = File(
        'ios/Runner/${iosDirectories[code]}.lproj/InfoPlist.strings',
      );
      expect(nativeFile.existsSync(), isTrue, reason: 'Missing iOS $code');
      final nativeCopy = nativeFile.readAsStringSync();
      expect(nativeCopy, contains('CFBundleDisplayName'));
      expect(nativeCopy, contains('NSCameraUsageDescription'));
    }
  });
}
