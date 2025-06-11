import 'dart:convert';
import 'dart:ffi';

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
///////////////////

class Products {

  final String category ;
  final String name;
  final double price;
  final double quantity;
  final double? discount;
  final String image;


  Products({

    required this.category,
    required this.name,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.image,
  });
  factory Products.fromjson(Map<String,dynamic>json){
    return Products(

      category: json['catecory'],
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
      discount: json['discount'],
      image: json['image']

    ) ;
  }






}
///////////////////

class Get_Products {

  final   category ;
  final int id ;
  final String name;
  final double price;
  final double quantity;
  final double? discount;
  final String image;


  Get_Products({

    required this.category,
    required this.id ,
    required this.name,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.image,
  });
  factory Get_Products.fromjson(Map<String,dynamic>json){
    return Get_Products(

        category: json['category'],
        id: json['id'],
        name: json['name'],
        price: json['price'],
        quantity: json['quantity'],
        discount: json['discount'],
        image: json['image']

    ) ;
  }






}
