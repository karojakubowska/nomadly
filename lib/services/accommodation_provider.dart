import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nomadly_app/models/Accomodation.dart';

class AccommodationProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Acommodation>> get allAccommodations {
    var list = _firestore
        .collection("Accommodations")
        .snapshots()
        .map((QuerySnapshot querySnapshot) => querySnapshot.docs
        .map((DocumentSnapshot documentSnapshot) {
      List<String> photoUrls = List<String>.from(documentSnapshot["photoUrl"]);
      return Acommodation(
        id: documentSnapshot.id,
        title: documentSnapshot["title"],
        city: documentSnapshot["city"],
        photo: documentSnapshot["photo"],
        country: documentSnapshot["city"],
        rate: documentSnapshot["rate"],
        price_per_night: documentSnapshot["price_per_night"],
        host_id: documentSnapshot['host_id'],
        description: documentSnapshot["description"],
        bedroom: documentSnapshot["bedroom"],
        bathroom: documentSnapshot["bathroom"],
        bed: documentSnapshot["bed"],
        address: documentSnapshot["address"],
        number_max_people: documentSnapshot["number_max_people"],
        reviews: documentSnapshot["reviews"],
        photoUrl: photoUrls,
      );
    })
        .toList());
    return list;
  }

// Future<String> getimageLocation(String path) {
//   return FirebaseStorage.instance
//       .refFromURL(path)
//       .getDownloadURL();
//       // .asStream()
//       // .map((downloadUrl) => downloadUrl);
// }
}
