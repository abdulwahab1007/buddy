import 'dart:io';

import 'package:buddy/res/contants/colors_contants.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EnhancedOrderCard extends StatelessWidget {
  final String orderName;
  final String buyerName;
  final String profileImageUrl;
  final String description;
  final String status;
  final DateTime startDate;
  final DateTime endDate;
  final List<dynamic> milestones;
  final List<dynamic> attachments;
  final List<dynamic> deliveredFiles;
  final bool isDelivered;
  final VoidCallback onStatusChange;
  final Function(int) onMilestoneToggle;
  final VoidCallback onEndDateChange;
  final VoidCallback onUploadWork;
  final VoidCallback onDeliverOrder;
  final VoidCallback onMessageBuyer;

  const EnhancedOrderCard({
    super.key,
    required this.orderName,
    required this.buyerName,
    required this.profileImageUrl,
    required this.description,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.milestones,
    required this.attachments,
    required this.deliveredFiles,
    required this.isDelivered,
    required this.onStatusChange,
    required this.onMilestoneToggle,
    required this.onEndDateChange,
    required this.onUploadWork,
    required this.onDeliverOrder,
    required this.onMessageBuyer,
  });

  Color _getStatusColor() {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      case 'Pending':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color.fromARGB(255, 200, 255, 235),
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(profileImageUrl),
                  backgroundColor: Colors.grey.shade300,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorsContants.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'from $buyerName',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// ORDER STATUS – Clickable
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: onStatusChange,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: _getStatusColor()),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          status,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: _getStatusColor(),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.edit,
                          size: 14,
                          color: _getStatusColor(),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isDelivered)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Delivered",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.check_circle,
                          size: 14,
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            /// DURATION + DATES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start Date:',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(startDate),
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onEndDateChange,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Row(
                        children: [
                          Text(
                            'End Date:',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.edit_calendar,
                            size: 16,
                            color: ColorsContants.primaryColor,
                          ),
                        ],
                      ),
                      Text(
                        DateFormat('MMM dd, yyyy').format(endDate),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// MILESTONES
            const Text(
              'Milestones:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...List.generate(milestones.length, (index) {
              final milestone = milestones[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => onMilestoneToggle(index),
                      child: Icon(
                        milestone['completed']
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        color: milestone['completed']
                            ? Colors.green
                            : Colors.orange,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        milestone['name'],
                        style: TextStyle(
                          fontSize: 14,
                          decoration: milestone['completed']
                              ? TextDecoration.lineThrough
                              : null,
                          color: milestone['completed']
                              ? Colors.grey
                              : Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

            // Attachments section
            if (attachments.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Uploaded Work Files:',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...attachments.map((attachment) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      attachment['type'] == 'image'
                          ? Icons.image
                          : Icons.attach_file,
                      color: ColorsContants.primaryColor,
                    ),
                    title: Text(attachment['name']),
                    subtitle: Text(
                      'Uploaded on ${DateFormat('MMM dd, yyyy').format(attachment['date'])}',
                    ),
                    trailing: attachment['type'] == 'image'
                        ? IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              // Preview image
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.file(
                                        File(attachment['path']),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                            child: Text('Unable to load image'),
                                          );
                                        },
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : null,
                    dense: true,
                  )),
            ],

            // Delivered files section
            if (deliveredFiles.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Delivered Files:',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
              const SizedBox(height: 8),
              ...deliveredFiles.map((file) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      file['type'] == 'image' ? Icons.image : Icons.attach_file,
                      color: Colors.green,
                    ),
                    title: Text(file['name']),
                    subtitle: Text(
                      'Delivered on ${DateFormat('MMM dd, yyyy').format(file['date'])}',
                    ),
                    trailing: file['type'] == 'image'
                        ? IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              // Preview image
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.file(
                                        File(file['path']),
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return const Center(
                                            child: Text('Unable to load image'),
                                          );
                                        },
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: const Text('Close'),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : null,
                    dense: true,
                  )),
            ],

            const SizedBox(height: 16),

            /// ACTION BUTTONS
            Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: ElevatedButton.icon(
                          onPressed: onMessageBuyer,
                          icon: Icon(
                            Icons.chat,
                            size: 20,
                            color: ColorsContants.textColor,
                          ),
                          label: Text(
                            'Message Buyer',
                            style: TextStyle(
                              color: ColorsContants.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsContants.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      SizedBox(
                        height: 50,
                        width: 160,
                        child: ElevatedButton.icon(
                          onPressed: onUploadWork,
                          icon: Icon(
                            Icons.upload,
                            size: 20,
                            color: ColorsContants.textColor,
                          ),
                          label: Text(
                            'Upload Work',
                            style: TextStyle(
                              color: ColorsContants.textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorsContants.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Deliver button
                  if (!isDelivered && attachments.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: onDeliverOrder,
                        icon: const Icon(
                          Icons.check_circle,
                          size: 20,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Deliver Order to Client',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Order delivered message
                  if (isDelivered) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.green),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            'Order has been delivered to client',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
