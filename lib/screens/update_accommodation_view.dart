import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:nomadly_app/utils/app_styles.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../utils/app_layout.dart';

class UpdateAccommodationScreen extends StatefulWidget {
  final DocumentSnapshot? accommodation;
  final String id;

  const UpdateAccommodationScreen(
      {Key? key, this.accommodation, required this.id})
      : super(key: key);

  @override
  State<UpdateAccommodationScreen> createState() =>
      _UpdateAccommodationScreenState();
}

class _UpdateAccommodationScreenState extends State<UpdateAccommodationScreen> {
  final titleController = TextEditingController();
  final cityController = TextEditingController();
  final streetController = TextEditingController();
  final countryController = TextEditingController();
  final descriptionController = TextEditingController();
  final price_per_nightController = TextEditingController();
  final bedController = TextEditingController();
  final bedroomController = TextEditingController();
  final bathroomController = TextEditingController();
  final number_max_peopleController = TextEditingController();
  final addressController = TextEditingController();

  bool kitchen = false;
  bool wifi = false;
  bool tv = false;
  bool air_conditioning = false;

  CollectionReference accommodation =
      FirebaseFirestore.instance.collection('Acccommodations');

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  final pickedFile = "";

  List<File> photos = [];
  final ImagePicker _imagePicker = ImagePicker();

  var imageURL = "";
  late String imageOld = " ";
  String _photoUrl = "";

  List<String> photoUrls = [];

  List<String> imageUrls = [];

  void initState() {
    super.initState();
    titleController.text = widget.accommodation!.get("title");
    cityController.text = widget.accommodation!.get("city");
    streetController.text = widget.accommodation!.get("street");
    countryController.text = widget.accommodation!.get("country");
    descriptionController.text = widget.accommodation!.get("description");
    price_per_nightController.text =
        widget.accommodation!.get("price_per_night").toString();
    number_max_peopleController.text =
        widget.accommodation!.get("number_max_people").toString();
    bedController.text = widget.accommodation!.get("bed").toString();
    bedroomController.text = widget.accommodation!.get("bedroom").toString();
    bathroomController.text = widget.accommodation!.get("bathroom").toString();
    addressController.text = widget.accommodation!.get("address");
    imageOld = widget.accommodation!.get("photo");
    kitchen = widget.accommodation!.get("kitchen");
    wifi = widget.accommodation!.get("wifi");
    tv = widget.accommodation!.get("tv");
    air_conditioning = widget.accommodation!.get("air_conditioning");

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref =
        storage.refFromURL(widget.accommodation!.get("photo") as String);
    ref.getDownloadURL().then((value) {
      setState(() {
        _photoUrl = value;
      });
    });

    List<dynamic> photos = widget.accommodation!.get("photoUrl");
    if (photos != null) {
      for (dynamic photo in photos) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.refFromURL(photo);
        ref.getDownloadURL().then((value) {
          setState(() {
            photoUrls.add(value);
          });
        }).catchError((error) {
          print('Error retrieving photo URL: $error');
        });
      }
    }

