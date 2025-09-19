import 'dart:async';
import 'package:buddy/Screens/CreatorScreens/creatorHome.dart';
import 'package:buddy/Screens/UserScreens/bayerHome.dart';
import 'package:buddy/helpers/token_validation.dart';
import 'package:flutter/material.dart';
import 'package:buddy/Screens/auth/login.dart';
import 'package:buddy/res/contants/colors_contants.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    final authData = await checkAuthStatus(expiryDays: 7);
    await Future.delayed(const Duration(seconds: 3)); // Splash duration

    if (authData['isValid'] == true) {
      final userRole = authData['role'].toString().toLowerCase();

      if (userRole == 'buyer') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BayerHome()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CreatorHome()),
        );
      }
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),
            Image.asset(
              'assets/buddyLogo.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'The Marketplace of Content Creators',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ColorsContants.primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const Spacer(flex: 2),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: ColorsContants.primaryColor.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      ColorsContants.primaryColor),
                  strokeWidth: 3,
                ),
              ),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
