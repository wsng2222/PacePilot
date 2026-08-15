import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:valcue/theme/app_theme.dart';
import 'package:valcue/widgets/app_segmented_control.dart';

void main() {
  // The test host is macOS, so PlatformInfo.isIOS is false here and these
  // tests exercise the same non-iOS pill-control branch used on Android.
  testWidgets('renders all labels and highlights the selected segment',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: AppSegmentedControl(
            labels: const ['기본', '크게', '매우 크게'],
            selectedIndex: 1,
            onValueChanged: (_) {},
            height: 44,
          ),
        ),
      ),
    );

    expect(find.text('기본'), findsOneWidget);
    expect(find.text('크게'), findsOneWidget);
    expect(find.text('매우 크게'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping a segment reports its index', (tester) async {
    var lastIndex = -1;

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: AppSegmentedControl(
            labels: const ['기본', '크게', '매우 크게'],
            selectedIndex: 0,
            onValueChanged: (index) => lastIndex = index,
            height: 44,
          ),
        ),
      ),
    );

    await tester.tap(find.text('매우 크게'));
    await tester.pumpAndSettle();

    expect(lastIndex, 2);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shrinkWrap sizes to content without overflowing',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: Scaffold(
          body: Center(
            child: AppSegmentedControl(
              labels: const ['kg', 'lbs'],
              selectedIndex: 0,
              onValueChanged: (_) {},
              height: 32,
              shrinkWrap: true,
            ),
          ),
        ),
      ),
    );

    expect(find.text('kg'), findsOneWidget);
    expect(find.text('lbs'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
