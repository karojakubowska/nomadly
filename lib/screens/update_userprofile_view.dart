import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nomadly_app/utils/app_styles.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:uuid/uuid.dart';

class EditProfilePage extends StatefulWidget {
  final String id;
  final String image;

  const EditProfilePage({super.key, required this.id, required this.image});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  CollectionReference user = FirebaseFirestore.instance.collection('Users');

  File? _photo;
  final ImagePicker _picker = ImagePicker();
  final pickedFile = "";

  var imageURL = "";
  late String imageOld = " ";
  String _photoUrl = "";

  late Stream<DocumentSnapshot> userStream;
  late String accountImage;

  final nameController = TextEditingController();
  final emailController = TextEditingController();

  void _updateUserProfile() async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        await currentUser.updateDisplayName(nameController.text);
        await currentUser.updateEmail(emailController.text);

        final uid = FirebaseAuth.instance.currentUser!.uid;
        var db = FirebaseFirestore.instance;
        db.collection("Users").doc(uid).update({
          'Name': nameController.text,
          'Email': emailController.text,
        });

        nameController.text = currentUser.displayName ?? '';
        emailController.text = currentUser.email ?? '';
      } catch (e) {
        print('Error updating user profile: $e');
      }
    }
  }

  @override
  void initState() {
    super.initState();

    final currentUser = FirebaseAuth.instance.currentUser;
    var db = FirebaseFirestore.instance;
    db.collection("Users").doc(currentUser?.uid).get().then((doc) {
      if (doc.exists) {
        nameController.text = doc['Name'];
        emailController.text = doc['Email'];
      }
    });
    userStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .snapshots();

    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.refFromURL(widget.image);
    ref.getDownloadURL().then((value) {
      setState(() {
        _photoUrl = value;
      });
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

  Future<void> updateImage(id, PickedFile) async {
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
      print('error occurred');
    }

    final db = FirebaseFirestore.instance;
    final users = db.collection("Users").doc(id);
    users.update({
      'AccountImage': imageURL.toString(),
    }).then((value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
  }

  @override
  Widget build(BuildContext context) {
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
            'Edit Profile',
            textAlign: TextAlign.center,
            style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                    fontSize: 20.0,
                    height: 1.2,
                    color: Colors.black,
                    fontWeight: FontWeight.w700)),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                  child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  //padding: EdgeInsets.all(15.0),
                  child: GestureDetector(
                    onTap: () {
                      _showPicker(context);
                    },
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 249, 250, 250),
                        borderRadius: const BorderRadius.all(Radius.circular(100)),
                        border: Border.all(
                          color: const Color.fromARGB(255, 217, 217, 217),
                          width: 0.5,
                        ),
                      ),
                      child: _photo != null
                          ? ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(100)),
                              child: Image.file(
                                _photo!,
                                width: 150,
                                height: 150,
                                fit: BoxFit.fitHeight,
                              ),
                            )
                          : _photoUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius:
                                      const BorderRadius.all(Radius.circular(100)),
                                  child: Image.network(
                                    _photoUrl,
                                    fit: BoxFit.cover,
                                  ))
                              : Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(255, 249, 250, 250),
                                    borderRadius:
                                        const BorderRadius.all(Radius.circular(100)),
                                    border: Border.all(
                                      color: const Color.fromARGB(255, 217, 217, 217),
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
                const SizedBox(
                  height: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Click to edit photo",
                      style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                              fontSize: 14.0,
                              height: 1.2,
                              color: Colors.grey,
                              fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 120.0),
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(45),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        backgroundColor:
                            const Color.fromARGB(255, 50, 134, 252)),
                    onPressed: () {
                      updateImage(widget.id, pickedFile);
                    },
                    icon: const Icon(Icons.lock_open, size: 0),
                    label: const Text('Save Image',
                        style: TextStyle(
                            fontSize: 18.0,
                            height: 1.2,
                            color: Colors.white,
                            fontWeight: FontWeight.w500)),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: StreamBuilder<DocumentSnapshot>(
                        stream: userStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          final userDoc = snapshot.data!;
                          final accountImage = userDoc.get('AccountImage');
                          return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextField(
                                    controller: nameController,
                                    cursorColor: Colors.white,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      labelText: 'Name',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color.fromARGB(
                                                255, 217, 217, 217)),
                                      ),
                                      filled: true,
                                      fillColor:
                                          Color.fromARGB(255, 249, 250, 250),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  child: TextField(
                                    controller: emailController,
                                    cursorColor: Colors.white,
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      labelText: 'Email',
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10.0)),
                                        borderSide: BorderSide(
                                            width: 1,
                                            color: Color.fromARGB(
                                                255, 217, 217, 217)),
                                      ),
                                      filled: true,
                                      fillColor:
                                          Color.fromARGB(255, 249, 250, 250),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      backgroundColor: const Color.fromARGB(
                                          255, 50, 134, 252),
                                    ),
                                    onPressed: _updateUserProfile,
                                    child: const Text('Save',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            height: 1.2,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500)),
                                  ),
                                )
                              ]);
                        }))
              ]))
            ]));
  }
}
