class Account {
  final String id;
  final String type;
  final String currency;
  final double balance;

  Account({
    required this.id,
    required this.type,
    required this.currency,
    required this.balance,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      type: json['type'],
      currency: json['currency'],
      balance: json['balance'].toDouble(),
    );
  }
  String get displayType {
    switch (type) {
      case 'current':
        return 'Compte Courant';
      case 'savings':
        return 'Compte Épargne';
      default:
        return type;
    }
  }
}