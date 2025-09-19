import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:buddy/Models/buyer_all_orders_model.dart';
import 'package:buddy/helpers/auth_helper.dart';
import 'package:buddy/helpers/config/app_url.dart';
import 'package:buddy/screens/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:buddy/res/contants/colors_contants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class BayerOrderHistory extends StatefulWidget {
  const BayerOrderHistory({super.key});

  @override
  State<BayerOrderHistory> createState() => _BayerOrderHistoryState();
}

class _BayerOrderHistoryState extends State<BayerOrderHistory> {
  // Sample orders data - in a real app, this would be fetched from a backend
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.BayerOrderHistoryUrl),
          headers: await getAuthHeaders());

      log(response.body.toString());
      if (response.statusCode == 200) {
        final parsed = BuyerAllOrders.fromJson(json.decode(response.body));
        if (parsed.status == true && parsed.data != null) {
          setState(() {
            orders = parsed.data!.map((data) {
              List milestones = [];
              try {
                milestones = data.milestone != null
                    ? List<Map<String, dynamic>>.from(
                        json.decode(data.milestone!))
                    : [];
              } catch (_) {}

              return {
                'id': data.id.toString(),
                'orderName': data.gig?.label ?? 'Unnamed Gig',
                'serviceProviderName': data.buyerName ?? 'Unknown Creator',
                'profileImageUrl': 'assets/avature.png', // default image
                'description': data.projectDetails ?? '',
                'duration': data.expectedDeliveryDate != null &&
                        data.startDate != null
                    ? '${DateTime.parse(data.expectedDeliveryDate!).difference(DateTime.parse(data.startDate!)).inDays} days'
                    : 'N/A',
                'orderStatus': data.status ?? 'Pending',
                'startDate': data.startDate ?? 'Unknown',
                'expectedCompletionDate':
                    data.expectedDeliveryDate ?? 'Unknown',
                'milestones': milestones,
                'deliveredFiles': [], // No file API provided yet
                'isDelivered': data.status?.toLowerCase() == 'completed',
              };
            }).toList();
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order History',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: ColorsContants.primaryColor,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(
                      context,
                      order: order,
                      onViewDeliveredFiles: () {
                        if (order['isDelivered']) {
                          _showDeliveredFiles(context, order['deliveredFiles']);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeliveredFiles(BuildContext context, List<dynamic> files) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Delivered Files',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: files.length,
                  itemBuilder: (context, index) {
                    final file = files[index];
                    return ListTile(
                      leading: Icon(
                        file['type'] == 'image'
                            ? Icons.image
                            : Icons.insert_drive_file,
                        color: ColorsContants.primaryColor,
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
                                Navigator.pop(context);
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
                                              child:
                                                  Text('Unable to load image'),
                                            );
                                          },
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text('Close'),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            )
                          : IconButton(
                              icon: const Icon(Icons.download),
                              onPressed: () {
                                // Download file logic would go here
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Downloading file...'),
                                  ),
                                );
                              },
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOrderCard(
    BuildContext context, {
    required Map<String, dynamic> order,
    required VoidCallback onViewDeliveredFiles,
  }) {
    final bool isDelivered = order['isDelivered'] ?? false;
    final String orderStatus = order['orderStatus'];

    return Card(
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
                  backgroundImage: AssetImage(order['profileImageUrl']),
                  backgroundColor: Colors.grey.shade300,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['orderName'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: ColorsContants.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'by ${order['serviceProviderName']}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                      if (order['description'] != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          order['description'],
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Status badges
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(orderStatus).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _getStatusColor(orderStatus)),
                  ),
                  child: Text(
                    orderStatus,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(orderStatus),
                    ),
                  ),
                ),
                if (isDelivered) ...[
                  const SizedBox(width: 8),
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
              ],
            ),

            const SizedBox(height: 12),

            /// DURATION + DATES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Duration: ${order['duration']}',
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Start: ${order['startDate']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Completion: ${order['expectedCompletionDate']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
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
            ...List.generate(order['milestones'].length, (index) {
              final milestone = order['milestones'][index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(
                      milestone['completed']
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color:
                          milestone['completed'] ? Colors.green : Colors.orange,
                      size: 18,
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

            const SizedBox(height: 12),

            /// ACTION BUTTONS
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Chat()),
                      );
                    },
                    icon: Icon(
                      Icons.chat,
                      size: 16,
                      color: ColorsContants.textColor,
                    ),
                    label: Text(
                      'Chat',
                      style: TextStyle(color: ColorsContants.textColor),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsContants.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (isDelivered) ...[
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: onViewDeliveredFiles,
                      icon: const Icon(
                        Icons.download,
                        size: 16,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'View Deliverables',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
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
}
