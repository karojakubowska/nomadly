class UserModel{
  String? name;
  String? email;
  String? accountType;
  String? imageurl;

  Map<String,dynamic> toJson()=>{
    'Name': name,
    'Email': email,
    'AccountType':accountType,
    };

UserModel.fromJson(Map<String,dynamic> json)
  {
    name=json['Name'];
    email=json['Email'];
    accountType=json['AccountType'];
    imageurl=json['imageurl'];
    }
UserModel.fromSnapshot(snapshot)
  : name=snapshot.data()['Name'],
  email=snapshot.data()['Email'],
  accountType=snapshot.data()['AccountType'],
  imageurl=snapshot.data()['Imageurl']
  ;
UserModel(snapshot)
  : name=snapshot.data()['Name'],
  email=snapshot.data()['Email'],
  accountType=snapshot.data()['AccountType'],
  imageurl=snapshot.data()['Imageurl']
  ;
  

}