class BuyerProfile {
  final int id;
  final String name;
  final String email;
  final String? contactNumber;
  final String? about;

  BuyerProfile({
    required this.id,
    required this.name,
    required this.email,
    this.contactNumber,
    this.about,
  });

  factory BuyerProfile.fromJson(Map<String, dynamic> json) {
    return BuyerProfile(
      id: json['id'] ?? 0, // Ensure ID is parsed
      name: json['name'] ?? "",
      email: json['email'] ?? "",
      contactNumber: json['contact_number'],
      about: json['about'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'contact_number': contactNumber,
      'about': about,
    };
  }
}
