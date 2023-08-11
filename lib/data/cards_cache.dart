import 'package:cards_clean_arch/domain/card.dart';

class RAMCardsCache {
  List<Card>? _cards;
  final Duration invalidateDuration;
  DateTime? _updatedAt;

  RAMCardsCache({required this.invalidateDuration});

  List<Card>? get cards {
    if (_updatedAt == null ||
        _updatedAt!.isBefore(DateTime.now().subtract(invalidateDuration))) {
      _cards = null;
    }

    return _cards;
  }

  void saveCards(List<Card> cards) {
    _updatedAt = DateTime.now();
    _cards = cards;
  }
}
