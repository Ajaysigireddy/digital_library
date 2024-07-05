class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String bookId;
  final String isbn;
  final String publisher;
  final String subject;
  final String bookUrl; // Correct field name
  final String coverImageUrl;
  final int reads;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    required this.bookId,
    required this.isbn,
    required this.publisher,
    required this.subject,
    required this.bookUrl, // Correct field name
    required this.coverImageUrl,
    required this.reads,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['title'],
      authors: List<String>.from(json['author']),
      bookId: json['bookID'],
      isbn: json['isbn'],
      publisher: json['publisher'],
      subject: json['subject'],
      bookUrl: json['bookURL'], // Correct field name
      coverImageUrl: json['coverPageURL'],
      reads: json['reads'],
    );
  }
}
