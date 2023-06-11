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
