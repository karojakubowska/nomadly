import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:nomadly_app/models/Accomodation.dart';
import 'package:provider/provider.dart';

class AccommodationProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Acommodation>> get allAccommodations {
    return _firestore.collection("Accommodations").snapshots().map(
        (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => Acommodation(
                title: documentSnapshot["title"],
                city: documentSnapshot["city"],
                photo: documentSnapshot["photo"],
                country: documentSnapshot["city"],
                rate: documentSnapshot["rate"],
                price_per_night: documentSnapshot["price_per_night"],
                description: documentSnapshot["description"],))
            .toList());
  }
  
  // Future<String> getimageLocation(String path) {
  //   return FirebaseStorage.instance
  //       .refFromURL(path)
  //       .getDownloadURL();
  //       // .asStream()
  //       // .map((downloadUrl) => downloadUrl);
  // }

  
}
