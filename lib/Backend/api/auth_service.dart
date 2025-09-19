import 'dart:convert';
import 'package:buddy/helpers/config/app_url.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//Signup

Future<bool> signUpUser({
  required String name,
  required String email,
  required String password,
  required String role,
}) async {
  try {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    var request = http.Request(
      'POST',
      Uri.parse(ApiConfig.signupUrl),
    );

    request.body = json.encode({
      "name": name,
      "email": email,
      "password": password,
      "password_confirmation": password,
      "role": role,
    });

    request.headers.addAll(headers);

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Signup response: ${response.body}');
      final data = jsonDecode(response.body);
      return data['success'] == true;
    } else {
      print('Signup failed: ${response.statusCode}');
      print('Response body: ${response.body}');
      return false;
    }
  } catch (e) {
    print('Error during signup: $e');
    return false;
  }
}

//Login

Future<Map<String, dynamic>> loginUser({
  required String email,
  required String password,
}) async {
  const String url = ApiConfig.loginUrl;

  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    print("Login Response: ${response.statusCode}");
    print("Login Body: ${response.body}");

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      final token = responseData['token'] ?? responseData['data']['token'];
      // ignore: unused_local_variable
      final id = responseData['id'] ?? responseData['data']['id'];
      // Handle role
      String? userRole;
      final roleData = responseData['role'] ?? responseData['data']?['role'];
      if (roleData != null) {
        if (roleData is List) {
          userRole = roleData.isNotEmpty ? roleData[0].toString() : 'buyer';
        } else {
          userRole = roleData.toString();
        }
      }

      final userId = responseData['id'] ??
          responseData['user_id'] ??
          responseData['data']?['id'] ??
          responseData['data']?['user_id'];

      if (token != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_role', userRole ?? 'buyer');
        if (userId != null) {
          await prefs.setInt('user_id', userId);
        }

        // Save token saved time
        int savedTime = DateTime.now().millisecondsSinceEpoch;
        await prefs.setInt('token_saved_time', savedTime);

        return {
          'success': true,
          'token': token,
          'role': userRole ?? 'buyer',
          'user_id': userId,
        };
      } else {
        return {'success': false};
      }
    } else {
      return {'success': false};
    }
  } catch (e) {
    print("Login exception: $e");
    return {'success': false};
  }
}
