import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers to capture user input data
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Manage loading state when backend communication is busy

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Firebase login validation handling function
  Future<void> _handleLogin() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    // client-side validation
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in both email and password")),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading spinner feedback
    });

    try {
      // Request authentication authorization verification from Firebase
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Success navigation redirect
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Catch error triggers like 'wrong-password' or 'user-not-found' cleanly
      String errorMessage = "Authentication failed. Please check your credentials.";

      if (e.code == 'user-not-found') {
        errorMessage = "No user account exists for this email address.";
      } else if (e.code == 'wrong-password') {
        errorMessage = "Incorrect password. Please try again.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address format is invalid.";
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Turn off loading spinner
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    // Responsive element calculations
    final double loginCardWidth = screenWidth * 0.86;
    final double inputFieldHeight = 55.0;
    final double logoSize = screenWidth * 0.32;
    final double buttonWidth = screenWidth * 0.6;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/images/login-bg.png',
              fit: BoxFit.cover,
            ),
          ),



          // Foreground Content
          SafeArea(
            child: Stack(
              children: [
                // Login Form
                Center(
                  child: Container(
                    width: loginCardWidth,
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
                    decoration: BoxDecoration(
                      color: const Color(0xea53585e).withOpacity(0.65),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 30),

                        // Email Input
                        _buildInputField(
                          controller: _emailController,
                          hintText: 'email:',
                          keyboardType: TextInputType.emailAddress,
                          height: inputFieldHeight * 0.8,
                        ),

                        const SizedBox(height: 20),

                        // Password Input
                        _buildInputField(
                          controller: _passwordController,
                          hintText: 'Password:',
                          obscureText: true,
                          height: inputFieldHeight * 0.8,
                        ),

                        const SizedBox(height: 35),

                        // Login Action Button Connected to Database Method
                        SizedBox(
                          width: buttonWidth,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleLogin, // Disable click actions while loading
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0082CD),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor: const Color(0xFF0082CD).withOpacity(0.5),
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(26),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                                : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Registration Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'New User? ',
                              style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Create an account',
                                style: TextStyle(
                                  color: Color(0xFF00529B),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),

                // Logo Layer
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: screenHeight * 0.04,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: logoSize * 1.2,
                        height: logoSize * 1.2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(logoSize * 0.22),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/logo.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Component Helper, shadowed text fields
  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    required double height,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: const Color(0xFFC3C5C7),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 5,
              offset: const Offset(0, 4),
            )
          ]
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black, fontSize: 16),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 16),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}