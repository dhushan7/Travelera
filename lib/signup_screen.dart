import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:country_picker/country_picker.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import 'login_screen.dart';
import 'terms_and_condition.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // INPUT CONTROLLERS
  final TextEditingController _nameController =
  TextEditingController();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _phoneController =
  TextEditingController();

  final TextEditingController _passwordController =
  TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();

  // SELECTED COUNTRY
  Country? _selectedCountry;

  bool _isLoading = false;

  // DISPOSE
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();

    super.dispose();
  }

  // CONVERT COUNTRY_PICKER COUNTRY TO PHONE_PARSER ISO CODE
  IsoCode? _getPhoneIsoCode() {
    if (_selectedCountry == null) {
      return null;
    }

    try {
      return IsoCode.values.firstWhere(
            (iso) =>
        iso.name.toUpperCase() ==
            _selectedCountry!.countryCode.toUpperCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // PHONE NUMBER VALIDATION
  bool _isValidPhoneNumber(String phone) {
    final IsoCode? isoCode = _getPhoneIsoCode();

    if (isoCode == null) {
      return false;
    }

    try {
      final PhoneNumber parsedNumber = PhoneNumber.parse(
        phone,
        destinationCountry: isoCode,
      );

      return parsedNumber.isValid(
        type: PhoneNumberType.mobile,
      );
    } catch (e) {
      return false;
    }
  }

  // GET INTERNATIONAL PHONE NUMBER
  String? _getInternationalPhoneNumber(String phone) {
    final IsoCode? isoCode = _getPhoneIsoCode();

    if (isoCode == null) {
      return null;
    }

    try {
      final PhoneNumber parsedNumber = PhoneNumber.parse(
        phone,
        destinationCountry: isoCode,
      );

      if (!parsedNumber.isValid(
        type: PhoneNumberType.mobile,
      )) {
        return null;
      }

      return parsedNumber.international;
    } catch (e) {
      return null;
    }
  }

  // SIGN UP
  Future<void> _handleSignup() async {
    final String fullName =
    _nameController.text.trim();

    final String email =
    _emailController.text.trim();

    final String contactNo =
    _phoneController.text.trim();

    // Passwords should NOT be trimmed.
    final String password =
        _passwordController.text;

    final String confirmPassword =
        _confirmPasswordController.text;

    // Hide keyboard.
    FocusScope.of(context).unfocus();

    // 1-FULL NAME
    if (fullName.isEmpty) {
      _showSnackBar(
        "Please enter your full name.",
      );
      return;
    }

    final RegExp nameRegex =
    RegExp(r"^[a-zA-ZÀ-ÿ\s'-]{2,50}$");

    if (!nameRegex.hasMatch(fullName)) {
      _showSnackBar(
        "Please enter a valid full name.",
      );
      return;
    }

    // 2-EMAIL
    if (email.isEmpty) {
      _showSnackBar(
        "Please enter your email address.",
      );
      return;
    }

    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      _showSnackBar(
        "Please enter a valid email address.",
      );
      return;
    }

    // 3-COUNTRY
    if (_selectedCountry == null) {
      _showSnackBar(
        "Please select your country.",
      );
      return;
    }

    // 4-MOBILE NUMBER
    if (contactNo.isEmpty) {
      _showSnackBar(
        "Please enter your mobile number.",
      );
      return;
    }

    if (!_isValidPhoneNumber(contactNo)) {
      _showSnackBar(
        "Please enter a valid mobile number for "
            "${_selectedCountry!.name}.",
      );
      return;
    }

    // Convert to international format.
    final String? internationalPhone =
    _getInternationalPhoneNumber(contactNo);

    if (internationalPhone == null) {
      _showSnackBar(
        "Unable to process the mobile number.",
      );
      return;
    }

    // 5-PASSWORD
    if (password.isEmpty) {
      _showSnackBar(
        "Please enter a password.",
      );
      return;
    }

    if (password.length < 8) {
      _showSnackBar(
        "Password must be at least 8 characters long.",
      );
      return;
    }

    // At least:
    // - one lowercase
    // - one uppercase
    // - one number

    final RegExp passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+$',
    );

    if (!passwordRegex.hasMatch(password)) {
      _showSnackBar(
        "Password must contain uppercase, "
            "lowercase and a number.",
      );
      return;
    }

    // 6-CONFIRM PASSWORD
    if (confirmPassword.isEmpty) {
      _showSnackBar(
        "Please confirm your password.",
      );
      return;
    }

    if (password != confirmPassword) {
      _showSnackBar(
        "Passwords do not match.",
      );
      return;
    }

    // EVERYTHING IS VALID
    setState(() {
      _isLoading = true;
    });

    try {
      // CREATE FIREBASE AUTH ACCOUNT
      final UserCredential userCredential =
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user =
          userCredential.user;

      if (user == null) {
        throw Exception(
          "User account could not be created.",
        );
      }

      // SAVE USER INFORMATION TO FIRESTORE
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'uid': user.uid,

        'fullName': fullName,

        'email': email,

        // Always save international format.
        // Example: +94712345678
        'contactNo': internationalPhone,

        // Full country name.
        // Example: Sri Lanka
        'country': _selectedCountry!.name,

        // ISO-2 country code.
        // Example: LK
        'countryCode':
        _selectedCountry!.countryCode,

        // International dialing code.
        // Example: 94
        'dialCode':
        '+${_selectedCountry!.phoneCode}',

        'role': 'user',

        'createdAt':
        FieldValue.serverTimestamp(),
      });

      // SUCCESS
      if (!mounted) return;

      _showSnackBar(
        "Account created successfully!",
      );

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        ),
            (route) => false,
      );
    }

    // FIREBASE AUTH ERRORS
    on FirebaseAuthException catch (e) {
      String message =
          "Registration failed.";

      if (e.code == 'email-already-in-use') {
        message =
        "This email is already linked to another account.";
      } else if (e.code == 'weak-password') {
        message =
        "The password is too weak.";
      } else if (e.code == 'invalid-email') {
        message =
        "The email address is invalid.";
      } else if (e.code == 'network-request-failed') {
        message =
        "Network error. Please check your internet connection.";
      }

      _showSnackBar(message);
    }

    // OTHER ERRORS
    catch (e) {
      _showSnackBar(
        "An unexpected error occurred. Please try again.",
      );
    }

    // STOP LOADING
    finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // SNACKBAR
  void _showSnackBar(String text) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
      ),
    );
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    final double screenHeight =
        MediaQuery.of(context).size.height;

    final double screenWidth =
        MediaQuery.of(context).size.width;

    final double cardWidth =
        screenWidth * 0.88;

    const double inputFieldHeight = 50.0;

    final double logoSize =
        screenWidth * 0.32;

    return Scaffold(
      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [

          // BACKGROUND
          Positioned.fill(
            child: Image.asset(
              'assets/images/login-bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // CONTENT
          SafeArea(
            child: Stack(
              children: [

                // REGISTRATION CARD
                Positioned(
                  top: 60,
                  left: 0,
                  right: 0,

                  child: Center(
                    child: Container(
                      width: cardWidth,

                      constraints:
                      BoxConstraints(
                        maxHeight:
                        screenHeight * 0.65,
                      ),

                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 24.0,
                      ),

                      decoration:
                      BoxDecoration(
                        color:
                        const Color(0xff3a4146)
                            .withOpacity(0.65),

                        borderRadius:
                        BorderRadius.circular(40),

                        border:
                        Border.all(
                          color:
                          const Color(0xFF0082CD),
                          width: 2.0,
                        ),
                      ),

                      child:
                      SingleChildScrollView(
                        physics:
                        const BouncingScrollPhysics(),

                        child: Column(
                          mainAxisSize:
                          MainAxisSize.min,

                          crossAxisAlignment:
                          CrossAxisAlignment.center,

                          children: [

                            const SizedBox(
                              height: 10,
                            ),

                            // FULL NAME
                            _buildInputField(
                              controller:
                              _nameController,
                              hintText:
                              'Full Name:',
                              height:
                              inputFieldHeight,
                            ),
                            const SizedBox(
                              height: 15,
                            ),

                            // EMAIL
                            _buildInputField(
                              controller:
                              _emailController,

                              hintText:
                              'Email:',

                              keyboardType:
                              TextInputType
                                  .emailAddress,

                              height:
                              inputFieldHeight,
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            // COUNTRY
                            _buildCountryField(
                              height:
                              inputFieldHeight,
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            // MOBILE NUMBER
                            _buildPhoneField(
                              height:
                              inputFieldHeight,
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            // PASSWORD
                            _buildInputField(
                              controller:
                              _passwordController,

                              hintText:
                              'Password:',

                              obscureText:
                              true,

                              height:
                              inputFieldHeight,
                            ),

                            const SizedBox(
                              height: 15,
                            ),

                            // CONFIRM PASSWORD
                            _buildInputField(
                              controller:
                              _confirmPasswordController,

                              hintText:
                              'Confirm Password:',

                              obscureText:
                              true,

                              height:
                              inputFieldHeight,
                            ),

                            const SizedBox(
                              height: 25,
                            ),

                            // SIGN UP BUTTON
                            SizedBox(
                              width:
                              screenWidth * 0.55,

                              height: 50,

                              child:
                              ElevatedButton(
                                onPressed:
                                _isLoading
                                    ? null
                                    : _handleSignup,

                                style:
                                ElevatedButton
                                    .styleFrom(
                                  backgroundColor:
                                  const Color(
                                      0xFF0082CD),

                                  foregroundColor:
                                  Colors.white,

                                  disabledBackgroundColor:
                                  const Color(
                                      0xFF0082CD)
                                      .withOpacity(
                                      0.5),

                                  elevation: 4,

                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        25),
                                  ),
                                ),

                                child: _isLoading
                                    ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child:
                                  CircularProgressIndicator(
                                    color:
                                    Colors.white,
                                    strokeWidth:
                                    2.5,
                                  ),
                                )
                                    : const Text(
                                  'Sign up',

                                  style:
                                  TextStyle(
                                    fontSize:
                                    26,
                                    fontWeight:
                                    FontWeight
                                        .bold,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 12,
                            ),

                            // TERMS AND CONDITIONS
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                    const TermsAndConditionsScreen(),
                                  ),
                                );
                              },

                              child: const Text(
                                'Terms and Conditions',

                                style:
                                TextStyle(
                                  color:
                                  Color(
                                      0xFF00529B),

                                  fontSize: 13,

                                  fontWeight:
                                  FontWeight.bold,

                                  decoration:
                                  TextDecoration
                                      .underline,
                                ),
                              ),
                            ),

                            const SizedBox(
                              height: 5,
                            ),

                            // LOGIN
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment
                                  .center,

                              children: [

                                const Text(
                                  'Have Account? ',

                                  style:
                                  TextStyle(
                                    color:
                                    Colors.black,

                                    fontSize: 13,

                                    fontWeight:
                                    FontWeight
                                        .w500,
                                  ),
                                ),

                                GestureDetector(
                                  onTap: () {
                                    Navigator
                                        .pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                        const LoginScreen(),
                                      ),
                                    );
                                  },

                                  child: const Text(
                                    'Login',

                                    style:
                                    TextStyle(
                                      color:
                                      Color(
                                          0xFF00529B),

                                      fontSize: 13,

                                      fontWeight:
                                      FontWeight
                                          .bold,

                                      decoration:
                                      TextDecoration
                                          .underline,
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

                // LOGO

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20,
                  child: Center(
                    child: Container(
                      width: logoSize,
                      height: logoSize,
                      decoration:
                      BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(
                          logoSize * 0.22,
                        ),

                        image:
                        const DecorationImage(
                          image: AssetImage(
                            'assets/images/logo.png',
                          ),
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

  // COUNTRY FIELD
  Widget _buildCountryField({
    required double height,
  }) {
    return GestureDetector(
      onTap: _isLoading
          ? null
          : () {
        showCountryPicker(
          context: context,

          // Show +94, +91, etc.
          showPhoneCode: true,

          // Automatically focus search.
          searchAutofocus: true,

          // When a country is selected.
          onSelect: (Country country) {
            setState(() {
              _selectedCountry = country;

              // Clear old phone number because
              // country has changed.
              _phoneController.clear();
            });
          },

          countryListTheme:
          CountryListThemeData(
            backgroundColor:
            Colors.white,

            bottomSheetHeight:
            600,

            borderRadius:
            const BorderRadius.only(
              topLeft:
              Radius.circular(30),
              topRight:
              Radius.circular(30),
            ),

            inputDecoration:
            InputDecoration(
              hintText:
              'Search country...',

              prefixIcon:
              const Icon(
                Icons.search,
                color:
                Colors.black54,
              ),

              filled: true,

              fillColor:
              const Color(
                  0xFFF0F0F0),

              border:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(
                    15),

                borderSide:
                BorderSide.none,
              ),
            ),
          ),
        );
      },

      child: Container(
        height: height,

        padding:
        const EdgeInsets.symmetric(
          horizontal: 20,
        ),

        decoration:
        BoxDecoration(
          color:
          const Color(0xFFC3C5C7),

          borderRadius:
          BorderRadius.circular(25),

          boxShadow: [
            BoxShadow(
              color:
              Colors.black.withOpacity(0.2),

              blurRadius: 4,

              offset:
              const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [

            // Country flag
            if (_selectedCountry != null)
              Text(
                _selectedCountry!.flagEmoji,
                style:
                const TextStyle(
                  fontSize: 22,
                ),
              ),

            if (_selectedCountry != null)
              const SizedBox(
                width: 10,
              ),

            // Country name
            Expanded(
              child: Text(
                _selectedCountry?.name ??
                    'Country:',

                style: TextStyle(
                  color:
                  _selectedCountry == null
                      ? Colors.black54
                      : Colors.black,

                  fontSize: 15,
                ),

                overflow:
                TextOverflow.ellipsis,
              ),
            ),

            // Dropdown icon
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }

  // PHONE FIELD
  Widget _buildPhoneField({
    required double height,
  }) {
    return Container(
      height: height,

      decoration:
      BoxDecoration(
        color:
        const Color(0xFFC3C5C7),

        borderRadius:
        BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.2),

            blurRadius: 4,

            offset:
            const Offset(0, 3),
          ),
        ],
      ),

      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      child: Row(
        children: [

          // COUNTRY CODE
          if (_selectedCountry != null) ...[
            Text(
              '+${_selectedCountry!.phoneCode}',

              style:
              const TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontWeight:
                FontWeight.w600,
              ),
            ),

            const SizedBox(
              width: 10,
            ),

            Container(
              width: 1,
              height: 25,
              color: Colors.black26,
            ),

            const SizedBox(
              width: 10,
            ),
          ],

          // PHONE INPUT
          Expanded(
            child: TextField(
              controller:
              _phoneController,

              enabled:
              !_isLoading,

              keyboardType:
              TextInputType.phone,

              style:
              const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),

              decoration:
              InputDecoration(
                hintText:
                _selectedCountry == null
                    ? 'Contact No:'
                    : 'Mobile Number:',

                hintStyle:
                const TextStyle(
                  color:
                  Colors.black54,
                  fontSize: 15,
                ),

                border:
                InputBorder.none,

                isDense: true,

                contentPadding:
                EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NORMAL TEXT FIELD BUILDER
  Widget _buildInputField({
    required TextEditingController controller,

    required String hintText,

    bool obscureText = false,

    TextInputType keyboardType =
        TextInputType.text,

    required double height,
  }) {
    return Container(
      height: height,

      decoration:
      BoxDecoration(
        color:
        const Color(0xFFC3C5C7),

        borderRadius:
        BorderRadius.circular(25),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.2),

            blurRadius: 4,

            offset:
            const Offset(0, 3),
          ),
        ],
      ),

      padding:
      const EdgeInsets.symmetric(
        horizontal: 20,
      ),

      alignment:
      Alignment.centerLeft,

      child: TextField(
        controller:
        controller,

        enabled:
        !_isLoading,

        obscureText:
        obscureText,

        keyboardType:
        keyboardType,

        style:
        const TextStyle(
          color: Colors.black,
          fontSize: 15,
        ),

        decoration:
        InputDecoration(
          hintText:
          hintText,

          hintStyle:
          const TextStyle(
            color:
            Colors.black54,
            fontSize: 15,
          ),

          border:
          InputBorder.none,

          isDense: true,

          contentPadding:
          EdgeInsets.zero,
        ),
      ),
    );
  }
}