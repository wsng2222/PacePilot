import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Theme Extension for semantic color tokens
/// Provides iOS-like semantic colors that adapt to light/dark themes
class AppColors extends ThemeExtension<AppColors> {
  final Color surfaceElevated;
  final Color border;
  final Color mutedText;
  final Color danger;
  final Color dangerText;

  const AppColors({
    required this.surfaceElevated,
    required this.border,
    required this.mutedText,
    required this.danger,
    required this.dangerText,
  });

  @override
  AppColors copyWith({
    Color? surfaceElevated,
    Color? border,
    Color? mutedText,
    Color? danger,
    Color? dangerText,
  }) {
    return AppColors(
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      border: border ?? this.border,
      mutedText: mutedText ?? this.mutedText,
      danger: danger ?? this.danger,
      dangerText: dangerText ?? this.dangerText,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      surfaceElevated: Color.lerp(surfaceElevated, other.surfaceElevated, t)!,
      border: Color.lerp(border, other.border, t)!,
      mutedText: Color.lerp(mutedText, other.mutedText, t)!,
      danger: Color.lerp(danger, other.danger, t)!,
      dangerText: Color.lerp(dangerText, other.dangerText, t)!,
    );
  }
}

class AppTheme {
  /// Shared corner radius for primary/secondary CTA buttons (ElevatedButton,
  /// AdaptiveButton, etc.) across the app, so buttons look consistent from
  /// screen to screen regardless of their width or height.
  static const double buttonRadius = 999;

