class EarningsModel {
  final double totalEarnings;
  final double availableForWithdrawal;
  final double monthlyEarnings;
  final double pendingClearance;
  final List<EarningTransaction> recentTransactions;
  final EarningsStats stats;

  EarningsModel({
    required this.totalEarnings,
    required this.availableForWithdrawal,
    required this.monthlyEarnings,
    required this.pendingClearance,
    required this.recentTransactions,
    required this.stats,
  });

  factory EarningsModel.fromJson(Map<String, dynamic> json) {
    return EarningsModel(
      totalEarnings: (json['total_earnings'] ?? 0.0).toDouble(),
      availableForWithdrawal: (json['available_for_withdrawal'] ?? 0.0).toDouble(),
      monthlyEarnings: (json['monthly_earnings'] ?? 0.0).toDouble(),
      pendingClearance: (json['pending_clearance'] ?? 0.0).toDouble(),
      recentTransactions: (json['recent_transactions'] as List<dynamic>? ?? [])
          .map((tx) => EarningTransaction.fromJson(tx))
          .toList(),
      stats: EarningsStats.fromJson(json['stats'] ?? {}),
    );
  }
}

class EarningTransaction {
  final String id;
  final double amount;
  final String type; // 'credit' or 'debit'
  final String description;
  final DateTime date;
  final String status; // 'completed', 'pending', 'failed'

  EarningTransaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.description,
    required this.date,
    required this.status,
  });

  factory EarningTransaction.fromJson(Map<String, dynamic> json) {
    return EarningTransaction(
      id: json['id'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      type: json['type'] ?? 'credit',
      description: json['description'] ?? '',
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'completed',
    );
  }
}

class EarningsStats {
  final int totalOrders;
  final int completedOrders;
  final int cancelledOrders;
  final double averageOrderValue;
  final double highestEarning;
  final Map<String, double> monthlyBreakdown;

  EarningsStats({
    required this.totalOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.averageOrderValue,
    required this.highestEarning,
    required this.monthlyBreakdown,
  });

  factory EarningsStats.fromJson(Map<String, dynamic> json) {
    final monthlyData = json['monthly_breakdown'] as Map<String, dynamic>? ?? {};
    return EarningsStats(
      totalOrders: json['total_orders'] ?? 0,
      completedOrders: json['completed_orders'] ?? 0,
      cancelledOrders: json['cancelled_orders'] ?? 0,
      averageOrderValue: (json['average_order_value'] ?? 0.0).toDouble(),
      highestEarning: (json['highest_earning'] ?? 0.0).toDouble(),
      monthlyBreakdown: monthlyData.map(
        (key, value) => MapEntry(key, (value ?? 0.0).toDouble()),
      ),
    );
  }
} 