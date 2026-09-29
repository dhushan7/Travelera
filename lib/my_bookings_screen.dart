import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('Please login to view your bookings.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('bookings')
            .orderBy(
          'createdAt',
          descending: true,
        )
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1E5D88),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading bookings:\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final bookings = snapshot.data?.docs ?? [];

          if (bookings.isEmpty) {
            return const Center(
              child: Text(
                'You have no bookings yet.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: bookings.length,

            itemBuilder: (context, index) {
              final data =
              bookings[index].data()
              as Map<String, dynamic>;

              return _buildBookingCard(data);
            },
          );
        },
      ),
    );
  }

  Widget _buildBookingCard(
      Map<String, dynamic> booking,
      ) {
    final String title =
        booking['requirementTitle'] ?? 'Booking';

    final String status =
        booking['status'] ?? 'pending';

    final String fullName =
        booking['fullName'] ?? 'N/A';

    final String email =
        booking['email'] ?? 'N/A';

    final dynamic amount =
        booking['paymentAmount'] ?? 0;

    Color statusColor;

    switch (status) {
      case 'approved':
        statusColor = Colors.green;
        break;

      case 'rejected':
        statusColor = Colors.red;
        break;

      default:
        statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: const Color(0xFFE2ECF7),
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          Text('Name: $fullName'),

          const SizedBox(height: 4),

          Text('Email: $email'),

          const SizedBox(height: 4),

          Text(
            'Payment: \$${amount.toString()}',
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Text(
                'Status: ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.15),
                  borderRadius:
                  BorderRadius.circular(20),
                ),

                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          if (booking['adminNote'] != null &&
              booking['adminNote']
                  .toString()
                  .isNotEmpty) ...[
            const SizedBox(height: 12),

            Text(
              'Admin: ${booking['adminNote']}',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ],
        ],
      ),
    );
  }
}