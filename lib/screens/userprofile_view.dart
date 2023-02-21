// import 'dart:io';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:device_info_plus/device_info_plus.dart';
//
// class UserProfileScreen extends StatefulWidget {
//   const UserProfileScreen({super.key});
//
//   @override
//   _UserProfileScreenState createState() => _UserProfileScreenState();
// }
//
// class _UserProfileScreenState extends State<UserProfileScreen> {
//   late String imageUrl = '';
//
//   Future uploadImage() async {
//     final _firebaseStorage = FirebaseStorage.instance;
//     final _imagePicker = ImagePicker();
//     PickedFile? image;
//     //Check Permissions
//     await Permission.photos.request();
//
//     var permissionStatus = await Permission.photos.status;
//
//     if (Platform.isAndroid) {
//       final androidInfo = await DeviceInfoPlugin().androidInfo;
//       if (androidInfo.version.sdkInt <= 32) {
//         await Permission.storage.request();
//
//         var permissionStatus = await Permission.storage.status;
//         if (permissionStatus.isGranted) {
//           //Select Image
//           image = await _imagePicker.getImage(source: ImageSource.gallery);
//           var file = File(image!.path);
//
//           var user = await FirebaseAuth.instance.currentUser!;
//           if (user != null) {
//             final destination = 'files/$file';
//             // final ref = _firebaseStorage.instance
//             //     .ref(destination)
//             //     .child('file/');
//             // await ref.putFile(_photo!);
//             var snapshot = await _firebaseStorage.ref(destination).child('file/').putFile(file);
//
//             //User is logged in, perform desired action
//             // var snapshot = await _firebaseStorage.ref().child('images').putFile(file);
//
//             var downloadUrl = await snapshot.ref.getDownloadURL();
//             setState(() {
//               imageUrl = downloadUrl;
//             });
//
//           } else {
//             //User is not logged in, show error message
//             print('User is not authorized, please log in first');
//           }
//           // } else {
//           //       print('No Image Path Received');
//           //     }
//           //   } else {
//           //     print('Permission not granted. Try Again with permission access');
//           //   }
//           // }  else {
//           //   /// use [Permissions.photos.status]
//         }
//       } else {
//         await Permission.photos.request();
//
//         var permissionStatus = await Permission.photos.status;
//         if (permissionStatus.isGranted) {
//           //Select Image
//
//           image = await _imagePicker.getImage(source: ImageSource.gallery);
//           var file = File(image!.path);
//
//           var user = await FirebaseAuth.instance.currentUser!;
//           if (user != null) {
//             //User is logged in, perform desired action
//             var snapshot = await _firebaseStorage.ref().child('').putFile(file);
//             var downloadUrl = await snapshot.ref.getDownloadURL();
//             setState(() {
//               imageUrl = downloadUrl;
//             });
//           } else {
//             //User is not logged in, show error message
//             print('User is not authorized, please log in first');
//           }
//         }
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Upload Image',
//           style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//         elevation: 0.0,
//         backgroundColor: Colors.white,
//       ),
//       body: Container(
//         color: Colors.white,
//         child: Column(
//           children: <Widget>[
//             Container(
//                 margin: EdgeInsets.all(15),
//                 padding: EdgeInsets.all(15),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.all(
//                     Radius.circular(15),
//                   ),
//                   border: Border.all(color: Colors.white),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       offset: Offset(2, 2),
//                       spreadRadius: 2,
//                       blurRadius: 1,
//                     ),
//                   ],
//                 ),
//                 child: (imageUrl != null)
//                     ? Image.network(imageUrl)
//                     : Image.network('')),
//             SizedBox(
//               height: 20.0,
//             ),
//             ElevatedButton(
//               child: Text("Upload Image",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 20)),
//               onPressed: () => {uploadImage()},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({Key? key}) : super(key: key) ;

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  final pickedFile ="";

  Future imgFromGallery(pickedFile) async {
    pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _photo = File(pickedFile.path);
    });
    // pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    //
    // setState(() {
    //   if (pickedFile != null) {
    //     _photo = File(pickedFile.path);
    //     //uploadFile();
    //     var user = FirebaseAuth.instance.currentUser!;
    //     var uid = user.uid;
    //     if (_photo == null) return;
    //     final fileName = basename(_photo!.path);
    //     final destination = '$uid/$fileName';
    //
    //     try {
    //       final ref = firebase_storage.FirebaseStorage.instance
    //           .ref(destination)
    //           .child('');
    //       ref.putFile(_photo!);
    //     } catch (e) {
    //       print('error occured');
    //     }
    //   } else {
    //     print('No image selected.');
    //   }
    // });
  }

  Future imgFromCamera(pickedFile) async {
    pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _photo = File(pickedFile.path);
    });
    }

  Future uploadFile(pickedFile) async {
    var user =  FirebaseAuth.instance.currentUser!;
    var uid = user.uid;
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = '$uid/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

  @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(),
  //     body: Column(
  //       children: <Widget>[
  //         const SizedBox(
  //           height: 32,
  //         ),
  //         Center(
  //           child: Column(
  //             children: <Widget>[
  //               GestureDetector(
  //                 onTap: () {
  //                   _showPicker(context);
  //                 },
  //                 child: Container(
  //                   width: 250,
  //                   height: 250,
  //                   decoration: BoxDecoration(
  //                     color: const Color(0xff000000),
  //                     borderRadius: BorderRadius.all(Radius.circular(10)),
  //                   ),
  //                   child: _photo != null
  //                       ? ClipRRect(
  //                     borderRadius: BorderRadius.all(Radius.circular(10)),
  //                     child: Image.file(
  //                       _photo!,
  //                       width: 100,
  //                       height: 100,
  //                       fit: BoxFit.fitHeight,
  //                     ),
  //                   )
  //                       : Container(
  //                     decoration: BoxDecoration(
  //                       color: Colors.grey[200],
  //                       borderRadius: BorderRadius.all(Radius.circular(10)),
  //                     ),
  //                     child: Icon(
  //                       Icons.camera_alt,
  //                       color: Colors.grey[800],
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget build(BuildContext context) {
  
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 32,
          ),
          Center(
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      color: const Color(0xff000000),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: _photo != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.file(
                        _photo!,
                        width: 100,
                        height: 100,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                        : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          Center(
            child: ElevatedButton(
              onPressed: () {
                uploadFile(pickedFile);
              },
              child: Text('Upload'),
            ),
          ),
        ],
      ),
    );
  }


  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Gallery'),
                    onTap: () {
                      imgFromGallery(pickedFile);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    imgFromCamera(pickedFile);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }
}
