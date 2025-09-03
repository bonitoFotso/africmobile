import 'package:africmobile/models/accountModel.dart';
import 'package:africmobile/models/transactionModel.dart';

class BankingService {
  static final List<Account> _mockAccounts = [
    Account(id: "acc_1", type: "current", currency: "XAF", balance: 542300),
    Account(id: "acc_2", type: "savings", currency: "XAF", balance: 1200000),
  ];

  static final List<Transaction> _mockTransactions = [
    Transaction(
      id: "tx_1",
      date: DateTime.parse("2025-07-12T09:22:00Z"),
      amount: -25000,
      currency: "XAF",
      description: "Loyer Juillet",
      status: "posted",
    ),
    Transaction(
      id: "tx_2",
      date: DateTime.parse("2025-07-10T14:11:00Z"),
      amount: 150000,
      currency: "XAF",
      description: "Salaire",
      status: "posted",
    ),
    Transaction(
      id: "tx_3",
      date: DateTime.parse("2025-07-08T10:30:00Z"),
      amount: -15000,
      currency: "XAF",
      description: "Courses alimentaires",
      status: "posted",
    ),
    Transaction(
      id: "tx_4",
      date: DateTime.parse("2025-07-05T16:45:00Z"),
      amount: -8500,
      currency: "XAF",
      description: "Transport",
      status: "posted",
    ),
  ];

  static Future<List<Account>> getAccounts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockAccounts;
  }

  static Future<List<Transaction>> getTransactions(String accountId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockTransactions;
  }

  static Future<Map<String, dynamic>> initiateTransfer({
    required String fromAccountId,
    required String toAccountNumber,
    required double amount,
    required String currency,
    required String note,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    
    // Simple validation
    final fromAccount = _mockAccounts.firstWhere((acc) => acc.id == fromAccountId);
    if (amount > fromAccount.balance) {
      throw Exception("Solde insuffisant");
    }

    return {
      "transferId": "tr_123",
      "status": "pending",
      "estimatedCompletion": "2025-08-21T12:00:00Z"
    };
  }
}
