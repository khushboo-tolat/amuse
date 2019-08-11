import 'package:geolocator/geolocator.dart';

class Location
{
  static Position getLocation()
  {
    return Geolocator().getCurrentPosition().then((p){
      return p;
    }) as Position;
  }
  static bool getDistence(Position p, double range)
  {
    Position current = getLocation();
    return (((Geolocator().distanceBetween(
        p.latitude, p.longitude, current.latitude, current.longitude)
        .then((value)
        {
          return value;
        })as double) /1000)  <= range)?true:false;
  }
}