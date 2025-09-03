import 'package:flutter_test/flutter_test.dart';
import 'package:africmobile/models/transactionModel.dart';

void main() {
  group('Transaction Model Tests', () {
    test('should create Transaction from JSON correctly', () {
      // Arrange
      final json = {
        'id': 'tx_1',
        'date': '2025-07-12T09:22:00Z',
        'amount': -25000,
        'currency': 'XAF',
        'description': 'Loyer Juillet',
        'status': 'posted',
      };

      // Act
      final transaction = Transaction.fromJson(json);

      // Assert
      expect(transaction.id, 'tx_1');
      expect(transaction.date, DateTime.parse('2025-07-12T09:22:00Z'));
      expect(transaction.amount, -25000.0);
      expect(transaction.currency, 'XAF');
      expect(transaction.description, 'Loyer Juillet');
      expect(transaction.status, 'posted');
    });

    test('should correctly identify credit transactions', () {
      // Arrange
      final creditTransaction = Transaction(
        id: 'tx_1',
        date: DateTime.now(),
        amount: 150000,
        currency: 'XAF',
        description: 'Salaire',
        status: 'posted',
      );

      // Act & Assert
      expect(creditTransaction.isCredit, true);
    });

    test('should correctly identify debit transactions', () {
      // Arrange
      final debitTransaction = Transaction(
        id: 'tx_2',
        date: DateTime.now(),
        amount: -25000,
        currency: 'XAF',
        description: 'Loyer',
        status: 'posted',
      );

      // Act & Assert
      expect(debitTransaction.isCredit, false);
    });

    test('should handle zero amount transaction', () {
      // Arrange
      final zeroTransaction = Transaction(
        id: 'tx_3',
        date: DateTime.now(),
        amount: 0,
        currency: 'XAF',
        description: 'Test',
        status: 'posted',
      );

      // Act & Assert
      expect(zeroTransaction.isCredit, false); // 0 is not > 0
    });

    test('should parse date correctly from ISO string', () {
      // Arrange
      const dateString = '2025-07-12T09:22:00Z';
      final expectedDate = DateTime.parse(dateString);
      
      final json = {
        'id': 'tx_1',
        'date': dateString,
        'amount': -25000,
        'currency': 'XAF',
        'description': 'Test',
        'status': 'posted',
      };

      // Act
      final transaction = Transaction.fromJson(json);

      // Assert
      expect(transaction.date, expectedDate);
    });
  });
}