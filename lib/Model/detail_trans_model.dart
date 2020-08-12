

import 'dart:convert';

List<DetailModel> jsonParse(final response) {
  final json = jsonDecode(response);
  final data = json['data'];

  print("response data : " + data.toString());

  return new List<DetailModel>.from(data.map((x) => DetailModel.fromJson(x)));
}

class DetailModel {

  int id;
  int prices;
  String title;
  String author;
  String description;
  String photo;
  String publisher;

  InfoModel infoModel;

  DetailModel({
    this.id,
    this.prices,
    this.title,
    this.author,
    this.description,
    this.publisher,
    this.photo,
    this.infoModel
  });

  factory DetailModel.fromJson(Map<String, dynamic> json) {
    return DetailModel(
        id: json['id'],
        prices: json['price'],
        title: json['title'],
        description: json['description'],
        author: json['author'],
        photo: json['photo'],
        publisher: json['publisher']);
  }
}

class InfoModel{

  String transId;
  int userId;
  String date;
  String total;

  InfoModel({
    this.transId,
    this.userId,
    this.date,
    this.total,
  });

  factory InfoModel.fromJson(Map<String, dynamic> json){
    return InfoModel(
        transId: json['trans_id'],
        userId: json['user_id'],
        date: json['date'],
        total: json['total']
    );
  }
}