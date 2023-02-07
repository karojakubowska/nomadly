// // import 'package:flutter/src/widgets/container.dart';
// // import 'package:flutter/src/widgets/framework.dart';
// //
// // class UserProfileScreen extends StatefulWidget {
// //   const UserProfileScreen({super.key});
// //
// //   @override
// //   State<UserProfileScreen> createState() => _UserProfileScreenState();
// // }
// //
// // class _UserProfileScreenState extends State<UserProfileScreen> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Container();
// //   }
// // }
//
// import 'dart:io';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({Key? key}) : super(key: key);
//
//   @override
//   State<UserProfileScreen> createState() => _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends State<UserProfileScreen> {
//   String downloadedUrl = "";
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Upload Image"),
//       ),
//       body: SizedBox(
//         width: double.infinity,
//         height: double.infinity,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             _customTextButton(
//                 title: "Upload",
//                 onPressed: () async {
//                   try {
//                     await Permission.photos.request();
//                     var permissionStatus = await Permission.photos.status;
//                     final storageRef = FirebaseStorage.instanceFor(bucket: "gs://nomady-ae4b6.appspot.com/");
//                     final imageRef = storageRef.ref("no_image.jpg");
//                     final ImagePicker picker = ImagePicker();
//                     var metadata = SettableMetadata(
//                       contentType: "image/jpeg",
//                     );
//                     if (permissionStatus.isGranted) {
//                     XFile? image =
//                     await picker.pickImage(source: ImageSource.gallery);
//                     if (image != null) {
//                       File selectedImagePath = File(image.path);
//                       await imageRef
//                           .putFile(selectedImagePath, metadata)
//                           .whenComplete(() {
//                       });
//                     } }else {
//                     }
//     } on FirebaseException catch (e) {
//                   }
//                 }),
//             const SizedBox(height: 15),
//             _customTextButton(
//                 title: "Download",
//                 onPressed: () async {
//                   try {
//                     final storageRef = FirebaseStorage.instance.ref();
//                     final imageRef = storageRef.child("no_image.jpg");
//                     var url = await imageRef.getDownloadURL();
//                     setState(() {
//                       downloadedUrl = url;
//                     });
//                     print(url);
//                   } on FirebaseException catch (e) {
//                   }
//                 }),
//             const Text(
//               "Result:",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Image.network(
//                 downloadedUrl,
//                 height: 190,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _customTextButton(
//       {required String title, required VoidCallback? onPressed}) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: TextButton(
//           style: ButtonStyle(
//             backgroundColor: MaterialStateProperty.all(Colors.green.shade600),
//           ),
//           onPressed: onPressed,
//           child: Text(
//             title,
//             style: const TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         ),
//       ),
//     );
//   }
// }


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
          // if (image != null) {
          //   //Upload to Firebase
          //   var snapshot = await _firebaseStorage
          //       .ref()
          //       .child('images/imageName')
          //       .putFile(file);
          //   var downloadUrl = await snapshot.ref.getDownloadURL();
          //   setState(() {
          //     var imageUrl = downloadUrl;
          //   });
          // } else {
          //       print('No Image Path Received');
          //     }
          //   } else {
          //     print('Permission not granted. Try Again with permission access');
          //   }
          // }  else {
          //   /// use [Permissions.photos.status]
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
            style: TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold),
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


// import 'dart:io';
//
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// class UserProfileScreen extends StatefulWidget {
//     const UserProfileScreen({super.key});
//   @override
//   _UserProfileScreenState createState() => _UserProfileScreenState();
// }
//
// // class _UserProfileScreenState extends State<UserProfileScreen> {
// //   String? imageUrl;
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('Upload Image')),
// //       body: Column(
// //         children: <Widget>[
// //           (imageUrl != null) ? Image.network(imageUrl!)
// //               : Placeholder(fallbackHeight: 200.0,fallbackWidth: double.infinity),
// //           SizedBox(height: 20.0,),
// //            ElevatedButton(onPressed: uploadImage(), child: Text('Upload Image'))],
// //       ),
// //     );
// //   }
// //
// //   uploadImage() async {
// //     final _storage = FirebaseStorage.instance;
// //     final _picker = ImagePicker();
// //     PickedFile image;
// //
// //
// //     //Check Permissions
// //     await Permission.photos.request();
// //
// //     var permissionStatus = await Permission.photos.status;
// //
// //     if (permissionStatus.isGranted){
// //       //Select Image
// //       image = (await _picker.getImage(source: ImageSource.gallery))!;
// //       var file = File(image.path);
// //
// //       if (image != null){
// //         //Upload to Firebase
// //         var snapshot = await _storage.ref().child('folderName/imageName').putFile(file);
// //         var downloadUrl = await snapshot.ref.getDownloadURL();
// //
// //         setState(() {
// //           imageUrl = downloadUrl;
// //         });
// //       } else {
// //         print('No Path Received');
// //       }
// //
// //     } else {
// //       print('Grant Permissions and try again');
// //     }
// //
// //   }
// //
// // }
//
// class _UserProfileScreenState extends State<UserProfileScreen> {
//   String? imageUrl;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Upload Image')),
//       body: Column(
//         children: <Widget>[
//           (imageUrl != null) ? Image.network(imageUrl!)
//               : Placeholder(
//               fallbackHeight: 200.0, fallbackWidth: double.infinity),
//           SizedBox(height: 20.0,),
//           ElevatedButton(
//               onPressed: () => uploadImage(), child: Text('Upload Image'))
//         ],
//       ),
//     );
//   }
//
//   uploadImage() async {
//     final _storage = FirebaseStorage.instance;
//     final _picker = ImagePicker();
//     PickedFile image;
//
//     // Check Permissions
//     await Permission.photos.request();
//
//     var permissionStatus = await Permission.photos.status;
//
//     if (permissionStatus.isGranted) {
//       // Select Image
//       image = (await _picker.getImage(source: ImageSource.gallery))!;
//       var file = File(image.path);
//
//       if (image != null) {
//         // Upload to Firebase
//         var snapshot = await _storage.ref()
//             .child('folderName/imageName')
//             .putFile(file);
//         var downloadUrl = await snapshot.ref.getDownloadURL();
//
//         setState(() {
//           imageUrl = downloadUrl;
//         });
//       } else {
//         print('No Path Received');
//       }
//     } else {
//       print('Grant Permissions and try again');
//     }
//   }
// }
  }
