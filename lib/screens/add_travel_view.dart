import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Travel.dart';
import 'package:nomadly_app/utils/app_styles.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddTravelView extends StatefulWidget {
  const AddTravelView({
    Key? key,
  }) : super(key: key);

  @override
  State<AddTravelView> createState() => _AddTravelViewState();
}

class _AddTravelViewState extends State<AddTravelView> {
  final nameController = TextEditingController();
  final destinationController = TextEditingController();
  final budgetController = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  final pickedFile = "";

  var gowno = "";

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
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('');
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

  CollectionReference travel = FirebaseFirestore.instance.collection('Travel');

  Future<void> addTravel(pickedFile) async {
    var user = await FirebaseAuth.instance.currentUser!;
    var uid = user.uid;
    if (_photo == null) return;
    final fileName = basename(_photo!.path);
    final destination = '$uid/$fileName';

    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref(destination)
          .child('');
      await ref.putFile(_photo!);
      print("destination");
      print(destination);
      print("photo");
      print(_photo);
      //gowno = _photo.toString();
      gowno = ("gs://nomady-ae4b6.appspot.com/" + destination.toString()).toString();
    } catch (e) {
      print('error occured');
    };
    return travel
        .add({
      'name': nameController.text,
      'destination': destinationController.text,
      'budget': int.parse(budgetController.text),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'photo': gowno.toString(),
    })
        .then((value) => print("Add Travel"))
        .catchError((error) => print("Error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Styles.backgroundColor,
        appBar: AppBar(
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          title: Text(
            'Add Travel',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
                textStyle: TextStyle(
                    fontSize: 20.0,
                    height: 1.2,
                    color: Colors.black,
                    fontWeight: FontWeight.w700)),
          ),
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
        // body: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     const SizedBox(height: 50,),
        //     TextField(
        //       controller: nameController,
        //       cursorColor: Colors.white,
        //       textInputAction: TextInputAction.next,
        //       decoration: const InputDecoration(labelText: 'Name',
        //         enabledBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //           borderSide: BorderSide(width: 1,color: Color.fromARGB(255, 217, 217, 217)),
        //         ),
        //         filled: true,
        //         fillColor:  Color.fromARGB(255, 249, 250, 250),
        //       ),
        //     ),
        //     const SizedBox(height: 20,),
        //     TextField(
        //       controller: destinationController,
        //       cursorColor: Colors.white,
        //       textInputAction: TextInputAction.done,
        //       decoration: const InputDecoration(labelText: 'Destination',
        //         enabledBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //           borderSide: BorderSide(width: 1,color: Color.fromARGB(255, 217, 217, 217)),
        //         ),
        //         filled: true,
        //         fillColor: Color.fromARGB(255, 249, 250, 250),
        //       ),
        //     ),
        //     const SizedBox(height: 20,),
        //     TextField(
        //       controller: budgetController,
        //       cursorColor: Colors.white,
        //       textInputAction: TextInputAction.done,
        //       keyboardType: TextInputType.number,
        //       decoration: const InputDecoration(labelText: 'Budget',
        //           enabledBorder: OutlineInputBorder(
        //           borderRadius: BorderRadius.all(Radius.circular(10.0)),
        //           borderSide: BorderSide(width: 1,color: Color.fromARGB(255, 217, 217, 217)),
        //         ),
        //         filled: true,
        //         fillColor: Color.fromARGB(255, 249, 250, 250),
        //       ),
        //     ),
        //     const SizedBox(height: 20,),
        //     ElevatedButton.icon(style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(60),
        //         shape: RoundedRectangleBorder(
        //             borderRadius: BorderRadius.circular(10.0)),
        //         backgroundColor: const Color.fromARGB(255, 50, 134, 252)),
        //       onPressed: addTravel,
        //       icon: const Icon(Icons.lock_open, size: 0),
        //       label: const Text('Add Travel',
        //           style: TextStyle(fontSize: 20)),
        //     ),
        //   ],
        // )
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 50,
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
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: nameController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Name',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                      width: 1, color: Color.fromARGB(255, 217, 217, 217)),
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
              controller: destinationController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Destination',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                      width: 1, color: Color.fromARGB(255, 217, 217, 217)),
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
              controller: budgetController,
              cursorColor: Colors.white,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              decoration: const InputDecoration(
                labelText: 'Budget',
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(
                      width: 1, color: Color.fromARGB(255, 217, 217, 217)),
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
            padding: EdgeInsets.all(20.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  backgroundColor: const Color.fromARGB(255, 50, 134, 252)),
              onPressed: () {
                addTravel(pickedFile);
              },
              icon: const Icon(Icons.lock_open, size: 0),
              label: const Text('Add Travel', style: TextStyle(fontSize: 20)),
            ),
          ),
          // const SizedBox(
          //   height: 32,
          // ),
          // Center(
          //   child: ElevatedButton(
          //     onPressed: () {
          //       uploadFile(pickedFile);
          //     },
          //     child: Text('Upload'),
          //   ),
          // ),
        ]));
  }
}
