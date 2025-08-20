import 'package:flutter/foundation.dart';

import '../../Farmer/Service/framwork.dart';

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
class Product {
  final int id;
  final String name;
  final String category;
  final String? description;
  final int quantity;
  final double priceOfKilo;
  final double totalPrice;
  final int discount;
  final String? url;

  Product({
    required this.id,
    required this.name,
    required this.category,
    this.description,
    required this.quantity,
    required this.priceOfKilo,
    required this.totalPrice,
    required this.discount,
    this.url,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    final rawUrl = json['url']?.toString() ?? '';
    final imageUrl = rawUrl.startsWith('http')
        ? rawUrl
        : "http://$ip:8000/storage/$rawUrl";
    return Product(
      id: json['id'] ?? 0,  // قيمة افتراضية لو null
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      description: json['description'],
      quantity: json['quantity'] ?? 0,
      priceOfKilo: json['price_of_kilo'] != null
          ? double.tryParse(json['price_of_kilo'].toString()) ?? 0.0
          : 0.0,
      totalPrice: json['total_price'] != null
          ? double.tryParse(json['total_price'].toString()) ?? 0.0
          : 0.0,
      discount: json['discount'] ?? 0,
      url: imageUrl.isNotEmpty ? imageUrl : "https://via.placeholder.com/150",
    );
  }
}


class Farmerd {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? governorate;
  final String city;
  final String? village;
  final List<Product> products;

  Farmerd({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.governorate,
    required this.city,
    this.village,
    required this.products,
  });

  factory Farmerd.fromJson(Map<String, dynamic> json) {
    return Farmerd(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phone: json['phone'],
      governorate: json['governorate'],
      city: json['city'],
      village: json['Village'],
      products: (json['products'] as List)
          .map((e) => Product.fromJson(e))
          .toList(),
    );
  }
}
class ProductModel {
  final int id;
  final String name;
  final String category;
  final String description;
  final double quantity;
  final double priceOfKilo;
  final double totalPrice;
  final String? url;

  ProductModel({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.quantity,
    required this.priceOfKilo,
    required this.totalPrice,
    this.url,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      description: json['description'],
      quantity: (json['quantity'] as num).toDouble(),
      priceOfKilo: double.parse(json['price_of_kilo'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
      url: json['url'],
    );
  }
}

class OrderItemModel {
  final int id;
  final int orderId;
  final int productId;
  final double kilos;
  final double pricePerKilo;
  final double totalPrice;
  final ProductModel product;

  OrderItemModel({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.kilos,
    required this.pricePerKilo,
    required this.totalPrice,
    required this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      orderId: json['order_id'],
      productId: json['product_id'],
      kilos: double.parse(json['kilos'].toString()),
      pricePerKilo: double.parse(json['price_per_kilo'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
      product: ProductModel.fromJson(json['product']),
    );
  }
}

class OrderModel {
  final int id;
  final int traderId;
  final int farmerId;
  final double totalPrice;
  final String status;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.traderId,
    required this.farmerId,
    required this.totalPrice,
    required this.status,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      traderId: json['trader_id'],
      farmerId: int.parse(json['farmer_id'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
      status: json['status'],
      items: (json['items'] as List)
          .map((e) => OrderItemModel.fromJson(e))
          .toList(),
    );
  }
}
