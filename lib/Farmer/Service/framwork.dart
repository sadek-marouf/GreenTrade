import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class coboutton extends StatelessWidget {

  final String text;

  final Color bgcolor;

  final Color textcolor;

  coboutton(
      {super.key, required this.text, required this.bgcolor, required this.textcolor});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: bgcolor,

          foregroundColor: textcolor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {},
        child: Text(text, style: const TextStyle(fontSize: 18)),
      ),
    );;
  }
}


class Costmer extends StatefulWidget {
  final String? namee;
  final String? title;
  final IconData? iconn;
  final TextInputType textInputType;
  final bool isPassword;
  final Color? ccolor ;

  final TextEditingController controler;

// إضافة وسيط لنوع الإدخال

  const Costmer({
    Key? key,
   this.ccolor = Colors.blue,
    required this.iconn,
    required this.controler,
    this.namee = '',
    required this.title,

    this.textInputType = TextInputType
        .text, this.isPassword = false,  // قيمة افتراضية لنوع الإدخال
  }) : super(key: key);

  @override
  State<Costmer> createState() => _CostmerState();
}

class _CostmerState extends State<Costmer> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 5),
            // child: Text(
            //   "${widget.title}",
            //   style: const TextStyle(
            //       color: Colors.black,
            //       fontSize: 20,
            //       fontWeight: FontWeight.bold),
            // ),
          ),
          Container(
            height: 70,
            child: TextFormField(
              controller: widget.controler,
              obscureText: widget.isPassword,
              keyboardType: widget.textInputType, // استخدام الوسيط هنا
              decoration: InputDecoration(

                fillColor: Colors.white,
                labelText: widget.title,
                labelStyle: TextStyle(fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
                filled: true,
                prefixIcon: Icon(
                  widget.iconn,
                  color: widget.ccolor,
                  size: 30,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color.fromARGB(255, 197, 103, 97),
                    width: 5,
                  ),
                ),
                focusColor: Colors.green[600],
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                  borderRadius: BorderRadius.circular(60),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}




/////////////////
class Product {
  final int id;
  final String name;

  Product({required this.id, required this.name});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
    );
  }

}

class Get_Products {
  final String category ;
  final int id;
  final String name;
  final double price;
  final double quantity;
  final double? discount;
  final String? description;
  final String image;

  Get_Products( {
    required this.category,
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.description,
    required this.image,
  });

  factory Get_Products.fromJson(Map<String, dynamic> json) {
    final rawUrl = json['url']?.toString() ?? '';
    final imageUrl = rawUrl.startsWith('http')
        ? rawUrl
        : "http://$ip:8000/storage/$rawUrl";
    print("Raw URL: $rawUrl");
    print("Final image URL: $imageUrl");
    return Get_Products(
      id: json['id'],
      name: json['name'].toString(),
      category: json['category'],
      price: double.tryParse(json['total_price'].toString()) ?? 0.0,
      quantity: double.tryParse(json['quantity'].toString()) ?? 0.0,
      description: json['description'],
      discount: json['discount'] != null
          ? double.tryParse(json['discount'].toString())
          : null,
      image: imageUrl.isNotEmpty ? imageUrl : "https://via.placeholder.com/150",


    )
    ;
  }
}
class Prdbycategory {
  final String category;
  final String name;
  final String image;

  Prdbycategory({
    required this.name,
    required this.image,
    required this.category,
  });

  factory Prdbycategory.fromJson(Map<String, dynamic> json) {
    return Prdbycategory(
      category: json['category_name'] ?? '',
      name: json['product_name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
class UpdateProductModel {
  final int id; // لازم لإرسال المعرف
  final String? idCategory;
  final String? name;
  final double? price;
  final double? quantity;
  final double? discount;
  final File? image;

  UpdateProductModel({
    required this.id,
    this.idCategory,
    this.name,
    this.price,
    this.quantity,
    this.discount,
    this.image,
  });

  // تحويل البيانات إلى Map مع حذف القيم null (حتى لا ترسلها)
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (idCategory != null) data['idCategory'] = idCategory;
    if (name != null) data['name'] = name;
    if (price != null) data['price'] = price;
    if (quantity != null) data['quantity'] = quantity;
    if (discount != null) data['discount'] = discount;
    // الصورة تحتاج تعامل خاص لأنها File مش نص عادي
    return data;
  }
}

String ip = "10.39.131.169" ;