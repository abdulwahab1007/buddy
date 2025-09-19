// ignore_for_file: sort_child_properties_last, deprecated_member_use

import 'package:buddy/screens/UserScreens/bayerHome.dart';
import 'package:flutter/material.dart';
import 'package:buddy/res/contants/colors_contants.dart';

class VerificationCode extends StatefulWidget {
  const VerificationCode({super.key});

  @override
  _VerificationCodeState createState() => _VerificationCodeState();
}

class _VerificationCodeState extends State<VerificationCode> {
  final TextEditingController codeController1 = TextEditingController();
  final TextEditingController codeController2 = TextEditingController();
  final TextEditingController codeController3 = TextEditingController();
  final TextEditingController codeController4 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              const SizedBox(height: 40),
              const Text(
                "Verification Code",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: ColorsContants.primaryColor, // Use primary color
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Enter the 4-digit code sent to your email.",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black, // Use primary color
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCodeInputField(codeController1),
                  _buildCodeInputField(codeController2),
                  _buildCodeInputField(codeController3),
                  _buildCodeInputField(codeController4),
                ],
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const BayerHome()));
                },
                child: Text(
                  "Confirm",
                  style:
                      TextStyle(fontSize: 16, color: ColorsContants.textColor),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(ColorsContants.primaryColor),
                  padding: MaterialStateProperty.all(
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 40)),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Optionally add a Resend option or a timer here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeInputField(TextEditingController controller) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "", // Hide counter text
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: ColorsContants.primaryColor,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}
