import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/utils/app_layout.dart';
import 'package:nomadly_app/utils/app_styles.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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
  final noteController = TextEditingController();
  final budgetController = TextEditingController();
  final number_of_peopleController = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  final pickedFile = "";

  var imageURL = "";

  late DateTime startDate;
  late DateTime endDate;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('Please select a start date'))),
      );
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: endDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('Please select an end date'))),
      );
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
                const SizedBox(height: 8.0),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: Text(tr('Gallery')),
                  onTap: () {
                    imgFromGallery(pickedFile);
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: Text(tr('Camera')),
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

  Future<void> addTravel(BuildContext context, pickedFile) async {
    if (nameController.text.isEmpty ||
        noteController.text.isEmpty ||
        destinationController.text.isEmpty ||
        budgetController.text.isEmpty ||
        startDate == null ||
        endDate == null ||
        number_of_peopleController.text.isEmpty ||
        _photo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('All fields are required'))),
      );
      return;
    }

    var user = await FirebaseAuth.instance.currentUser!;
    var uid = user.uid;
    if (_photo == null) return;

    String uuid = const Uuid().v4();
    String uniqueFileName = '$uid/$uuid.jpg';
    final destination = uniqueFileName;

    try {
      final ref =
          firebase_storage.FirebaseStorage.instance.ref(destination).child('');
      await ref.putFile(_photo!);
      imageURL = ("gs://nomady-ae4b6.appspot.com/" + destination.toString())
          .toString();
    } catch (e) {
      print('error occured');
    };
    return travel.add({
      'name': nameController.text,
      'note': noteController.text,
      'destination': destinationController.text,
      'budget': int.parse(budgetController.text),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'photo': imageURL.toString(),
      'start_date': startDate,
      'end_date': endDate,
      'number_of_people': int.parse(number_of_peopleController.text),
    }).then((value) {
      print("DocumentSnapshot successfully updated!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('New travel added'))),
      );
    }, onError: (e) {
      print("Error updating document $e");
    });
  }

  @override
  void initState() {
    super.initState();
    startDate = DateTime.now();
    endDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final size = AppLayout.getSize(context);
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          color: Colors.black,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
        title: Text(
          tr('Add Travel'),
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontSize: 20.0,
                  height: 1.2,
                  color: Colors.black,
                  fontWeight: FontWeight.w700)),
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        toolbarTextStyle: const TextTheme(
          titleMedium: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ).bodyText2,
        titleTextStyle: const TextTheme(
          titleMedium: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ).headline6,
      ),
      body: ListView(
        children: [
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10, right: 20, left: 20),
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Container(
                      width: size.width,
                      height: size.height * 0.22,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 249, 250, 250),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: const Color.fromARGB(255, 217, 217, 217),
                          width: 0.5,
                        ),
                      ),
                      child: _photo != null
                          ? ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: Image.file(
                                _photo!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 249, 250, 250),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 217, 217, 217),
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
                    controller: nameController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: tr('Name'),
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
                    controller: destinationController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: tr('Destination'),
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
                    controller: budgetController,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: tr('Budget'),
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
                  child: Column(children: [
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: TextField(
                              decoration:  InputDecoration(
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
                                labelText: tr('Start Date'),
                                hintText: tr('Please select a start date'),
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
                                labelText: tr('End Date'),
                                hintText: tr('Please select an end date'),
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
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: number_of_peopleController,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: tr('Number of people'),
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
                    controller: noteController,
                    cursorColor: Colors.white,
                    maxLines: 5,
                    textInputAction: TextInputAction.next,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      labelText: tr('Note'),
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
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor:
                            const Color.fromARGB(255, 50, 134, 252)),
                    onPressed: () {
                      addTravel(context, pickedFile);
                    },
                    icon: const Icon(Icons.lock_open, size: 0),
                    label: Text(tr('Add Travel'),
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
