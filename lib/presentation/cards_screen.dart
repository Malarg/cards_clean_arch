import 'package:cards_clean_arch/data/cards_cache.dart';
import 'package:cards_clean_arch/data/mock_cards_repository.dart';
import 'package:cards_clean_arch/domain/cards_bloc.dart';
import 'package:cards_clean_arch/domain/cards_interactor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: MultiBlocProvider(
        providers: [
          Provider<RAMCardsCache>(
            create: (context) =>
                RAMCardsCache(invalidateDuration: const Duration(seconds: 10)),
          ),
          Provider<MockCardRepository>(
            create: (context) => MockCardRepository(),
          ),
          Provider(
            create: (context) => CardsInteractor(
              cardsCache: context.read<RAMCardsCache>(),
              cardRepository: context.read<MockCardRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => CardsBloc(
              cardsInteractor: context.read<CardsInteractor>(),
            ),
          ),
        ],
        child: CardsList(),
      )),
    );
  }
}

class CardsList extends StatelessWidget {
  const CardsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: BlocBuilder<CardsBloc, CardsState>(
            builder: (context, state) {
              return switch (state) {
                CardsInitialState() => const Center(
                    child: Text('initial'),
                  ),
                CardsLoadingState() => const Center(
                    child: CircularProgressIndicator(),
                  ),
                CardsLoadedState(cards: final cards) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return Card(
                        child: ListTile(
                          title: Text(card.title),
                          subtitle: Text(card.createdAt.toString()),
                        ),
                      );
                    },
                  ),
                CardsErrorState(message: final message) => Center(
                    child: Text(message),
                  ),
              };
            },
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<CardsBloc>().add(RefreshCardsEvent());
          },
          child: const Text('Refresh'),
        ),
      ],
    );
  }
}
