import 'dart:convert';
import 'package:bookapp/Model/history_model.dart';
import 'package:bookapp/utils/baseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HistoryRepo {

  Future<List<HistoryModel>> getData() async {

    SharedPreferences shared = await SharedPreferences.getInstance();
    int id = shared.getInt("id");

    String _url = BaseUrl.History() + id.toString() + "?page=1";

    final response = await http.get(_url);

    if(response.statusCode == 200){
      return jsonParse(response.body);
    }else{
      throw Exception();
    }

  }

  List<HistoryModel> jsonParse(final response){
    final json = jsonDecode(response);
    final data = json['data'];
    print("response data : " + data.toString());

    return new List<HistoryModel>.from(data.map((x)=> HistoryModel.fromJson(x)));
  }

}