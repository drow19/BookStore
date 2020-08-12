class BookModel {
  int id;
  int prices;
  String title;
  String author;
  String description;
  String photo;
  String publisher;

  BookModel({
    this.id,
    this.prices,
    this.title,
    this.author,
    this.description,
    this.publisher,
    this.photo,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
        id: json['id'],
        prices: json['price'],
        title: json['title'],
        description: json['description'],
        author: json['author'],
        photo: json['photo'],
        publisher: json['publisher']);
  }
}
