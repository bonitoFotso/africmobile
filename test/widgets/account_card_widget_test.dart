import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:africmobile/screens/widget/accountCardWidget.dart';
import 'package:africmobile/models/accountModel.dart';

void main() {
  group('AccountCard Tests', () {
    testWidgets('should display account information correctly', (WidgetTester tester) async {
      // Arrange
      final account = Account(
        id: 'acc_1',
        type: 'current',
        currency: 'XAF',
        balance: 542300,
      );


      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(
              account: account,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Compte Courant'), findsOneWidget);
      expect(find.text('ACC_1'), findsOneWidget);
      expect(find.text('542 300 XAF'), findsOneWidget);
      expect(find.byIcon(Icons.account_balance_wallet), findsOneWidget);
    });

    testWidgets('should handle tap correctly', (WidgetTester tester) async {
      // Arrange
      final account = Account(
        id: 'acc_2',
        type: 'savings',
        currency: 'XAF',
        balance: 1200000,
      );

      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(
              account: account,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.byType(AccountCard));
      await tester.pumpAndSettle();

      // Assert
      expect(tapped, true);
    });

    testWidgets('should display correct icon for savings account', (WidgetTester tester) async {
      // Arrange
      final account = Account(
        id: 'acc_2',
        type: 'savings',
        currency: 'XAF',
        balance: 1200000,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(
              account: account,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.savings), findsOneWidget);
      expect(find.text('Compte Épargne'), findsOneWidget);
    });

    testWidgets('should display negative balance in red', (WidgetTester tester) async {
      // Arrange
      final account = Account(
        id: 'acc_3',
        type: 'current',
        currency: 'XAF',
        balance: -50000,
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AccountCard(
              account: account,
              onTap: () {},
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('-50 000 XAF'), findsOneWidget);
      
      // Verify the text color is red
      final textWidget = tester.widget<Text>(find.text('-50 000 XAF'));
      expect(textWidget.style?.color, Colors.red);
    });
  });
}