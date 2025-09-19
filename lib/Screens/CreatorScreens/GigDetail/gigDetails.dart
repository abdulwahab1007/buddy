
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

// IMPORTANT: Ensure this import points to yor updated GigModel file
import 'package:buddy/Models/gigModel.dart'; // Corrected import to the updated GigModel
import 'package:buddy/res/contants/colors_contants.dart';
// Import new API services
import 'package:buddy/Backend/index.dart';

class GigDetails extends StatefulWidget {
  final int gigId;
  final int index;
  // final String startingPrice;
  final Function(int, GigModel) onGigUpdated;
  final Function(int) onGigDeleted;

  const GigDetails({
    Key? key,
    required this.gigId,
    required this.index,
    required this.onGigUpdated,
    required this.onGigDeleted,
    // required this.startingPrice,
  }) : super(key: key);

  @override
  State<GigDetails> createState() => _GigDetailsState();
}

class _GigDetailsState extends State<GigDetails> {
  late Future<GigModel> _gigFuture;
  bool _isDeleting = false;
  late GigModel _currentGig; // To hold the fetched gig data for local updates

  @override
  void initState() {
    super.initState();
    _gigFuture = fetchGigDetailById(widget.gigId);
  }

  Future<GigModel> fetchGigDetailById(int gigId) async {
    try {
      // Use new API service to get gig details
      final response = await CreatorService.getGigDetails(gigId);
      
      if (response['success'] == true) {
        final data = response['data'];
        debugPrint('API Response (Single Gig): $data');

        if (data == null) {
          throw Exception('API returned null data');
        }

        final gig = GigModel.fromJson(data);
        debugPrint('Final Processed Image URL (GigDetails): ${gig.media_path}');
        _currentGig = gig; // Initialize _currentGig after successful fetch
        return gig;
      } else {
        throw Exception(response['error'] ?? 'Failed to load gig details');
      }
    } catch (e) {
      debugPrint('Error fetching gig details: $e');
      rethrow;
    }
  }

