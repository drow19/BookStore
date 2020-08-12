
import 'package:shared_preferences/shared_preferences.dart';

class LoginModel {
  int id;
  String name;
  String email;
  String password;

  LoginModel({
    this.id,
    this.name,
    this.password,
    this.email,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password']);
  }

  user() async {
    SharedPreferences user = await SharedPreferences.getInstance();
    user.setInt("id", id);
    user.setString("name", name);
    user.setString("email", email);
    user.setString("password", password);
  }
}
