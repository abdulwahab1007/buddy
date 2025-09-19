import 'package:flutter/material.dart';
import 'package:buddy/res/contants/colors_contants.dart';
import 'package:buddy/Screens/Order/enhanced_order_card.dart';

class OrdersSection extends StatefulWidget {
  const OrdersSection({super.key});

  @override
  State<OrdersSection> createState() => _OrdersSectionState();
}

class _OrdersSectionState extends State<OrdersSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample data - Replace with actual data from your backend
  final List<Map<String, dynamic>> activeOrders = [
    {
      'orderName': 'Website Design',
      'buyerName': 'John Smith',
      'profileImageUrl': 'assets/avature.png',
      'description': 'Modern website design for a tech startup',
      'status': 'In Progress',
      'startDate': DateTime.now(),
      'endDate': DateTime.now().add(const Duration(days: 14)),
      'milestones': [
        {'name': 'Wireframes', 'completed': true},
        {'name': 'Design Draft', 'completed': false},
        {'name': 'Final Delivery', 'completed': false},
      ],
      'attachments': [],
      'deliveredFiles': [],
      'isDelivered': false,
    },
    {
      'orderName': 'Mobile App UI',
      'buyerName': 'Sarah Johnson',
      'profileImageUrl': 'assets/avature.png',
      'description': 'UI design for iOS fitness application',
      'status': 'In Progress',
      'startDate': DateTime.now(),
      'endDate': DateTime.now().add(const Duration(days: 10)),
      'milestones': [
        {'name': 'User Flow', 'completed': true},
        {'name': 'UI Design', 'completed': false},
      ],
      'attachments': [],
      'deliveredFiles': [],
      'isDelivered': false,
    },
  ];

  final List<Map<String, dynamic>> completedOrders = [
    {
      'orderName': 'Logo Design',
      'buyerName': 'Mike Wilson',
      'profileImageUrl': 'assets/avature.png',
      'description': 'Modern logo design for a restaurant',
      'status': 'Completed',
      'startDate': DateTime.now().subtract(const Duration(days: 30)),
      'endDate': DateTime.now().subtract(const Duration(days: 15)),
      'milestones': [
        {'name': 'Initial Concepts', 'completed': true},
        {'name': 'Final Design', 'completed': true},
      ],
      'attachments': [],
      'deliveredFiles': [],
      'isDelivered': true,
    },
  ];

  final List<Map<String, dynamic>> cancelledOrders = [
    {
      'orderName': 'Banner Design',
      'buyerName': 'Emma Davis',
      'profileImageUrl': 'assets/avature.png',
      'description': 'Social media banner design',
      'status': 'Cancelled',
      'startDate': DateTime.now().subtract(const Duration(days: 20)),
      'endDate': DateTime.now().subtract(const Duration(days: 18)),
      'milestones': [
        {'name': 'Design Draft', 'completed': false},
      ],
      'attachments': [],
      'deliveredFiles': [],
      'isDelivered': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with count
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Icon(Icons.assignment, color: ColorsContants.primaryColor),
                const SizedBox(width: 10),
                const Text(
                  "My Orders",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: ColorsContants.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${activeOrders.length + completedOrders.length + cancelledOrders.length} Total",
                    style: const TextStyle(
                      color: ColorsContants.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Custom TabBar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: ColorsContants.primaryColor,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey[600],
              labelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.pending_actions),
                      const SizedBox(width: 8),
                      Text("Active (${activeOrders.length})"),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle),
                      const SizedBox(width: 8),
                      Text("Completed (${completedOrders.length})"),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.cancel),
                      const SizedBox(width: 8),
                      Text("Cancelled (${cancelledOrders.length})"),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Active Orders
                _buildOrdersList(activeOrders),

                // Completed Orders
                _buildOrdersList(completedOrders),

                // Cancelled Orders
                _buildOrdersList(cancelledOrders),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              "No orders found",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return EnhancedOrderCard(
          orderName: order['orderName'],
          buyerName: order['buyerName'],
          profileImageUrl: order['profileImageUrl'],
          description: order['description'],
          status: order['status'],
          startDate: order['startDate'],
          endDate: order['endDate'],
          milestones: order['milestones'],
          attachments: order['attachments'],
          deliveredFiles: order['deliveredFiles'],
          isDelivered: order['isDelivered'],
          onStatusChange: () {},
          onMilestoneToggle: (_) {},
          onEndDateChange: () {},
          onUploadWork: () {},
          onDeliverOrder: () {},
          onMessageBuyer: () {},
        );
      },
    );
  }
}
