import 'dart:convert';

import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../Service/framwork.dart';





part 'viewproduct_event.dart';
part 'viewproduct_state.dart';

class ViewproductBloc extends Bloc<ViewproductEvent, ViewproductState> {
  ViewproductBloc() : super(ViewproductInitial()) {

    on<GetProducts>(_Viewproduct);
  }
  Future<void> _Viewproduct(
      ViewproductEvent event ,
      Emitter<ViewproductState> emit
      ) async {
    emit(ViewProductLoading()) ;

    try{
      final fakeProducts = [
       {  'category' : "fruit",
         'id' : 20 ,
         'name' : "tomatom" ,
         "price" : 21.0 ,
         "quantity" : 25.0,
         "image" : "images/farmer.jpg"
       },
        {  'category' : "veg",
          'id' : 35 ,
          'name' : "tomatom" ,
          "price" : 21.0 ,
          "quantity" : 25.0,
          "image" : "images/farmer.jpg"
        },
        {  'category' : "fruit",
          'id' : 45 ,
          'name' : "tomatom" ,
          "price" : 21.0 ,
          "quantity" : 25.0,
          "image" : "images/farmer.jpg" ,
          "discount": 20.3
        } ,
        { 'category' : "veg",
          'id' : 85 ,
          'name' : "tomatom" ,
          "price" : 21.0 ,
          "quantity" : 25.0,
          "image" : "images/farmer.jpg" ,
          "discount": 20.3
        },
        {  'category' : "veg",
          'id' : 75 ,
          'name' : "tomamtom" ,
          "price" : 21.0 ,
          "quantity" : 25.0,
          "image" : "images/farmer.jpg" ,
          "discount": 30.3
        },
        {  'category' : "fruit",
          'id' : 65 ,
          'name' : "tomasdmtom" ,
          "price" : 21.0 ,
          "quantity" : 25.0,
          "image" : "images/farmer.jpg" ,
          "discount": 30.3
        },
        {  'category' : "veg",
          'id' : 55 ,
          'name' : "tomsdfamtom" ,
          "price" : 21.0 ,
          "quantity" : 25.0,
          "image" : "images/farmer.jpg" ,
          "discount": 30.3
        }
      ];
      // final response =await http.get(
      //   Uri.parse("__________________API_________________") ,
      //       headers: {
      //         'Authorization': 'Token',
      //         'Accept': 'application/json',
      //
      // }
      // );
      // if (response.statusCode ==201 ){
      //   final List<dynamic> data = jsonDecode(response.body);
      //   final products = data.map((e) => Products.fromjson(e)).toList();
      final Get_products = fakeProducts.map((e) => Get_Products.fromjson(e)).toList();
      emit(ViewProductLoaded(Get_products));


    } catch (e) {
      emit(ViewProductError('Error: ${e.toString()}'));
    }
  }


    }


