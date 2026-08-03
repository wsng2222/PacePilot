import 'package:flutter/widgets.dart';

/// Canonical catalog for every locale exposed by the app.
///
/// Persistence continues to use the stable base language [code], while
/// [locale] pins the regional conventions used for dates, numbers, speech,
/// and other locale-sensitive presentation.
class SupportedAppLanguage {
  const SupportedAppLanguage({
    required this.code,
    required this.locale,
    required this.nativeName,
    required this.flagEmoji,
  });

  final String code;
  final Locale locale;
  final String nativeName;
  final String flagEmoji;

  static const all = <SupportedAppLanguage>[
    SupportedAppLanguage(
      code: 'en',
      locale: Locale('en', 'US'),
      nativeName: 'English',
      flagEmoji: '🇬🇧',
    ),
    SupportedAppLanguage(
      code: 'es',
      locale: Locale('es', 'ES'),
      nativeName: 'Español (España)',
      flagEmoji: '🇪🇸',
    ),
    SupportedAppLanguage(
      code: 'fr',
      locale: Locale('fr', 'FR'),
      nativeName: 'Français',
      flagEmoji: '🇫🇷',
    ),
    SupportedAppLanguage(
      code: 'de',
      locale: Locale('de', 'DE'),
      nativeName: 'Deutsch',
      flagEmoji: '🇩🇪',
    ),
    SupportedAppLanguage(
      code: 'it',
      locale: Locale('it', 'IT'),
      nativeName: 'Italiano',
      flagEmoji: '🇮🇹',
    ),
    SupportedAppLanguage(
      code: 'nl',
      locale: Locale('nl', 'NL'),
      nativeName: 'Nederlands',
      flagEmoji: '🇳🇱',
    ),
    SupportedAppLanguage(
      code: 'da',
      locale: Locale('da', 'DK'),
      nativeName: 'Dansk',
      flagEmoji: '🇩🇰',
    ),
    SupportedAppLanguage(
      code: 'nb',
      locale: Locale('nb', 'NO'),
      nativeName: 'Norsk bokmål',
      flagEmoji: '🇳🇴',
    ),
    SupportedAppLanguage(
      code: 'ru',
      locale: Locale('ru', 'RU'),
      nativeName: 'Русский',
      flagEmoji: '🇷🇺',
    ),
    SupportedAppLanguage(
      code: 'pt',
      locale: Locale('pt', 'BR'),
      nativeName: 'Português (Brasil)',
      flagEmoji: '🇧🇷',
    ),
    SupportedAppLanguage(
      code: 'ja',
      locale: Locale('ja', 'JP'),
      nativeName: '日本語',
      flagEmoji: '🇯🇵',
    ),
    SupportedAppLanguage(
      code: 'zh',
      locale: Locale('zh', 'CN'),
      nativeName: '简体中文',
      flagEmoji: '🇨🇳',
    ),
    SupportedAppLanguage(
      code: 'ko',
      locale: Locale('ko', 'KR'),
      nativeName: '한국어',
      flagEmoji: '🇰🇷',
    ),
    SupportedAppLanguage(
      code: 'vi',
      locale: Locale('vi', 'VN'),
      nativeName: 'Tiếng Việt',
      flagEmoji: '🇻🇳',
    ),
    SupportedAppLanguage(
      code: 'ar',
      locale: Locale('ar', 'SA'),
      nativeName: 'العربية',
      flagEmoji: '🇸🇦',
    ),
    SupportedAppLanguage(
      code: 'th',
      locale: Locale('th', 'TH'),
      nativeName: 'ไทย',
      flagEmoji: '🇹🇭',
    ),
  ];

  static final codes = Set<String>.unmodifiable(
    all.map((language) => language.code),
  );

  static final codesInDisplayOrder = List<String>.unmodifiable(
    all.map((language) => language.code),
  );

  static final locales = List<Locale>.unmodifiable(
    all.map((language) => language.locale),
  );

  static bool supports(String languageCode) => codes.contains(languageCode);

  static SupportedAppLanguage fromCode(String languageCode) {
    return all.firstWhere(
      (language) => language.code == languageCode,
      orElse: () => all.first,
    );
  }
}
