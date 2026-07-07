import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    if (!context.mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Colors.white,
      body: currentUser == null
          ? const Center(child: Text('No active user found.'))
          : SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          // Switched to snapshots() stream for real-time updates
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(currentUser.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFF1E5D88)),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            // Debugging Block
            if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
              if (snapshot.hasError) {
                print("🔥 FIRESTORE ERROR: ${snapshot.error}");
              }
              if (snapshot.hasData && !snapshot.data!.exists) {
                print("📂 DOCUMENT DOES NOT EXIST: Looked for collection 'users' with document ID: ${FirebaseAuth.instance.currentUser?.uid}");
              }

              return const Center(
                child: Text('Failed to load profile details.', style: TextStyle(fontWeight: FontWeight.bold)),
              );
            }
            // Enhanced debugging logic to print explicitly to your console log
            if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
              if (snapshot.hasError) {
                debugPrint("Firestore Error: ${snapshot.error}");
              } else if (snapshot.hasData && !snapshot.data!.exists) {
                debugPrint("Firestore Error: Document targeting UID '${currentUser.uid}' does not exist in collection 'users'.");
              }

              // return const Center(
              //   child: Text(
              //     'Failed to load profile details.',
              //     style: TextStyle(fontWeight: FontWeight.bold),
              //   ),
              // );
            }

            final Map<String, dynamic> userData =
            snapshot.data!.data() as Map<String, dynamic>;

            final String fullName = userData['fullName'] ?? 'N/A';
            final String country = userData['country'] ?? 'N/A';
            final String contactNo = userData['contactNo'] ?? 'N/A';
            final String email = userData['email'] ?? 'N/A';

            return Column(
              children: [
                SizedBox(height: screenHeight * 0.12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 24.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDEE8F5),
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            CircleAvatar(
                              radius: 42,
                              backgroundColor: Colors.grey[400],
                              child: const Icon(
                                Icons.person_outline_rounded,
                                size: 48,
                                color: Colors.black,
                              ),
                            ),
                            Positioned(
                              right: 2,
                              bottom: 2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 18,
                                  color: Colors.black,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 32),
                        _buildProfileDetail('Name: $fullName'),
                        const SizedBox(height: 16),
                        _buildProfileDetail('Country: $country'),
                        const SizedBox(height: 16),
                        _buildProfileDetail('Contact: $contactNo'),
                        const SizedBox(height: 16),
                        _buildProfileDetail('Email: $email'),
                        const SizedBox(height: 36),
                        SizedBox(
                          width: screenWidth * 0.52,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => _handleLogout(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF70160E),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: screenWidth * 0.35,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: screenHeight * 0.07),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileDetail(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
    );
  }
}