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


// import 'package:flutter/material.dart';
//
// class AppWeb extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Przykład przycisków'),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               ElevatedButton.icon(
//                 onPressed: () {
//                   // Akcja po naciśnięciu przycisku "Pobierz aplikację"
//                   print('Pobierz aplikację');
//                 },
//                 icon: Icon(Icons.download),
//                 label: Text('Pobierz aplikację'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: Size(200, 100),
//                 ),
//               ),
//               SizedBox(height: 20),
//               ElevatedButton.icon(
//                 onPressed: () {
//                   // Akcja po naciśnięciu przycisku "Panel administracyjny"
//                   print('Panel administracyjny');
//                 },
//                 icon: Icon(Icons.admin_panel_settings),
//                 label: Text('Panel administracyjny'),
//                 style: ElevatedButton.styleFrom(
//                   minimumSize: Size(200, 100),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
