import 'package:flutter/foundation.dart';

class Farmer {
  final String name ;
  final String Location ;
  Farmer({
    required this.name ,required this.Location
});
  factory Farmer.fromjson(Map<String,dynamic>json){
    return Farmer(name: json['name'], Location: json['Location']);
  }
}