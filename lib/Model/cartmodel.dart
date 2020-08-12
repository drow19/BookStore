import 'package:hive/hive.dart';
part 'cartmodel.g.dart';

@HiveType(typeId: 0)
class CartModel {
  @HiveField(0)
  int id;
  @HiveField(2)
  int prices;
  @HiveField(3)
  String title;
  @HiveField(4)
  String author;
  @HiveField(5)
  String description;
  @HiveField(6)
  String photo;
  @HiveField(7)
  String publisher;

  CartModel(
      {this.id,
      this.title,
      this.photo,
      this.description,
      this.author,
      this.prices,
      this.publisher});
}
