import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/profile-details-web.dart';

class ReportDetails extends StatelessWidget {
  final String reportId;

  ReportDetails({required this.reportId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Report')
          .doc(reportId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        final reportData = snapshot.data!.data() as Map<String, dynamic>;
        return Scaffold(
          appBar: AppBar(
            title: Text('Report Details'),
          ),
          body: Container(
            margin: EdgeInsets.all(20),
            constraints: BoxConstraints(maxWidth: 300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reportData['title'],
                  style: GoogleFonts.roboto(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(reportData['userId'])
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Text(
                      'Reported by: ${userData['Name']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    );
                  },
                ),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(reportData['otherUserId'])
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    final userData =
                        snapshot.data!.data() as Map<String, dynamic>;
                    return Text(
                      'Reported: ${userData['Name']}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Report Content:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  reportData['text'],
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Przeglądaj profil zgłaszającego
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileDetails(
                          userId: reportData['userId'],
                        ),
                      ),
                    );
                  },
                  child: Text('Przeglądaj profil zgłaszającego'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Przeglądaj profil zgłaszającego
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileDetails(
                          userId: reportData['otherUserId'],
                        ),
                      ),
                    );
                  },
                  child: Text('Przeglądaj profil zgłoszonego'),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

void onLogoutClicked() {
  FirebaseAuth.instance.signOut();
}
