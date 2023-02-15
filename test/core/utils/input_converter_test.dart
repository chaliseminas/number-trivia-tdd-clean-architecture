import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/utils/input_converter.dart';

void main() {

  late InputConverter inputConverter;

 setUp(() {
   inputConverter = InputConverter();
 });

 group("StringToUnsignedInteger", () {

   test("Should return an integer when string represents unsigned integer", () {

     ///assign
     String tString = '123';
     int tResultInteger = 123;

     ///act
     final result = inputConverter.stringToUnsignedInteger(tString);

     ///assert
     expect(result, Right(tResultInteger));

   });

   test("Should return a failure when string is not integer", () {

     String tString = "test";

     final result = inputConverter.stringToUnsignedInteger(tString);

     expect(result, Left(InvalidInputFailure()));

   });

   test(
     'should return a failure when the string is a negative integer',
         () async {
       // arrange
       const str = '-123';
       // act
       final result = inputConverter.stringToUnsignedInteger(str);
       // assert
       expect(result, Left(InvalidInputFailure()));
     },
   );

 });

}