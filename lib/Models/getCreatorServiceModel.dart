// To parse this JSON data, do
//
//     final getCreatorServices = getCreatorServicesFromJson(jsonString);

import 'dart:convert';

GetCreatorServices getCreatorServicesFromJson(String str) =>
    GetCreatorServices.fromJson(json.decode(str));

String getCreatorServicesToJson(GetCreatorServices data) =>
    json.encode(data.toJson());

class GetCreatorServices {
  final List<CreatorServices>? services;

  GetCreatorServices({
    this.services,
  });

  factory GetCreatorServices.fromJson(Map<String, dynamic> json) =>
      GetCreatorServices(
        services: json["services"] == null
            ? []
            : List<CreatorServices>.from(
                json["services"]!.map((x) => CreatorServices.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "services": services == null
            ? []
            : List<dynamic>.from(services!.map((x) => x.toJson())),
      };
}

class CreatorServices {
  final int? id;
  final String? creatorProfileId;
  final String? serviceTitle;
  final String? servicePrice;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CreatorServices({
    this.id,
    this.creatorProfileId,
    this.serviceTitle,
    this.servicePrice,
    this.createdAt,
    this.updatedAt,
  });

  factory CreatorServices.fromJson(Map<String, dynamic> json) =>
      CreatorServices(
        id: json["id"] ?? 0,
        creatorProfileId: json["creator_profile_id"] ?? "",
        serviceTitle: json["service_title"] ?? "",
        servicePrice: json["service_price"] ?? "",
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "creator_profile_id": creatorProfileId,
        "service_title": serviceTitle,
        "service_price": servicePrice,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
