import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
class Booking {
  String? id;
  String? accommodationId;
  String? hostId;
  String? userId;
  Timestamp? startDate; //czy to będzie ten typ???
  Timestamp? endDate;
  num? guestNumber;
  double? totalPrice;
  String? status;
  String? username;
  bool? isAccommodationRated;
  bool? isUserRated;

  Booking(
      {this.accommodationId,
      this.hostId,
      this.userId,
      this.startDate,
      this.endDate,
      this.guestNumber,
      this.totalPrice,
      this.status,
      this.username,
      this.isAccommodationRated,
       this.isUserRated});

  Booking.fromJson(Map<String, dynamic> json) {
    accommodationId = json['accommodation_id'];
    hostId=json['host_id'];
    userId = json['user_id'];
    status = json['status'];
    username = json['username'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    guestNumber = json['guest_number'];
    totalPrice = (json['total_price']).toDouble();
    isAccommodationRated = json['isAccommodationRated'];
    isUserRated = json['isUserRated'];
    
  }
}
