// Quote/citation model for home page
// Parses assets/data/home/quotes.json

class HomeQuote {
  final String id;
  final String text;
  final String? author;

  const HomeQuote({
    required this.id,
    required this.text,
    this.author,
  });

  factory HomeQuote.fromJson(Map<String, dynamic> json) {
    return HomeQuote(
      id: json['id'] as String,
      text: json['text'] as String,
      author: json['author'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        if (author != null) 'author': author,
      };
}