  /// AppBar system overlay styles that only set icon brightness, leaving
  /// [SystemUiOverlayStyle.statusBarColor], [systemNavigationBarColor], and
  /// [systemNavigationBarDividerColor] at their default `null`. The built-in
  /// [SystemUiOverlayStyle.light]/[.dark] presets Flutter would otherwise
  /// infer per-AppBar set explicit colors, which triggers the deprecated
  /// Window.setStatusBarColor/setNavigationBarColor/setNavigationBarDividerColor
  /// calls Play Console flags on Android 15 (Window.setDecorFitsSystemWindows(false)
  /// in MainActivity.hideSystemUI already makes the app draw edge-to-edge, so no
  /// color is needed here).
  static const SystemUiOverlayStyle _lightAppBarOverlayStyle =
      SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.dark,
  );
  static const SystemUiOverlayStyle _darkAppBarOverlayStyle =
      SystemUiOverlayStyle(
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemNavigationBarIconBrightness: Brightness.light,
  );

  static ThemeData forLocale(ThemeData theme, Locale locale) {
    final primaryFamily = switch (locale.languageCode) {
      'ar' => GoogleFonts.notoSansArabic().fontFamily!,
      'th' => GoogleFonts.notoSansThai().fontFamily!,
      'ko' => GoogleFonts.notoSansKr().fontFamily!,
      'ja' => GoogleFonts.notoSansJp().fontFamily!,
      'zh' => GoogleFonts.notoSansSc().fontFamily!,
      _ => GoogleFonts.lato().fontFamily!,
    };
    final fallbacks = switch (locale.languageCode) {
      'ar' => [GoogleFonts.notoSansArabic().fontFamily!],
      'th' => [GoogleFonts.notoSansThai().fontFamily!],
      'ko' => [GoogleFonts.notoSansKr().fontFamily!],
      'ja' => [GoogleFonts.notoSansJp().fontFamily!],
      'zh' => [GoogleFonts.notoSansSc().fontFamily!],
      _ => <String>[],
    };
    return theme.copyWith(
      textTheme: theme.textTheme.apply(
        fontFamily: primaryFamily,
        fontFamilyFallback: fallbacks,
      ),
      primaryTextTheme: theme.primaryTextTheme.apply(
        fontFamily: primaryFamily,
        fontFamilyFallback: fallbacks,
      ),
    );
  }

  // Light Theme
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.red,
      brightness: Brightness.light,
    ).copyWith(
      primary: Colors.red,
      secondary: Colors.red.shade700,
      error: Colors.red,
      surface: Colors.white,
      onSurface: Colors.black,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: Colors.white,
    textTheme: _buildTextTheme(Brightness.light),
    fontFamily: GoogleFonts.lato().fontFamily,
    fontFamilyFallback: [
      GoogleFonts.notoSansArabic().fontFamily!,
      GoogleFonts.notoSansThai().fontFamily!,
      GoogleFonts.notoSansKr().fontFamily!,
      GoogleFonts.notoSansJp().fontFamily!,
      GoogleFonts.notoSansSc().fontFamily!,
      GoogleFonts.notoSansTc().fontFamily!,
    ],
    iconTheme: const IconThemeData(
      color: Colors.black87,
      size: 24,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black87),
      systemOverlayStyle: _lightAppBarOverlayStyle,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.black87,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey.shade200,
        disabledForegroundColor: const Color(0xFF8E8E93),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        elevation: 0,
      ),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      surfaceTintColor: Colors.transparent,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.grey.shade200,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: false,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      contentPadding: EdgeInsets.zero,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Colors.black87,
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AppColors(
        surfaceElevated: Color(0xFFFFFFFF),
        border: Color(0xFFE5E5EA),
        mutedText: Color(0xFF8E8E93),
        danger: Color(0xFFFF3B30),
        dangerText: Color(0xFFFF3B30),
      ),
    ],
  );

  // Dark Theme
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.red,
      brightness: Brightness.dark,
    ).copyWith(
      primary: Colors.red.shade400,
      secondary: Colors.red.shade300,
      error: Colors.red.shade400,
      surface: const Color(0xFF1C1C1E),
      onSurface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onError: Colors.white,
    ),
    scaffoldBackgroundColor: const Color(0xFF000000),
    textTheme: _buildTextTheme(Brightness.dark),
    fontFamily: GoogleFonts.lato().fontFamily,
    fontFamilyFallback: [
      GoogleFonts.notoSansArabic().fontFamily!,
      GoogleFonts.notoSansThai().fontFamily!,
      GoogleFonts.notoSansKr().fontFamily!,
      GoogleFonts.notoSansJp().fontFamily!,
      GoogleFonts.notoSansSc().fontFamily!,
      GoogleFonts.notoSansTc().fontFamily!,
    ],
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 24,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1C1C1E),
      foregroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
      systemOverlayStyle: _darkAppBarOverlayStyle,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.white70,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
        disabledForegroundColor: const Color(0xFF8E8E93),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(buttonRadius),
        ),
        elevation: 0,
      ),
    ),
    cardTheme: CardThemeData(
      color: const Color(0xFF1C1C1E),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1), width: 1),
      ),
      surfaceTintColor: Colors.transparent,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: const Color(0xFF1C1C1E),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: Colors.white.withValues(alpha: 0.1),
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: false,
      border: InputBorder.none,
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      focusedErrorBorder: InputBorder.none,
      contentPadding: EdgeInsets.zero,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: const Color(0xFF2C2C2E),
      contentTextStyle: const TextStyle(color: Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      behavior: SnackBarBehavior.floating,
    ),
    extensions: const <ThemeExtension<dynamic>>[
      AppColors(
        surfaceElevated: Color(0xFF2C2C2E),
        border: Color(0xFF38383A),
        mutedText: Color(0xFF8E8E93),
        danger: Color(0xFFFF453A),
        dangerText: Color(0xFFFF6961),
      ),
    ],
  );

  static TextTheme _buildTextTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final baseColor = isDark ? Colors.white : Colors.black87;

    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 64,
        fontWeight: FontWeight.w900,
        color: baseColor,
        letterSpacing: -2.0,
      ),
      displayMedium: TextStyle(
        fontSize: 56,
        fontWeight: FontWeight.w900,
        color: baseColor,
        letterSpacing: -1.5,
      ),
      displaySmall: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w900,
        color: baseColor,
        letterSpacing: -1.0,
      ),
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w900,
        color: baseColor,
        letterSpacing: -0.8,
      ),
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w900,
        color: baseColor,
        letterSpacing: -0.5,
      ),
      headlineSmall: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w900,
        color: baseColor,
        letterSpacing: -0.5,
      ),
      titleLarge: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w900,
        color: baseColor,
        letterSpacing: -0.5,
      ),
      titleMedium: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: baseColor,
        letterSpacing: -0.3,
      ),
      titleSmall: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: baseColor,
        letterSpacing: -0.3,
      ),
      bodyLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: baseColor,
        letterSpacing: -0.2,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: baseColor,
        letterSpacing: -0.2,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: isDark ? Colors.white70 : Colors.black54,
        letterSpacing: -0.2,
      ),
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w900,
        color: baseColor,
        letterSpacing: -0.3,
      ),
      labelMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w900,
        color: baseColor,
        letterSpacing: -0.2,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w900,
        color: isDark ? Colors.white60 : Colors.black54,
        letterSpacing: -0.1,
      ),
    );
  }
}

/// Helper extension to easily access AppColors from context
extension AppColorsExtension on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
