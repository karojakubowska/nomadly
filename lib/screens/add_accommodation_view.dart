import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Date.dart';
import 'package:nomadly_app/utils/app_styles.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

import '../utils/app_layout.dart';

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
  final bedController = TextEditingController();
  final bathroomController = TextEditingController();
  final bedroomController = TextEditingController();
  final addressController = TextEditingController();
  final number_max_peopleController = TextEditingController();
  bool kitchen = false;
  bool wifi = false;
  bool tv = false;
  bool air_conditioning = false;
  String? _selectedType;

  final List<String> _types = [
    "Apartament",
    "Villa",
    "Hotel",
    "Hostel",
    "Cabin",
    "Bungalow",
    "Room"
  ];

  // final boolController = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  final pickedFile = "";

  List<File> photos = [];
  final ImagePicker _imagePicker = ImagePicker();

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

  void _showPicker1(context) {
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

  Future<void> _showPicker(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr('Choose photo:')),
          actions: [
            TextButton(
              child: Text(tr('Gallery')),
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
              child: Text(tr('Camera')),
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

  CollectionReference accommodation =
      FirebaseFirestore.instance.collection('Accommodations');

  Future<void> addAccommodation(BuildContext context, pickedFile) async {
    if (titleController.text.isEmpty ||
        countryController.text.isEmpty ||
        cityController.text.isEmpty ||
        streetController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        price_per_nightController.text.isEmpty ||
        bedController.text.isEmpty ||
        bedroomController.text.isEmpty ||
        addressController.text.isEmpty ||
        number_max_peopleController.text.isEmpty ||
        bathroomController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    var user = await FirebaseAuth.instance.currentUser!;
    var uid = user.uid;
    if (_photo == null) return;

    String dateTime = DateTime.now().toString();
    String uuid = const Uuid().v4();
    String uniqueFileName = '$uid/$dateTime-$uuid.jpg';

    //final fileName = basename(_photo!.path);
    final destination = uniqueFileName;

    try {
      final ref =
          firebase_storage.FirebaseStorage.instance.ref(destination).child('');
      await ref.putFile(_photo!);
      imageURL = ("gs://nomady-ae4b6.appspot.com/" + destination.toString())
          .toString();
    } catch (e) {
      print('error occured');
    }
    ;
    List<BookDate>bookedDates=[BookDate(date: DateTime.now().add(Duration(days:-32)),hour:"14"),BookDate(date: DateTime.now().add(Duration(days:-31)),hour:"11")];
    List<String> otherPhotoURLs = [];
    for (var photo in photos) {
      String otherPhotoDateTime = DateTime.now().toString();
      String otherPhotoUuid = Uuid().v4();
      String otherPhotoUniqueFileName =
          '$uid/$otherPhotoDateTime-$otherPhotoUuid.jpg';

      final otherPhotoDestination = otherPhotoUniqueFileName;
      try {
        final otherPhotoRef = firebase_storage.FirebaseStorage.instance
            .ref(otherPhotoDestination)
            .child('');
        await otherPhotoRef.putFile(photo);
        String otherPhotoURL = ("gs://nomady-ae4b6.appspot.com/" +
                otherPhotoDestination.toString())
            .toString();
        otherPhotoURLs.add(otherPhotoURL);
      } catch (e) {
        print('error occurred');
      }
    }
    return accommodation.add({
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
      'rate': 0.0,
      'reviews': 0,
      'photo': imageURL.toString(),
      'photoUrl': otherPhotoURLs,
      'kitchen': kitchen ? true : false,
      'wifi': wifi ? true : false,
      'tv': tv ? true : false,
      'air_conditioning': air_conditioning ? true : false,
      'type': _selectedType,
      'reservations_count':0,
      'booked_dates':bookedDates,
    }).then((value) {
      print("DocumentSnapshot successfully updated!");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New accommodation added')),
      );
      setState(() {
        _photo = null;
        _selectedType = null;
      });
      titleController.clear();
      countryController.clear();
      cityController.clear();
      streetController.clear();
      descriptionController.clear();
      price_per_nightController.clear();
      addressController.clear();
      bedController.clear();
      bathroomController.clear();
      bedroomController.clear();
      number_max_peopleController.clear();
      kitchen = false;
      wifi = false;
      tv = false;
      air_conditioning = false;
      photos.clear();
    }, onError: (e) {
      print("Error updating document $e");
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale;
    final size = AppLayout.getSize(context);
    return Scaffold(
      backgroundColor: Styles.backgroundColor,
      appBar: AppBar(
        title: Text(
          tr('Add Accommodation'),
          textAlign: TextAlign.center,
          style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                  fontSize: 20.0,
                  height: 1.2,
                  color: Colors.black,
                  fontWeight: FontWeight.w700)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarTextStyle: const TextTheme(
          subtitle1: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ).bodyText2,
        titleTextStyle: const TextTheme(
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
                  padding:
                      const EdgeInsets.only(bottom: 10, right: 20, left: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: Container(
                      width: size.width,
                      height: size.height * 0.32,
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
                                width: size.width * 0.6,
                                height: size.height * 0.2,
                                fit: BoxFit.cover,
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
                                Icons.camera_alt_outlined,
                                color: Colors.grey[800],
                                size: 30,
                              ),
                            ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 0, right: 20, left: 20),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      primary: Color.fromARGB(255, 50, 134, 252),
                    ),
                    onPressed: () {
                      _showPicker1(context);
                    },
                    icon: Icon(Icons.camera_alt, size: 0),
                    label: Text(
                      tr('Add main photo'),
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, right: 20, left: 20),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          // _showPicker(context);
                        },
                        child: Container(
                          width: size.width,
                          height: size.height * 0.22,
                          child: photos.isNotEmpty
                              ? SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: List.generate(
                                      photos.length,
                                      (index) => Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              child: Image.file(
                                                photos[index],
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
                                                      photos.removeAt(index);
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: 160,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.camera_alt_outlined),
                                        color: Colors.grey[800],
                                        iconSize: 30,
                                        onPressed: () {},
                                      ),
                                    ),
                                    Container(
                                      width: 160,
                                      height: 160,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: IconButton(
                                        icon: Icon(Icons.add),
                                        iconSize: 30,
                                        color: Colors.grey[800],
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      SizedBox(height: 5),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          primary: Color.fromARGB(255, 50, 134, 252),
                        ),
                        onPressed: () {
                          _showPicker(context);
                        },
                        icon: Icon(Icons.camera_alt, size: 0),
                        label: Text(
                          tr('Add other photo'),
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
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
                        tr("Basic Information:"),
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
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
                    decoration: InputDecoration(
                      labelText: tr('Title'),
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
                    decoration: InputDecoration(
                      labelText: tr('Description'),
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
                    decoration: InputDecoration(
                      labelText: tr('Street'),
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
                    decoration: InputDecoration(
                      labelText: tr('Address'),
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
                    decoration: InputDecoration(
                      labelText: tr('City'),
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
                    decoration: InputDecoration(
                      labelText: tr('Country'),
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
                    decoration: InputDecoration(
                      labelText: tr('Price per night'),
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
                    decoration: InputDecoration(
                      labelText: tr('Number max People'),
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
                    decoration: InputDecoration(
                      labelText: tr('Amount Bed'),
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
                    decoration: InputDecoration(
                      labelText: tr('Amount Bedroom'),
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
                    decoration: InputDecoration(
                      labelText: tr('Amount Bathroom'),
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
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 249, 250, 250),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 1,
                        color: const Color.fromARGB(255, 217, 217, 217),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(5),
                      child: DropdownButton<String>(
                        value: _selectedType,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value;
                          });
                        },
                        hint: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            tr("Select the type of accommodation"),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        underline: Container(),
                        dropdownColor: Styles.backgroundColor,
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color.fromARGB(255, 57, 57, 57),
                        ),
                        isExpanded: true,
                        items: _types
                            .map(
                              (e) => DropdownMenuItem(
                            value: e,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(e),
                            ),
                          ),
                        )
                            .toList(),
                        selectedItemBuilder: (BuildContext context) => _types
                            .map(
                              (e) => Center(
                            child: Text(
                              e,
                              style: const TextStyle(
                                color: Color.fromARGB(255, 57, 57, 57),
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),
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
                        tr("Other:"),
                        style: GoogleFonts.roboto(
                            textStyle: const TextStyle(
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
                    title: Text(tr("Kitchen"),
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
                    title: Text(tr("Wifi"),
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
                    title: Text(tr("TV"),
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
                    title: Text(tr("Air Conditioning"),
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
                  padding: const EdgeInsets.all(15.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor:
                            const Color.fromARGB(255, 50, 134, 252)),
                    onPressed: () {
                      addAccommodation(context, pickedFile);
                    },
                    icon: const Icon(Icons.lock_open, size: 0),
                    label: Text(tr('Add Accommodation'),
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
