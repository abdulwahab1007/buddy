import 'dart:developer';
import 'dart:convert';

import 'dart:io';
import 'package:buddy/Models/getCreatorServiceModel.dart';

import 'package:buddy/helpers/helper_function_api/ContentCreator/content_Creator_editProfile.dart';
import 'package:flutter/material.dart';
import 'package:buddy/res/contants/colors_contants.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final String currentName;
  final String currentTitle;
  final String currentAbout;
  final List<Map<String, dynamic>> currentSkills;

  // final List<Service> currentServices;
  final String currentProfileImage;

  const EditProfileScreen({
    Key? key,
    required this.currentName,
    required this.currentTitle,
    required this.currentAbout,
    required this.currentSkills,
    // required this.currentServices,
    required this.currentProfileImage,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController titleController;
  late TextEditingController aboutController;
  late TextEditingController skillController;
  late TextEditingController serviceTitleController;
  late TextEditingController servicePriceController;

  File? pickedImageFile;
  List<Map<String, dynamic>> skills = [];
  // { "id": 5, "name": "Flutter" }

  bool isSaving = false;
  List<CreatorServices> services = [];

  @override
  void initState() {
    super.initState();
    _loadCreatorServiceData();
    nameController = TextEditingController(text: widget.currentName);
    titleController = TextEditingController(text: widget.currentTitle);
    aboutController = TextEditingController(text: widget.currentAbout);
    skillController = TextEditingController();
    serviceTitleController = TextEditingController();
    servicePriceController = TextEditingController();
    skills = widget.currentSkills
        .map((s) => {"id": s["id"], "name": s["name"]})
        .toList();

    // services = List.from(widget.currentServices);
  }

  Future<void> _loadCreatorServiceData() async {
    try {
      final GetCreatorServices profile =
          await CreatorProfileEdit().fetchCreatorService();
      setState(() {
        services = profile.services ?? [];
      });

      if (profile.services != null && profile.services!.isNotEmpty) {
        serviceTitleController.text =
            profile.services!.first.serviceTitle ?? '';
        servicePriceController.text =
            profile.services!.first.servicePrice ?? '';
      }
    } catch (e) {
      log("❌ Failed to load services: $e");
      setState(() {
        services = [];
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() {
        pickedImageFile = File(pickedFile.path);
      });
    }
  }

  void _addSkill() async {
    final newSkillName = skillController.text.trim();
    if (newSkillName.isNotEmpty) {
      final response = await CreatorProfileEdit().createCreatorSkills(
        skillName: newSkillName,
      );

      if (response.statusCode == 200) {
        final createdSkill = jsonDecode(response.body);
        // Assuming response has { "id": 15, "name": "Flutter" }

        setState(() {
          skills.add({"id": createdSkill["id"], "name": createdSkill["name"]});
          skillController.clear();
        });
      } else {
        log("❌ Failed to add skill: ${response.statusCode}");
      }
    }
  }

  void _removeSkill(int index) async {
    final skillId = skills[index]["id"];
    final skillName = skills[index]["name"];

    log("🛠 Attempting to delete skill: $skillName (ID: $skillId)");

    try {
      final response = await CreatorProfileEdit().deleteCreatorSkills(skillId);

      if (response.statusCode == 200) {
        log("✅ Skill deleted from DB: $skillName");
        setState(() {
          skills.removeAt(index); // Remove from UI
        });
      } else {
        log("❌ Failed to delete skill: Status ${response.statusCode}");
        log("📩 Response body: ${response.body}");
      }
    } catch (e) {
      log("❌ Error deleting skill: $e");
    }
  }

  void _removeService(CreatorServices service, int index) async {
    final id = service.id;

    if (id == null || id == 0) {
      log("❌ Invalid service ID: $id");
      return;
    }

    log("🛠 Attempting to delete service with ID: $id");

    try {
      final response = await CreatorProfileEdit().deleteCreatorServices(id);

      if (response.statusCode == 200) {
        log("✅ Service deleted successfully from DB");
        setState(() {
          services.removeAt(index); // Remove from UI only after success
        });
      } else {
        log("❌ Failed to delete service: Status ${response.statusCode}");
        log("📩 Response body: ${response.body}");
      }
    } catch (e) {
      log("❌ Error while deleting service: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (isSaving)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ColorsContants.primaryColor),
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: () {
                Navigator.pop(context, {
                  'name': nameController.text,
                  'title': titleController.text,
                  'about': aboutController.text,
                  'skills': skills,
                  'services': services,
                  'imageFile': pickedImageFile,
                });
              },
              child: const Text(
                'Save',
                style: TextStyle(
                  color: ColorsContants.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image Section
            Center(
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        radius: 57,
                        backgroundImage: pickedImageFile != null
                            ? FileImage(pickedImageFile!)
                            : const AssetImage("assets/avature.png")
                                as ImageProvider,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: ColorsContants.primaryColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Form Fields
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: nameController,
                    label: "Full Name",
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: titleController,
                    label: "Professional Title",
                    icon: Icons.work_outline,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    controller: aboutController,
                    label: "About Me",
                    icon: Icons.info_outline,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 30),

                  // Skills Section
                  const Text(
                    "Skills",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: skillController,
                          decoration: InputDecoration(
                            hintText: "Add a skill",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide:
                                  BorderSide(color: Colors.grey.shade300),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: _addSkill,
                        icon: const Icon(Icons.add_circle,
                            color: ColorsContants.primaryColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: skills.asMap().entries.map((entry) {
                      final index = entry.key;
                      final skill = entry.value;

                      return Chip(
                        label: Text(skill["name"]),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () => _removeSkill(index),
                        backgroundColor:
                            ColorsContants.primaryColor.withOpacity(0.1),
                        labelStyle:
                            const TextStyle(color: ColorsContants.primaryColor),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  // // Services Section
                  // const Text(
                  //   "Services",
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black87,
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  // Container(
                  //   padding: const EdgeInsets.all(16),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(12),
                  //     border: Border.all(color: Colors.grey.shade300),
                  //   ),
                  //   child: Column(
                  //     children: [
                  //       TextField(
                  //         controller: serviceTitleController,
                  //         decoration: const InputDecoration(
                  //           hintText: "Service Title",
                  //           border: UnderlineInputBorder(),
                  //         ),
                  //       ),
                  //       const SizedBox(height: 10),
                  //       TextField(
                  //         controller: servicePriceController,
                  //         decoration: const InputDecoration(
                  //           hintText: "Price",
                  //           border: UnderlineInputBorder(),
                  //         ),
                  //         keyboardType: TextInputType.number,
                  //       ),
                  //       const SizedBox(height: 10),
                  //       ElevatedButton(
                  //         onPressed: _addService,
                  //         style: ElevatedButton.styleFrom(
                  //           backgroundColor: ColorsContants.primaryColor,
                  //           shape: RoundedRectangleBorder(
                  //             borderRadius: BorderRadius.circular(8),
                  //           ),
                  //         ),
                  //         child: const Text("Add Service"),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // const SizedBox(height: 10),
                  // ...services.asMap().entries.map((entry) {
                  //   final index = entry.key;
                  //   final service = entry.value;

                  //   return GestureDetector(
                  //     onTap: () {
                  //       print("Service tapped: ${service.id}, Index: $index");
                  //     },
                  //     child: Card(
                  //       margin: const EdgeInsets.only(bottom: 8),
                  //       child: ListTile(
                  //         title: Text(service.serviceTitle ?? 'No Title'),
                  //         subtitle: Text("₹${service.servicePrice ?? '0'}"),
                  //         trailing: IconButton(
                  //           icon: const Icon(Icons.delete_outline,
                  //               color: Colors.red),
                  //           onPressed: () => _removeService(service, index),
                  //         ),
                  //       ),
                  //     ),
                  //   );
                  // }).toList(),

                  // const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: ColorsContants.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ColorsContants.primaryColor),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    titleController.dispose();
    aboutController.dispose();
    skillController.dispose();
    serviceTitleController.dispose();
    servicePriceController.dispose();
    super.dispose();
  }
}
