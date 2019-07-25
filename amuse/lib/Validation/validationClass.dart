class Validation{

  static String validatePIN(String value){
    Pattern pattern = r'^\d{4}$';

    RegExp regexp = new RegExp(pattern);

    if (value.isEmpty){
      return 'Pin cannot be empty';
    }
    else if(value.length  != 4){
      return 'Only 4 digits allowed';
    }
    else if(!regexp.hasMatch(value)){
      return 'Only digits are allowed';
    }
    else{
      return null;
    }
  }

  static String validateUsername(String value){
    Pattern pattern = r'^[a-zA-Z ]{4,25}$';

    RegExp regexp = new RegExp(pattern);

    if (value.isEmpty){
      return 'Password cannot be empty';
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

  static String validateGroupName(String value){
    Pattern pattern = r'^.{1,25}$';

    RegExp regexp = new RegExp(pattern);

    if (value.isEmpty){
      return 'GroupName can\'t be empty';
    }
    else if(value.length < 1){
      return 'Atleast 1 characters required';
    }
    else if(value.length > 25){
      return 'Not more than 25 characters required';
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
    else if(value.length < 1){
      return 'Atleast 1 characters required';
    }
    else if(value.length > 100){
      return 'Not more than 100 characters required';
    }
    else{
      return null;
    }
  }
}
