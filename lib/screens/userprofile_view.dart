import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/screens/change_password_view.dart';
import 'package:nomadly_app/screens/help_support_view.dart';
import 'package:nomadly_app/screens/update_userprofile_view.dart';
import 'package:nomadly_app/screens/privacy_policy_view.dart';
import 'package:nomadly_app/screens/terms_conditions_view.dart';
import 'package:nomadly_app/utils/app_styles.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  var img = "";
  late Stream<DocumentSnapshot> userStream;
  late String name, email, accountImage;
  String id = "";
  late final user;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    id =  FirebaseAuth.instance.currentUser!.uid.toString();
    user =  FirebaseAuth.instance.currentUser;
    userStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          title: Text(
            'Profile',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                    fontSize: 20.0,
                    height: 1.2,
                    color: Colors.black,
                    fontWeight: FontWeight.w700)),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot>(
            stream: userStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final userDoc = snapshot.data!;
              name = userDoc.get('Name');
              email = userDoc.get('Email');
              accountImage = userDoc.get('AccountImage');
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Row(
                      children: [
                        FutureBuilder(
                          future: FirebaseStorage.instance
                              .refFromURL(accountImage)
                              .getDownloadURL(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.hasData) {
                              return CircleAvatar(
                                  radius: 40.0,
                                  backgroundImage:
                                      NetworkImage(snapshot.data.toString()));
                            } else {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }
                          },
                        ),
                        const SizedBox(width: 30.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      fontSize: 20.0,
                                      height: 1.2,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              email,
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      fontSize: 16.0,
                                      height: 1.2,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300)),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => EditProfilePage(id:id, image: accountImage))));
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Expanded(
                    child: ListView(children: [
                      _buildProfileSection(
                        context,
                        title: 'Change Password',
                        icon: Icons.lock_outline,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      const ChangePasswordPage())));
                        },
                      ),
                      _buildProfileSection(
                        context,
                        title: 'Language',
                        icon: Icons.language,
                        onPressed: () {},
                      ),
                      _buildProfileSection(
                        context,
                        title: 'Notifications',
                        icon: Icons.notifications_active_outlined,
                        onPressed: () {},
                      ),
                      _buildProfileSection(
                        context,
                        title: 'Terms and Conditions',
                        icon: Icons.security,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      const TermsConditionsScreen())));
                        },
                      ),
                      _buildProfileSection(
                        context,
                        title: 'Privacy Policy',
                        icon: Icons.local_police,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) =>
                                      const PrivacyPolicyScreen())));
                        },
                      ),
                      _buildProfileSection(
                        context,
                        title: 'Help & Support',
                        icon: Icons.help,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const HelpSupportScreen())));
                        },
                      ),
                      const SizedBox(height: 16),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(55),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            backgroundColor:
                                const Color.fromARGB(255, 50, 134, 252),
                          ),
                          onPressed: _signOut,
                          child: const Text('Log out',
                              style: TextStyle(
                                  fontSize: 20.0,
                                  height: 1.2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ]),
                  ),
                ],
              );
            }));
  }

  void _signOut() {
    FirebaseAuth.instance.signOut();
  }

  Widget _buildProfileSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 8.0, 20.0, 8.0),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, color: Colors.black),
                const SizedBox(width: 16.0),
                Text(
                  title,
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   _UserProfileScreenState createState() => _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends State<UserProfileScreen> {
//   late Stream<DocumentSnapshot> userStream;
//   late String name, email;
//
//   @override
//   void initState() {
//     super.initState();
//     final currentUser = FirebaseAuth.instance.currentUser;
//     userStream = FirebaseFirestore.instance
//         .collection('Users')
//         .doc(currentUser!.uid)
//         .snapshots();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Styles.backgroundColor,
//         appBar: AppBar(
//         title: Text(
//         'Profile',
//         textAlign: TextAlign.center,
//         style: GoogleFonts.roboto(
//         textStyle: TextStyle(
//         fontSize: 20.0,
//         height: 1.2,
//         color: Colors.black,
//         fontWeight: FontWeight.w700)),
//     ),
//     backgroundColor: Colors.transparent,
//     elevation: 0,
//     centerTitle: true,
//     ),
//     body: StreamBuilder<DocumentSnapshot>(
//     stream: userStream,
//     builder: (context, snapshot) {
//     if (snapshot.connectionState == ConnectionState.waiting) {
//     return Center(child: CircularProgressIndicator());
//     }
//
//     final userDoc = snapshot.data!;
//     name = userDoc.get('Name');
//     email = userDoc.get('Email');
//
//     return Column(
//     children: [
//     Padding(
//     padding: const EdgeInsets.all(25.0),
//     child: Row(
//     children: [
//     CircleAvatar(
//     radius: 40.0,
//     backgroundImage: NetworkImage(
//     'https://cdn-icons-png.flaticon.com/512/3177/3177440.png'),
//     ),
//     SizedBox(width: 30.0),
//     Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//     Text(
//     name,
//     style: GoogleFonts.roboto(
//     textStyle: TextStyle(
//     fontSize: 20.0,
//     height: 1.2,
//     color: Colors.black,
//     fontWeight: FontWeight.w500)),
//     ),
//     SizedBox(height: 8.0),
//     Text(
//     email,
//     style: GoogleFonts.roboto(
//     textStyle: TextStyle(
//     fontSize: 16.0,
//     height: 1.2,
//     color: Colors.black,
//     fontWeight: FontWeight.w300)),
//     ),
//     ],
//     ),
//     Spacer(),
//     IconButton(
//     icon: Icon(Icons.edit),
//     onPressed: () {
//     Navigator.push(
//     context,
//     MaterialPageRoute(
//     builder: ((context) => EditProfilePage())));
//     },
//     ),
//     ],
//     ),
//     ),
//     SizedBox(height: 10.0),
//     Expanded(
//     child: ListView
//     (
//     children
//     :
//     [
//     _buildProfileSection
//     (
//     context
//     ),
//       SizedBox(height: 10.0),
//       _buildAccountSection(context),
//       SizedBox(height: 10.0),
//       _buildPrivacySection(context),
//     ]),
//     ),
//     ],
//     );
//     },
//     ),
//     );
//   }
//
//   Widget _buildProfileSection(BuildContext context) {
//     return Card(
//         child: Padding(
//         padding: const EdgeInsets.all(16.0),
//     child: Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//     Text(
//     'Profile',
//     style: GoogleFonts.roboto(
//     textStyle: TextStyle(
//     fontSize: 18.0,
//     height: 1.2,
//     color: Colors.black,
//     fontWeight: FontWeight.w500)),
//     ),
//     SizedBox(height: 10.0),
//     ListTile(
//     title: Text(
//     'Name',
//     style: GoogleFonts.roboto(
//     textStyle: TextStyle(
//     fontSize: 16.0,
//     height: 1.2,
//     color: Colors.black,
//     fontWeight: FontWeight.w500)),
//     ),
//     subtitle: Text(
//     name,
//     style: GoogleFonts.roboto(
//     textStyle: TextStyle(
//     fontSize: 16.0,
//     height: 1.2,
//     color: Colors.black,
//     fontWeight: FontWeight.w300)),
//     ),
//     trailing: IconButton(
//     icon: Icon(Icons.edit),
//     onPressed: () {
//     Navigator.push(
//     context,
//     MaterialPageRoute(
//     builder: ((context) => EditProfilePage())));
//     },
//     ),
//     ),
//     SizedBox(height: 10.0),
//     ListTile(
//     title: Text(
//     'Email',
//     style: GoogleFonts.roboto(
//     textStyle: TextStyle(
//     fontSize: 16.0,
//     height: 1.2,
//     color: Colors.black,
//     fontWeight: FontWeight.w500)),
//     ),
//     subtitle: Text(
//     email,
//     style: GoogleFonts.roboto(
//     textStyle: TextStyle(
//     fontSize: 16.0,
//     height: 1.2,
//     color: Colors.black,
//     fontWeight: FontWeight.w300)),
//     ),
//     trailing: IconButton(
//     icon: Icon(Icons.edit),
//     onPressed: () {
//     Navigator.push(
//     context,
//     MaterialPageRoute(
//     builder: ((context) => EditProfilePage())));
//     },
//     ),
//    ),
