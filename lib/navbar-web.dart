import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/home-web.dart';
import 'package:nomadly_app/main-web.dart';
import 'package:nomadly_app/statistics-web.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function() onShowAllUsersClicked;
  final void Function() onManageReportsClicked;
  final void Function() onLogoutClicked;
  final void Function() onStatsClicked;

  TopNavBar({
    required this.onShowAllUsersClicked,
    required this.onManageReportsClicked,
    required this.onLogoutClicked,
    required this.onStatsClicked,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Text(
        'NOMADLY - ADMIN PANEL',
        style: GoogleFonts.roboto(
          textStyle: const TextStyle(
            fontSize: 20.0,
            height: 1.2,
            color: Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: onShowAllUsersClicked,
          child: Text(
            'Show All Users',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                fontSize: 16.0,
                height: 1.2,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        const SizedBox(width: 40.0),
        TextButton(
          onPressed: onManageReportsClicked,
          child: Text(
            'Manage Reports',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                fontSize: 16.0,
                height: 1.2,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        const SizedBox(width: 40.0),
        TextButton(
          onPressed: onStatsClicked,
          child: Text(
            'Statistics',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                fontSize: 16.0,
                height: 1.2,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        const SizedBox(width: 40.0),
        TextButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MyWebView()),
            );
          },
          child: Text(
            'Logout',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                fontSize: 16.0,
                height: 1.2,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
        ),
        const SizedBox(width: 20.0),
      ],
    );
  }
}
