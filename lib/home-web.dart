import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/main-web.dart';
import 'package:nomadly_app/navbar-web.dart';
import 'package:nomadly_app/statistics-web.dart';

import 'report-web.dart';

class HomeWeb extends StatelessWidget {
  const HomeWeb({Key? key});

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
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: Text(
                  'All Users',
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

                      return Column(
                        children: [
                          const SizedBox(height: 16),
                          DataTable(
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    height: 1.2,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Name',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    height: 1.2,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Account Type',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    height: 1.2,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Account Status',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    height: 1.2,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Actions',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    height: 1.2,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                            rows: users.map<DataRow>((user) {
                              final userData = user.data() as Map<String, dynamic>;
                              return DataRow(cells: [
                                DataCell(Text(userData['Email'])),
                                DataCell(Text(userData['Name'])),
                                DataCell(Text(userData['AccountType'])),
                                DataCell(Text(userData['AccountStatus'])),
                                DataCell(
                                  userData['AccountType'] == 'Admin'
                                      ? const Row(
                                    children: [
                                      Icon(Icons.delete, color: Colors.white),
                                      const SizedBox(width: 5),
                                      Icon(Icons.block, color: Colors.white),
                                    ],
                                  )
                                      : Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          if (userData['AccountType'] != 'Admin') {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: const Text('Confirm Deletion'),
                                                  content: const Text('Are you sure you want to delete this user?'),
                                                  actions: [
                                                    TextButton(
                                                      child: const Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text('Delete'),
                                                      onPressed: () {
                                                        FirebaseFirestore.instance
                                                            .collection('Users')
                                                            .doc(user.id)
                                                            .delete()
                                                            .then((value) => Navigator.of(context).pop())
                                                            .catchError((error) => print('Failed to delete user: $error'));
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 5),
                                      IconButton(
                                        icon: userData['AccountStatus'] == 'Blocked' ? const Icon(Icons.block) : const Icon(Icons.lock_open),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: userData['AccountStatus'] == 'Blocked' ? const Text('Confirm Unblock') : const Text('Confirm Block'),
                                                content: userData['AccountStatus'] == 'Blocked'
                                                    ? const Text('Are you sure you want to unblock this user?')
                                                    : const Text('Are you sure you want to block this user?'),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: userData['AccountStatus'] == 'Blocked' ? const Text('Unblock') : const Text('Block'),
                                                    onPressed: () {
                                                      String newStatus = userData['AccountStatus'] == 'Blocked' ? 'Active' : 'Blocked';
                                                      FirebaseFirestore.instance
                                                          .collection('Users')
                                                          .doc(user.id)
                                                          .update({'AccountStatus': newStatus})
                                                          .then((value) => Navigator.of(context).pop())
                                                          .catchError((error) => print('Failed to change user status: $error'));
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ]);
                            }).toList(),
                          ),
                        ],
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
