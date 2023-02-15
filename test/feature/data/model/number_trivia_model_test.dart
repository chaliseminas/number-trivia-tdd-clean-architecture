import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/feature/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/feature/number_trivia/domain/entities/number_trivia.dart';

import '../../../fixtures/fixture_reader.dart';

void main() {

  final tNumberTriviaModel = NumberTriviaModel(text: "test", number: 1);

  test("Should be a subclass of number trivia entity", () async {

    ///arrange
    final Map<String, dynamic> jsonMap = json.decode(fixture("trivia_double.json"));

    ///act
    final result = NumberTriviaModel.fromJson(jsonMap);

    ///assert
    expect(result, isA<NumberTrivia>());

  });

  group("toJson()", () {

    test("Should return a JSON map containing proper data", () async {

      ///act
      final result = tNumberTriviaModel.toJson();

      ///assert
      final expectedJsonMap = {
        "text": "test",
        "number": 1
      };
      expect(result, expectedJsonMap);

    });

  });

}