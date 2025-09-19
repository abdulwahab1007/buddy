import 'dart:convert';
import 'dart:developer';
import 'package:buddy/Models/buyer_all_orders_model.dart';
import 'package:buddy/helpers/auth_helper.dart';
import 'package:buddy/helpers/config/app_url.dart';
import 'package:buddy/res/contants/colors_contants.dart';
import 'package:buddy/screens/chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CreatorOrderStatus extends StatefulWidget {
  const CreatorOrderStatus({super.key});

  @override
  State<CreatorOrderStatus> createState() => _CreatorOrderStatusState();
}

class _CreatorOrderStatusState extends State<CreatorOrderStatus>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<Map<String, dynamic>> allOrders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchOrders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
            allOrders = parsed.data!.map((data) {
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
                'buyerName': data.buyerName ?? 'Unknown Buyer',
                'profileImageUrl': 'assets/avature.png',
                'description': data.projectDetails ?? 'No description provided',
                'status': data.status ?? 'Pending',
                'price': '\$${data.budget ?? 0}',
                'daysLeft': data.expectedDeliveryDate != null &&
                        data.startDate != null
                    ? '${DateTime.parse(data.expectedDeliveryDate!).difference(DateTime.now()).inDays} days left'
                    : 'N/A',
                'progress': _calculateProgress(milestones),
                'startDate':
                    DateTime.parse(data.startDate ?? DateTime.now().toString()),
                'endDate': DateTime.parse(
                    data.expectedDeliveryDate ?? DateTime.now().toString()),
                'completedDate': data.status?.toLowerCase() == 'completed'
                    ? DateFormat('MMM dd, yyyy').format(DateTime.now())
                    : null,
                'rating': 4.5,
                'milestones': milestones,
                'deliveredFiles': [], // Placeholder for delivered files
                'isDelivered': data.status?.toLowerCase() == 'completed',
              };
            }).toList();
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching orders: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  double _calculateProgress(List<dynamic> milestones) {
    if (milestones.isEmpty) return 0.0;
    int completedMilestones =
        milestones.where((m) => m['completed'] == true).length;
    return completedMilestones / milestones.length;
  }

  @override
  Widget build(BuildContext context) {
    final pendingOrders =
        allOrders.where((order) => order['status'] == 'pending').toList();
    final completedOrders =
        allOrders.where((order) => order['status'] == 'Completed').toList();
    final cancelledOrders =
        allOrders.where((order) => order['status'] == 'Cancelled').toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: ColorsContants.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.assignment_outlined,
                              color: ColorsContants.primaryColor, size: 24),
                        ),
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "My Orders",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${allOrders.length} Total Orders",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  TabBar(
                    controller: _tabController,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(
                        width: 3,
                        color: ColorsContants.primaryColor,
                      ),
                      insets: EdgeInsets.symmetric(horizontal: 40),
                    ),
                    labelColor: ColorsContants.primaryColor,
                    unselectedLabelColor: Colors.grey[600],
                    labelStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    tabs: [
                      _buildTab(Icons.pending_actions, "pending",
                          pendingOrders.length),
                      _buildTab(Icons.check_circle_outline, "Done",
                          completedOrders.length),
                      _buildTab(Icons.cancel_outlined, "Cancel",
                          cancelledOrders.length),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _buildOrdersList(pendingOrders, "pending"),
                        _buildOrdersList(completedOrders, "completed"),
                        _buildOrdersList(cancelledOrders, "cancelled"),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(IconData icon, String label, int count) {
    return Tab(
      height: 56,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 6),
              Text(label),
            ],
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: ColorsContants.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 11,
                color: ColorsContants.primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders, String type) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 64,
              color: Colors.grey[300],
            ),
            const SizedBox(height: 16),
            Text(
              "No ${type.toLowerCase()} orders",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              type == "pending"
                  ? "Your pending orders will appear here"
                  : type == "completed"
                      ? "Completed orders will be listed here"
                      : "Cancelled orders will be shown here",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order, type);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, String type) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: type == "pending"
                  ? ColorsContants.primaryColor.withOpacity(0.1)
                  : type == "completed"
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(order['profileImageUrl']),
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
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "by ${order['buyerName']}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: type == "pending"
                        ? ColorsContants.primaryColor
                        : type == "completed"
                            ? Colors.green
                            : Colors.red,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order['status'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Price",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          order['price'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    if (type == "pending") ...[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Time Left",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            order['daysLeft'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: ColorsContants.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (type == "completed") ...[
                      Row(
                        children: [
                          ...List.generate(
                            order['rating'],
                            (index) => const Icon(Icons.star,
                                color: Colors.amber, size: 18),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                if (type == "pending") ...[
                  const SizedBox(height: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Progress",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            "${(order['progress'] * 100).toInt()}%",
                            style: const TextStyle(
                              fontSize: 12,
                              color: ColorsContants.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: order['progress'],
                          backgroundColor: Colors.grey[200],
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              ColorsContants.primaryColor),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 16),
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
                          color: milestone['completed']
                              ? Colors.green
                              : Colors.orange,
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
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(16)),
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const Chat()),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_outlined,
                          color: Colors.grey[700],
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Message",
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (type == "completed" && order['isDelivered']) {
                        _showDeliveredFiles(context, order['deliveredFiles']);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: type == "pending"
                          ? ColorsContants.primaryColor
                          : Colors.grey[700],
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          type == "pending"
                              ? Icons.check_circle_outline
                              : Icons.remove_red_eye,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          type == "pending" ? "Complete" : "View Deliverables",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
                      title: Text(file['name'] ?? 'Unknown File'),
                      subtitle: Text(
                        'Delivered on ${DateFormat('MMM dd, yyyy').format(file['date'] ?? DateTime.now())}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.download),
                        onPressed: () {
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
}
