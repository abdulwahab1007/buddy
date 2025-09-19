import 'package:buddy/res/contants/colors_contants.dart';
import 'package:flutter/material.dart';

class CreatorEarnings extends StatelessWidget {
  const CreatorEarnings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          // Custom AppBar
          const SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  SizedBox(width: 10),
                  Text(
                    "Earnings",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: ColorsContants.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Earnings Summary
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Total Earnings",
                      style: TextStyle(
                          fontSize: 16, color: ColorsContants.textColor)),
                  const SizedBox(height: 8),
                  const Text("₹25,000",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: ColorsContants.primaryColor)),
                  const SizedBox(height: 6),
                  const Text("This Month",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Withdrawable Balance + Withdraw Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Available to Withdraw",
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                        SizedBox(height: 6),
                        Text(
                          "₹15,000",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) =>
                            _buildWithdrawBottomSheet(context),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                    ),
                    child: Text(
                      "Withdraw",
                      style: TextStyle(color: ColorsContants.textColor),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Transaction History
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  "Transaction History",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              separatorBuilder: (_, __) => const Divider(),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 6),
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.monetization_on,
                        color: ColorsContants.primaryColor),
                  ),
                  title: Text("Order #${1000 + index}",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Completed • Apr 2025"),
                  trailing: const Text(
                    "₹5,000",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: ColorsContants.primaryColor),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWithdrawBottomSheet(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(
        runSpacing: 20,
        children: [
          Center(
            child: Icon(Icons.horizontal_rule,
                size: 40, color: ColorsContants.textColor),
          ),
          const Text(
            "Withdraw Earnings",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Select a withdrawal method and confirm your request.",
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: Icon(
              Icons.account_balance_wallet_outlined,
              color: ColorsContants.textColor,
            ),
            title: const Text("Bank Transfer"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context);
              // Show confirmation or next step
            },
          ),
          ListTile(
            leading: const Icon(Icons.account_balance),
            title: const Text("UPI / PayTM"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // trigger withdraw logic (if needed)
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              "Confirm Withdraw",
              style: TextStyle(fontSize: 16, color: ColorsContants.textColor),
            ),
          ),
        ],
      ),
    );
  }
}
