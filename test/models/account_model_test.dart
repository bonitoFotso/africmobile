import 'package:flutter_test/flutter_test.dart';
import 'package:africmobile/models/accountModel.dart';

void main() {
  group('Account Model Tests', () {
    test('should create Account from JSON correctly', () {
      // Arrange
      final json = {
        'id': 'acc_1',
        'type': 'current',
        'currency': 'XAF',
        'balance': 542300,
      };

      // Act
      final account = Account.fromJson(json);

      // Assert
      expect(account.id, 'acc_1');
      expect(account.type, 'current');
      expect(account.currency, 'XAF');
      expect(account.balance, 542300.0);
    });

    test('should return correct display type for current account', () {
      // Arrange
      final account = Account(
        id: 'acc_1',
        type: 'current',
        currency: 'XAF',
        balance: 542300,
      );

      // Act & Assert
      expect(account.displayType, 'Compte Courant');
    });

    test('should return correct display type for savings account', () {
      // Arrange
      final account = Account(
        id: 'acc_2',
        type: 'savings',
        currency: 'XAF',
        balance: 1200000,
      );

      // Act & Assert
      expect(account.displayType, 'Compte Épargne');
    });

    test('should return original type for unknown account type', () {
      // Arrange
      final account = Account(
        id: 'acc_3',
        type: 'business',
        currency: 'XAF',
        balance: 100000,
      );

      // Act & Assert
      expect(account.displayType, 'business');
    });

    test('should handle different balance values', () {
      // Arrange & Act
      final positiveAccount = Account(id: 'acc_1', type: 'current', currency: 'XAF', balance: 1000);
      final zeroAccount = Account(id: 'acc_2', type: 'current', currency: 'XAF', balance: 0);
      final negativeAccount = Account(id: 'acc_3', type: 'current', currency: 'XAF', balance: -500);

      // Assert
      expect(positiveAccount.balance, 1000.0);
      expect(zeroAccount.balance, 0.0);
      expect(negativeAccount.balance, -500.0);
    });
  });
}