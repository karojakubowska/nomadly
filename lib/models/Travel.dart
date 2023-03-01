import 'package:cloud_firestore/cloud_firestore.dart';

class Travel{
  String? name;
  int? budget;
  String? destination;
  Timestamp? start_date;
  Timestamp? end_date;
  String? note;
  String? photo;
  int? number_of_people;
  List<dynamic>? to_do_list;
  String? documentId;
  String? userId;

//funkcja mapująca dane na json
  Map<String,dynamic> toJson()=>{
    'budget': budget,
    'name': name,
    'destination': destination,
    'start_date': start_date,
    'end_date': end_date,
    'note': note,
    'photo': photo,
    'number_of_people': number_of_people,
    'to_do_list': to_do_list,
    'documentId': documentId,
    'userId': userId,
  };

  Travel.fromSnapshot(DocumentSnapshot snapshot) :
        name = snapshot['name'],
        documentId = snapshot.id;


  Travel.fromJson(Map<String,dynamic> json)
  {
    budget=json['budget'];
    name=json['name'];
    destination=json['destination'];
    start_date=json['start_date'];
    end_date=json['end_date'];
    note=json['note'];
    photo=json['photo'];
    number_of_people=json['number_of_people'];
    to_do_list=json['to_do_list'];
    documentId = json['documentId'];
    userId = json['userId'];
  }
}

