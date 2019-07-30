import 'package:flutter_test/flutter_test.dart';
import 'package:amuse/Validation/validationClass.dart';

void main(){

  //Validate UserName

  test('Empty Username returns error string', () {
    final result = Validation.validateUsername('');
    expect(result, 'Username cannot be empty');
  });

  test('Non-empty Username not length of 4 returns error string', () {
    final result = Validation.validateUsername('Abc');
    expect(result, 'Atleast 4 characters required');
  });

  test('Non-empty Username length of 4 of uppercase characters returns null', () {
    final result = Validation.validateUsername('PINM');
    expect(result, null);
  });

  test('Non-empty Username length of 4 of lowercase characters returns null', () {
    final result = Validation.validateUsername('pinm');
    expect(result, null);
  });

  test('Non-empty Username length of 4 of numbers returns error string', () {

    final result = Validation.validateUsername('1234');
    expect(result, 'Only characters are allowed');
  });

  test('Non-empty Username length of 4 of special characters returns error string', () {
    final result = Validation.validateUsername('._=,');
    expect(result, 'Only characters are allowed');
  });

  test('Non-empty Username length of 26 of characters returns error string', () {
    final result = Validation.validateUsername('qwertyuiopasdfghjklzxcvbnm');
    expect(result, 'Not more than 25 characters required');
  });

  //Validate PIN Number
  
  test('Empty PIN returns error string', () {
    final result = Validation.validatePIN('');
    expect(result, 'PIN cannot be empty');
  });

  test('Non-empty PIN not length of 4 returns error string', () {
    final result = Validation.validatePIN('012');
    expect(result, '4 Digits are required');
  });

  test('Non-empty PIN not length of 4 returns error string', () {
    final result = Validation.validatePIN('012345');
    expect(result, '4 Digits are required');
  });

  test('Non-empty PIN not length of 4 of characters returns error string', () {
    final result = Validation.validatePIN('PIN');
    expect(result, '4 Digits are required');
  });

  test('Non-empty PIN length of 4 of characters returns error string', () {
    final result = Validation.validatePIN('PINM');
    expect(result, 'PINM is not valid PIN number');
  });

  test('Non-empty PIN length of 4 digits',(){
    final result = Validation.validatePIN('0123');
    expect(result,null);
  });

  //Validate Group Name

  test('Empty Group Name returns error string', () {
    final result = Validation.validateGroupName('');
    expect(result, 'GroupName can\'t be empty');
  });

  test('Non-empty Group Name not more than 25 characters',(){
    final result = Validation.validateGroupName('abcdefghijklmnopqrstuvwxyz');
    expect(result, 'Not more than 25 characters required');
  });

  test('Non-empty Group Name between 1 to 25 characters',(){
    final result = Validation.validateGroupName('abcdef');
    expect(result,null);
  });

  //Validate Group Description

  test('Empty Group Description returns error',(){
    final result = Validation.validateDescription('');
    expect(result, 'Group Description can\'t be empty');
  });

  test('Non-empty Group Description not more than 100 characters',(){
    final result = Validation.validateDescription('qwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnmqwertyuiopasdfghjklzxcvbnm');
    expect(result, 'Not more than 100 characters required');
  });

  test('Non-empty Group Description between 1 to 100 characters',(){
    final result = Validation.validateDescription('qwertyuiopasdfghjkl');
    expect(result, null);
  });
}