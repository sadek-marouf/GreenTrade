import 'dart:convert';


import 'package:http/http.dart' as http;

import 'framwork.dart';

class ProductServier{
  final String baseUrl="-----------API-------------" ;
  Future<List<Get_Products>> getUserProducts(String token) async{
    final url = Uri.parse("$baseUrl/user/products") ;
    final resposne = await http.get(
      url ,
      headers: {
        'Authorization' : 'Bearer $token' ,
        'Accept' : 'application',
      },
    );
    if(resposne.statusCode == 201 ){
      final List data =json.decode(resposne.body);
      return data.map((json) => Get_Products.fromjson(json)).toList() ;
    }
  else {
  throw Exception('Failed to load products');
  }


  }
}