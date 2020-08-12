import 'package:bookapp/Model/book_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:bookapp/utils/baseUrl.dart';

class BookRepository {
  Future<List<BookModel>> getData(String search, String page) async {
    String _url;

    search == ""
        ? _url = BaseUrl.ListBook() + page
        : _url = BaseUrl.SearchBook() + search + "?page=$page";

    final response = await http.get(_url);

    if (response.statusCode == 200) {
      return parseJson(response.body);
    } else {
      throw Exception();
    }
  }

  List<BookModel> parseJson(final response) {
    final json = jsonDecode(response);
    final data = json['data'];
    print("response data : " + data.toString());

    return new List<BookModel>.from(data.map((x) => BookModel.fromJson(x)));
  }
}
