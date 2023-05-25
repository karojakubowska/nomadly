import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final void Function() onShowAllUsersClicked;
  final void Function() onManageReportsClicked;
  final void Function() onLogoutClicked;

  TopNavBar({
    required this.onShowAllUsersClicked,
    required this.onManageReportsClicked,
    required this.onLogoutClicked,
    required Null Function() onShowAllUsersPressed,
    required Null Function() onLogoutPressed,
    required Null Function() onManageReportsPressed,
    required bool automaticallyImplyLeading,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // usuwa przycisk cofnij
      title: Text('NOMADLY - ADMIN PANEL',
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontSize: 20.0,
                  height: 1.2,
                  color: Colors.white,
                  fontWeight: FontWeight.w400))),
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
                    fontWeight: FontWeight.w300)),
          ),
        ),
        const SizedBox(width: 40.0), // dodajemy przerwę pomiędzy przyciskami
        TextButton(
          onPressed: onManageReportsClicked,
          child: Text(
            'Manage Reports',
            style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                    fontSize: 16.0,
                    height: 1.2,
                    color: Colors.white,
                    fontWeight: FontWeight.w300)),
          ),
        ),
        const SizedBox(width: 40.0), // dodajemy przerwę pomiędzy przyciskami
        TextButton(
          onPressed: onLogoutClicked,
          child: Text(
            'Logout',
            style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                    fontSize: 16.0,
                    height: 1.2,
                    color: Colors.white,
                    fontWeight: FontWeight.w300)),
          ),
        ),
        const SizedBox(width: 20.0)
      ],
    );
  }
}


void onLogoutClicked() {
  FirebaseAuth.instance.signOut();
}