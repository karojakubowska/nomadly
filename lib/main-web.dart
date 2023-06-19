import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'login-web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyWebView());
}

class MyWebView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nomadly',
      home: Scaffold(
        body: Center(
          child: AppWeb(),
        ),
      ),
    );
  }
}

void _launchURL(String url) async {
  if (url.startsWith('gs://')) {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .refFromURL(url)
        .getDownloadURL();
    url = downloadURL;
  }

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Nie można otworzyć adresu $url';
  }
}

class AppWeb extends StatelessWidget {
  final String apkStorageLink =
      'gs://nomady-ae4b6.appspot.com/app/android/app-release.apk';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/icons/travel.png',
                    width: 60.0,
                    height: 60.0,
                  ),
                  SizedBox(height: 120.0),
                  Text(
                    "Find your next",
                    style: GoogleFonts.roboto(
                      fontSize: 45,
                      fontWeight: FontWeight.w800,
                      color: const Color.fromARGB(251, 251, 117, 122),
                    ),
                  ),
                  Text(
                    "Adventure with Nomadly!",
                    style: GoogleFonts.roboto(
                      fontSize: 50,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(255, 13, 150, 151),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  Text(
                    'Nomadly is a mobile application that enables convenient booking of accommodations and travel planning. Find the perfect place to stay, discover new destinations, and enjoy a unique travel experience. You will find a wide range of accommodation options tailored to your preferences and budget.',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: const Color.fromARGB(180, 32, 32, 32),
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 50.0),
                  Container(
                    child: ElevatedButton(
                      onPressed: () {
                        _launchURL(apkStorageLink);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 20.0),
                        backgroundColor: Color.fromARGB(255, 13, 150, 151),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      child: Text(
                        'Download App',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.topRight,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            'assets/images/ian-dooley-TevqnfbI0Zc-unsplash.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(
                                onClickedSignUp: () {
                                },
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.all(20.0),
                          backgroundColor: Color.fromARGB(251, 251, 117, 122),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: Text(
                          'Admin Panel',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
