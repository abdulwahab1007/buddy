import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:buddy/Models/buyer_profile_model.dart';
import 'package:buddy/helpers/auth_helper.dart';
import 'package:buddy/helpers/config/app_url.dart';
import 'package:http/http.dart' as http;

import 'package:shared_preferences/shared_preferences.dart';

class Buyer {
  Future<BuyerProfile> fetchBuyerProfileById(int id) async {
    final response = await http.get(
      Uri.parse("${ApiConfig.BayerProfileUrl}/$id"),
      headers: await getAuthHeaders(),
    );

    log("Hitting fetchBuyerProfile API: ${ApiConfig.BayerProfileUrl}/$id");
    log("Response status: ${response.statusCode}");
    log("Response body: ${response.body}");

    if (response.statusCode == 200) {
      return BuyerProfile.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Profile not found');
    } else {
      throw Exception('Failed to load profile. Status: ${response.statusCode}');
    }
  }

  Future<BuyerProfile?> createBuyerProfile({
    required String name,
    required String email,
    required String phone,
    File? imageFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(ApiConfig.BayerProfileUrl),
    );
    request.headers.addAll(await getAuthHeaders());
    request.fields['user_id'] = userId.toString();
    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['contact_number'] = phone;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profile_image', imageFile.path),
      );
    }

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final jsonData = json.decode(respStr);

    log("Create profile response status: ${response.statusCode}");
    log("Create profile response body: $respStr");

    // Handle profile exists case
    if (jsonData is Map && jsonData['message'] == "Profile already exists.") {
      return null;
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Extract the actual profile ID from the response
      final profileId = jsonData['profile']['id'] as int;

      // ✅ Store buyer ID in SharedPreferences
      await prefs.setInt('buyer_id', profileId);
      log("Stored buyer ID: $profileId");

      return BuyerProfile(
        id: profileId,
        name: jsonData['profile']['name'] ?? "",
        email: jsonData['profile']['email'] ?? "",
        contactNumber: jsonData['profile']['contact_number']?.toString(),
        about: jsonData['profile']['about']?.toString(),
      );
    } else {
      throw Exception("Failed to create profile: $respStr");
    }
  }

  Future<BuyerProfile> updateBuyerProfile({
    required String name,
    required String email,
    required String phone,
    String? about,
    File? imageFile,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final buyerId = prefs.getInt('buyer_id');
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse("${ApiConfig.BayerProfileUrl}/$buyerId"), // ✅ Use passed ID
    );

    request.headers.addAll(await getAuthHeaders());
    request.fields['name'] = name;
    request.fields['email'] = email; // ✅ Add email field
    request.fields['contact_number'] = phone;

    if (imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('profile_image', imageFile.path),
      );
    }

    final response = await request.send();
    final respStr = await response.stream.bytesToString();
    final jsonData = json.decode(respStr);

    log("Update profile response: $respStr");

    if (response.statusCode == 200) {
      // ✅ Parse the profile from the 'profile' object in response
      return BuyerProfile.fromJson(jsonData['profile']);
    } else {
      throw Exception("Failed to update profile: $respStr");
    }
  }
}

// class Buyer {
//   Future<BuyerProfile?> fetchBuyerProfileById(int id) async {
//     final prefs = await SharedPreferences.getInstance();
//     final buyerId = prefs.getInt('buyer_id') ?? id;

//     final response = await http.get(
//       Uri.parse("${ApiConfig.BayerProfileUrl}/$buyerId"),
//       headers: await getAuthHeaders(),
//     );

//     log("➡️ Fetching buyer profile ${ApiConfig.BayerProfileUrl}/$buyerId");
//     log("Response: ${response.body}");

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);

//       // 🔴 If API returns "Profile not found"
//       if (jsonData is Map && jsonData['message'] == "Profile not found") {
//         return null; // return null → show create screen
//       }

//       return BuyerProfile.fromJson(jsonData);
//     } else {
//       throw Exception(
//         'Failed to load profile. Status code: ${response.statusCode}',
//       );
//     }
//   }

//   Future<BuyerProfile?> createBuyerProfile({
//     required String name,
//     required String email,
//     required String phone,
//     File? imageFile,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getInt('user_id'); // login user id

//     var request = http.MultipartRequest(
//       'POST',
//       Uri.parse(ApiConfig.BayerProfileUrl),
//     );

//     request.headers.addAll(await getAuthHeaders());

//     request.fields['user_id'] = userId.toString();
//     request.fields['name'] = name;
//     request.fields['email'] = email;
//     request.fields['contact_number'] = phone;

//     if (imageFile != null) {
//       request.files.add(
//         await http.MultipartFile.fromPath('profile_image', imageFile.path),
//       );
//     }

//     final response = await request.send();
//     final respStr = await response.stream.bytesToString();

//     log("➡️ Create profile response: $respStr");
//     final jsonData = json.decode(respStr);

//     if (jsonData is Map && jsonData['message'] == "Profile already exists.") {
//       return null;
//     }

//     if (response.statusCode == 200 || response.statusCode == 201) {
//       return BuyerProfile.fromJson(jsonData);
//     } else {
//       throw Exception("Failed to create profile: $respStr");
//     }
//   }
// }
