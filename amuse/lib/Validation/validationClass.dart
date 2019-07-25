class Validation{

  static String validatePIN(String value){

    if (value.isEmpty){
      return 'Password cannot be empty';
    }
    else if (value.length < 4) {
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
