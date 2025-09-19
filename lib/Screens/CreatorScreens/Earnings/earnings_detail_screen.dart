import 'package:buddy/Models/earnings_model.dart';
import 'package:buddy/res/contants/colors_contants.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EarningsDetailScreen extends StatefulWidget {
  const EarningsDetailScreen({Key? key}) : super(key: key);

  @override
  State<EarningsDetailScreen> createState() => _EarningsDetailScreenState();
}

class _EarningsDetailScreenState extends State<EarningsDetailScreen> {
  late Future<EarningsModel> _earningsFuture;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadEarningsData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadEarningsData() async {
    // TODO: Replace with actual API call
    _earningsFuture = Future.value(
      EarningsModel(
        totalEarnings: 125000,
        availableForWithdrawal: 15000,
        monthlyEarnings: 45000,
        pendingClearance: 8500,
        recentTransactions: [
          EarningTransaction(
            id: '1',
            amount: 2500,
            type: 'credit',
            description: 'Logo Design Project',
            date: DateTime.now().subtract(const Duration(days: 1)),
            status: 'completed',
          ),
          EarningTransaction(
            id: '2',
            amount: 3500,
            type: 'credit',
            description: 'Website Development',
            date: DateTime.now().subtract(const Duration(days: 2)),
            status: 'completed',
          ),
          EarningTransaction(
            id: '3',
            amount: 1500,
            type: 'credit',
            description: 'UI/UX Design',
            date: DateTime.now().subtract(const Duration(days: 3)),
            status: 'pending',
          ),
        ],
        stats: EarningsStats(
          totalOrders: 124,
          completedOrders: 120,
          cancelledOrders: 4,
          averageOrderValue: 2500,
          highestEarning: 15000,
          monthlyBreakdown: {
            'Jan': 35000,
            'Feb': 42000,
            'Mar': 38000,
            'Apr': 45000,
            'May': 40000,
            'Jun': 48000,
          },
        ),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }

  List<String> _getChartLabels() {
    return ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  }

  List<FlSpot> _getChartData(EarningsModel earnings) {
    return [
      const FlSpot(0, 8000),
      const FlSpot(1, 12000),
      const FlSpot(2, 10000),
      const FlSpot(3, 15000),
      const FlSpot(4, 11000),
      const FlSpot(5, 13000),
      const FlSpot(6, 14000),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Earnings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<EarningsModel>(
        future: _earningsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: _loadEarningsData,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final earnings = snapshot.data!;
          return RefreshIndicator(
            onRefresh: _loadEarningsData,
            child: CustomScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOverviewCard(earnings),
                      const SizedBox(height: 16),
                      _buildChartSection(earnings),
                      const SizedBox(height: 16),
                      _buildTransactionsList(earnings.recentTransactions),
                      const SizedBox(height: 16), // Bottom padding
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCard(EarningsModel earnings) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  "Available for withdrawal",
                  earnings.availableForWithdrawal,
                  ColorsContants.primaryColor,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: Colors.grey[300],
              ),
              Expanded(
                child: _buildOverviewItem(
                  "Monthly Earnings",
                  earnings.monthlyEarnings,
                  Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(height: 1, color: Colors.grey[300]),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  "Pending Clearance",
                  earnings.pendingClearance,
                  Colors.orange,
                ),
              ),
              Container(
                width: 1,
                height: 60,
                color: Colors.grey[300],
              ),
              Expanded(
                child: _buildOverviewItem(
                  "Total Earnings",
                  earnings.totalEarnings,
                  Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(String label, double amount, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '₹${NumberFormat('#,##,###').format(amount)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: valueColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(EarningsModel earnings) {
    final labels = _getChartLabels();
    final spots = _getChartData(earnings);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Earnings Overview',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value >= 0 && value < labels.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              labels[value.toInt()],
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: ColorsContants.primaryColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: ColorsContants.primaryColor.withOpacity(0.1),
                    ),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    tooltipBgColor: Colors.black87,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot spot) {
                        return LineTooltipItem(
                          '₹${NumberFormat('#,##,###').format(spot.y)}',
                          const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(List<EarningTransaction> transactions) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 12),
            child: Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey[200],
                height: 1,
              ),
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: transaction.type == 'credit'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      transaction.type == 'credit'
                          ? Icons.arrow_downward
                          : Icons.arrow_upward,
                      color:
                          transaction.type == 'credit' ? Colors.green : Colors.red,
                      size: 20,
                    ),
                  ),
                  title: Text(
                    transaction.description,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    DateFormat('MMM dd, yyyy').format(transaction.date),
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  trailing: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 120),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            '₹${NumberFormat('#,##,###').format(transaction.amount)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: transaction.type == 'credit'
                                  ? Colors.green
                                  : Colors.red,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(transaction.status)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            transaction.status.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: _getStatusColor(transaction.status),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
} 