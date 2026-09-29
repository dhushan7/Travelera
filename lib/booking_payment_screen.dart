import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added Firebase Auth to fetch the logged-in user
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingPaymentScreen extends StatefulWidget {
  final String requirementTitle;
  final String imagePath;

  const BookingPaymentScreen({
    super.key,
    required this.requirementTitle,
    required this.imagePath,
  });

  @override
  State<BookingPaymentScreen> createState() => _BookingPaymentScreenState();
}

class _BookingPaymentScreenState extends State<BookingPaymentScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expDateController = TextEditingController();
  final _cvnController = TextEditingController();

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _loadUserEmail();
  }

  /// Automatically fetches the logged-in user's email from Firebase
  void _loadUserEmail() {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null && user.email != null) {
      _emailController.text = user.email!;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _cardNameController.dispose();
    _cardNumberController.dispose();
    _expDateController.dispose();
    _cvnController.dispose();
    super.dispose();
  }

  Future<void> _processPayment() async {
    if (_cardNumberController.text.isEmpty ||
        _expDateController.text.isEmpty ||
        _cvnController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please complete all payment fields'),
        ),
      );
      return;
    }

    final expParts = _expDateController.text.split('/');

    if (expParts.length != 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid Expiration Date format (Use MM/YY)'),
        ),
      );
      return;
    }

    final int? expMonth = int.tryParse(expParts[0]);
    final int? expYear = int.tryParse(expParts[1]);

    if (expMonth == null || expYear == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid expiration numbers'),
        ),
      );
      return;
    }

    setState(() => _isProcessing = true);

    try {
      await Stripe.instance.dangerouslyUpdateCardDetails(
        CardDetails(
          number: _cardNumberController.text.replaceAll(' ', ''),
          expirationMonth: expMonth,
          expirationYear: expYear,
          cvc: _cvnController.text.trim(),
        ),
      );

      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      final String paymentMethodId = paymentMethod.id;

      debugPrint(
        'Secure Payment Method created: $paymentMethodId',
      );

      // Save booking
      await _saveBookingToFirebase(paymentMethodId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Booking submitted successfully. Waiting for admin approval.',
            ),
          ),
        );

        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Error: ${e.toString()}'),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  Future<void> _saveBookingToFirebase(String paymentMethodId) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('No logged-in user found.');
    }

    // User's UID is used to keep bookings separated by user.
    final String uid = user.uid;

    // Get the user's email from Firebase Authentication.
    final String email = user.email ?? _emailController.text.trim();

    if (email.isEmpty) {
      throw Exception('User email not found.');
    }

    // Create a new booking document.
    final DocumentReference bookingRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('bookings')
        .doc();

    await bookingRef.set({
      'bookingId': bookingRef.id,

      // User information
      'userId': uid,
      'email': email,

      // Booking information
      'requirementTitle': widget.requirementTitle,
      'imagePath': widget.imagePath,
      'fullName': _nameController.text.trim(),
      'contactNo': _contactController.text.trim(),

      // Payment information
      'paymentAmount': 250,
      'currency': 'USD',
      'paymentMethodId': paymentMethodId,

      // Admin approval status
      'status': 'pending',

      // Admin can add a message later
      'adminNote': '',

      // Dates
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    debugPrint(
      'Booking saved successfully for user: $email',
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Header with nested back button and logo
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 22),
                    onPressed: () {
                      Navigator.pop(context); // Pops back under nested Tab Navigator safely
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: screenWidth * 0.10),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: screenWidth * 0.32,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    Text(
                      widget.requirementTitle,
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        color: Colors.black87,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        widget.imagePath,
                        width: 130,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2ECF7),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildUnderlinedField(controller: _nameController, label: 'Full Name:'),

                          // DISABLED FIELD FOR EMAIL
                          _buildUnderlinedField(
                            controller: _emailController,
                            label: 'email:',
                            keyboardType: TextInputType.emailAddress,
                            enabled: false, // Disables text entry
                          ),

                          _buildUnderlinedField(controller: _contactController, label: 'Contact no:', keyboardType: TextInputType.phone),
                          _buildUnderlinedField(controller: _cardNameController, label: 'Name on Card:'),
                          _buildUnderlinedField(controller: _cardNumberController, label: 'Card Number:', keyboardType: TextInputType.number),
                          Row(
                            children: [
                              Expanded(
                                child: _buildUnderlinedField(
                                  controller: _expDateController,
                                  label: 'exp Date:',
                                  hint: 'MM/YY',
                                  keyboardType: TextInputType.datetime,
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: _buildUnderlinedField(
                                  controller: _cvnController,
                                  label: 'cvn:',
                                  hint: '123',
                                  obscure: true,
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Center(
                            child: Text(
                              'Booking cost + Advance : \$250',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w700, color: Colors.black),
                            ),
                          ),
                          const Center(
                            child: Text(
                              '(Rest of expenses you need to handle on time)',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.black87),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: (screenWidth * 0.38),
                                height: 42,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF458A8C),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    elevation: 0,
                                  ),
                                  child: const Text('More Details', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                                ),
                              ),
                              SizedBox(
                                width: (screenWidth * 0.38),
                                height: 42,
                                child: ElevatedButton(
                                  onPressed: _isProcessing ? null : _processPayment,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF5A9AD4),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    elevation: 0,
                                  ),
                                  child: _isProcessing
                                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                      : const Text('Pay Now', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUnderlinedField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool obscure = false,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true, // Added enabled argument
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              label,
              style: TextStyle(
                  color: enabled ? Colors.black87 : Colors.black45, // Visually change label color when disabled
                  fontSize: 14,
                  fontWeight: FontWeight.w400
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              keyboardType: keyboardType,
              enabled: enabled, // Passes status parameter directly to internal TextField node
              style: TextStyle(
                  color: enabled ? Colors.black : Colors.black45, // Grey out font when disabled
                  fontSize: 14,
                  fontWeight: FontWeight.w600
              ),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.black26),
                contentPadding: const EdgeInsets.only(bottom: 4),
                isDense: true,
                disabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black26, width: 1)), // Soft border for disabled state
                enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black45, width: 1)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFF5A9AD4), width: 1.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}