import 'dart:convert';

import 'package:bookapp/Model/detail_trans_model.dart';
import 'package:bookapp/utils/baseUrl.dart';
import 'package:http/http.dart' as http;

class DetailRepo {
  Future<String> getData(var idTrans) async {
    String _url = BaseUrl.DetailTrans() + idTrans;

    final response = await http.get(_url);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception();
    }
  }

  List<DetailModel> jsonParse(final response) {
    final json = jsonDecode(response);
    final data = json['data'];

    print("response data : " + data.toString());

    return new List<DetailModel>.from(data.map((x) => DetailModel.fromJson(x)));
  }
}
