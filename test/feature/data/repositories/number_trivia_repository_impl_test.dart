import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exception.dart';
import 'package:number_trivia/core/error/failures.dart';
import 'package:number_trivia/core/network/network_info.dart';
import 'package:number_trivia/feature/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/feature/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/feature/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:number_trivia/feature/number_trivia/domain/entities/number_trivia.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks([NumberTriviaRemoteDataSource, NumberTriviaLocalDataSource, NetworkInfo])
void main() {
  late NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;
  late MockNumberTriviaRemoteDataSource mockNumberTriviaRemoteDataSource;
  late MockNumberTriviaLocalDataSource mockNumberTriviaLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNumberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    mockNumberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();

    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
      numberTriviaRemoteDataSource: mockNumberTriviaRemoteDataSource,
      numberTriviaLocalDataSource: mockNumberTriviaLocalDataSource,
      networkInfo: mockNetworkInfo
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }


  group("getConcreteNumberTrivia", () {

    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: "test", number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("Should test is device is online", () async {
      ///arrange
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true);

      ///act
      await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

      ///assert
      verify(mockNetworkInfo.isConnected);

    });
    
    runTestsOnline(() {
      
      test("should return remote data when the call to remote data is successful", () async {

        ///arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        ///act
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

        ///assert
        verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));

      });

      test("Should cache the data locally when the call to remote data is successful", () async {

        ///arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenAnswer((_) async => tNumberTriviaModel);

        ///act
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

        ///assert
        verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockNumberTriviaLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test("Should return server failure when the call to remote data is unsuccessful", () async {

        ///arrange
        when(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber))
            .thenThrow(ServerException());

        ///act
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

        ///assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));

        expect(result, equals(Left(ServerFailure())));

      });
      
    });
    
    runTestsOffline(() {

      test("Should return last locally cached data when the cached data is present", () async {

        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));

      });

      test('should return CacheFailure when there is no cached data present', () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });
      
    });

  });

  group("getRandomNumberTrivia", () {

    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: "test", number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test("Should test is device is online", () async {
      ///arrange
      when(mockNetworkInfo.isConnected)
          .thenAnswer((_) async => true);

      ///act
      await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

      ///assert
      verify(mockNetworkInfo.isConnected);

    });

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
            () async {
          // arrange
          when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
          // assert
          verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        },
      );

      test(
        'should cache the data locally when the call to remote data source is successful',
            () async {
          // arrange
          when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);
          // act
          await numberTriviaRepositoryImpl.getRandomNumberTrivia();
          // assert
          verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
          verify(mockNumberTriviaLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
            () async {
          // arrange
          when(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia())
              .thenThrow(ServerException());
          // act
          final result = await numberTriviaRepositoryImpl.getRandomNumberTrivia();
          // assert
          verify(mockNumberTriviaRemoteDataSource.getRandomNumberTrivia());
          verifyZeroInteractions(mockNumberTriviaLocalDataSource);
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });

    runTestsOffline(() {

      test("Should return last locally cached data when the cached data is present", () async {

        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenAnswer((_) async => tNumberTriviaModel);

        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);

        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));

      });

      test('should return CacheFailure when there is no cached data present', () async {
        // arrange
        when(mockNumberTriviaLocalDataSource.getLastNumberTrivia())
            .thenThrow(CacheException());
        // act
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // assert
        verifyZeroInteractions(mockNumberTriviaRemoteDataSource);
        verify(mockNumberTriviaLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(CacheFailure())));
      });

    });

  });

}