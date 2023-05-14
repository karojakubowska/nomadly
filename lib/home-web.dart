import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/navbar-web.dart';

import 'report-web.dart';

class HomeWeb extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopNavBar(
        automaticallyImplyLeading: false,
        onShowAllUsersPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => HomeWeb())));
        },
        onManageReportsPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => ReportWeb())));
        },
        onLogoutPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => HomeWeb())));
        },
        onShowAllUsersClicked: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => HomeWeb())));
        },
        onManageReportsClicked: () {
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => ReportWeb())));
        },
        onLogoutClicked: () {
          FirebaseAuth.instance.signOut();
        },
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.all(0),
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(height: 16),
              Text(
                'All Users',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 16),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .snapshots(),
                  builder: (context, userSnapshot) {
                    if (userSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${userSnapshot.error}'));
                    }
                    if (!userSnapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    final users = userSnapshot.data!.docs;
                    int totalUsers = users.length;
                    int totalHosts = users
                        .where((user) => user['AccountType'] == 'Host')
                        .length;
                    int totalClients = users
                        .where((user) => user['AccountType'] == 'Client')
                        .length;
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('Accommodations')
                          .snapshots(),
                      builder: (context, accommodationSnapshot) {
                        if (accommodationSnapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Error: ${accommodationSnapshot.error}'));
                        }
                        if (!accommodationSnapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final accommodations = accommodationSnapshot.data!.docs;
                        int totalAccommodations = accommodations.length;

                        return Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total Users: $totalUsers'),
                              Text('Total Hosts: $totalHosts'),
                              Text('Total Clients: $totalClients'),
                              Text('Total Accommodations: $totalAccommodations'),
                            ],
                          ),
                          SizedBox(height: 16),
                          // Add other widgets here as needed
                          DataTable(
                            columns: const [
                              DataColumn(
                                  label: Text('Email',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          height: 1.2,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600))),
                              DataColumn(
                                  label: Text('Name',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          height: 1.2,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600))),
                              DataColumn(
                                  label: Text('Account Type',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          height: 1.2,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600))),
                              DataColumn(
                                  label: Text('Account Status',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          height: 1.2,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600))),
                              DataColumn(
                                  label: Text('Actions',
                                      style: TextStyle(
                                          fontSize: 16.0,
                                          height: 1.2,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600))),
                            ],
                            rows: users.map<DataRow>((user) {
                              final userData =
                              user.data() as Map<String, dynamic>;
                              return DataRow(cells: [
                                DataCell(Text(userData['Email'])),
                                DataCell(Text(userData['Name'])),
                                DataCell(Text(userData['AccountType'])),
                                DataCell(Text(userData['AccountStatus'])),
                                DataCell(
                                  userData['AccountType'] == 'Admin'
                                      ? Row(
                                    children: [
                                      Icon(Icons.delete,
                                          color: Colors.white),
                                      SizedBox(width: 5),
                                      Icon(Icons.block,
                                          color: Colors.white),
                                    ],
                                  )
                                      : Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () {
                                          if (userData['AccountType'] !=
                                              'Admin') {
                                            showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  title: Text(
                                                      'Confirm Deletion'),
                                                  content: Text(
                                                      'Are you sure you want to delete this user?'),
                                                  actions: [
                                                    TextButton(
                                                      child:
                                                      Text('Cancel'),
                                                      onPressed: () {
                                                        Navigator.of(
                                                            context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child:
                                                      Text('Delete'),
                                                      onPressed: () {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                            'Users')
                                                            .doc(user.id)
                                                            .delete()
                                                            .then((value) =>
                                                            Navigator.of(
                                                                context)
                                                                .pop())
                                                            .catchError(
                                                                (error) =>
                                                                print(
                                                                    'Failed to delete user: $error'));
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                      ),
                                      SizedBox(width: 5),
                                      IconButton(
                                        icon: Icon(Icons.block),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title:
                                                Text('Confirm Block'),
                                                content: Text(
                                                    'Are you sure you want to block this user?'),
                                                actions: [
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(
                                                          context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Block'),
                                                    onPressed: () {
                                                      FirebaseFirestore
                                                          .instance
                                                          .collection(
                                                          'Users')
                                                          .doc(user.id)
                                                          .update({
                                                        'AccountStatus':
                                                        'Blocked'
                                                      })
                                                          .then((value) =>
                                                          Navigator.of(
                                                              context)
                                                              .pop())
                                                          .catchError(
                                                              (error) =>
                                                              print(
                                                                  'Failed to block user: $error'));
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
                          )
                        ]);
                      },
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }
}

void onLogoutClicked() {
  FirebaseAuth.instance.signOut();
}
