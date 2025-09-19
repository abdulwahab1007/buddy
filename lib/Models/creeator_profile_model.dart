class CreatorProfileData {
  final String name;
  final String title;
  final String email;
  final String about;
  final List<Map<String, dynamic>> skills;
  final String profileImageUrl;

  CreatorProfileData({
    required this.name,
    required this.title,
    required this.email,
    required this.about,
    required this.skills,
    required this.profileImageUrl,
  });

  factory CreatorProfileData.fromJson(Map<String, dynamic> json) {
    return CreatorProfileData(
      name: json['name'] ?? '',
      title: json['expertise'] ?? '',
      email: json['email'] ?? '',
      about: json['about_me'] ?? '',
      profileImageUrl: json['profileImageUrl'] ?? '',
      skills: (json['skills'] as List<dynamic>? ?? []).map((skill) {
        return {"id": skill['id'], "name": skill['name']};
      }).toList(),
    );
  }
}
