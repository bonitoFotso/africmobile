class Transaction {
  final String id;
  final DateTime date;
  final double amount;
  final String currency;
  final String description;
  final String status;

  Transaction({
    required this.id,
    required this.date,
    required this.amount,
    required this.currency,
    required this.description,
    required this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      date: DateTime.parse(json['date']),
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      description: json['description'],
      status: json['status'],
    );
  }

  bool get isCredit => amount > 0;
}