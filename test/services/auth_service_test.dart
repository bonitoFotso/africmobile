import 'package:africmobile/services/authService.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthService Tests', () {
    setUp(() {
      // Reset auth state before each test
      AuthService.logout();
    });

    test('should login successfully with correct credentials', () async {
      // Arrange
      const username = 'alice';
      const password = 'password123';

      // Act
      final result = await AuthService.login(username, password);

      // Assert
      expect(result, true);
      expect(AuthService.isAuthenticated, true);
      expect(AuthService.currentUser?.name, 'Alice T.');
      expect(AuthService.currentUser?.id, 'u_1');
    });

    test('should fail login with incorrect credentials', () async {
      // Arrange
      const username = 'alice';
      const password = 'wrongpassword';

      // Act
      final result = await AuthService.login(username, password);

      // Assert
      expect(result, false);
      expect(AuthService.isAuthenticated, false);
      expect(AuthService.currentUser, isNull);
    });

    test('should logout successfully', () {
      // Arrange - Login first
      AuthService.login('alice', 'password123');

      // Act
      AuthService.logout();

      // Assert
      expect(AuthService.isAuthenticated, false);
      expect(AuthService.currentUser, isNull);
    });

    test('should handle empty credentials', () async {
      // Act & Assert
      expect(await AuthService.login('', ''), false);
      expect(await AuthService.login('alice', ''), false);
      expect(await AuthService.login('', 'password123'), false);
    });
  });
}