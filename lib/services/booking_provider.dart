import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nomadly_app/models/Booking.dart';

class BookingProvider{
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Booking>> get allBookings {

    var list= _firestore.collection("Bookings").snapshots().map(
        (QuerySnapshot querySnapshot) => querySnapshot.docs
            .map((DocumentSnapshot documentSnapshot) => Booking(
                id:documentSnapshot.id,
                accommodationId: documentSnapshot["accommodation_id"],
                hostId: documentSnapshot["host_id"],
                userId: documentSnapshot["user_id"],
                startDate: documentSnapshot["start_date"].toDate(),
                endDate: documentSnapshot["end_date"].toDate(),
                guestNumber: documentSnapshot["guest_number"],
                totalPrice: documentSnapshot["total_price"],
                status: documentSnapshot["status"],
                username: documentSnapshot["username"],
                isAccommodationRated:  documentSnapshot["isAccommodationRated"],
                isUserRated: documentSnapshot["isUserRated"],
                city:documentSnapshot["city"],
                country:documentSnapshot["country"]))
            .toList());
    return list;
  }
}