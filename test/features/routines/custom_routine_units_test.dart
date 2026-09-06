import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:valcue/app_settings/app_settings_model.dart';
import 'package:valcue/app_settings/app_settings_provider.dart';
import 'package:valcue/features/routines/models/machine_type.dart';
import 'package:valcue/features/routines/screens/ai_routine_generator_sheet.dart';
import 'package:valcue/features/routines/utils/custom_routine_units.dart';
import 'package:valcue/l10n/app_localizations.dart';
import 'package:valcue/theme/app_theme.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('CustomRoutineUnits', () {
    test('round-trips distance between kilometers and miles', () {
      final miles = CustomRoutineUnits.distanceForDisplay(
        5,
        useMiles: true,
      );
      final kilometers = CustomRoutineUnits.distanceToKilometers(
        miles,
        useMiles: true,
      );

      expect(miles, closeTo(3.10686, 0.00001));
      expect(kilometers, closeTo(5, 0.00001));
    });

    test('round-trips weight between kilograms and pounds', () {
      final pounds = CustomRoutineUnits.weightForDisplay(
        70,
        usePounds: true,
      );
      final kilograms = CustomRoutineUnits.weightToKilograms(
        pounds,
        usePounds: true,
      );

      expect(pounds, closeTo(154.324, 0.001));
      expect(kilograms, closeTo(70, 0.00001));
    });
  });

  testWidgets('custom routine form reflects mi and lbs settings',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final provider = AppSettingsProvider(
      initialSettings: AppSettings.defaultSettings.copyWith(
        measurement: 'mph',
        weightUnit: 'lbs',
      ),
      loadSettingsOnCreate: false,
    );
    addTearDown(provider.dispose);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppSettingsProvider>.value(
        value: provider,
        child: MaterialApp(
          theme: ThemeData(
            extensions: const [
              AppColors(
                surfaceElevated: Colors.white,
                border: Color(0xFFE5E5EA),
                mutedText: Color(0xFF8E8E93),
                danger: Color(0xFFFF3B30),
                dangerText: Color(0xFFFF3B30),
              ),
            ],
          ),
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: AiRoutineGeneratorSheet(
              initialMachineType: MachineType.treadmill,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 20 min at medium difficulty caps the treadmill target at 3.4 km
    // (see _maxDistanceTargetKm), which is 2.1 mi once converted.
    expect(find.text('2.1 mi'), findsOneWidget);
    expect(find.text('lbs'), findsOneWidget);

    final weightField = tester.widget<TextField>(find.byType(TextField));
    expect(weightField.controller!.text, '154.3');

    await tester.enterText(find.byType(TextField), '500');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();

    expect(weightField.controller!.text, startsWith('500'));
  });
}
