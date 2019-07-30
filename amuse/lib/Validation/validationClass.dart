class Validation{

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

  static String validateUsername(String value){
    Pattern pattern = r'^[a-zA-Z ]{4,25}$';

    RegExp regexp = new RegExp(pattern);

    if (value.isEmpty){
      return 'UserName cannot be empty';
    }
    else if(value.length < 4){
      return 'Atleast 4 characters required';
    }
    else if(value.length > 25){
      return 'Not more than 25 characters required';
    }
    else if(!regexp.hasMatch(value)){
      return 'Only characters are allowed';
    }
    else{
      return null;
    }
  }

  static String validateDescription(String value){
    Pattern pattern = r'^.{1,100}$';

    RegExp regexp = new RegExp(pattern);

    if (value.isEmpty){
      return 'Group Description can\'t be empty';
    }
    else if(value.length > 100){
      return 'Not more than 100 characters required';
    }
    else{
      return null;
    }
  }

  static String validateGroupName(String value){
    Pattern pattern = r'^.{1,25}$';

    RegExp regexp = new RegExp(pattern);

    if (value.isEmpty){
      return 'GroupName can\'t be empty';
    }
    else if(value.length > 25){
      return 'Not more than 25 characters required';
    }
    else{
      return null;
    }
  }
}
