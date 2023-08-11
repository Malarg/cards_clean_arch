class Card {
  final String id;
  final String title;
  final DateTime createdAt = DateTime.now();

  Card({
    required this.id,
    required this.title,
  });
}
