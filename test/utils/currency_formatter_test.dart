import 'package:flutter_test/flutter_test.dart';
import 'package:africmobile/utils/currencyFormatter.dart';

void main() {
  group('CurrencyFormatter Tests', () {
    test('should format positive amounts correctly', () {
      // Act & Assert
      expect(CurrencyFormatter.format(1000, 'XAF'), '1 000 XAF');
      expect(CurrencyFormatter.format(542300, 'XAF'), '542 300 XAF');
      expect(CurrencyFormatter.format(1200000, 'XAF'), '1 200 000 XAF');
    });

    test('should format negative amounts correctly', () {
      // Act & Assert
      expect(CurrencyFormatter.format(-25000, 'XAF'), '-25 000 XAF');
      expect(CurrencyFormatter.format(-1500, 'XAF'), '-1 500 XAF');
    });

    test('should format zero correctly', () {
      // Act & Assert
      expect(CurrencyFormatter.format(0, 'XAF'), '0 XAF');
    });

    test('should handle different currencies', () {
      // Act & Assert
      expect(CurrencyFormatter.format(1000, 'EUR'), '1 000 EUR');
      expect(CurrencyFormatter.format(1000, 'USD'), '1 000 USD');
    });

    test('should format decimal amounts correctly', () {
      // Act & Assert
      expect(CurrencyFormatter.format(1000.50, 'XAF'), '1 000 XAF'); // Should remove decimals
      expect(CurrencyFormatter.format(1000.99, 'XAF'), '1 000 XAF');
    });

    test('should handle large amounts', () {
      // Act & Assert
      expect(CurrencyFormatter.format(1000000000, 'XAF'), '1 000 000 000 XAF');
    });

    test('should handle single digit amounts', () {
      // Act & Assert
      expect(CurrencyFormatter.format(5, 'XAF'), '5 XAF');
      expect(CurrencyFormatter.format(-7, 'XAF'), '-7 XAF');
    });
  });
}