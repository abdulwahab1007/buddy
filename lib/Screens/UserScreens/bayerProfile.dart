import 'dart:developer';
import 'dart:io';
import 'package:buddy/Screens/auth/login.dart';
import 'package:buddy/helpers/helper_function_api/bayer/bayerProfileApi.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:buddy/Models/buyer_profile_model.dart';
import 'package:buddy/res/contants/colors_contants.dart';

class BayerProfile extends StatefulWidget {
  const BayerProfile({super.key});

  @override
  _BayerProfileState createState() => _BayerProfileState();
}

class _BayerProfileState extends State<BayerProfile> {
  BuyerProfile? _profile;
  bool _isLoading = true;
  bool _isEditing = false; // Track edit mode
  File? _image;
  final ImagePicker _picker = ImagePicker();

  // Create/Edit form ke liye controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBuyerProfile();
  }

  // API se profile load karne ka function
  Future<void> _loadBuyerProfile() async {
    setState(() => _isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final buyerId = prefs.getInt('buyer_id');

      log("Loading profile for buyer ID: $buyerId");

      if (buyerId == null || buyerId == 0) {
        _profile = null;
      } else {
        Buyer bayer = Buyer();
        _profile = await bayer.fetchBuyerProfileById(buyerId);

        // Pre-fill controllers with profile data
        _nameController.text = _profile!.name;
        _emailController.text = _profile!.email;
        _phoneController.text = _profile!.contactNumber ?? '';
        _aboutController.text = _profile!.about ?? '';
      }
    } catch (e) {
      print("Error loading profile: $e");
      if (e.toString().contains("Profile not found")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile not found, please create one")),
        );
      }
      _profile = null;
    }
    setState(() {
      _isLoading = false;
      _isEditing = false;
    });
  }

  Future<void> _createProfile() async {
    try {
      Buyer bayer = Buyer();
      BuyerProfile? created = await bayer.createBuyerProfile(
        name: _nameController.text,
        email: _emailController.text,
        phone: _phoneController.text,
        imageFile: _image,
      );

      if (created == null) {
        // If profile already exists, try to load it
        final prefs = await SharedPreferences.getInstance();
        final buyerId = prefs.getInt('buyer_id');

        if (buyerId != null && buyerId != 0) {
          await _loadBuyerProfile();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Profile already exists but ID not found"),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile created successfully!"),
            backgroundColor: Colors.green,
          ),
        );
        await _loadBuyerProfile();
      }
    } catch (e) {
      print("Error creating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateProfile() async {
    try {
      if (_profile == null) return;

      Buyer bayer = Buyer();
      await bayer.updateBuyerProfile(
        name: _nameController.text,
        email: _emailController.text, // ✅ Pass email
        phone: _phoneController.text,
        about: _aboutController.text, // ✅ Pass about
        // imageFile: _image,
      );

      // ✅ Refresh the profile data
      await _loadBuyerProfile();

      setState(() {
        _isEditing = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profile updated successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print("Error updating profile: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _logoutUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear all authentication-related data
      await prefs.remove('auth_token');
      await prefs.remove('user_id');
      await prefs.remove('buyer_id'); // ✅ Clear buyer ID

      log("User logged out. Cleared: auth_token, user_id, buyer_id");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } catch (e) {
      print("Error during logout: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Logout failed: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Image picking failed: $e");
    }
  }

  Widget _buildInfoRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: ColorsContants.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Text(
            _profile == null ? "Create Profile" : "Edit Profile",
            style: const TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: ColorsContants.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _pickImage,
            child: const CircleAvatar(
                radius: 60,
                child: Icon(Icons.person,
                    size: 40, color: ColorsContants.primaryColor)),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: "Name"),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: "Email"),
            enabled: _profile == null, // Email can't be changed after creation
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(labelText: "Phone"),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (_profile !=
                  null) // Show cancel button only when editing existing profile
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _isEditing = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
              Expanded(
                child: ElevatedButton(
                  onPressed: _profile == null ? _createProfile : _updateProfile,
                  child: Text(
                      _profile == null ? "Create Profile" : "Save Changes"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ImageProvider? _getProfileImage() {
  //   if (_image != null) return FileImage(_image!);
  //   if (_profile?.imageUrl != null && _profile!.imageUrl!.isNotEmpty) {
  //     return NetworkImage(_profile!.imageUrl!);
  //   }
  //   return const AssetImage('assets/avature.png') as ImageProvider;
  // }

  Widget _buildProfileView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Profile",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: ColorsContants.primaryColor,
                ),
              ),
              const Spacer(),
              IconButton(
                icon:
                    const Icon(Icons.edit, color: ColorsContants.primaryColor),
                onPressed: () => setState(() => _isEditing = true),
              ),
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.logout,
                      color: ColorsContants.primaryColor),
                ),
                onPressed: _logoutUser,
              ),
            ],
          ),
          const Center(
            child: CircleAvatar(
              radius: 60,
              // backgroundImage: _getProfileImage(),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Switch Mode',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ColorsContants.primaryColor,
                fontSize: 20),
          ),
          SlidingSwitch(
            value: false,
            width: 250,
            onChanged: (bool value) {
              print(value);
            },
            height: 55,
            animationDuration: const Duration(milliseconds: 400),
            onTap: () {},
            onDoubleTap: () {},
            onSwipe: () {},
            textOff: "Buyer",
            textOn: "Creator",
            iconOff: Icons.shopping_bag,
            iconOn: Icons.create,
            contentSize: 30,
            colorOn: ColorsContants.primaryColor,
            colorOff: Colors.blue,
            background: const Color(0xffe4e5eb),
            buttonColor: Colors.white,
            inactiveColor: Colors.grey,
          ),
          const SizedBox(height: 10),
          _buildInfoRow("Name", _profile!.name, Icons.person),
          const SizedBox(height: 10),
          _buildInfoRow("Email", _profile!.email, Icons.email),
          const SizedBox(height: 10),
          if (_profile!.contactNumber != null &&
              _profile!.contactNumber!.isNotEmpty)
            _buildInfoRow("Phone", _profile!.contactNumber!, Icons.phone),
          if (_profile!.about != null && _profile!.about!.isNotEmpty)
            _buildInfoRow("About", _profile!.about!, Icons.info),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                        color: ColorsContants.primaryColor),
                    SizedBox(height: 16),
                    Text('Loading profile...'),
                  ],
                ),
              )
            : _isEditing || _profile == null
                ? _buildProfileForm() // Create or Edit form
                : _buildProfileView(), // Profile view
      ),
    );
  }
}
