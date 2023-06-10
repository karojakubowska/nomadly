import 'package:firebase_storage/firebase_storage.dart';

class UserModel {
  String? name;
  String? email;
  String? accountType;
  String? accountImage;
  String? accountStatus;
  num? rate;
  num? opinionsNumber;

  Map<String, dynamic> toJson() => {
        'Name': name,
        'Email': email,
        'AccountType': accountType,
        'AccountImage': accountImage,
        'rate': rate,
        'opinionsNumber': opinionsNumber,
        'AccountStatus': accountStatus,
      };

  Future<String> convertPathToURL(String path) {
    return FirebaseStorage.instance.refFromURL(path).getDownloadURL();
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    email = json['Email'];
    accountType = json['AccountType'];
    accountImage = json['AccountImage'];
    rate = json['rate'];
    opinionsNumber = json['opinionsNumber'];
    accountStatus = json['AccountStatus'];
  }
  UserModel.fromSnapshot(snapshot)
      : name = snapshot.data()['Name'],
        email = snapshot.data()['Email'],
        accountType = snapshot.data()['AccountType'],
        accountImage = snapshot.data()['AccountImage'],
        rate = snapshot.data()['rate'],
        opinionsNumber = snapshot.data()['opinionsNumber'],
        accountStatus = snapshot.data()['AccountStatus'];
  UserModel(snapshot)
      : name = snapshot.data()['Name'],
        email = snapshot.data()['Email'],
        accountType = snapshot.data()['AccountType'],
        accountImage = snapshot.data()['AccountImage'],
        rate = snapshot.data()['rate'],
        opinionsNumber = snapshot.data()['opinionsNumber'],
       accountStatus = snapshot.data()['AccountStatus'];
  bool get isBlocked => accountStatus == 'Blocked';

}
