import 'package:cards_clean_arch/domain/card.dart';

class MockCardRepository {
  Future<List<Card>> fetchCards() async {
    await Future.delayed(const Duration(seconds: 2));
    return List.generate(
      30,
      (index) => Card(
        id: '$index',
        title: 'Card $index',
      ),
    );
  }
}
