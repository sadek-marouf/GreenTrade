import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../framwork.dart';








class ProductsRepository {
  final http.Client client;
  ProductsRepository(this.client);

  Future<List<Product>> fetchByCategory(String category) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('https://yourdomain.com/api/products?category=$category');
    final res = await client.get(url , headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (res.statusCode == 201) {

      final list = jsonDecode(res.body) as List;
      return list.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
  Future<void> addProduct({
    required String idCategory,

    required String nameProduct,
    required double price,
    required double quantity,
    required File image,
    int? discount,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final uri = Uri.parse('https://example.com/api/add_product') ;


    final request = http.MultipartRequest('POST', uri ) ;
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['id_category'] = idCategory;

    request.fields['name_product'] = nameProduct;
    request.fields['price'] = price.toString();
    request.fields['quantity'] = quantity.toString();

    if (discount != null) {
      request.fields['discount'] = discount.toString();
    }

    final fileStream = http.ByteStream(image.openRead());
    final length = await image.length();
    final multipartFile = http.MultipartFile(
      'image',
      fileStream,
      length,
      filename: image.path.split('/').last,
    );

    request.files.add(multipartFile);
    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to add product');
    }
  }
  Future<Get_Products> GetIdProduct (
      int id
      ) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(Uri.parse("__________________API__________________"),headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',

    });
    if(response.statusCode == 200){
      final data = jsonDecode(response.body) ;
      return Get_Products.fromjson(data) ;
    }
    else{throw Exception('Failed to load product');}
  }
  Future<void> addEditProduct({
    required String idCategory,
    required int id ,

    required String nameProduct,
    required double price,
    required double quantity,
    required File image,
    double? discount,
  }) async {
    final uri = Uri.parse('https://example.com/api/add_product' );

    final request = http.MultipartRequest('POST', uri );
    request.fields['id_category'] = idCategory;
    request.fields['id'] = id as String;
    request.fields['name_product'] = nameProduct;
    request.fields['price'] = price.toString();
    request.fields['quantity'] = quantity.toString();

    if (discount != null) {
      request.fields['discount'] = discount.toString();
    }

    final fileStream = http.ByteStream(image.openRead());
    final length = await image.length();
    final multipartFile = http.MultipartFile(
      'image',
      fileStream,
      length,
      filename: image.path.split('/').last,
    );

    request.files.add(multipartFile);
    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception('Failed to add product');
    }
  }
  Future<void> deleteProduct(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    // مثال استدعاء HTTP لحذف المنتج
    final response = await http.delete(Uri.parse('https://api.example.com/products/$id'),headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }
}

