import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:africmobile/screens/widget/transactionCardWidget.dart';
import 'package:africmobile/models/transactionModel.dart';

void main() {
  group('TransactionCard Tests', () {
    testWidgets('should display credit transaction correctly', (WidgetTester tester) async {
      // Arrange
      final transaction = Transaction(
        id: 'tx_1',
        date: DateTime.parse('2025-07-12T09:22:00Z'),
        amount: 150000,
        currency: 'XAF',
        description: 'Salaire',
        status: 'posted',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionCard(transaction: transaction),
          ),
        ),
      );

      // Assert
      expect(find.text('Salaire'), findsOneWidget);
      expect(find.text('150 000 XAF'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
    });

    testWidgets('should display debit transaction correctly', (WidgetTester tester) async {
      // Arrange
      final transaction = Transaction(
        id: 'tx_2',
        date: DateTime.parse('2025-07-12T09:22:00Z'),
        amount: -25000,
        currency: 'XAF',
        description: 'Loyer Juillet',
        status: 'posted',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionCard(transaction: transaction),
          ),
        ),
      );

      // Assert
      expect(find.text('Loyer Juillet'), findsOneWidget);
      expect(find.text('-25 000 XAF'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_upward), findsOneWidget);
    });

    testWidgets('should display pending status badge', (WidgetTester tester) async {
      // Arrange
      final transaction = Transaction(
        id: 'tx_3',
        date: DateTime.now(),
        amount: -15000,
        currency: 'XAF',
        description: 'Transfer pending',
        status: 'pending',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionCard(transaction: transaction),
          ),
        ),
      );

      // Assert
      expect(find.text('PENDING'), findsOneWidget);
    });

    testWidgets('should not display status badge for posted transactions', (WidgetTester tester) async {
      // Arrange
      final transaction = Transaction(
        id: 'tx_4',
        date: DateTime.now(),
        amount: -15000,
        currency: 'XAF',
        description: 'Posted transaction',
        status: 'posted',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TransactionCard(transaction: transaction),
          ),
        ),
      );

      // Assert
      expect(find.text('POSTED'), findsNothing);
    });

    testWidgets('should truncate long descriptions', (WidgetTester tester) async {
      // Arrange
      final transaction = Transaction(
        id: 'tx_5',
        date: DateTime.now(),
        amount: -5000,
        currency: 'XAF',
        description: 'This is a very long transaction description that should be truncated when displayed in the card widget to prevent overflow issues',
        status: 'posted',
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 300, // Constrain width to force truncation
              child: TransactionCard(transaction: transaction),
            ),
          ),
        ),
      );

      // Assert - The widget should exist (truncation is handled by maxLines and overflow)
      expect(find.byType(TransactionCard), findsOneWidget);
      
      // Find the Text widget with the description
      final descriptionFinder = find.text(transaction.description);
      expect(descriptionFinder, findsOneWidget);
      
      // Verify the Text widget has proper overflow handling
      final textWidget = tester.widget<Text>(descriptionFinder);
      expect(textWidget.maxLines, 2);
      expect(textWidget.overflow, TextOverflow.ellipsis);
    });
  });
}