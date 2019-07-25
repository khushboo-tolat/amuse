import 'package:flutter_test/flutter_test.dart';
import 'package:amuse/Validation/validationClass.dart';

void main(){
  test('empty PIN returns error string', () {

    final result = Validation.validatePIN('');
    expect(result, 'PIN cannot be empty');
  });

  test('non-empty PIN not length of 4 returns error string', () {

    final result = Validation.validatePIN('012');
    expect(result, '4 Digits are required');
  });

  test('non-empty PIN not length of 4 returns error string', () {

    final result = Validation.validatePIN('012345');
    expect(result, '4 Digits are required');
  });

  test('non-empty PIN not length of 4 of characters returns error string', () {

    final result = Validation.validatePIN('PIN');
    expect(result, '4 Digits are required');
  });

  test('non-empty PIN length of 4 of characters returns error string', () {

    final result = Validation.validatePIN('PINM');
    expect(result, 'PINM is not valid PIN number');
  });

  test('non-empty PIN length of 4 digits',(){

    final result = Validation.validatePIN('0123');
    expect(result,null);
  });
}