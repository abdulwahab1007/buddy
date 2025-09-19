
import 'package:flutter/material.dart';
import 'package:buddy/res/contants/colors_contants.dart';
import 'package:intl/intl.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class PlaceOrderScreen extends StatefulWidget {
  final String creatorName;
  final String creatorTitle;
  final String serviceTitle;
  final String servicePrice;

  const PlaceOrderScreen({
    Key? key,
    required this.creatorName,
    required this.creatorTitle,
    required this.serviceTitle,
    required this.servicePrice,
  }) : super(key: key);

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _requirementsController = TextEditingController();
  DateTime? _deliveryDate;
  String? _selectedPackage;
  final List<String> _packages = ['Basic', 'Standard', 'Premium'];
  final Map<String, double> _packagePrices = {
    'Basic': 299.0,
    'Standard': 599.0,
    'Premium': 999.0,
  };

  // List to store attached files
  final List<Map<String, dynamic>> _attachedFiles = [];

  @override
  void initState() {
    super.initState();
    _selectedPackage = _packages[0];
  }

  @override
  void dispose() {
    _projectTitleController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _deliveryDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ColorsContants.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _deliveryDate) {
      setState(() {
        _deliveryDate = picked;
      });
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        _attachedFiles.add({
          'name': file.name,
          'path': file.path,
          'type': _getFileType(file.extension ?? ''),
          'size': file.size,
          'date': DateTime.now(),
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File attached successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _pickVideo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? video = await picker.pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        _attachedFiles.add({
          'name': video.name,
          'path': video.path,
          'type': 'video',
          'date': DateTime.now(),
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Video attached successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _attachedFiles.add({
          'name': image.name,
          'path': image.path,
          'type': 'image',
          'date': DateTime.now(),
        });
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image attached successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  String _getFileType(String extension) {
    extension = extension.toLowerCase();
    if (['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension)) {
      return 'image';
    } else if (['mp4', 'mov', 'avi', 'mkv', 'wmv', 'flv'].contains(extension)) {
      return 'video';
    } else if (['pdf', 'doc', 'docx', 'txt', 'rtf'].contains(extension)) {
      return 'document';
    } else if (['mp3', 'wav', 'ogg', 'aac', 'm4a'].contains(extension)) {
      return 'audio';
    } else {
      return 'file';
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachedFiles.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File removed'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Attach Files (Optional)',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.image,
                    label: 'Image',
                    onTap: () {
                      Navigator.pop(context);
                      _pickImage();
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.videocam,
                    label: 'Video',
                    onTap: () {
                      Navigator.pop(context);
                      _pickVideo();
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.attach_file,
                    label: 'File',
                    onTap: () {
                      Navigator.pop(context);
                      _pickFile();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Attach demo videos, images, or any reference files to help the creator understand your requirements better.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: ColorsContants.primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: ColorsContants.primaryColor,
              size: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Icon _getFileIcon(String type) {
    switch (type) {
      case 'image':
        return const Icon(Icons.image, color: Colors.blue);
      case 'video':
        return const Icon(Icons.videocam, color: Colors.red);
      case 'document':
        return const Icon(Icons.description, color: Colors.amber);
      case 'audio':
        return const Icon(Icons.audiotrack, color: Colors.green);
      default:
        return const Icon(Icons.insert_drive_file, color: Colors.grey);
    }
  }

  void _submitOrder() {
    if (_formKey.currentState!.validate()) {
      if (_deliveryDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an expected delivery date'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Here you would typically send the order to your backend
      // For now, we'll just show a success dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Order Placed Successfully'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your order for "${_projectTitleController.text}" has been sent to ${widget.creatorName}. They will review and respond shortly.',
              ),
              if (_attachedFiles.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  '${_attachedFiles.length} file(s) attached',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: const Text(
                'OK',
                style: TextStyle(color: ColorsContants.primaryColor),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Place Order',
          style: TextStyle(
            color: ColorsContants.primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorsContants.primaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Creator Info Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: const AssetImage("assets/avature.png"),
                      backgroundColor: Colors.grey.shade300,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.creatorName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            widget.creatorTitle,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Service: ${widget.serviceTitle}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Starting at: ${widget.servicePrice}',
                            style: const TextStyle(
                              fontSize: 14,
                              color: ColorsContants.primaryColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Project Details
              const Text(
                'Project Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Project Title
              TextFormField(
                controller: _projectTitleController,
                decoration: InputDecoration(
                  labelText: 'Project Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: ColorsContants.primaryColor),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a project title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Project Description
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Project Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: ColorsContants.primaryColor),
                  ),
                ),
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a project description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Specific Requirements
              TextFormField(
                controller: _requirementsController,
                decoration: InputDecoration(
                  labelText: 'Specific Requirements',
                  hintText: 'E.g., file formats, style preferences, etc.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: ColorsContants.primaryColor),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Attachments Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Attachments (Optional)',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 55,
                    width: 150,
                    child: ElevatedButton.icon(
                      onPressed: _showAttachmentOptions,
                      icon: const Icon(Icons.attach_file, size: 18),
                      label: const Text('Add File'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsContants.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Display attached files
              if (_attachedFiles.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'No files attached yet. Add demo videos or reference files (optional).',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              else
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _attachedFiles.length,
                    itemBuilder: (context, index) {
                      final file = _attachedFiles[index];
                      return ListTile(
                        leading: _getFileIcon(file['type']),
                        title: Text(
                          file['name'],
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                          'Added on ${DateFormat('MMM dd, yyyy').format(file['date'])}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeAttachment(index),
                        ),
                        dense: true,
                      );
                    },
                  ),
                ),

              const SizedBox(height: 24),

              // Package Selection
              const Text(
                'Select Package',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Package Radio Buttons
              ...List.generate(_packages.length, (index) {
                final package = _packages[index];
                return RadioListTile<String>(
                  title: Text(package),
                  subtitle:
                      Text('₹${_packagePrices[package]?.toStringAsFixed(2)}'),
                  value: package,
                  groupValue: _selectedPackage,
                  activeColor: ColorsContants.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      _selectedPackage = value;
                    });
                  },
                );
              }),

              const SizedBox(height: 24),

              // Delivery Date
              const Text(
                'Expected Delivery Date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _deliveryDate == null
                            ? 'Select a date'
                            : DateFormat('MMM dd, yyyy').format(_deliveryDate!),
                        style: TextStyle(
                          color: _deliveryDate == null
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                      const Icon(
                        Icons.calendar_today,
                        color: ColorsContants.primaryColor,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _submitOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsContants.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Place Order',
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorsContants.textColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
