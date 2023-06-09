import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/home-web.dart';
import 'package:nomadly_app/main-web.dart';
import 'package:nomadly_app/navbar-web.dart';
import 'package:nomadly_app/report-details-web.dart';
import 'package:nomadly_app/statistics-web.dart';

class ReportWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        onShowAllUsersClicked: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HomeWeb()),
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
        }, onStatsClicked: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => StatsWeb()),
        );
      },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'All Reports',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('Report').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final reports = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final reportData = reports[index].data() as Map<String, dynamic>;
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ReportDetails(
                                reportId: reports[index].id,
                              ),
                            ),
                          );
                        },
                        highlightColor: Colors.grey.withOpacity(0.5),
                        splashColor: Colors.grey.withOpacity(0.5),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                reportData['title'],
                                style: GoogleFonts.roboto(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 10),
                              FutureBuilder<DocumentSnapshot>(
                                future: FirebaseFirestore.instance.collection('Users').doc(reportData['userId']).get(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  if (!snapshot.hasData) {
                                    return const CircularProgressIndicator();
                                  }
                                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                                  return Text(
                                    'Reported by: ${userData['Name']}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[700],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
