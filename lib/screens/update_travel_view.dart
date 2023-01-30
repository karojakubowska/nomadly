import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nomadly_app/models/Travel.dart';

class UpdateTravelView extends StatefulWidget {
  final DocumentSnapshot? travel;
  final String id;

  const UpdateTravelView({
    Key? key, this.travel, required this.id
  }):super(key:key);

  @override
  State<UpdateTravelView> createState() => _UpdateTravelViewState();
}
class _UpdateTravelViewState extends State<UpdateTravelView> {
  final nameController=TextEditingController();
  final destinationController=TextEditingController();

  CollectionReference travel = FirebaseFirestore.instance.collection('Travel');

  //get id => String id;

  Future<void>updateTravel(id) async {
    //await FirebaseFirestore.instance.collection('Travel').doc((widget.travel!.get("id"))).updateData({'name': nameController.text});
    final db = FirebaseFirestore.instance;
    final washingtonRef = db.collection("Travel").doc(id);
    washingtonRef.update({"name": nameController.text}).then(
            (value) => print("DocumentSnapshot successfully updated!"),
        onError: (e) => print("Error updating document $e"));
    print(id);
  }

  void initState() {
    super.initState();
    nameController.text =(widget.travel!.get("name"));
    destinationController.text =(widget.travel!.get("destination"));
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
              onPressed: () {
                updateTravel(widget.id);
              },              
              icon: const Icon(Icons.lock_open, size: 0),
              label: const Text('Update Travel',
                  style: TextStyle(fontSize: 20)),
            ),
          ],
        )
    ) ;
  }}