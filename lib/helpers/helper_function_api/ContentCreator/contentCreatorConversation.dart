// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:developer';

import 'package:buddy/Models/getCreatorServiceModel.dart';
import 'package:buddy/helpers/auth_helper.dart';
import 'package:buddy/helpers/config/app_url.dart';
import 'package:http/http.dart' as http;

class contentCreatorConversation {
  Future createCreatorConversation({
    required String receiverId,
    required String message,
  }) async {
    var url = Uri.parse(ApiConfig.contentCreatorConversationUrl);
    var request = http.MultipartRequest('POST', url);

    // Add authentication headers if needed
    final headers = await getAuthHeaders();
    request.headers.addAll(headers);

    request.fields['receiver_id'] = receiverId;
    request.fields['message'] = message;

    // Send request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    log("📡 API HIT: createCreatorService → ${response.statusCode}");
    log("📦 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return GetCreatorServices.fromJson(jsonData);
    } else {
      throw Exception(
          '❌ Failed to create service. Status: ${response.statusCode}');
    }
  }
}
