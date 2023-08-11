import 'package:cards_clean_arch/data/cards_cache.dart';
import 'package:cards_clean_arch/data/mock_cards_repository.dart';
import 'package:cards_clean_arch/domain/card.dart';

class CardsInteractor {
  final MockCardRepository _cardRepository;
  final RAMCardsCache _cardsCache;

  CardsInteractor({
    required MockCardRepository cardRepository,
    required RAMCardsCache cardsCache,
  })  : _cardRepository = cardRepository,
        _cardsCache = cardsCache;

  Future<List<Card>> fetchCards() async {
    final cachedCards = _cardsCache.cards;
    if (cachedCards != null) {
      return cachedCards;
    }

    final cards = await _cardRepository.fetchCards();
    _cardsCache.saveCards(cards);
    return cards;
  }
}
