import 'dart:convert';
import 'dart:io';
import 'package:farm1/Trader/Trader_Bloc/GetFarmer_bloc/getfarmer_bloc.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Service.dart';


class TraderRepo {
  final http.Client client;
  TraderRepo(this.client) ;
  Future<List<Farmer>> GetListFarmer()async{
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse("___________________API TO GET FARMER_________________");
    final res = await client.get(url , headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });
    if(res.statusCode == 201){
    final  list  =jsonDecode(res.body ) as List;
    return list.map((e)=> Farmer.fromjson(e)).toList() ;




    }
    else {
      throw Exception('Failed to load products');
    }
  }
}