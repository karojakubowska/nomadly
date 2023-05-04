import 'package:cloud_firestore/cloud_firestore.dart';
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
          Navigator.push(
              context, MaterialPageRoute(builder: ((context) => HomeWeb())));
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
                stream:
                    FirebaseFirestore.instance.collection('Users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final users = snapshot.data!.docs;
                  return DataTable(
                    columns: [
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
                          label: Text('Delete Account',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  height: 1.2,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))),
                    ],
                    rows: users.map<DataRow>((user) {
                      final userData = user.data() as Map<String, dynamic>;
                      return DataRow(cells: [
                        DataCell(Text(userData['Email'])),
                        DataCell(Text(userData['Name'])),
                        DataCell(Text(userData['AccountType'])),
                        DataCell(
                          userData['AccountType'] == 'Admin'
                              ? Icon(Icons.delete, color: Colors.white)
                              : IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    if (userData['AccountType'] != 'Admin') {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text('Confirm Deletion'),
                                            content: Text(
                                                'Are you sure you want to delete this user?'),
                                            actions: [
                                              TextButton(
                                                child: Text('Cancel'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: Text('Delete'),
                                                onPressed: () {
                                                  FirebaseFirestore.instance
                                                      .collection('Users')
                                                      .doc(user.id)
                                                      .delete()
                                                      .then((value) =>
                                                          Navigator.of(context)
                                                              .pop())
                                                      .catchError((error) => print(
                                                          'Failed to delete user: $error'));
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                    ;
                                  },
                                ),
                        ),
                      ]);
                    }).toList(),
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
