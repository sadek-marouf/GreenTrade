import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Trader/Service/Service.dart';
import '../framwork.dart';








class ProductsRepository {
  final http.Client client;

  ProductsRepository(this.client);

  Future<List<Prdbycategory>> fetchProductNamesByType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse('http://$ip:8000/api/categories-by-type');

    final res = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'type': type}),
    );

    print('📬 Response status: ${res.statusCode}');
    print('📦 Response body: ${res.body}');


    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      print('📦 Response body: ${res.body}');
      final List productsJson = data['products'];

      return productsJson.map((e) => Prdbycategory.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load product names');
    }
  }

  Future<void> addProduct({
    required String idCategory,

    required String nameProduct,
    required double priceofkilo,

    required double quantity,
    required File image,
    int? discount,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final uri = Uri.parse('http://$ip:8000/api/product/create');


    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['category'] = idCategory;

    request.fields['name'] = nameProduct;
    request.fields['price_of_kilo'] = priceofkilo.toString();

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
      filename: image.path
          .split('/')
          .last,
    );

    request.files.add(multipartFile);
    final response = await request.send();

    if (response.statusCode != 201) {
      print('📬 Response status: ${response.statusCode}');

      throw Exception('Failed to add product');
    }
  }

  Future<Get_Products> GetIdProduct(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
        Uri.parse("http://$ip:8000/api/products/$id}"), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',

    });
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final data = json['product'];
      return Get_Products.fromJson(data);
    }
    else {
      throw Exception('Failed to load product');
    }
  }

  Future<void> addEditProduct({
    required String idCategory,
    required int id,

    required String nameProduct,
    required double price,
    required double quantity,
    required File image,
    double? discount,
  }) async {
    final uri = Uri.parse('http://$ip:8000/api/products/$id/update');
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = nameProduct;
    request.fields['price_of_kilo'] = price.toString();
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
      filename: image.path
          .split('/')
          .last,
    );

    request.files.add(multipartFile);
    final response = await request.send();

    if (response.statusCode != 200) {
      print("Error response: $response");
      throw Exception('Failed to add product');
    }
  }

  Future<void> deleteProduct(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
        Uri.parse('http://$ip:8000/api/products/$id'), headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    if (response.statusCode != 200) {
      print(response.body);
      throw Exception('Failed to delete product');
    }
  }


  Future<Farmerd> visitfarmer(int id) async {

    final responce = await http.get(
        Uri.parse("http://$ip:8000/api/farmer/$id/products"));
    print("=========///////////////////////http://$ip:8000/api/farmer/$id/products");
    if (responce.statusCode == 200) {
      print("=== STATUS CODE: ${responce.statusCode}");
      print("=== RESPONSE BODY: ${responce.body}");


      final decoded = jsonDecode(responce.body); // فكك JSON كامل
      final data = decoded['data'];
      return Farmerd.fromJson(data);
    }
    else {

      print("=========================${responce.body}");
      throw Exception('Failed to load product');
    }
  }

}