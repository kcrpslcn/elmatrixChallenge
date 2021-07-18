import 'package:either_dart/either.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('how to get left/right', () {
    Either<String, String> eitherValue;
    eitherValue = Right('right');
    expect(eitherValue.isRight, true);
    expect(eitherValue.right, 'right');
    eitherValue = Left('left');
    expect(eitherValue.isLeft, true);
    expect(eitherValue.left, 'left');
  });

  test('how to fold an either', () {
    Either<String, String> eitherValue = Right('right');
    expect(
        eitherValue.fold(
            (left) => fail('This should not be called'), (right) => right),
        'right');
  });

  test('how to transform left/right', () {
    Either<String, String> eitherValue = Right('right');
    // map returns a new instance!
    eitherValue.map((right) => 'map right');
    // nothing changed without assigning
    expect(eitherValue.right, 'right');
    eitherValue = eitherValue.map((right) => 'map right');
    // now it changes
    expect(eitherValue.right, 'map right');

    eitherValue = eitherValue.mapLeft((left) => 'null');
    expect(eitherValue.isLeft, false);
    expect(() => eitherValue.left, throwsA(isA<Exception>()));
  });
}
