import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/home-web.dart';
import 'package:nomadly_app/main-web.dart';
import 'package:nomadly_app/navbar-web.dart';

import 'report-web.dart';

class StatsWeb extends StatelessWidget {
  const StatsWeb({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        onShowAllUsersClicked: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomeWeb()),
          );
        },
        onManageReportsClicked: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReportWeb()),
          );
        },
        onLogoutClicked: () {
          FirebaseAuth.instance.signOut();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyWebView()),
          );
        },
        onStatsClicked: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const StatsWeb()),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Statistics',
                  style: GoogleFonts.roboto(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Users').snapshots(),
                builder: (context, userSnapshot) {
                  if (userSnapshot.hasError) {
                    return Center(child: Text('Error: ${userSnapshot.error}'));
                  }
                  if (!userSnapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final users = userSnapshot.data!.docs;
                  int totalUsers = users.length - 1;
                  int totalHosts = users.where((user) => user['AccountType'] == 'Host').length;
                  int totalClients = users.where((user) => user['AccountType'] == 'Client').length;
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('Accommodations').snapshots(),
                    builder: (context, accommodationSnapshot) {
                      if (accommodationSnapshot.hasError) {
                        return Center(child: Text('Error: ${accommodationSnapshot.error}'));
                      }
                      if (!accommodationSnapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final accommodations = accommodationSnapshot.data!.docs;
                      int totalAccommodations = accommodations.length;

                      return StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance.collection('Reviews').snapshots(),
                        builder: (context, reviewSnapshot) {
                          if (reviewSnapshot.hasError) {
                            return Center(child: Text('Error: ${reviewSnapshot.error}'));
                          }
                          if (!reviewSnapshot.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          final reviews = reviewSnapshot.data!.docs;
                          int totalReviews = reviews.length;

                          return StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance.collection('Bookings').snapshots(),
                            builder: (context, bookingSnapshot) {
                              if (bookingSnapshot.hasError) {
                                return Center(child: Text('Error: ${bookingSnapshot.error}'));
                              }
                              if (!bookingSnapshot.hasData) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              final bookings = bookingSnapshot.data!.docs;
                              int totalBookings = bookings.length;
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildDataItem('Total Users', totalUsers.toString(), '/images/profile.png'),
                                        _buildDataItem('Total Hosts', totalHosts.toString(), '/images/users.png'),
                                        _buildDataItem('Total Clients', totalClients.toString(), '/images/group.png'),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(50, 0, 50, 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        _buildDataItem('Total Accommodations', totalAccommodations.toString(), '/images/homepage.png'),
                                        _buildDataItem('Total Reviews', totalReviews.toString(), '/images/feedback.png'),
                                        _buildDataItem('Total Bookings', totalBookings.toString(), '/images/booking.png'),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Widget _buildDataItem(String label, String value, String iconPath) {
  return Container(
    width: 220,
    height: 200,
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.9),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 5,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          iconPath,
          width: 60,
          height: 60,
        ),
        SizedBox(height: 16),
        Text(
          label + ": " + value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}
