import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:africmobile/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Flow Integration Tests', () {
    testWidgets('complete login flow should work correctly', (WidgetTester tester) async {
      // Launch app
      app.main();
      await tester.pumpAndSettle();

      // Verify we're on login screen
      expect(find.text('@Fric Banking'), findsOneWidget);
      expect(find.text('Connexion'), findsOneWidget);

      // Enter credentials
      await tester.enterText(find.byType(TextField).first, 'alice');
      await tester.enterText(find.byType(TextField).last, 'password123');

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify we're on dashboard
      expect(find.text('Bonjour, Alice T.'), findsOneWidget);
      expect(find.text('Solde Total'), findsOneWidget);
      expect(find.text('1 742 300 XAF'), findsOneWidget);
    });

    testWidgets('should show error for invalid credentials', (WidgetTester tester) async {
      // Launch app
      app.main();
      await tester.pumpAndSettle();

      // Enter wrong credentials
      await tester.enterText(find.byType(TextField).first, 'alice');
      await tester.enterText(find.byType(TextField).last, 'wrongpassword');

      // Tap login button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify error message appears
      expect(find.text('Identifiants incorrects'), findsOneWidget);
      
      // Verify we're still on login screen
      expect(find.text('Connexion'), findsOneWidget);
    });
  });
}