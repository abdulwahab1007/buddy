import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> uploadStory({
  required String caption,
  required File mediaFile,
}) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    debugPrint("No token found in SharedPreferences.");
    return false;
  }

  // Print the token for debugging
  debugPrint("Auth Token: $token");

  try {
    var url = Uri.parse('https://buddy.nexltech.com/public/api/stories');
    var request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    request.fields['caption'] = caption;

    request.files.add(
      await http.MultipartFile.fromPath(
        'media',
        mediaFile.path,
      ),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    debugPrint('Upload Story Response Code: ${response.statusCode}');
    debugPrint('Upload Story Response Body: ${response.body}');

    return response.statusCode == 200 || response.statusCode == 201;
  } catch (e) {
    debugPrint("Upload Story Error: $e");
    return false;
  }
}

// View Order
