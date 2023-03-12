import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/utils/app_styles.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

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

    nameController.text = currentUser?.displayName ?? '';
    emailController.text = currentUser?.email ?? '';
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
            'Edit Profile',
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
          centerTitle: true,
        ),
        body: ListView(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                  child: Column(children: <Widget>[
                SizedBox(height: 24),
                CircleAvatar(
                  radius: 80,
                  //backgroundImage: AssetImage('assets/profile_pic.jpg'),
                ),
                SizedBox(height: 24),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child:
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 75.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(45),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                backgroundColor: const Color.fromARGB(255, 50, 134, 252),
                              ),
                              onPressed: () {  },
                              child: const Text('Edit Photo',
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      height: 1.2,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ),
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
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
                    controller: emailController,
                    cursorColor: Colors.white,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
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
                  height: 30,
                ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(55),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          backgroundColor: const Color.fromARGB(255, 50, 134, 252),
                        ),
                        onPressed: _updateUserProfile,
                        child: const Text('Save',
                            style: TextStyle(
                                fontSize: 18.0,
                                height: 1.2,
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                      ),
                    ),
              ]))
            ]));
  }
}
