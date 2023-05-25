import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nomadly_app/models/Favorites.dart';

class WishlistProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<Favorites>> get allFavourites {
    var list = _firestore
        .collection("Wishlists")
        .doc(_auth.currentUser?.uid)
        .collection("favs")
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => Favorites(
                  accommodationId: documentSnapshot["accommodationId"],
                ))
            .toList());
    return list;
  }
}
