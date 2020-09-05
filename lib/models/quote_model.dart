class Quote {
  String quote;
  String author;

  Quote.fromJson(Map<String, dynamic> json) {
    quote = json['text'];
    author = json['author'];
  }
}
