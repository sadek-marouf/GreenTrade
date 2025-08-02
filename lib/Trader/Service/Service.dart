import 'package:flutter/foundation.dart';

class Farmerid {
  final String name;

  final String Location;

  Farmerid({required this.name, required this.Location});

  factory Farmerid.fromjson(Map<String, dynamic> json) {
    return Farmerid(name: json['name'], Location: json['Location']);
  }
}

class TraderProduct {
  final int id;

  final String name;
  final String type; // "Fruits" or "Vegetables"
  final String imageUrl;
  final double price;
  final int quantity;
  final String farmerName;
  final String farmerLocation;
  final int farmerNumber;
  final String farmerEmail;

  final double? discountPercentage; // null إذا ما في عرض

  TraderProduct({
    required this.id,
    required this.name,
    required this.type,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.farmerName,
    required this.farmerLocation,
    required this.farmerNumber,
    required this.farmerEmail,
    this.discountPercentage,
  });

  factory TraderProduct.fromjson(Map<String, dynamic> json) {
    return TraderProduct(
        id: json['id'],
        name: json['name'],
        type: json['type'],
        imageUrl: json['image'],
        price: json["price"],
        quantity: json['quantity'],
        farmerName: json['farmername'],
        farmerLocation: json['farmerlocation'],
        farmerEmail: json['farmeremail'],
        farmerNumber: json['farmernumber'],
        discountPercentage: json['discount']);
  }
}

class FarmerProducts {}

class Farmer {
  final String id;

  final String name;
  final String location;
  final int number;
  final String email;

  Farmer(
      {required this.id,
      required this.name,
      required this.location,
      required this.number,
      required this.email});

  factory Farmer.fromjson(Map<String, dynamic> json) {
    return Farmer(
        id: json['id'],
        name: json['name'],
        location: json['location'],
        number: json['number'],
        email: json['email']);
  }
}
