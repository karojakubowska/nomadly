import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/main-web.dart';
import 'package:nomadly_app/navbar-web.dart';
import 'package:nomadly_app/report-web.dart';
import 'package:nomadly_app/statistics-web.dart';

import 'home-web.dart';

class ReportDetails extends StatefulWidget {
  final String reportId;

  ReportDetails({required this.reportId});

  @override
  _ReportDetailsState createState() => _ReportDetailsState();
}

class _ReportDetailsState extends State<ReportDetails> {
  bool showReporterDetails = false;
  bool showReportedUserDetails = false;

  void toggleReporterDetails() {
    setState(() {
      showReporterDetails = !showReporterDetails;
    });
  }

  void toggleReportedUserDetails() {
    setState(() {
      showReportedUserDetails = !showReportedUserDetails;
    });
  }

  void sendEmailToReporter() {
    // Implement the logic to send an email to the reporter
  }

  void sendEmailToReportedUser() {
    // Implement the logic to send an email to the reported user
  }

  void deleteReport() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Report"),
          content: Text("Are you sure you want to delete this report?"),
          actions: [
            ElevatedButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text("Delete"),
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('Report')
                    .doc(widget.reportId)
                    .delete();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ReportWeb()),
                );
              },
            ),
          ],
        );
      },
    );
  }

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
        },
        onStatsClicked: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StatsWeb()),
          );
        },
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Report')
            .doc(widget.reportId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final reportData = snapshot.data!.data() as Map<String, dynamic>;
          // Sprawdź czy report został odczytany
          final bool isRead = reportData['isRead'] ?? false;
          // Jeśli report nie został odczytany, zaktualizuj wartość pola "isRead" na true
          if (!isRead) {
            FirebaseFirestore.instance
                .collection('Report')
                .doc(widget.reportId)
                .update({'isRead': true});
          }
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(
                  top: 100, bottom: 100, left: 150, right: 150),
              child: Center(
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Report Details',
                            style: GoogleFonts.roboto(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: Text(
                            'Title: ${reportData['title']}',
                            style: GoogleFonts.roboto(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
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
                              return const CircularProgressIndicator();
                            }
                            final userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 80),
                              child: GestureDetector(
                                onTap: toggleReporterDetails,
                                child: Text(
                                  'Reported by: ${userData['Name']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        if (showReporterDetails)
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
                                return const CircularProgressIndicator();
                              }
                              final userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 80),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Name: ${userData['Name']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Email: ${userData['Email']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Status: ${userData['AccountStatus']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Account Type: ${userData['AccountType']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
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
                              return const CircularProgressIndicator();
                            }
                            final userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                            return Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 80),
                              child: GestureDetector(
                                onTap: toggleReportedUserDetails,
                                child: Text(
                                  'Reported: ${userData['Name']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        if (showReportedUserDetails)
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
                                return const CircularProgressIndicator();
                              }
                              final userData =
                              snapshot.data!.data() as Map<String, dynamic>;
                              return Column(
                                children: [
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 80),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Name: ${userData['Name']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Email: ${userData['Email']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Status: ${userData['AccountStatus']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          'Account Type: ${userData['AccountType']}',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: Text(
                            'Report Content:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 80),
                          child: Text(
                            reportData['text'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: sendEmailToReporter,
                                child: Text('Send Email to Reporter'),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: sendEmailToReportedUser,
                                child: Text('Send Email to Reported User'),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: deleteReport,
                                child: Text('Delete Report'),
                              ),
                              SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('Report')
                                      .doc(widget.reportId)
                                      .update({'isRead': true});
                                },
                                child: Text('Mark as Read'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}