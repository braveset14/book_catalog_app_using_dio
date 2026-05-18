class Book {
  final int id;
  final String title;
  final String description;
  final String author;
  final String condition;
  final double price;

  Book({
    required this.id,
    required this.author,
    required this.condition,
    required this.price,
    required this.description,
    required this.title,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    final conditions = ['Excellent', 'Good', 'Fair', 'Poor'];
    final conditionIndex = (json['userId'] as int) % conditions.length;
    final price = (json['id'] as int) % 45 + 5;

    return Book(
      id: json['id'],
      title: json['title'] ?? 'Untitled Book',
      description: json['body'] ?? 'No description available.',
      author: 'User ${json['userId']}',
      condition: conditions[conditionIndex],
      price: price.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': description ?? '',
      'userId': 1,
    };
  }
}
