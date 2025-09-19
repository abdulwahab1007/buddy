import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isTokenValid({int expiryDays = 7}) async {
  final prefs = await SharedPreferences.getInstance();

  final token = prefs.getString('auth_token');
  final savedTime = prefs.getInt('token_saved_time');

  if (token == null || savedTime == null) return false;

  final now = DateTime.now().millisecondsSinceEpoch;
  final expiryDuration = Duration(days: expiryDays).inMilliseconds;

  return (now - savedTime) < expiryDuration;
}

Future<Map<String, dynamic>> checkAuthStatus({int expiryDays = 7}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  final role = prefs.getString('user_role');
  final savedTime = prefs.getInt('token_saved_time');

  if (token == null || savedTime == null || role == null) {
    return {'isValid': false};
  }

  final now = DateTime.now().millisecondsSinceEpoch;
  final expiryDuration = Duration(days: expiryDays).inMilliseconds;

  if ((now - savedTime) < expiryDuration) {
    return {
      'isValid': true,
      'role': role,
    };
  }

  return {'isValid': false};
}
