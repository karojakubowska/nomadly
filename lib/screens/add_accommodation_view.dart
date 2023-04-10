import 'package:firebase_auth/firebase_auth.dart';
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

class AddAccommodationScreen extends StatefulWidget {

  const AddAccommodationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddAccommodationScreen> createState() => _AddAccommodationScreenState();
}

class _AddAccommodationScreenState extends State<AddAccommodationScreen> {
  final titleController = TextEditingController();
  final cityController = TextEditingController();
  final streetController = TextEditingController();
  final countryController = TextEditingController();
  final descriptionController = TextEditingController();
  final price_per_nightController = TextEditingController();
  // final boolController = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  final pickedFile = "";

  var imageURL = "";

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

  void _showPicker(context) {
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

  CollectionReference accommodation = FirebaseFirestore.instance.collection('Accommodations');

  Future<void> addAccommodation(BuildContext context, pickedFile) async {
    if (titleController.text.isEmpty ||
        countryController.text.isEmpty ||
        cityController.text.isEmpty ||
        streetController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        price_per_nightController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    var user = await FirebaseAuth.instance.currentUser!;
    var uid = user.uid;
    if (_photo == null) return;

    String dateTime = DateTime.now().toString();
    String uuid = Uuid().v4();
    String uniqueFileName = '$uid/$dateTime-$uuid.jpg';

    //final fileName = basename(_photo!.path);
    final destination = uniqueFileName;

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination).child('');
      await ref.putFile(_photo!);
      imageURL = ("gs://nomady-ae4b6.appspot.com/" + destination.toString()).toString();
    } catch (e) {
      print('error occured');
    }
    ;
    return accommodation.add({
      'title': titleController.text,
      'country': countryController.text,
      'city': cityController.text,
      'street': streetController.text,
      'description': descriptionController.text,
      'price_per_night': int.parse(price_per_nightController.text),
      'host_id': FirebaseAuth.instance.currentUser!.uid,
      'rate': 0.0,
      'photo': imageURL.toString(),
    }).then((value) {
      print("DocumentSnapshot successfully updated!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('New accommodation added')),
      );
    }, onError: (e) {
      print("Error updating document $e");
    });
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Add Accommodation',
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
        textTheme: TextTheme(
          subtitle1: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 0.0),
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Container(
                      width: 150,
                      height: 150,
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
                          width: 50,
                          height: 50,
                          fit: BoxFit.fitHeight,
                        ),
                      )
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
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
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
                  height: 10,
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
                // const SizedBox(height: 10),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 20),
                //   child: CheckboxListTile(
                //     title: const Text('Value'),
                //     value: boolController.text == 'true',
                //     onChanged: (bool? value) {
                //       setState(() {
                //         boolController.text = value.toString();
                //       });
                //     },
                //     controlAffinity: ListTileControlAffinity.leading,
                //   ),
                // ),
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
                      addAccommodation(context,pickedFile);
                    },
                    icon: const Icon(Icons.lock_open, size: 0),
                    label: const Text('Add Accommodation',
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


