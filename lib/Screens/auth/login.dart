
import 'package:buddy/Backend/index.dart';
import 'package:buddy/Screens/CreatorScreens/creatorHome.dart';
import 'package:buddy/Screens/UserScreens/bayerHome.dart';
import 'package:flutter/material.dart';
import 'package:buddy/res/contants/colors_contants.dart';
import 'package:buddy/screens/auth/signUp.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Use new API service to login
      final response = await AuthService.login(email: email, password: password);
      print("Login response: $response");

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        final token = data['token'];
        // final userRole = data['role'] ?? 'buyer';
        final userId = data['user_id'];
        final userName = data['name'] ?? 'User';

final rawRole = data['role'];
String userRole;

if (rawRole is List && rawRole.isNotEmpty) {
  userRole = rawRole.first.toString(); // ✅ Convert to String
} else if (rawRole is String) {
  userRole = rawRole;
} else {
  userRole = 'buyer';
}
        print(
            "Login successful - Token: $token, Role: $userRole, UserId: $userId");

        // Save data to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);
        await prefs.setString('user_role', userRole);
        await prefs.setString('user_name', userName);
        if (userId != null) {
          await prefs.setInt('user_id', userId);
          print("Saved user ID to preferences: $userId");
        } else {
          print("No user ID in response");
        }

        // Navigate based on user role
        if (!mounted) return;

        if (userRole.toLowerCase() == 'buyer') {
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
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['error'] ?? "Invalid email or password")),
        );
      }
    } catch (e) {
      print("Login error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $e")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final width = constraints.maxWidth;

            return SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: height),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.topLeft,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.arrow_back_ios_rounded,
                              color: ColorsContants.primaryColor),
                        ),
                      ),
                      SizedBox(height: height * 0.015),
                      Center(
                        child: ClipOval(
                          child: Image.asset(
                            'assets/Login-rafiki.png',
                            width: width * 0.5,
                            height: height * 0.2,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.015),
                      const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: ColorsContants.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Please sign in to your account",
                        style: TextStyle(
                          fontSize: 14,
                          color: ColorsContants.textColor,
                        ),
                      ),
                      SizedBox(height: height * 0.015),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          suffixIcon: Icon(Icons.person),
                          labelText: "Email",
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                          labelText: "Password",
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          backgroundColor: ColorsContants.primaryColor,
                        ),
                        onPressed: _isLoading ? null : _login,
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              )
                            : const Text("Sign In",
                                style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey.shade400)),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text("or login with"),
                          ),
                          Expanded(child: Divider(color: Colors.grey.shade400)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorsContants.primaryColor),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Image.asset(
                                'assets/Google.png',
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          InkWell(
                            onTap: () {},
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorsContants.primaryColor),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Image.asset(
                                'assets/Facbook.png',
                                height: 50,
                                width: 50,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF7D8B91),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignUp()),
                              );
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 16,
                                color: ColorsContants.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
