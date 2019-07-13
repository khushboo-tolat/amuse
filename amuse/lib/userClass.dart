class User
{
  static final User _user = new User._internal();
  String userId;
  String name;
  String eMail;
  String profilePicture;

  factory User()
  {
    return _user;
  }
  User._internal();


}
