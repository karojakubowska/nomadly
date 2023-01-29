import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Travel.dart';

class AddTravelView extends StatefulWidget {

  const AddTravelView({
    Key? key,
  }):super(key:key);

  @override
  State<AddTravelView> createState() => _AddTravelViewState();
}

class _AddTravelViewState extends State<AddTravelView> {
  final nameController=TextEditingController();
  final destinationController=TextEditingController();

  // Future addTravel() async {
  //   final uid=FirebaseAuth.instance.currentUser!.uid;
  //   var db = FirebaseFirestore.instance;
  //   db.collection("Travel").doc(uid).set({
  //     'name': nameController.text,
  //     'destination': destinationController.text,
  //   });
  // }

  CollectionReference travel = FirebaseFirestore.instance.collection('Travel');

  Future<void> addTravel() {
    return travel
        .add({
      'name': nameController.text,
      'destination': destinationController.text,
    })
        .then((value) => print("Add Travel"))
        .catchError((error) => print("Error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: Colors.black,
            icon: Icon(Icons.arrow_back),
            onPressed: () {},
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 50,),
          TextField(
            controller: nameController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(labelText: 'Name',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(width: 1,color: Color.fromARGB(255, 217, 217, 217)),
              ),
              filled: true,
              fillColor:  Color.fromARGB(255, 249, 250, 250),
            ),
          ),
          const SizedBox(height: 20,),
          TextField(
            controller: destinationController,
            cursorColor: Colors.white,
            textInputAction: TextInputAction.done,
            decoration: const InputDecoration(labelText: 'Destination',
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
                borderSide: BorderSide(width: 1,color: Color.fromARGB(255, 217, 217, 217)),
              ),
              filled: true,
              fillColor: Color.fromARGB(255, 249, 250, 250),
            ),
          ),
          const SizedBox(height: 20,),
          ElevatedButton.icon(style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(60),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              backgroundColor: const Color.fromARGB(255, 50, 134, 252)),
            onPressed: addTravel,
            icon: const Icon(Icons.lock_open, size: 0),
            label: const Text('Add Travel',
                style: TextStyle(fontSize: 20)),
          ),
        ],
      )
  ) ;
}}