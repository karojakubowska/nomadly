import 'package:firebase_storage/firebase_storage.dart';

class UserModel{
  String? name;
  String? email;
  String? accountType;
  String? accountImage;

  Map<String,dynamic> toJson()=>{
    'Name': name,
    'Email': email,
    'AccountType':accountType,
    'AccountImage':accountImage,
    };

  Future<String> convertPathToURL(String path){
    return FirebaseStorage.instance
        .refFromURL(path)
        .getDownloadURL();
  }

  UserModel.fromJson(Map<String,dynamic> json)
  {
    name=json['Name'];
    email=json['Email'];
    accountType=json['AccountType'];
    accountImage=json['AccountImage'];
    }
UserModel.fromSnapshot(snapshot)
  : name=snapshot.data()['Name'],
  email=snapshot.data()['Email'],
  accountType=snapshot.data()['AccountType'],
  accountImage=snapshot.data()['AccountImage']
  ;
UserModel(snapshot)
  : name=snapshot.data()['Name'],
  email=snapshot.data()['Email'],
  accountType=snapshot.data()['AccountType'],
  accountImage=snapshot.data()['AccountImage']
  ;

}