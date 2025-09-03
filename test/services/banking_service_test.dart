
import 'package:flutter_test/flutter_test.dart';
import 'package:africmobile/services/bankingService.dart';
import 'package:africmobile/models/accountModel.dart';
import 'package:africmobile/models/transactionModel.dart';

void main() {
  group('BankingService Tests', () {
    test('should return list of accounts', () async {
      // Act
      final accounts = await BankingService.getAccounts();

      // Assert
      expect(accounts, isA<List<Account>>());
      expect(accounts.length, 2);
      expect(accounts[0].id, 'acc_1');
      expect(accounts[0].type, 'current');
      expect(accounts[0].balance, 542300);
      expect(accounts[1].id, 'acc_2');
      expect(accounts[1].type, 'savings');
      expect(accounts[1].balance, 1200000);
    });

    test('should return list of transactions for account', () async {
      // Act
      final transactions = await BankingService.getTransactions('acc_1');

      // Assert
      expect(transactions, isA<List<Transaction>>());
      expect(transactions.length, greaterThan(0));
      expect(transactions.first.currency, 'XAF');
    });

    test('should initiate transfer successfully with valid data', () async {
      // Arrange
      const fromAccountId = 'acc_1';
      const toAccountNumber = '1234567890';
      const amount = 20000.0;
      const currency = 'XAF';
      const note = 'Test transfer';

      // Act
      final result = await BankingService.initiateTransfer(
        fromAccountId: fromAccountId,
        toAccountNumber: toAccountNumber,
        amount: amount,
        currency: currency,
        note: note,
      );

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['transferId'], isNotNull);
      expect(result['status'], 'pending');
      expect(result['estimatedCompletion'], isNotNull);
    });

    test('should throw exception when transfer amount exceeds balance', () async {
      // Arrange
      const fromAccountId = 'acc_1';
      const toAccountNumber = '1234567890';
      const amount = 600000.0; // More than account balance (542300)
      const currency = 'XAF';
      const note = 'Test transfer';

      // Act & Assert
      expect(
        () => BankingService.initiateTransfer(
          fromAccountId: fromAccountId,
          toAccountNumber: toAccountNumber,
          amount: amount,
          currency: currency,
          note: note,
        ),
        throwsException,
      );
    });

    test('should calculate total balance correctly', () async {
      // Act
      final accounts = await BankingService.getAccounts();
      final totalBalance = accounts.fold(0.0, (sum, account) => sum + account.balance);

      // Assert
      expect(totalBalance, 1742300); // 542300 + 1200000
    });
  });
}
