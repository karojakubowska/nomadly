import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Travel.dart';
import 'package:nomadly_app/utils/app_styles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:uuid/uuid.dart';

class UpdateTravelView extends StatefulWidget {
  final DocumentSnapshot? travel;
  final String id;

  const UpdateTravelView({Key? key, this.travel, required this.id})
      : super(key: key);

  @override
  State<UpdateTravelView> createState() => _UpdateTravelViewState();
}

class _UpdateTravelViewState extends State<UpdateTravelView> {
  final nameController = TextEditingController();
  final destinationController = TextEditingController();
  final budgetController = TextEditingController();
  final number_of_peopleController = TextEditingController();
  final noteController = TextEditingController();

  CollectionReference travel = FirebaseFirestore.instance.collection('Travel');

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  late String pickedFile = "";

  var imageURL = "";
  late String imageOld=" ";
  late DateTime startDate;
  late DateTime endDate;

  void initState() {
    super.initState();
    nameController.text = (widget.travel!.get("name"));
    destinationController.text = (widget.travel!.get("destination"));
    noteController.text = (widget.travel!.get("note"));
    budgetController.text = (widget.travel!.get("budget").toString());
    number_of_peopleController.text =
    (widget.travel!.get("number_of_people").toString());
    imageOld = (widget.travel!.get("photo"));
    startDate = (widget.travel!.get("start_date") as Timestamp).toDate();
    endDate = (widget.travel!.get("end_date") as Timestamp).toDate();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDate ?? DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    }
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
  //
  // Future uploadFile(pickedFile, String oldImagePath) async {
  //   var user = await FirebaseAuth.instance.currentUser!;
  //   var uid = user.uid;
  //   if (pickedFile == null) return;
  //   final fileName = basename(pickedFile);
  //   final destination = '$uid/$fileName';
  //
  //   if (oldImagePath.isNotEmpty) {
  //     await firebase_storage.FirebaseStorage.instance.ref(oldImagePath).delete();
  //   }
  //
  //   try {
  //     final ref = firebase_storage.FirebaseStorage.instance.ref(destination).child('');
  //     await ref.putFile(File(pickedFile));
  //   } catch (e) {
  //     print('error occurred');
  //   }
  // }
  // Future uploadFile(File imageFile, String oldImagePath) async {
  //   var user = await FirebaseAuth.instance.currentUser!;
  //   var uid = user.uid;
  //   if (imageFile == null) return;
  //   final fileName = basename(imageFile.path);
  //   final destination = '$uid/$fileName';
  //
  //   if (oldImagePath.isNotEmpty) {
  //     await firebase_storage.FirebaseStorage.instance.ref(oldImagePath).delete();
  //   }
  //
  //   try {
  //     final ref = firebase_storage.FirebaseStorage.instance.ref(destination).child('');
  //     await ref.putFile(imageFile);
  //     return destination;
  //   } catch (e) {
  //     print('error occurred');
  //     return null;
  //   }
  // }
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

  //get id => String id;

  // Future<void> updateTravel(id, String oldImagePath) async {
  //   final db = FirebaseFirestore.instance;
  //   final travel = db.collection("Travel").doc(id);
  //   travel.update({
  //     "name": nameController.text,
  //     "destination": destinationController.text,
  //     "budget": int.parse(budgetController.text),
  //     "number_of_people": int.parse(number_of_peopleController.text),
  //     "note": noteController.text,
  //     'start_date': startDate,
  //     'end_date': endDate,
  //   }).then((value) => print("DocumentSnapshot successfully updated!"),
  //       onError: (e) => print("Error updating document $e"));
  //   print(id);
  //   if (_photo != null) {
  //     pickedFile = _photo!.path;
  //     await uploadFile(pickedFile, oldImagePath);
  //   }
  // }

  // Future<void> updateTravel(id, String oldImagePath) async {
  //   final db = FirebaseFirestore.instance;
  //   final travel = db.collection("Travel").doc(id);
  //   String? newImagePath;
  //
  //   if (_photo != null) {
  //     newImagePath = await uploadFile(_photo!, oldImagePath);
  //   }
  //
  //   Map<String, dynamic> dataToUpdate = {
  //     "name": nameController.text,
  //     "destination": destinationController.text,
  //     "budget": int.parse(budgetController.text),
  //     "number_of_people": int.parse(number_of_peopleController.text),
  //     "note": noteController.text,
  //     'start_date': startDate,
  //     'end_date': endDate,
  //   };
  //
  //   if (newImagePath != null) {
  //     dataToUpdate['photo'] = newImagePath;
  //   }
  //
  //   travel.update(dataToUpdate).then(
  //           (value) => print("DocumentSnapshot successfully updated!"),
  //       onError: (e) => print("Error updating document $e"));
  //   print(id);
  // }

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

