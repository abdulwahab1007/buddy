import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>> getAuthHeaders({
  bool isMultipart = false,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    throw Exception('Auth token not found');
  }

  return {
    'Authorization': 'Bearer $token',
    'Accept': 'application/json',
    if (!isMultipart) 'Content-Type': 'application/json',
  };
}

// import 'package:shared_preferences/shared_preferences.dart';

Future<String> getAuthToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null || token.isEmpty) {
    throw Exception("Auth token not found");
  }

  return token;
}
