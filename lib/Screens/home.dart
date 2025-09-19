import 'package:buddy/screens/auth/login.dart';
import 'package:buddy/screens/listCreators.dart';
import 'package:flutter/material.dart';
import 'package:buddy/res/contants/colors_contants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // Timer(Duration(seconds: 100), () {
    //   Navigator.pushReplacementNamed(
    //       context, '/home'); // or use Get.toNamed('/home') if using GetX
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsContants.primaryColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            const Center(
              child: Text(
                "Buddy Pro",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Login()));
                },
                child: const Text(
                  'Content Creator',
                  style: TextStyle(color: Color(0xFF213555)),
                )),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ListCreators()));
              },
              child: const Text(
                'Buyer',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
