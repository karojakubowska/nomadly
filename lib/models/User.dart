class User{
  String? name;
  String? email;
  String? accountType;

  Map<String,dynamic> toJson()=>{
    'Name': name,
    'Email': email,
    'AccountType':accountType,
    };

User.fromJson(Map<String,dynamic> json)
  {
    name=json['Name'];
    email=json['Email'];
    accountType=json['AccountType'];
    }
}