    setState(() {
      imageUrls = photos.map((photo) => photo.toString()).toList();
    });
  }

  Future imgFromGallery(pickedFile) async {
    pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _photo = File(pickedFile.path);
    });
  }

  Future imgFromCamera(pickedFile) async {
    pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _photo = File(pickedFile.path);
    });
  }

  Future uploadFile(pickedFile) async {
    var user = await FirebaseAuth.instance.currentUser!;
    var uid = user.uid;
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = '$uid/$fileName';

    try {
      final ref =
          firebase_storage.FirebaseStorage.instance.ref(destination).child('');
      await ref.putFile(_photo!);
    } catch (e) {
      print('error occured');
    }
  }

  void _showPicker1(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                SizedBox(height: 8.0),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    imgFromGallery(pickedFile);
                    Navigator.of(context).pop();
                  },
                ),
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

  Future<void> _showPicker(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Choose photo:'),
          actions: [
            TextButton(
              child: Text('Gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                final XFile? pickedFile = await _imagePicker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 85,
                  maxWidth: 1080,
                  maxHeight: 1920,
                );
                if (pickedFile != null) {
                  setState(() {
                    final File photo = File(pickedFile.path);
                    photos.add(photo);
                  });
                }
              },
            ),
            TextButton(
              child: Text('Camera'),
              onPressed: () async {
                Navigator.of(context).pop();
                final XFile? pickedFile = await _imagePicker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 85,
                  maxWidth: 1080,
                  maxHeight: 1920,
                );
                if (pickedFile != null) {
                  setState(() {
                    final File photo = File(pickedFile.path);
                    photos.add(photo);
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }


  // Future<void> updateAccommodation(id, PickedFile) async {
  //   var user = await FirebaseAuth.instance.currentUser!;
  //   var uid = user.uid;
  //
  //   if (_photo == null) {
  //     final db = FirebaseFirestore.instance;
  //     final accommodation = db.collection("Accommodations").doc(id);
  //
  //     List<String> updatedPhotoUrls = [];
  //
  //     for (var photo in photos) {
  //       String uuid = Uuid().v4();
  //       String uniqueFileName = '$uid/$uuid.jpg';
  //       final destination = uniqueFileName;
  //
  //
  //       try {
  //         final ref = firebase_storage.FirebaseStorage.instance.ref(destination).child('');
  //         await ref.putFile(photo);
  //        String  photoUrl = ("gs://nomady-ae4b6.appspot.com/" + destination.toString())
  //             .toString();
  //         updatedPhotoUrls.add(photoUrl);
  //       } catch (e) {
  //         print('error occurred');
  //       }
  //       // try {
  //       //   final ref =
  //       //   firebase_storage.FirebaseStorage.instance.ref(destination);
  //       //   await ref.putFile(photo);
  //       //   String photoUrl = await ref.getDownloadURL();
  //       //   updatedPhotoUrls.add(photoUrl);
  //       // } catch (e) {
  //       //   print('Error uploading photo: $e');
  //       // }
  //     }
  //
  //     // Delete old photos from Firebase Storage
  //     for (var oldPhotoUrl in photoUrls) {
  //       try {
  //         await firebase_storage.FirebaseStorage.instance
  //             .refFromURL(oldPhotoUrl)
  //             .delete();
  //         print("Old photo successfully deleted: $oldPhotoUrl");
  //       } catch (e) {
  //         print('Error deleting old photo: $e');
  //       }
  //     }
  //
  //     accommodation.update({
  //       'title': titleController.text,
  //       'country': countryController.text,
  //       'city': cityController.text,
  //       'street': streetController.text,
  //       'description': descriptionController.text,
  //       'address': addressController.text,
  //       'price_per_night': int.parse(price_per_nightController.text),
  //       'bed': int.parse(bedController.text),
  //       'bathroom': int.parse(bathroomController.text),
  //       'bedroom': int.parse(bedroomController.text),
  //       'number_max_people': int.parse(number_max_peopleController.text),
  //       'host_id': FirebaseAuth.instance.currentUser!.uid,
  //       'photo': imageOld.toString(),
  //       'kitchen': kitchen ? true : false,
  //       'wifi': wifi ? true : false,
  //       'tv': tv ? true : false,
  //       'air_conditioning': air_conditioning ? true : false,
  //       'photoUrl': updatedPhotoUrls,
  //     }).then((value) => print("DocumentSnapshot successfully updated!"),
  //         onError: (e) => print("Error updating document $e"));
  //   } else {
  //     final db = FirebaseFirestore.instance;
  //     final accommodation = db.collection("Accommodations").doc(id);
  //
  //     FirebaseStorage.instance.refFromURL(imageOld).delete().then((_) {
  //       print("Image successfully deleted!");
  //     }).catchError((error) {
  //       print("Error removing image: $error");
  //     });
  //
  //     String uuid = Uuid().v4();
  //     String uniqueFileName = '$uid/$uuid.jpg';
  //     final destination = uniqueFileName;
  //
  //     try {
  //       final ref = firebase_storage.FirebaseStorage.instance
  //           .ref(destination)
  //           .child('');
  //       await ref.putFile(_photo!);
  //       imageURL = ("gs://nomady-ae4b6.appspot.com/" + destination.toString())
  //           .toString();
  //     } catch (e) {
  //       print('error occurred');
  //     }
  //
  //     List<String> updatedPhotoUrls = [];
  //
  //     for (var photo in photos) {
  //       String uuid = Uuid().v4();
  //       String uniqueFileName = '$uid/$uuid.jpg';
  //       final destination = uniqueFileName;
  //
  //       try {
  //         final ref =
  //             firebase_storage.FirebaseStorage.instance.ref(destination);
  //         await ref.putFile(photo);
  //         String photoUrl = await ref.getDownloadURL();
  //         updatedPhotoUrls.add(photoUrl);
  //       } catch (e) {
  //         print('Error uploading photo: $e');
  //       }
  //     }
  //
  //     // Delete old photos from Firebase Storage
  //     for (var oldPhotoUrl in photoUrls) {
  //       try {
  //         await firebase_storage.FirebaseStorage.instance
  //             .refFromURL(oldPhotoUrl)
  //             .delete();
  //         print("Old photo successfully deleted: $oldPhotoUrl");
  //       } catch (e) {
  //         print('Error deleting old photo: $e');
  //       }
  //     }
  //
  //     accommodation.update({
  //       'title': titleController.text,
  //       'country': countryController.text,
  //       'city': cityController.text,
  //       'street': streetController.text,
  //       'description': descriptionController.text,
  //       'address': addressController.text,
  //       'price_per_night': int.parse(price_per_nightController.text),
  //       'bed': int.parse(bedController.text),
  //       'bathroom': int.parse(bathroomController.text),
  //       'bedroom': int.parse(bedroomController.text),
  //       'number_max_people': int.parse(number_max_peopleController.text),
  //       'host_id': FirebaseAuth.instance.currentUser!.uid,
  //       'photo': imageURL.toString(),
  //       'kitchen': kitchen ? true : false,
  //       'wifi': wifi ? true : false,
  //       'tv': tv ? true : false,
  //       'air_conditioning': air_conditioning ? true : false,
  //       'photoUrl': updatedPhotoUrls,
  //     }).then((value) => print("DocumentSnapshot successfully updated!"),
  //         onError: (e) => print("Error updating document $e"));
  //   }
  // }


  Future<void> updateAccommodation(id, PickedFile) async {
    var user = await FirebaseAuth.instance.currentUser!;
    var uid = user.uid;

    if (_photo == null) {
      final db = FirebaseFirestore.instance;
      final accommodation = db.collection("Accommodations").doc(id);

      List<String> updatedPhotoUrls = [];

      for (var photo in photos) {
        String uuid = Uuid().v4();
        String uniqueFileName = '$uid/$uuid.jpg';
        final destination = uniqueFileName;

        try {
          final ref = firebase_storage.FirebaseStorage.instance
              .ref(destination)
              .child('');
          await ref.putFile(photo);
          String photoUrl = ("gs://nomady-ae4b6.appspot.com/" +
              destination.toString())
              .toString();
          updatedPhotoUrls.add(photoUrl);
        } catch (e) {
          print('Error occurred');
        }
      }

      // Delete old photos from Firebase Storage and Firestore
      for (var oldPhotoUrl in photoUrls) {
        try {
          await firebase_storage.FirebaseStorage.instance
              .refFromURL(oldPhotoUrl)
              .delete();
          print("Old photo successfully deleted: $oldPhotoUrl");

          // Remove old photo URL from Firestore
          updatedPhotoUrls.remove(oldPhotoUrl);
        } catch (e) {
          print('Error deleting old photo: $e');
        }
      }

      accommodation.update({
        'title': titleController.text,
        'country': countryController.text,
        'city': cityController.text,
        'street': streetController.text,
        'description': descriptionController.text,
        'address': addressController.text,
        'price_per_night': int.parse(price_per_nightController.text),
        'bed': int.parse(bedController.text),
        'bathroom': int.parse(bathroomController.text),
        'bedroom': int.parse(bedroomController.text),
        'number_max_people': int.parse(number_max_peopleController.text),
        'host_id': FirebaseAuth.instance.currentUser!.uid,
        'photo': imageOld.toString(),
        'kitchen': kitchen ? true : false,
        'wifi': wifi ? true : false,
        'tv': tv ? true : false,
        'air_conditioning': air_conditioning ? true : false,
        'photoUrl': updatedPhotoUrls,
      }).then((value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
    } else {
      final db = FirebaseFirestore.instance;
      final accommodation = db.collection("Accommodations").doc(id);

      FirebaseStorage.instance.refFromURL(imageOld).delete().then((_) {
        print("Image successfully deleted!");
      }).catchError((error) {
        print("Error removing image: $error");
      });

      String uuid = Uuid().v4();
      String uniqueFileName = '$uid/$uuid.jpg';
      final destination = uniqueFileName;

      try {
        final ref = firebase_storage.FirebaseStorage.instance
            .ref(destination)
            .child('');
        await ref.putFile(_photo!);
        imageURL = ("gs://nomady-ae4b6.appspot.com/" + destination.toString())
            .toString();
      } catch (e) {
        print('Error occurred');
      }

      List<String> updatedPhotoUrls = [];

      for (var photo in photos) {
        String uuid = Uuid().v4();
        String uniqueFileName = '$uid/$uuid.jpg';
        final destination = uniqueFileName;

        try {
          final ref =
          firebase_storage.FirebaseStorage.instance.ref(destination);
          await ref.putFile(photo);
          String photoUrl = await ref.getDownloadURL();
          updatedPhotoUrls.add(photoUrl);
        } catch (e) {
          print('Error uploading photo: $e');
        }
      }

// Delete old photos from Firebase Storage and Firestore
      for (var oldPhotoUrl in photoUrls) {
        try {
          await firebase_storage.FirebaseStorage.instance
              .refFromURL(oldPhotoUrl)
              .delete();
          print("Old photo successfully deleted: $oldPhotoUrl");

          // Remove old photo URL from Firestore
          updatedPhotoUrls.remove(oldPhotoUrl);
        } catch (e) {
          print('Error deleting old photo: $e');
        }
      }

      accommodation.update({
        'title': titleController.text,
        'country': countryController.text,
        'city': cityController.text,
        'street': streetController.text,
        'description': descriptionController.text,
        'address': addressController.text,
        'price_per_night': int.parse(price_per_nightController.text),
        'bed': int.parse(bedController.text),
        'bathroom': int.parse(bathroomController.text),
        'bedroom': int.parse(bedroomController.text),
        'number_max_people': int.parse(number_max_peopleController.text),
        'host_id': FirebaseAuth.instance.currentUser!.uid,
        'photo': imageURL.toString(),
        'kitchen': kitchen ? true : false,
        'wifi': wifi ? true : false,
        'tv': tv ? true : false,
        'air_conditioning': air_conditioning ? true : false,
        'photoUrl': updatedPhotoUrls,
      }).then((value) => print("DocumentSnapshot successfully updated!"),
          onError: (e) => print("Error updating document $e"));
    }
  }


      @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Update Accommodation',
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              textStyle: TextStyle(
                  fontSize: 20.0,
                  height: 1.2,
                  color: Colors.black,
                  fontWeight: FontWeight.w700)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarTextStyle: TextTheme(
          subtitle1: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ).bodyText2,
        titleTextStyle: TextTheme(
          subtitle1: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ).headline6,
      ),
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 10, right: 20, left: 20),
                  child: GestureDetector(
                    onTap: () {
                      _showPicker1(context);
                    },
                    child: Container(
                      width: size.width,
                      height: size.height * 0.31,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 249, 250, 250),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: Color.fromARGB(255, 217, 217, 217),
                          width: 0.5,
                        ),
                      ),
                      child: _photo != null
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: Image.file(
                                _photo!,
                                width: size.width,
                                height: size.height * 0.31,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : _photoUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  child: Image.network(
                                    _photoUrl,
                                    fit: BoxFit.cover,
                                  ))
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 249, 250, 250),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10)),
                                    border: Border.all(
                                      color: Color.fromARGB(255, 217, 217, 217),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey[800],
                                      ),
                                    ],
                                  ),
                                ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _showPicker(context);
                  },
                  child: Container(
                    width: size.width,
                    height: size.height * 0.22,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ...photos.asMap().entries.map(
                                (entry) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: Image.file(
                                      entry.value,
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        iconSize: 15,
                                        icon: Icon(Icons.close),
                                        color: Colors.grey[800],
                                        onPressed: () {
                                          setState(() {
                                            photos.removeAt(entry.key);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          ...photoUrls.asMap().entries.map(
                                (entry) => Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.all(Radius.circular(10)),
                                    child: Image.network(
                                      entry.value,
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: Container(
                                      width: 30,
                                      height: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: IconButton(
                                        iconSize: 15,
                                        icon: Icon(Icons.close),
                                        color: Colors.grey[800],
                                        onPressed: () {
                                          setState(() {
                                            photoUrls.removeAt(entry.key);
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // GestureDetector(
                //   onTap: () {
                //     _showPicker(context);
                //   },
                //   child: Container(
                //     width: size.width,
                //     height: size.height * 0.22,
                //     child: SingleChildScrollView(
                //       scrollDirection: Axis.horizontal,
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           ...photos.asMap().entries.map(
                //                 (entry) => Padding(
                //                   padding: const EdgeInsets.all(4.0),
                //                   child: Stack(
                //                     children: [
                //                       ClipRRect(
                //                         borderRadius: BorderRadius.all(
                //                             Radius.circular(10)),
                //                         child: Image.file(
                //                           entry.value,
                //                           width: 160,
                //                           height: 160,
                //                           fit: BoxFit.cover,
                //                         ),
                //                       ),
                //                       Positioned(
                //                         top: 5,
                //                         right: 5,
                //                         child: Container(
                //                           width: 30,
                //                           height: 30,
                //                           decoration: BoxDecoration(
                //                             color: Colors.white,
                //                             shape: BoxShape.circle,
                //                           ),
                //                           child: IconButton(
                //                             iconSize: 15,
                //                             icon: Icon(Icons.close),
                //                             color: Colors.grey[800],
                //                             onPressed: () {
                //                               setState(() {
                //                                 photos.removeAt(entry.key);
                //                               });
                //                             },
                //                           ),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //           ...photoUrls.asMap().entries.map(
                //                 (entry) => Padding(
                //                   padding: const EdgeInsets.all(4.0),
                //                   child: Stack(
                //                     children: [
                //                       ClipRRect(
                //                         borderRadius: BorderRadius.all(
                //                             Radius.circular(10)),
                //                         child: Image.network(
                //                           entry.value,
                //                           width: 160,
                //                           height: 160,
                //                           fit: BoxFit.cover,
                //                         ),
                //                       ),
                //                       Positioned(
                //                         top: 5,
                //                         right: 5,
                //                         child: Container(
                //                           width: 30,
                //                           height: 30,
                //                           decoration: BoxDecoration(
                //                             color: Colors.white,
                //                             shape: BoxShape.circle,
                //                           ),
                //                           child: IconButton(
                //                             iconSize: 15,
                //                             icon: Icon(Icons.close),
                //                             color: Colors.grey[800],
                //                             onPressed: () {
                //                               setState(() {
                //                                 photoUrls.removeAt(entry.key);
                //                               });
                //                             },
                //                           ),
                //                         ),
                //                       ),
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Click to edit photo",
                      style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                              fontSize: 14.0,
                              height: 1.2,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Basic Information:",
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 20.0,
                                height: 1.2,
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: titleController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 217, 217, 217)),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 249, 250, 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: descriptionController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 217, 217, 217)),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 249, 250, 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: streetController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Street',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 217, 217, 217)),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 249, 250, 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: addressController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 217, 217, 217)),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 249, 250, 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: cityController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 217, 217, 217)),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 249, 250, 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: countryController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                          width: 1,
                          color: Color.fromARGB(255, 217, 217, 217),
                        ),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 249, 250, 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: price_per_nightController,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Price per night',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 217, 217, 217)),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 249, 250, 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: number_max_peopleController,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Number max People',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 217, 217, 217)),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 249, 250, 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: bedController,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Amount Bed',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 217, 217, 217)),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 249, 250, 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: bedroomController,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Amount Bedroom',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 217, 217, 217)),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 249, 250, 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: bathroomController,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Amount Bathroom',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(
                            width: 1,
                            color: Color.fromARGB(255, 217, 217, 217)),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 249, 250, 250),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Other:",
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                                fontSize: 20.0,
                                height: 1.2,
                                color: Colors.black,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: CheckboxListTile(
                    title: Text("Kitchen",
                        style: TextStyle(
                            fontSize: 16.0,
                            height: 1.2,
                            color: Colors.black,
                            fontWeight: FontWeight.w300)),
                    value: kitchen,
                    onChanged: (bool? value) {
                      setState(() {
                        kitchen = value!;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: CheckboxListTile(
                    title: Text("Wifi",
                        style: TextStyle(
                            fontSize: 16.0,
                            height: 1.2,
                            color: Colors.black,
                            fontWeight: FontWeight.w300)),
                    value: wifi,
                    onChanged: (bool? value) {
                      setState(() {
                        wifi = value!;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: CheckboxListTile(
                    title: Text("TV",
                        style: TextStyle(
                            fontSize: 16.0,
                            height: 1.2,
                            color: Colors.black,
                            fontWeight: FontWeight.w300)),
                    value: tv,
                    onChanged: (bool? value) {
                      setState(() {
                        tv = value!;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: CheckboxListTile(
                    title: Text("Air Conditioning",
                        style: TextStyle(
                            fontSize: 16.0,
                            height: 1.2,
                            color: Colors.black,
                            fontWeight: FontWeight.w300)),
                    value: air_conditioning,
                    onChanged: (bool? value) {
                      setState(() {
                        air_conditioning = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor:
                            const Color.fromARGB(255, 50, 134, 252)),
                    onPressed: () {
                      updateAccommodation(widget.id, pickedFile);
                    },
                    icon: const Icon(Icons.lock_open, size: 0),
                    label: const Text('Update Accommodation',
                        style: TextStyle(fontSize: 20)),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
