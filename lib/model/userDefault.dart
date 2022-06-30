import 'package:intl/intl.dart';

class UserDefault{
  final String id;
  final String name;
  final String email;
  final String userid;
  final DateTime lastLogIn;
    final String changePassword;
    final String error;

  UserDefault({this.id, this.name, this.email, this.userid, this.lastLogIn,this.error,this.changePassword});

  factory UserDefault.fromJson(Map<String, dynamic> json) {
    return UserDefault(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      userid: json['userid'],
      changePassword:  json['changePasswordDate'],
      //lastLogIn: DateTime.parse(json['lastLogIn']),
      lastLogIn:new DateFormat("yyyy/MM/ddd HH:mm:ss").parse(json['lastLogIn'])  ,
      error: json['error'],
    );
  }
}
