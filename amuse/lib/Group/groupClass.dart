import 'package:geolocator/geolocator.dart';

class Group {
  String groupId;
  String groupName;
  String groupPic;
  String category;
  String subCat;
  String desc;
  Position position;
  double area;
  String createdBy;
  Group();
  Group.all(this.groupId, this.groupName, this.groupPic, this.category, this.subCat,
      this.desc, this.position, this.area, this.createdBy);
}
class UserGroup
{
  String groupId;
  bool mode;

  UserGroup(String Id, bool mo)
  {
    this.groupId=Id;
    this.mode=mo;
  }
}