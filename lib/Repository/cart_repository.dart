import 'dart:convert';

import 'package:bookapp/Model/cartmodel.dart';
import 'package:http/http.dart' as http;
import 'package:bookapp/utils/baseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo {
  Future<String> postData(var data) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    var id = shared.getInt("id");

    Map<dynamic, dynamic> raw = data.toMap();
    List list = raw.values.toList();
    CartModel _cartx;

    List<Map<String, dynamic>> post = new List();
    Map<String, dynamic> toJson() => {
          "id": _cartx.id,
        };

    for (int i = 0; i < raw.length; i++) {
      _cartx = list[i];
      Map<String, dynamic> json;
      json = toJson();
      post.add(json);
    }

    var body = jsonEncode({"user_id": id, "books": post});

    String _url = BaseUrl.PostData();

    print(body);

    final response = await http.post(Uri.encodeFull(_url),
        body: body, headers: {'Content-type': 'application/json'});

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final status = json['success'];
      print(json);
      return status;
    } else {
      throw Exception();
    }
  }
}
