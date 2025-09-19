
import 'package:buddy/Backend/index.dart';
import 'package:flutter/material.dart';
import 'package:buddy/res/contants/colors_contants.dart';
import 'package:buddy/screens/auth/login.dart';
import 'package:buddy/screens/verificationCode.dart';
// Import your API service

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController nameController = TextEditingController(); // NEW
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String selectedRole = 'Admin'; // Can be Admin, Seller, or Buyer

  bool isLoading = false;

  void _handleSignUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage("Please fill all fields");
      return;
    }

    if (password != confirmPassword) {
      _showMessage("Passwords do not match");
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Use new API service to register user
      final response = await AuthService.register(
        name: name,
        email: email,
        password: password,
        role: selectedRole,
      );

      setState(() {
        isLoading = false;
      });

      if (response['success'] == true) {
        _showMessage("Signup successful!");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VerificationCode()),
        );
      } else {
        _showMessage(response['error'] ?? "Signup failed. Please try again.");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showMessage("Signup failed: ${e.toString()}");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            final width = constraints.maxWidth;

            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Back button
                    Align(
                      alignment: Alignment.topLeft,
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios_rounded,
                            color: ColorsContants.primaryColor),
                      ),
                    ),
                    SizedBox(height: height * 0.015),

                    // Image
                    Center(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/Sign up-pana.png',
                          width: width * 0.5,
                          height: height * 0.25,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    SizedBox(height: height * 0.015),
                    const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: ColorsContants.primaryColor),
                    ),
                    const SizedBox(height: 4),
                    const Text("Create a new account",
                        style: TextStyle(fontSize: 14, color: Colors.black)),
                    SizedBox(height: height * 0.015),

                    // Name Field
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.person),
                        labelText: "Name",
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email Field
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.email_outlined),
                        labelText: "Email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Password Field
                    TextField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.lock),
                        labelText: "Password",
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    TextField(
                      controller: confirmPasswordController,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.lock_outline),
                        labelText: "Confirm Password",
                      ),
                      obscureText: true,
                    ),
                    const SizedBox(height: 16),

                    // Role Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      items: ['Admin', 'Content Creator', 'Buyer'].map((role) {
                        return DropdownMenuItem(value: role, child: Text(role));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedRole = value;
                          });
                        }
                      },
                      decoration:
                          const InputDecoration(labelText: "Select Role"),
                    ),
                    const SizedBox(height: 16),

                    // Sign Up Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: ColorsContants.primaryColor,
                      ),
                      onPressed: isLoading ? null : _handleSignUp,
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Sign Up",
                              style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(height: 16),

                    // Socials
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey.shade400)),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text("or sign up with"),
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
                            child: Image.asset('assets/Google.png',
                                height: 50, width: 50),
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
                            child: Image.asset('assets/Facbook.png',
                                height: 50, width: 50),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.015),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style: TextStyle(
                              fontSize: 14, color: (Color(0xFF7D8B91))),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Login()));
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                                fontSize: 16,
                                color: ColorsContants.primaryColor),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height * 0.015),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
