import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/feature/number_trivia/domain/entities/number_trivia.dart';
import 'package:number_trivia/feature/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:number_trivia/feature/number_trivia/domain/usecases/usecase.dart';

class GetConcreteNumberTrivia extends UseCase<NumberTrivia, Params> {

  final NumberTriviaRepository numberTriviaRepository;
  GetConcreteNumberTrivia(this.numberTriviaRepository);

  @override
  Future<Either<Failure, NumberTrivia>?> call(Params params) async {
    return await numberTriviaRepository.getConcreteNumberTrivia(params.number);
  }

}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}