  Future<void> updateTravel(id, PickedFile) async {
    var user = await FirebaseAuth.instance.currentUser!;
    var uid = user.uid;
    if (_photo == null) return;

    FirebaseStorage.instance.refFromURL(imageOld).delete().then((_) {
      print("Image successfully deleted!");
    }).catchError((error) {
      print("Error removing image: $error");
    });
    String uuid = Uuid().v4();
    String uniqueFileName = '$uid/$uuid.jpg';
    final destination = uniqueFileName;

    try {
      final ref = firebase_storage.FirebaseStorage.instance.ref(destination).child('');
      await ref.putFile(_photo!);
      imageURL = ("gs://nomady-ae4b6.appspot.com/"+destination.toString()).toString();
    } catch (e) {
      print('error occurred');
    }

    final db = FirebaseFirestore.instance;
    final travel = db.collection("Travel").doc(id);
    travel.update({
      "name": nameController.text,
      "destination": destinationController.text,
      "budget": int.parse(budgetController.text),
      "number_of_people": int.parse(number_of_peopleController.text),
      "note": noteController.text,
      'start_date': startDate,
      'end_date': endDate,
      'photo': imageURL.toString(),
    }).then((value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  // Future<void> updateTravel(id, PickedFile) async {
  //   var user = await FirebaseAuth.instance.currentUser!;
  //   var uid = user.uid;
  //   if (_photo == null) return;
  //
  //   String uuid = Uuid().v4();
  //   String uniqueFileName = '$uid/$uuid.jpg';
  //   final destination = uniqueFileName;
  //
  //   final db = FirebaseFirestore.instance;
  //   final travel = db.collection("Travel").doc(id);
  //
  //   // pobranie starej ścieżki zdjęcia
  //   final document = await travel.get();
  //   final oldImagePath = document['photo'];
  //
  //   // usunięcie starego zdjęcia
  //   if (oldImagePath.isNotEmpty) {
  //     await firebase_storage.FirebaseStorage.instance.ref(oldImagePath).delete();
  //   }
  //
  //   try {
  //     final ref = firebase_storage.FirebaseStorage.instance.ref(destination).child('');
  //     await ref.putFile(_photo!);
  //     imageURL = ("gs://nomady-ae4b6.appspot.com/"+destination.toString()).toString();
  //   } catch (e) {
  //     print('error occurred');
  //   }
  //
  //   travel.update({
  //     "name": nameController.text,
  //     "destination": destinationController.text,
  //     "budget": int.parse(budgetController.text),
  //     "number_of_people": int.parse(number_of_peopleController.text),
  //     "note": noteController.text,
  //     'start_date': startDate,
  //     'end_date': endDate,
  //     'photo': imageURL.toString(),
  //   }).then((value) => print("DocumentSnapshot successfully updated!"),
  //       onError: (e) => print("Error updating document $e"));
  // }


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
          'Update Travel',
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
      body: ListView(children: [
        SingleChildScrollView(
          child: Column(children: <Widget>[
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
                    borderRadius: BorderRadius.all(Radius.circular(10)),
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
                      borderRadius: BorderRadius.all(Radius.circular(10)),
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
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  width: 1,
                                  color:
                                  Color.fromARGB(255, 217, 217, 217)),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 249, 250, 250),
                            labelText: 'Start Date',
                            hintText: 'Please select a start date',
                          ),
                          readOnly: true,
                          onTap: () => _selectStartDate(context),
                          controller: TextEditingController(
                            text: startDate == null
                                ? ''
                                : DateFormat('dd-MM-yyyy')
                                .format(startDate),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        child: TextField(
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(
                                  width: 1,
                                  color:
                                  Color.fromARGB(255, 217, 217, 217)),
                            ),
                            filled: true,
                            fillColor: Color.fromARGB(255, 249, 250, 250),
                            labelText: 'End Date',
                            hintText: 'Please select an end date',
                          ),
                          readOnly: true,
                          onTap: () => _selectEndDate(context),
                          controller: TextEditingController(
                            text: endDate == null
                                ? ''
                                : DateFormat('dd-MM-yyyy').format(endDate),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: number_of_peopleController,
                cursorColor: Colors.white,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Number of People',
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
                controller: noteController,
                cursorColor: Colors.white,
                maxLines: 5,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Note',
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
                  updateTravel(widget.id, pickedFile);
                },
                icon: const Icon(Icons.lock_open, size: 0),
                label:
                    const Text('Update Travel', style: TextStyle(fontSize: 20)),
              ),
            )
          ]))
        ]));
  }
}
