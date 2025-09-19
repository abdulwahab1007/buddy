import 'dart:convert';
import 'dart:developer';


import 'package:buddy/Models/getCreatorServiceModel.dart';
import 'package:buddy/helpers/auth_helper.dart';
import 'package:buddy/helpers/config/app_url.dart';

import 'package:http/http.dart' as http;

class CreatorProfileEdit {
  Future<GetCreatorServices> fetchCreatorService() async {
    final response = await http.get(
      Uri.parse(ApiConfig.getCreatorServiceUrl),
      headers: await getAuthHeaders(),
    );
    log("hitting api  ${ApiConfig.getCreatorServiceUrl}");
    log(response.body.toString());
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      log("Response data: $jsonData");

      return GetCreatorServices.fromJson(jsonData);
    } else {
      throw Exception(
          'Failed to load profile. Status code: ${response.statusCode}');
    }
  }

  Future<GetCreatorServices> createCreatorService({
    required String serviceTitle,
    required String servicePrice,
  }) async {
    var url = Uri.parse(ApiConfig.createCreatorServiceUrl);
    var request = http.MultipartRequest('POST', url);

    // Add authentication headers if needed
    final headers = await getAuthHeaders();
    request.headers.addAll(headers);

    request.fields['service_title'] = serviceTitle;
    request.fields['service_price'] = servicePrice;

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

  Future<http.Response> deleteCreatorServices(int id) async {
    log("Deleting service with ID: $id");

    var request = http.Request(
        'DELETE', Uri.parse('${ApiConfig.deleteCreatorServiceUrl}/1?$id'));
    final headers = await getAuthHeaders();
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    return await http.Response.fromStream(response);
  }

  Future createCreatorSkills({
    required String skillName,
  }) async {
    var url = Uri.parse(ApiConfig.createskillsUrl);
    var request = http.MultipartRequest('POST', url);

    // Add authentication headers if needed
    final headers = await getAuthHeaders();
    request.headers.addAll(headers);

    request.fields['name'] = skillName;

    // Send request
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    log("📡 API HIT: createCreatorService → ${response.statusCode}");
    log("📦 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      log("Response data: $jsonData");
    } else {
      throw Exception(
          '❌ Failed to create service. Status: ${response.statusCode}');
    }
  }

  Future<http.Response> deleteCreatorSkills(int id) async {
    var request = http.Request(
      'DELETE',
      Uri.parse('https://buddy.nexltech.com/public/api/skills/$id'),
    );
    final headers = await getAuthHeaders();
    request.headers.addAll(headers);

    http.StreamedResponse streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }
}
