import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late String imageUrl = '';

  Future uploadImage() async {
    final _firebaseStorage = FirebaseStorage.instance;
    final _imagePicker = ImagePicker();
    PickedFile? image;
    //Check Permissions
    await Permission.photos.request();

    var permissionStatus = await Permission.photos.status;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        await Permission.storage.request();

        var permissionStatus = await Permission.storage.status;
        if (permissionStatus.isGranted) {
          //Select Image
          image = await _imagePicker.getImage(source: ImageSource.gallery);
          var file = File(image!.path);

          var user = await FirebaseAuth.instance.currentUser!;
          if (user != null) {
            //User is logged in, perform desired action
            var snapshot = await _firebaseStorage
                .ref()
                .child('images/imageName')
                .putFile(file);
            var downloadUrl = await snapshot.ref.getDownloadURL();
            setState(() {
              var imageUrl = downloadUrl;
            });
          } else {
            //User is not logged in, show error message
            print('User is not authorized, please log in first');
          }
          // } else {
          //       print('No Image Path Received');
          //     }
          //   } else {
          //     print('Permission not granted. Try Again with permission access');
          //   }
          // }  else {
          //   /// use [Permissions.photos.status]
        }
      } else {
        await Permission.photos.request();

        var permissionStatus = await Permission.photos.status;
        if (permissionStatus.isGranted) {
          //Select Image

          image = await _imagePicker.getImage(source: ImageSource.gallery);
          var file = File(image!.path);

          var user = await FirebaseAuth.instance.currentUser!;
          if (user != null) {
            //User is logged in, perform desired action
            var snapshot =
                await _firebaseStorage.ref().child('images/').putFile(file);
            var downloadUrl = await snapshot.ref.getDownloadURL();
            setState(() {
              var imageUrl = downloadUrl;
            });
          } else {
            //User is not logged in, show error message
            print('User is not authorized, please log in first');
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Upload Image',
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.all(15),
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(15),
                  ),
                  border: Border.all(color: Colors.white),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(2, 2),
                      spreadRadius: 2,
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: (imageUrl != null)
                    ? Image.network(imageUrl)
                    : Image.network('')),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              child: Text("Upload Image",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              onPressed: () => {uploadImage()},
            ),
          ],
        ),
      ),
    );
  }
}
