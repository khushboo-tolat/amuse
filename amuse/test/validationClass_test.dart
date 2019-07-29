import 'package:flutter_test/flutter_test.dart';
import 'package:amuse/Validation/validationClass.dart';

void main(){
  //Validate UserName
  test('empty Username returns error string', () {

    final result = Validation.validateUsername('');
    expect(result, 'Username cannot be empty');
  });

  test('non-empty Username not length of 4 returns error string', () {

    final result = Validation.validateUsername('Abc');
    expect(result, 'Atleast 4 characters required');
  });

  test('non-empty Username length of 4 of characters returns error string', () {

    final result = Validation.validateUsername('PINM');
    expect(result, null);
  });

  test('non-empty Username length of 4 of characters returns error string', () {

    final result = Validation.validateUsername('pinm');
    expect(result, null);
  });

  test('non-empty Username length of 4 of characters returns error string', () {

    final result = Validation.validateUsername('1234');
    expect(result, 'Only characters are allowed');
  });

  test('non-empty Username length of 4 of characters returns error string', () {

    final result = Validation.validateUsername('._=,');
    expect(result, 'Only characters are allowed');
  });

  test('non-empty Username length of 26 of characters returns error string', () {

    final result = Validation.validateUsername('qwertyuiopasdfghjklzxcvbnm');
    expect(result, 'Not more than 25 characters required');
  });
  
  //Validate PIN Number
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