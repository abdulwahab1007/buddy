import 'dart:io';
import 'package:buddy/Backend/api/gigs_service.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CreateGigScreen extends StatefulWidget {
  const CreateGigScreen({super.key});

  @override
  _CreateGigScreenState createState() => _CreateGigScreenState();
}

class _CreateGigScreenState extends State<CreateGigScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _labelController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _selectedImage;
  bool _isLoading = false;
  bool _isPicking = false;

  Future<void> _pickImage() async {
    if (_isPicking) return;
    _isPicking = true;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    } finally {
      _isPicking = false;
    }
  }

  Future<void> _submitGig() async {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      setState(() => _isLoading = true);
      print('Submitting gig with label: ${_labelController.text}, '
          'description: ${_descriptionController.text}, '
          'starting price: ${_priceController.text}'
          'media file: ${_selectedImage!.path}');
      bool success = await createGig(
        label: _labelController.text,
        description: _descriptionController.text,
        startingPrice: _priceController.text,
        mediaFile: _selectedImage!,
      );

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              success ? 'Gig Created Successfully!' : 'Failed to Create Gig'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and select an image.')),
      );
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Create New Gig'),
        centerTitle: true,
        backgroundColor: Colors.greenAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _labelController,
                              decoration:
                                  _inputDecoration('Gig Title', Icons.title),
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter gig title' : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _descriptionController,
                              decoration: _inputDecoration(
                                  'Description', Icons.description),
                              validator: (value) =>
                                  value!.isEmpty ? 'Enter description' : null,
                              maxLines: 4,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _priceController,
                              decoration: _inputDecoration(
                                  'Starting Price', Icons.attach_money),
                              keyboardType: TextInputType.number,
                              validator: (value) => value!.isEmpty
                                  ? 'Enter starting price'
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _pickImage,
                      child: _selectedImage != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                _selectedImage!,
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Container(
                              height: 180,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey),
                              ),
                              child: const Center(
                                child: Text(
                                  'Tap to select an image',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.grey),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _submitGig,
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text(
                          'Submit Gig',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: Colors.greenAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
