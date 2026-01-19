import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bookwise/screens/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('OnboardingScreen navigates pages and completes',
      (WidgetTester tester) async {
    // Mock SharedPreferences
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MaterialApp(
      home: OnboardingScreen(),
    ));

    // Check first page presence
    expect(find.text("Explorez"), findsOneWidget);
    expect(find.text("Continuer"), findsOneWidget);

    // Tap Continue -> Page 2
    await tester.tap(find.text("Continuer"));
    await tester.pumpAndSettle();
    expect(find.text("Suivez"), findsOneWidget);

    // Tap Continue -> Page 3
    await tester.tap(find.text("Continuer"));
    await tester.pumpAndSettle();
    expect(find.text("Profitez"), findsOneWidget);

    // Check button text changes to Commencer
    expect(find.text("Commencer"), findsOneWidget);

    // Tap Commencer
    // Note: We can't easily test navigation replacement unless we use a navigator observer
    // or check if 'seen_onboarding' is set.

    await tester.tap(find.text("Commencer"));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('seen_onboarding'), true);
  });
}