  Future<void> _deleteGig(int gigId) async {
    setState(() => _isDeleting = true);

    try {
      // Use new API service to delete gig
      final response = await CreatorService.deleteGig(gigId);
      
      if (response['success'] == true) {
        if (mounted) {
          widget.onGigDeleted(widget.index);
          Navigator.pop(context); // Pop the detail screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gig deleted successfully')),
          );
        }
      } else {
        throw Exception(response['error'] ?? 'Failed to delete gig');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting gig: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  void _showDeleteConfirmation(BuildContext context, int gigId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Gig'),
        content: const Text('Are you sure you want to delete this gig?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Pop the dialog
              _deleteGig(gigId);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showEditPopup() {
    TextEditingController titleController =
        TextEditingController(text: _currentGig.title);
    TextEditingController descController =
        TextEditingController(text: _currentGig.description);
    TextEditingController priceController =
        TextEditingController(text: _currentGig.price);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Gig"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "Description"),
              ),
              TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Price"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
              onPressed: () {
                final updatedGig = _currentGig.copyWith(
                  title: titleController.text,
                  description: descController.text,
                  price: priceController.text,
                  // Keep existing image info as it's not edited here
                  media_path: _currentGig.media_path,
                );

                setState(() {
                  _currentGig = updatedGig; // Update local state
                });

                widget.onGigUpdated(widget.index, updatedGig); // Notify parent
                Navigator.pop(context); // Pop the dialog
              },
              child: const Text("Save")),
        ],
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _showEditPopup();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title:
                    const Text('Delete', style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context); // Pop the bottom sheet
                  _showDeleteConfirmation(context, _currentGig.id);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GigModel>(
      future: _gigFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: ColorsContants.primaryColor),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _gigFuture = fetchGigDetailById(widget.gigId);
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsContants.primaryColor,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_rounded,
                    color: ColorsContants.primaryColor),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: const Center(child: Text('Gig not found')),
          );
        }

        final gig = _currentGig; // Use the locally managed _currentGig

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_rounded,
                  color: ColorsContants.primaryColor),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              gig.title,
              style: const TextStyle(
                color: ColorsContants.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: ColorsContants.primaryColor,
                ),
                onPressed: _showBottomSheet, // Use the bottom sheet for options
              ),
              if (_isDeleting)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _gigFuture = fetchGigDetailById(widget.gigId);
              });
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gig Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: CachedNetworkImage(
                        imageUrl: gig
                            .media_path, // <--- IMPORTANT: Use gig.imageUrl here
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        errorWidget: (context, url, error) {
                          debugPrint('CachedNetworkImage Error: $error');
                          debugPrint('Failed URL for image: $url');
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 40,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Failed to load image',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Title Section
                  _buildSectionCard(
                    child: ListTile(
                      leading:
                          const Icon(Icons.title, color: ColorsContants.primaryColor),
                      title: const Text(
                        "Title",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        gig.title,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Description Section
                  _buildSectionCard(
                    child: ListTile(
                      leading: const Icon(Icons.description,
                          color: ColorsContants.primaryColor),
                      title: const Text(
                        "Description",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        gig.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Price Section
                  _buildSectionCard(
                    child: ListTile(
                      leading: const Icon(Icons.attach_money,
                          color: ColorsContants.primaryColor),
                      title: const Text(
                        "Starting Price",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "₹${gig.price}",
                        style: const TextStyle(
                          fontSize: 18,
                          color: ColorsContants.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Features (kept from your original code)
                  const Text(
                    "What's Included",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureList([
                    "Professional Service",
                    "Fast Delivery",
                    "100% Satisfaction",
                    "Revisions Available",
                    "24/7 Support"
                  ]),

                  const SizedBox(height: 24),
                  // Order Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        showSendOfferDialog(gig.price);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorsContants.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Place Order',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> showSendOfferDialog(String price) async {
    TextEditingController nameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController detailsController = TextEditingController();


    DateTime? selectedDate;
    // List<String> gigs = ['Gig 1', 'Gig 2', 'Gig 3']; // Replace with actual gigs

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Create Offer',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: ColorsContants.primaryColor,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Gig Selection

                    const SizedBox(height: 16),
                    // Number of Revisions
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: Colors.grey[100],
                    //     borderRadius: BorderRadius.circular(15),
                    //   ),
                    //   child: TextField(
                    //     controller: revisionController,
                    //     keyboardType: TextInputType.number,
                    //     decoration: InputDecoration(
                    //       labelText: 'Number of Revisions',
                    //       border: OutlineInputBorder(
                    //         borderRadius: BorderRadius.circular(15),
                    //         borderSide: BorderSide.none,
                    //       ),
                    //       filled: true,
                    //       fillColor: Colors.transparent,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    // Price
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Full Name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: detailsController,
                      maxLines: 4,
                      decoration: const InputDecoration(labelText: 'Project Details'),
                    ),
                    const SizedBox(height: 12),

                    const SizedBox(height: 16),
                    // Delivery Date Selection
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
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
                            if (picked != null) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 16),
                            child: Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Colors.grey),
                                const SizedBox(width: 12),
                                Text(
                                  selectedDate == null
                                      ? 'Select Delivery Date'
                                      : DateFormat('MMM dd, yyyy')
                                          .format(selectedDate!),
                                  style: TextStyle(
                                    color: selectedDate == null
                                        ? Colors.grey[600]
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Send Offer Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorsContants.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final token = prefs.getString('auth_token');

                          if (token == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text('Authentication token not found')),
                            );
                            return;
                          }

                          if (selectedDate == null ||
                              nameController.text.isEmpty ||
                              emailController.text.isEmpty ||
                              detailsController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill all fields')),
                            );
                            return;
                          }



                          try {
                            // Use new API service to create order
                            final response = await BuyerService.createOrder(
                              gigId: widget.gigId,
                              buyerName: nameController.text,
                              email: emailController.text,
                              projectDetails: detailsController.text,
                              budget: double.parse(price.toString()),
                              expectedDeliveryDate: DateFormat('yyyy-MM-dd').format(selectedDate!),
                            );

                            if (response['success'] == true) {
                              Navigator.pop(context); // Close the dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Order placed successfully!')),
                              );
                            } else {
                              throw Exception(response['error'] ?? 'Failed to place order');
                            }
                          } catch (e) {
                            debugPrint('Order exception: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error placing order: ${e.toString()}')),
                            );
                          }
                        },
                        child: const Text(
                          'Send Offer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildFeatureList(List<String> features) {
    return Column(
      children: features.map((feature) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              const Icon(
                Icons.check_circle,
                color: ColorsContants.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                feature,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
