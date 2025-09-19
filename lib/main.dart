
import 'package:buddy/screens/Splash.dart';
import 'package:buddy/res/theme/addThem.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Buddy',
      theme: lightTheme,
      //home: Home(),
      home: const Splash(),
    );
  }
}
