import 'package:buddy/screens/CreatorScreens/creatorHome.dart';
import 'package:buddy/res/contants/colors_contants.dart';
import 'package:flutter/material.dart';

class Subscription extends StatelessWidget {
  const Subscription({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Centered "buddy" text
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pop(context); // Navigate back
                    },
                    child: const Align(
                      alignment: Alignment.topLeft,
                      child: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: ColorsContants.primaryColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "buddy",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: ColorsContants.primaryColor,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 20),
              // SizedBox(
              //   height: 250,
              //   width: 300,
              //   child: Image.asset(
              //     "assets/buddyLogo.png",
              //     fit: BoxFit.contain,
              //   ),
              // ),
              // SizedBox(height: 20),
              // Center(
              //   child: Text(
              //     "Unlock Premium Features",
              //     style: TextStyle(
              //       fontSize: 22,
              //       fontWeight: FontWeight.bold,
              //       color: ColorsContants.primaryColor,
              //     ),
              //   ),
              // ),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 260,
                    width: 300,
                    child: Image.asset(
                      "assets/buddyLogo.png",
                      fit: BoxFit.contain,
                    ),
                  ),

                  // Positioned text inside the image
                  const Positioned(
                    bottom: 20,
                    child: Text(
                      "Unlock Premium Features",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: ColorsContants.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPlanBox("12", "months", "\$999 /m", false),
                  _buildPlanBox("3", "months", "\$249 /m", true),
                  _buildPlanBox("1", "months", "\$399/m", false),
                ],
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {},
                child: const Text(
                  "Get 3 Month ₹250",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const CreatorHome()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: ColorsContants.primaryColor,
                  side: const BorderSide(color: ColorsContants.primaryColor),
                ),
                child: const Text("Try Buddy Premium Free for 14 Days"),
              ),
              //SizedBox(height: 30),
              const Spacer(),
              const Center(
                child: Text(
                  "Does My Subscription Auto Renew ?",
                  style: TextStyle(
                    color: ColorsContants.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "You can disable this at any time.",
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanBox(
      String duration, String unit, String price, bool isSelected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isSelected ? 110 : 100, // Increase size if selected
      padding:
          EdgeInsets.symmetric(vertical: isSelected ? 16 : 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isSelected
            ? ColorsContants.primaryColor.withOpacity(0.1)
            : Colors.white,
        border: Border.all(
          color:
              isSelected ? ColorsContants.primaryColor : Colors.grey.shade300,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isSelected)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorsContants.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: const Center(
                child: Text(
                  '50% Off',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Text(
            duration,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ColorsContants.primaryColor,
            ),
          ),
          Text(
            unit,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}
