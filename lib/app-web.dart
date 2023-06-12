import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AppWeb extends StatelessWidget {
  final String apkStorageLink =
      'gs://nomady-ae4b6.appspot.com/app/android/app-release.apk';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APK Download',
      home: Scaffold(
        appBar: AppBar(
          title: Text('APK Download'),
        ),
        body: Center(
          child: ElevatedButton(
            child: Text('Pobierz APK'),
            onPressed: () {
              _launchURL(apkStorageLink);
            },
          ),
        ),
      ),
    );
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
}

void main() {
  runApp(AppWeb());
}

//
// // import 'package:flutter/material.dart';
// //
// // class AppWeb extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: Scaffold(
// //         appBar: AppBar(
// //           title: Text('Przykład przycisków'),
// //         ),
// //         body: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               ElevatedButton.icon(
// //                 onPressed: () {
// //                   // Akcja po naciśnięciu przycisku "Pobierz aplikację"
// //                   print('Pobierz aplikację');
// //                 },
// //                 icon: Icon(Icons.download),
// //                 label: Text('Pobierz aplikację'),
// //                 style: ElevatedButton.styleFrom(
// //                   minimumSize: Size(200, 100),
// //                 ),
// //               ),
// //               SizedBox(height: 20),
// //               ElevatedButton.icon(
// //                 onPressed: () {
// //                   // Akcja po naciśnięciu przycisku "Panel administracyjny"
// //                   print('Panel administracyjny');
// //                 },
// //                 icon: Icon(Icons.admin_panel_settings),
// //                 label: Text('Panel administracyjny'),
// //                 style: ElevatedButton.styleFrom(
// //                   minimumSize: Size(200, 100),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class AppWeb extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Row(
//         children: [
//           Expanded(
//             flex: 1,
//             child: Container(
//               padding: EdgeInsets.fromLTRB(50.0, 40.0, 50.0, 40.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Image.asset(
//                     'assets/icons/travel.png',
//                     width: 60.0,
//                     height: 60.0,
//                   ),
//                   SizedBox(height: 120.0),
//                   Text(
//                     "Find your next",
//                     style: GoogleFonts.roboto(
//                       fontSize: 45,
//                       fontWeight: FontWeight.w800,
//                       color: const Color.fromARGB(251, 251, 117, 122),
//                     ),
//                   ),
//                   Text(
//                     "Adventure with Nomadly!",
//                     style: GoogleFonts.roboto(
//                       fontSize: 50,
//                       fontWeight: FontWeight.w900,
//                       color: Color.fromARGB(255, 13, 150, 151),
//                     ),
//                   ),
//                   SizedBox(height: 30.0),
//                   Text(
//                     'Nomadly is a mobile application that enables convenient booking of accommodations and travel planning. Find the perfect place to stay, discover new destinations, and enjoy a unique travel experience. You will find a wide range of accommodation options tailored to your preferences and budget.',
//                     style: GoogleFonts.roboto(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w400,
//                       color: const Color.fromARGB(180, 32, 32, 32),
//                       height: 1.5,
//                     ),
//                   ),
//                   SizedBox(height: 50.0),
//                   Container(
//                     child: ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: 20.0, vertical: 20.0),
//                         backgroundColor: Color.fromARGB(255, 13, 150, 151),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0)),
//                       ),
//                       child: Text(
//                         'Download App',
//                         style: GoogleFonts.roboto(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w400,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Container(
//               alignment: Alignment.topRight,
//               child: Stack(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
//                     decoration: BoxDecoration(
//                       image: DecorationImage(
//                         image: AssetImage(
//                             '/images/ian-dooley-TevqnfbI0Zc-unsplash.jpg'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 20,
//                     right: 20,
//                     child: Container(
//                       child: ElevatedButton(
//                         onPressed: () {
//                           // Akcja po naciśnięciu przycisku "Admin Panel"
//                         },
//                         style: ElevatedButton.styleFrom(
//                           padding: EdgeInsets.all(20.0),
//                           backgroundColor: Color.fromARGB(251, 251, 117, 122),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10.0),
//                           ),
//                         ),
//                         child: Text(
//                           'Admin Panel',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.w400,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
