import 'package:cloud_firestore/cloud_firestore.dart';

class UserOpinion {
  String? hostId;
  String? userId;
  String? accommodationId;
  String? opinionText;
  num? rate;
  Timestamp? date;

  UserOpinion({
    required this.hostId,
    required this.userId,
    required this.accommodationId,
    required this.opinionText,
    required this.rate,
    required this.date,
  });

  UserOpinion.fromJson(Map<String, dynamic> json) {
    hostId = json['hostId'];
    userId = json['userId'];
    accommodationId = json['accommodationId'];
    opinionText = json['reviewText'];
    rate = json['rate'];
    date = json['pub_date'];
  }
}
