import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/screens/change_password_view.dart';
import 'package:nomadly_app/screens/edit_profile_view.dart';
import 'package:nomadly_app/screens/privacy_policy_view.dart';
import 'package:nomadly_app/screens/terms_conditions_view.dart';
import 'package:nomadly_app/utils/app_styles.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          title: Text(
            'Profile',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    fontSize: 20.0,
                    height: 1.2,
                    color: Colors.black,
                    fontWeight: FontWeight.w700)),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: NetworkImage(
                        'https://www.example.com/images/profile.jpg'),
                  ),
                  SizedBox(width: 30.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name Surname',
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 20.0,
                                height: 1.2,
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'email@example.com',
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 16.0,
                                height: 1.2,
                                color: Colors.black,
                                fontWeight: FontWeight.w300)),
                      ),
                    ],
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => EditProfilePage())));
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
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
                            builder: ((context) => ChangePasswordPage())));
                  },
                ),
                _buildProfileSection(
                  context,
                  title: 'Language',
                  icon: Icons.language,
                  onPressed: () {
                  },
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
                            builder: ((context) => TermsConditionsScreen())));
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
                            builder: ((context) => PrivacyPolicyScreen())));
                  },
                ),
                _buildProfileSection(
                  context,
                  title: 'Help & Support',
                  icon: Icons.help,
                  onPressed: () {},
                ),
                SizedBox(height: 16),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      backgroundColor: const Color.fromARGB(255, 50, 134, 252),
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
        ));
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
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(icon, color: Colors.black),
                SizedBox(width: 16.0),
                Text(
                  title,
                  style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400)),
                ),
                Spacer(),
                Icon(Icons.keyboard_arrow_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

