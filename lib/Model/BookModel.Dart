class BookModel {
  String book_id;
  String book_name;

  BookModel(this.book_id, this.book_name);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'book_id': book_id,
      'book_name': book_name,
    };
    return map;
  }

  BookModel.fromMap(Map<String, dynamic> map) {
    book_id = map['book_id'];
    book_name = map['book_name'];
  }
}
