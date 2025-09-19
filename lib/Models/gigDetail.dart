// import 'package:flutter/material.dart';
// // import 'package:buddy/res/contants/colors_contants.dart';

// class GigModel {
//   final int id;
//   final String title;
//   final String description;
//   final String price;
//   final IconData? icon;
//   final String mediaPath;
//   final String mediaUrl;
//   final String imageUrl;

//   GigModel({
//     required this.id,
//     required this.title,
//     required this.description,
//     required this.price,
//     required this.mediaPath,
//     required this.mediaUrl,
//     required this.imageUrl,
//     this.icon = Icons.work,
//   });

//   factory GigModel.fromJson(Map<String, dynamic> json) {
//     print('Raw JSON: $json');
    
//     // Get the media URL from the response
//     final String mediaUrl = json['media_url'] ?? '';
//     print('Media URL from JSON: $mediaUrl');
    
//     // Extract the filename from the media_url if it exists
//     String mediaPath = '';
//     if (mediaUrl.isNotEmpty) {
//       final parts = mediaUrl.split('/');
//       if (parts.isNotEmpty) {
//         mediaPath = parts.last;
//       }
//     }
//     print('Extracted Media Path: $mediaPath');
    
//     // Construct the full image URL
//     final String imageUrl = mediaUrl.isNotEmpty 
//         ? mediaUrl 
//         : 'https://buddy.nexltech.com/public/storage/gigs/$mediaPath';
//     print('Final Image URL: $imageUrl');
    
//     return GigModel(
//       id: json['id'] ?? 0,
//       title: json['label'] ?? json['title'] ?? '',
//       description: json['description'] ?? '',
//       price: (json['starting_price'] ?? json['price'])?.toString() ?? '0',
//       icon: Icons.design_services,
//       mediaPath: mediaPath,
//       mediaUrl: mediaUrl,
//       imageUrl: imageUrl,
//     );
//   }

//   GigModel copyWith({
//     int? id,
//     String? title,
//     String? description,
//     String? price,
//     IconData? icon,
//     String? mediaPath,
//     String? mediaUrl,
//     String? imageUrl,
//   }) {
//     return GigModel(
//       id: id ?? this.id,
//       title: title ?? this.title,
//       description: description ?? this.description,
//       price: price ?? this.price,
//       icon: icon ?? this.icon,
//       mediaPath: mediaPath ?? this.mediaPath,
//       mediaUrl: mediaUrl ?? this.mediaUrl,
//       imageUrl: imageUrl ?? this.imageUrl,
//     );
//   }
// }

// class GigDetailsScreen extends StatefulWidget {
//   final int index;
//   final GigModel gig;
//   final Function(int, GigModel) onGigUpdated;
//   final Function(int) onGigDeleted;

//   const GigDetailsScreen({
//     Key? key,
//     required this.index,
//     required this.gig,
//     required this.onGigUpdated,
//     required this.onGigDeleted,
//   }) : super(key: key);

//   @override
//   State<GigDetailsScreen> createState() => _GigDetailsScreenState();
// }

// class _GigDetailsScreenState extends State<GigDetailsScreen> {
//   late GigModel _currentGig;

//   @override
//   void initState() {
//     super.initState();
//     _currentGig = widget.gig;
//   }

//   void _showEditPopup() {
//     TextEditingController titleController =
//         TextEditingController(text: _currentGig.title);
//     TextEditingController descController =
//         TextEditingController(text: _currentGig.description);
//     TextEditingController priceController =
//         TextEditingController(text: _currentGig.price);

//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Edit Gig"),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                 controller: titleController,
//                 decoration: const InputDecoration(labelText: "Title"),
//               ),
//               TextField(
//                 controller: descController,
//                 maxLines: 3,
//                 decoration: const InputDecoration(labelText: "Description"),
//               ),
//               TextField(
//                 controller: priceController,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(labelText: "Price"),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel")),
//           ElevatedButton(
//               onPressed: () {
//                 final updatedGig = _currentGig.copyWith(
//                   title: titleController.text,
//                   description: descController.text,
//                   price: priceController.text,
//                 );

//                 setState(() {
//                   _currentGig = updatedGig;
//                 });

//                 widget.onGigUpdated(widget.index, updatedGig);
//                 Navigator.pop(context);
//               },
//               child: const Text("Save")),
//         ],
//       ),
//     );
//   }

//   void _confirmDelete() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Delete Gig"),
//         content: const Text("Are you sure you want to delete this gig?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             style: TextButton.styleFrom(
//               foregroundColor: Colors.red,
//             ),
//             onPressed: () {
//               widget.onGigDeleted(widget.index);
//               Navigator.pop(context);
//               Navigator.pop(context);
//             },
//             child: const Text("Delete"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: const Icon(Icons.edit),
//                 title: const Text('Edit'),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _showEditPopup();
//                 },
//               ),
//               ListTile(
//                 leading: const Icon(Icons.delete, color: Colors.red),
//                 title:
//                     const Text('Delete', style: TextStyle(color: Colors.red)),
//                 onTap: () {
//                   Navigator.pop(context);
//                   _confirmDelete();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildSectionCard({required Widget child}) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 3,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: child,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           _currentGig.title,
//           style: TextStyle(color: ColorsContants.primaryColor),
//         ),
//         backgroundColor: Colors.white,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new_rounded),
//           onPressed: () => Navigator.pop(context),
//           color: ColorsContants.primaryColor,
//         ),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.edit, color: ColorsContants.primaryColor),
//             onPressed: _showBottomSheet,
//           ),
//         ],
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Image Section
//               Card(
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(16),
//                 ),
//                 elevation: 4,
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(16),
//                   child: _currentGig.media_path.isNotEmpty
//                       ? Image.network(
//                           'https://buddy.nexltech.com/storage/app/public/${_currentGig.media_path}',
//                           fit: BoxFit.cover,
//                           width: double.infinity,
//                           height: 200,
//                           errorBuilder: (context, error, stackTrace) =>
//                               const Icon(
//                             Icons.broken_image,
//                             size: 80,
//                             color: Colors.grey,
//                           ),
//                         )
//                       : Container(
//                           height: 200,
//                           color: Colors.grey.shade300,
//                           child: const Center(
//                             child: Icon(
//                               Icons.image,
//                               size: 80,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // Title Section
//               _buildSectionCard(
//                 child: ListTile(
//                   leading: Icon(Icons.title, color: ColorsContants.primaryColor),
//                   title: const Text(
//                     "Title",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(
//                     _currentGig.title,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),

//               // Description Section
//               _buildSectionCard(
//                 child: ListTile(
//                   leading: Icon(Icons.description, color: ColorsContants.primaryColor),
//                   title: const Text(
//                     "Description",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(
//                     _currentGig.description,
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),

//               // Price Section
//               _buildSectionCard(
//                 child: ListTile(
//                   leading: Icon(Icons.attach_money, color: ColorsContants.primaryColor),
//                   title: const Text(
//                     "Starting Price",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   subtitle: Text(
//                     _currentGig.price,
//                     style: TextStyle(
//                       fontSize: 18,
//                       color: ColorsContants.primaryColor,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
