import 'dart:convert';
import 'dart:io';


import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Service.dart';


class TraderRepo {
  final http.Client client;
  TraderRepo(this.client) ;
  Future<List<TraderProduct>> GetListProduct()async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse("___________________API TO GET FARMER_________________");
    final res = await client.get(url , headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if(res.statusCode == 201){
      final list = jsonDecode(res.body) as List;
      return list.map((json) => TraderProduct.fromjson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }


  Future<List<TraderProduct>> searchProducts(String keyword) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse("https://your.api/search?query=$keyword");

    final response = await client.get(url, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as List;
      return data.map((e) => TraderProduct.fromjson(e)).toList();
    } else {
      throw Exception('Failed to search products');
    }
  }


}