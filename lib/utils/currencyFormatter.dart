class CurrencyFormatter {
  static String format(double amount, String currency) {
    final isNegative = amount < 0;
    final absoluteAmount = amount.abs();
    final formattedAmount = absoluteAmount.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]} ',
    );
    
    final sign = isNegative ? '-' : '';
    return '$sign$formattedAmount $currency';
  }
}
