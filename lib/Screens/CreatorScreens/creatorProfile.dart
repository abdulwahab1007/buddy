import 'dart:developer';
import 'dart:io';


import 'package:buddy/Backend/api/gigs_service.dart' as api_service;
import 'package:buddy/Models/creeator_profile_model.dart';
// import 'package:buddy/Backend/api_service.dart' as api_service;
// import 'package:buddy/Models/creeator_profile_model.dart' show CreatorProfileData, Service;
import 'package:buddy/Screens/auth/login.dart';
import 'package:flutter/material.dart';

import 'package:buddy/res/contants/colors_contants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:buddy/Screens/CreatorScreens/EditProfile.dart';

class CreatorProfile extends StatefulWidget {
  const CreatorProfile({super.key});

  @override
  State<CreatorProfile> createState() => _CreatorProfileState();
}

class _CreatorProfileState extends State<CreatorProfile> {
  String name = "";
  String title = "";
  String email = '';
  String about = "";
  List<Map<String, dynamic>> skills = [];

  List<Service> services = [];
  String profileImageUrl = "";
  File? pickedImageFile;

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      CreatorProfileData data = await api_service.fetchProfileData();

      setState(() {
        name = data.name;
        title = data.title;
        email = data.email;
        about = data.about;

        // Store skills as a list of maps with 'id' and 'name'
        skills = data.skills.map((skill) {
          return {'id': skill['id'], 'name': skill['name']};
        }).toList();

        profileImageUrl = data.profileImageUrl;
        isLoading = false;
      });
    } catch (error) {
      print("Error loading profile: $error");
    }
  }



  void _navigateToEditProfile() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(
          currentName: name,
          currentTitle: title,
          currentAbout: about,
          currentSkills: skills,
          // currentServices: services
          //     .map((s) => Service(title: s.title, price: s.price))
          //     .toList(),
          currentProfileImage: profileImageUrl,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        name = result['name'];
        title = result['title'];
        about = result['about'];
        skills = List<Map<String, dynamic>>.from(result['skills']);

        // services = (result['services'] as List)
        //     .map((s) => Service(title: s.title, price: s.price))
        //     .toList();
        if (result['imageFile'] != null) {
          pickedImageFile = result['imageFile'];
        }
      });
      // TODO: Implement API call to update profile
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: ColorsContants.primaryColor,
              ),
            )
          : CustomScrollView(
              slivers: [
                // Modern App Bar
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: [
                            ColorsContants.primaryColor.withOpacity(0.8),
                            ColorsContants.primaryColor.withOpacity(0.4),
                          ],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 37,
                                    backgroundImage: pickedImageFile != null
                                        ? FileImage(pickedImageFile!)
                                        : const AssetImage("assets/avature.png")
                                            as ImageProvider,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      Text(
                                        title,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, color: Colors.white),
                      ),
                      onPressed: _navigateToEditProfile,
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.logout, color: Colors.white),
                      ),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('auth_token');
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Login()),
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ),

                // Profile Content
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Stats Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 24),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "4.8",
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    " (128 Reviews)",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  _buildStatItem(
                                      "Orders", "54", Icons.shopping_bag),
                                  _buildStatItem(
                                      "Earnings", "\u20b912.5k", Icons.wallet),
                                  _buildStatItem("Projects", "16", Icons.work),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // About Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.person_outline,
                                      color: ColorsContants.primaryColor),
                                  SizedBox(width: 10),
                                  Text(
                                    "About Me",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                about,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Skills Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.psychology,
                                      color: ColorsContants.primaryColor),
                                  SizedBox(width: 10),
                                  Text(
                                    "Skills",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: skills.map((skill) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: ColorsContants.primaryColor
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: ColorsContants.primaryColor
                                            .withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      skill[
                                          'name'], // ✅ Access the name from the map
                                      style: const TextStyle(
                                        color: ColorsContants.primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: ColorsContants.primaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
