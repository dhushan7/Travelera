import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';
import 'terms_and_condition.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Input Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController(); // Added Confirm Password Controller

  bool _isLoading = false; // Tracks database process status

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose(); // Added Confirm Password Disposal
    super.dispose();
  }

  // Database logic with robust validations and dynamic role configuration
  Future<void> _handleSignup() async {
    final String fullName = _nameController.text.trim();
    final String email = _emailController.text.trim();
    final String contactNo = _phoneController.text.trim();
    final String country = _countryController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim(); // Captured confirm password value

    await FirebaseAuth.instance.signOut();

    if (!mounted) return;

    FocusScope.of(context).unfocus();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );

    // Check for empty fields
    if (fullName.isEmpty || email.isEmpty || contactNo.isEmpty || country.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showSnackBar("Please fill out all fields.");
      return;
    }

    // Validate email structure format
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      _showSnackBar("Please enter a valid email address.");
      return;
    }

    // Validate password length
    if (password.length < 6) {
      _showSnackBar("Password must be at least 6 characters long.");
      return;
    }

    // Validate if passwords match exactly
    if (password != confirmPassword) {
      _showSnackBar("Passwords do not match.");
      return;
    }

    // Activate loading overlay spinner
    setState(() {
      _isLoading = true;
    });

    try {
      // Create Authentication Record in Firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Profile payload with hardcoded role parameter
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'uid': userCredential.user!.uid,
        'fullName': fullName,
        'email': email,
        'contactNo': contactNo,
        'country': country,
        'role': 'user', // Hardcoded user role assigned right here
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        _showSnackBar("Account created successfully!");

        // Navigation route down to Login View screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }

    } on FirebaseAuthException catch (e) {
      String message = "Registration Failed.";
      if (e.code == 'email-already-in-use') {
        message = "This email is already linked to another user account.";
      } else if (e.code == 'weak-password') {
        message = "The password selected is not secure enough.";
      } else if (e.code == 'invalid-email') {
        message = "The format of the email address is invalid.";
      }
      _showSnackBar(message);
    } catch (e) {
      _showSnackBar("An unexpected error occurred. Please try again.");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Turn off loading state logic
        });
      }
    }
  }

  // Snackbar Messenger Helper
  void _showSnackBar(String text) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final double cardWidth = screenWidth * 0.88;
    final double inputFieldHeight = 50.0;
    final double logoSize = screenWidth * 0.32;

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

          // const SizedBox(height: 100),

          // Content Layer
          SafeArea(
            child: Stack(
              children: [
                // Registration Card with 100px Top Margin
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: cardWidth,
                      constraints: BoxConstraints(
                        maxHeight: screenHeight * 0.65,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
                      decoration: BoxDecoration(
                        color: const Color(0xff3a4146).withOpacity(0.65),
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(
                          color: const Color(0xFF0082CD),
                          width: 2.0,
                        ),
                      ),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Slightly reduced vertical padding to accommodate the 6th field cleanly within constraints
                            const SizedBox(height: 10),

                            _buildInputField(
                              controller: _nameController,
                              hintText: 'Full Name:',
                              height: inputFieldHeight,
                            ),
                            const SizedBox(height: 15),

                            _buildInputField(
                              controller: _emailController,
                              hintText: 'email:',
                              keyboardType: TextInputType.emailAddress,
                              height: inputFieldHeight,
                            ),
                            const SizedBox(height: 15),

                            _buildInputField(
                              controller: _phoneController,
                              hintText: 'Contact No:',
                              keyboardType: TextInputType.phone,
                              height: inputFieldHeight,
                            ),
                            const SizedBox(height: 15),

                            _buildInputField(
                              controller: _countryController,
                              hintText: 'Country:',
                              height: inputFieldHeight,
                            ),
                            const SizedBox(height: 15),

                            _buildInputField(
                              controller: _passwordController,
                              hintText: 'Password:',
                              obscureText: true,
                              height: inputFieldHeight,
                            ),
                            const SizedBox(height: 15),

                            // Added Confirm Password Input Field
                            _buildInputField(
                              controller: _confirmPasswordController,
                              hintText: 'Confirm Password:',
                              obscureText: true,
                              height: inputFieldHeight,
                            ),

                            const SizedBox(height: 25),

                            // Dynamic interactive execution submission control widget
                            SizedBox(
                              width: screenWidth * 0.55,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleSignup,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0082CD),
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: const Color(0xFF0082CD).withOpacity(0.5),
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                                    : const Text(
                                  'Sign up',
                                  style: TextStyle(
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Terms and Conditions Link
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const TermsAndConditionsScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                'Terms and Conditions',
                                style: TextStyle(
                                  color: Color(0xFF00529B),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),

                            // Login link
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Have Account? ',
                                  style: TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Login',
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Logo
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20,
                  child: Center(
                    child: Container(
                      width: logoSize,
                      height: logoSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(logoSize * 0.22),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/logo.png'),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Text Field Builder
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
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 3),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.centerLeft,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black, fontSize: 15),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black54, fontSize: 15),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}