part of 'number_trivia_bloc.dart';

@immutable
abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState([List props = const <dynamic>[]]) : super();
}

class Empty extends NumberTriviaState {
  @override
  List<Object?> get props => [];
}

class Loading extends NumberTriviaState {
  @override
  List<Object?> get props => [];
}

class Loaded extends NumberTriviaState {

  final NumberTrivia numberTrivia;

  const Loaded({required this.numberTrivia});

  @override
  List<Object?> get props => [];
}

class Error extends NumberTriviaState {

  final String message;

  const Error({required this.message});

  @override
  List<Object?> get props => [];
}
