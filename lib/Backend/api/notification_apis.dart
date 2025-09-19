import 'dart:convert';
import 'dart:developer';
// import 'dart:io';
import 'package:buddy/Models/notification_model.dart';
import 'package:http/http.dart' as http;

// import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<List<NotificationItem>> fetchNotifications() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');

  if (token == null) {
    throw Exception('No auth token found');
  }

  var headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  final uri = Uri.parse(
      'https://buddy.nexltech.com/public/api/notifications?receiver_id=2');
  final response = await http.get(uri, headers: headers);
  log("hitting api");
  log(response.body.toString());
  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResponse = json.decode(response.body);
    if (jsonResponse.containsKey('data') && jsonResponse['data'] is List) {
      final List<dynamic> data = jsonResponse['data'];
      return data.map((item) => NotificationItem.fromJson(item)).toList();
    } else {
      return [];
    }
  } else {
    log('Failed to load notifications: ${response.statusCode}');
  }
  return [];
}
