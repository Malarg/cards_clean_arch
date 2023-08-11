import 'dart:async';

import 'package:cards_clean_arch/domain/card.dart';
import 'package:cards_clean_arch/domain/cards_interactor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class CardsEvent {
  const CardsEvent();
}

class RefreshCardsEvent extends CardsEvent {}

sealed class CardsState {
  const CardsState();
}

class CardsInitialState extends CardsState {}

class CardsLoadingState extends CardsState {}

class CardsLoadedState extends CardsState {
  final List<Card> cards;

  const CardsLoadedState({required this.cards});
}

class CardsErrorState extends CardsState {
  final String message;

  const CardsErrorState({required this.message});
}

class CardsBloc extends Bloc<CardsEvent, CardsState> {
  final CardsInteractor _cardsInteractor;

  CardsBloc({required CardsInteractor cardsInteractor})
      : _cardsInteractor = cardsInteractor,
        super(CardsInitialState()) {
    on<RefreshCardsEvent>(_onRefreshCardsEvent);
  }

  Future<void> _onRefreshCardsEvent(
      RefreshCardsEvent event, Emitter<CardsState> emit) async {
    emit(CardsLoadingState());
    try {
      final cards = await _cardsInteractor.fetchCards();
      emit(CardsLoadedState(cards: cards));
    } catch (e) {
      emit(CardsErrorState(message: e.toString()));
    }
  }
}
