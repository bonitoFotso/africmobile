import 'package:africmobile/models/userModel.dart';

class AuthService {
  static User? _currentUser;
  static String? _token;

  static Future<bool> login(String username, String password) async {
    // Mock API call
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (username == "alice" && password == "password123") {
      _token = "ey.mock.token";
      _currentUser = User(id: "u_1", name: "Alice T.", role: "user");
      return true;
    }
    return false;
  }

  static void logout() {
    _currentUser = null;
    _token = null;
  }

  static User? get currentUser => _currentUser;
  static bool get isAuthenticated => _token != null;
}
