class Validation{

  static String validateEmail(String value){
    Pattern pattern = r'^([a-zA-Z0-9_\-\.]+)@g(oogle)?mail\.com$';

    RegExp regexp = new RegExp(pattern);

    if(value.isEmpty) {
      return "Email can't be empty";
    }
    else if(!regexp.hasMatch(value)){
      return 'Enter valid Email';
    }
    else{
      return null;
    }
  }

  static String validatePassword(String value){
    Pattern pattern = r'^(?=.*?[0-9]).{6,}$';

    RegExp regexp = new RegExp(pattern);

    if (value.isEmpty){
      return 'Password cannot be empty';
    }
    else if(value.length < 6){
      return 'Atleast 6 characters required';
    }
    else if(value.length > 6 && !regexp.hasMatch(value)){
      return 'Atleast one number required';
    }
    else{
      return null;
    }
  }

  static String validateUsername(String value){
    Pattern pattern = r'^(?=.*?[a-zA-Z]).{4,}$';

    RegExp regexp = new RegExp(pattern);

    if (value.isEmpty){
      return 'Password cannot be empty';
    }
    else if(value.length < 4){
      return 'Atleast 4 characters required';
    }
    else if(value.length > 4 && !regexp.hasMatch(value)){
      return 'Only characters allowed';
    }
    else{
      return null;
    }
  }
  static String validatePIN(String value){
    
    if (value.isEmpty){
      return 'PIN cannot be empty';
    }
    else if (value.length != 4) {
      return '4 Digits are required';
    }
    else{
      final n = num.tryParse(value);
      if(n == null){
        return '$value is not valid PIN number';
      }
    }
    return null;
  }
}
