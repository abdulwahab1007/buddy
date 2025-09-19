import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:buddy/Models/creeator_profile_model.dart';
import 'package:buddy/Models/gigModel.dart';

import 'package:buddy/Models/order_model.dart';
import 'package:buddy/helpers/auth_helper.dart';
import 'package:buddy/helpers/config/app_url.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

Future<bool> createGig({
  required String label,
  required String description,
  required String startingPrice,
  required File mediaFile,
}) async {
  // Get token from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    debugPrint("No token found in SharedPreferences.");
    return false;
  }

  var url = Uri.parse('https://buddy.nexltech.com/public/api/gigs');
  var request = http.MultipartRequest('POST', url);

  // Set headers with token
  request.headers['Authorization'] = 'Bearer $token';
  request.headers['Accept'] = 'application/json';

  // Add fields
  request.fields['label'] = label;
  request.fields['description'] = description;
  request.fields['starting_price'] = startingPrice;

  // Add media file
  request.files.add(
    await http.MultipartFile.fromPath('media', mediaFile.path),
  );

  // Send request
  var streamedResponse = await request.send();
  var response = await http.Response.fromStream(streamedResponse);

  log("hitting api");
  log(response.body.toString());

  debugPrint('Create Gig Response: ${response.statusCode}');
  debugPrint('Create Gig Body: ${response.body}');

  return response.statusCode == 200;
}

// View Profile

Future<CreatorProfileData> fetchProfileData() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getInt('user_id'); // get the user_id saved in login

  if (userId == null) {
    throw Exception('User ID not found in SharedPreferences');
  }

  final url = "${ApiConfig.userProfileUrl}/$userId";

  final response = await http.get(
    Uri.parse(url),
    headers: await getAuthHeaders(),
  );
  log(jsonDecode(response.body).toString());
  log("hitting api  $url");
  log(response.body.toString());

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    return CreatorProfileData.fromJson(jsonData);
  } else {
    throw Exception(
      'Failed to load profile. Status code: ${response.statusCode}',
    );
  }
}

//Upload Story

Future<List<Order>> fetchOrders() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    throw Exception('No auth token found');
  }

  // final headers = {
  //   'Accept': 'application/json',
  //   'Content-Type': 'application/json',
  //   'Authorization': 'Bearer $token',
  // };

  final uri =
      Uri.parse('http://buddy.nexltech.com/public/api/creator/my-orders');
  try {
    final response = await http.get(
      uri,
      headers: await getAuthHeaders(),
    );

    log("hitting api");
    log(response.body.toString());

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse is Map<String, dynamic> &&
          jsonResponse.containsKey('data')) {
        final data = jsonResponse['data'];

        if (data is List) {
          return data.map((orderJson) => Order.fromJson(orderJson)).toList();
        } else {
          throw Exception('Unexpected data format: "data" is not a list');
        }
      } else {
        throw Exception('Invalid or missing "data" field in response');
      }
    } else {
      throw Exception('Failed to load orders: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('An error occurred while fetching orders: $e');
  }
}

Future<List<GigModel>> fetchGigs() async {
  final token = await getAuthToken(); // get token using helper

  final url = Uri.parse('https://buddy.nexltech.com/public/api/gigs/details');
  final headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final response = await http.get(url, headers: headers);
  log("hitting api");
  log(response.body.toString());
  if (response.statusCode == 200) {
    final decoded = json.decode(response.body);
    final List<dynamic> gigsJson =
        decoded is List ? decoded : (decoded['data'] ?? []);
    return gigsJson.map((gigJson) => GigModel.fromJson(gigJson)).toList();
  } else {
    throw Exception('Failed to fetch gigs: ${response.reasonPhrase}');
  }
}

Future<List<GigModel>> searchGigs(String query) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    throw Exception('No auth token found');
  }

  try {
    final response = await http.get(
      Uri.parse(
          'https://buddy.nexltech.com/public/api/gigs/search?query=$query'),
      headers: await getAuthHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => GigModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search gigs: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error searching gigs: $e');
    rethrow;
  }
}

// Future<BuyerProfile> fetchBuyerProfile(int buyerId) async {
//   print("=================== FETCH BUYER PROFILE ===================");
//   print("Fetching profile for buyer ID: $buyerId");

//   final prefs = await SharedPreferences.getInstance();
//   final token = prefs.getString('auth_token');

//   print("Auth token from preferences: ${token != null ? 'Present' : 'Missing'}");

//   if (token == null) {
//     throw Exception('Token not found in SharedPreferences');
//   }

//   final headers = {
//     'Content-Type': 'application/json',
//     'Accept': 'application/json',
//     'Authorization': 'Bearer $token',
//   };

//   print("Making API request to: https://buddy.nexltech.com/public/api/buyer-profile/$buyerId");
//   print("Using headers: $headers");

//   final response = await http.get(
//     Uri.parse('https://buddy.nexltech.com/public/api/buyer-profile/$buyerId'),
//     headers: headers,
//   );

//   print("Response status code: ${response.statusCode}");
//   print("Response body: ${response.body}");

//   if (response.statusCode == 200) {
//     final jsonData = json.decode(response.body);
//     print("Parsed JSON data: $jsonData");

//     // If response is wrapped inside "data"
//     final profile = BuyerProfile.fromJson(jsonData['data'] ?? jsonData);
//     print("Created BuyerProfile object: Name=${profile.name}, Email=${profile.email}");
//     print("=======================================================");
//     return profile;
//   } else {
//     print("Error response: ${response.body}");
//     print("=======================================================");
//     throw Exception(
//         'Failed to load profile. Status code: ${response.statusCode}');
//   }
// }
