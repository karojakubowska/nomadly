import 'package:cloud_firestore/cloud_firestore.dart';

class UserOpinion {
  String? hostId;
  String? userId;
  String? hostName;
  String? opinionText;
  num? rate;
  Timestamp? date;

  UserOpinion({
    required this.hostId,
    required this.userId,
    required this.hostName,
    required this.opinionText,
    required this.rate,
    required this.date,
  });

  UserOpinion.fromJson(Map<String, dynamic> json) {
    hostId = json['hostId'];
    userId = json['userId'];
    hostName = json['hostName'];
    opinionText = json['opinionText'];
    rate = json['rate'];
    date = json['pub_date'];
  }
}
