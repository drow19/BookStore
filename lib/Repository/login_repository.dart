import 'dart:convert';
import 'package:bookapp/utils/baseUrl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  int id;
  String name;
  String email;
  String password;

  LoginRepository({
    this.id,
    this.name,
    this.password,
    this.email,
  });

  factory LoginRepository.fromJson(Map<String, dynamic> json) {
    return LoginRepository(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password']);
  }

  Future<String> getData(String email, String password) async {
    String _url = BaseUrl.URL();

    final response =
        await http.post(_url, body: {"email": email, "password": password});

    if (response.statusCode == 200) {
      print(response.body);
      final data = jsonDecode(response.body);
      final status = data['success'];

      if (status == "1") {
        String name = data['data']['name'];
        final id = data['data']['id'];
        final email = data['data']['email'];
        SharedPreferences user = await SharedPreferences.getInstance();
        user.setString("name", name);
        user.setString("email", email);
        user.setInt("id", id);
      }

      return status;
    } else {
      throw Exception();
    }
  }
}
