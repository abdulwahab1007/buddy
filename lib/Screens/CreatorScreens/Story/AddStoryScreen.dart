import 'dart:io';
import 'package:buddy/Backend/api/story_apis.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:buddy/res/contants/colors_contants.dart';
import 'package:buddy/Models/StoryModel.dart';




class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  File? _image;
  final TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  final picker = ImagePicker();

  Future<void> _pickImage(ImageSource source, BuildContext context) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }

  void _showImageSourceOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera, context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery, context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadStory(BuildContext context) async {
    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final success = await uploadStory(
      caption: _captionController.text,
      mediaFile: _image!,
    );

    if (success && mounted) {
      Navigator.pop(
        context,
        StoryItem(
          imageUrl: _image!
              .path, // You can update this to actual URL if server returns it
          duration: const Duration(seconds: 5),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to upload story")),
      );
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _captionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: ColorsContants.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "Add Story",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: ColorsContants.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Image Picker
                if (_image == null)
                  GestureDetector(
                    onTap: () {
                      _showImageSourceOptions(context);
                    },
                    child: Container(
                      height: 300,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate,
                              size: 64, color: Colors.grey[600]),
                          const SizedBox(height: 12),
                          Text(
                            'Tap to add a photo',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          _image!,
                          height: 300,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _image = null;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.black54,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 16),

                // Caption
                TextField(
                  controller: _captionController,
                  decoration: InputDecoration(
                    hintText: 'Add a caption...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // Upload Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _isLoading ? null : _uploadStory(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsContants.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Share Story',
                            style: TextStyle(fontSize: 16),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
