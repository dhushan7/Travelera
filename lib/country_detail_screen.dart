import 'package:flutter/material.dart';

class CountryDetailScreen extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final Color titleColor;

  const CountryDetailScreen({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    this.titleColor = const Color(0xFF1E3F00), // Fallback forest green
  });

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

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

              const SizedBox(height: 25),

              // Dynamic Rounded Image Frame
              Container(
                width: screenWidth * 0.65,
                height: screenHeight * 0.30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  image: DecorationImage(
                    image: AssetImage(imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Dynamic Country Name
              Text(
                title,
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  color: titleColor,
                ),
              ),

              const SizedBox(height: 15),

              // Dynamic Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF2C3E35),
                    height: 1.35,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Visit Button
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: SizedBox(
                  width: screenWidth * 0.48,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () {
                      //  routing logics
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF235E8E),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: const Text(
                      'Visit',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}