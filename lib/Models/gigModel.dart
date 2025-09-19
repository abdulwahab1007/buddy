import 'package:flutter/material.dart';

class GigModel {
  final int id;
  final String title;
  final String description;
  final String price;
  final IconData? icon;
  final String media_path;

  GigModel({
    required this.id,
    required this.title,
    required this.description,
    required this.media_path,
    required this.price,
    this.icon = Icons.work,
  });

  factory GigModel.fromJson(Map<String, dynamic> json) {
    return GigModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      title: json['label'] ?? 'No title',
      description: json['description'] ?? '',
      price: json['starting_price']?.toString() ?? '0',
      media_path: json['media'] ??
          json['media_path'] ??
          'https://via.placeholder.com/150',
    );
  }

  // ✅ Add copyWith method here
  GigModel copyWith({
    int? id,
    String? title,
    String? description,
    String? price,
    IconData? icon,
    String? media_path,
  }) {
    return GigModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      icon: icon ?? this.icon,
      media_path: media_path ?? this.media_path,
    );
  }
}
