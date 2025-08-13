import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Service/framwork.dart';
import '../../../Service/repositories/products_repository.dart';

import 'package:http/http.dart' as http;


part 'edit_product_event.dart';
part 'edit_product_state.dart';



class EditProductBloc extends Bloc<EditProductEvent, EditProductState> {
  final ProductsRepository productRepository;
  EditProductBloc(this.productRepository) : super(EditProductInitial()) {
    on<GetIdProduct>(ongetidproduct);
    on<UpdateProductEvent>(_onAdd);  //
    on<DeleteProductEvent>(_ondelet) ;
  }

  Future<void> ongetidproduct(
      GetIdProduct event , Emitter<EditProductState> state
      ) async{
    print("[Bloc] Received GetIdProduct(${event.productId})");

    emit(GetIdProductLoading());
    try{
      final Get_Products product =await productRepository.GetIdProduct(event.productId);
      print("[Bloc] Loaded product: ${product.name}");

      emit(GetIdProductLoaded(product  ));
    }catch(e){emit(GetIdProductError('Failed to load product: ${e.toString()}'));}

}
  Future<void> _onAdd(UpdateProductEvent event, Emitter<EditProductState> emit) async {
    emit(UpdateProductLoading());
    try {
      final uri = Uri.parse('http://$ip:8000/api/products/${event.id}/update');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      // فقط أضف الحقول غير الفارغة
      if (event.name != null) {
        request.fields['name'] = event.name!;
      }
      if (event.price != null) {
        request.fields['price_of_kilo'] = event.price!.toString();
      }
      if (event.quantity != null) {
        request.fields['quantity'] = event.quantity!.toString();
      }
      if (event.discount != null) {
        request.fields['discount'] = event.discount!.toString();
      }
      if (event.idCategory != null) {
        request.fields['id_category'] = event.idCategory!;
      }

      // أضف الصورة إذا غيرت
      if (event.imageFile != null) {
        final fileStream = http.ByteStream(event.imageFile!.openRead());
        final length = await event.imageFile!.length();
        final multipartFile = http.MultipartFile(
          'image',
          fileStream,
          length,
          filename: event.imageFile!.path.split('/').last,
        );
        request.files.add(multipartFile);
      }

      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception('Failed to update product');
      }

      emit(UpdateProductSuccess());
    } catch (e) {
      emit(UpdateProductError(e.toString()));
    }
  }

  Future<void> _ondelet(DeleteProductEvent event , Emitter<EditProductState> emit) async {
  emit(DeleteProductLoading());
  try {
  await productRepository.deleteProduct(event.id);
  emit(DeleteProductSuccess());
  } catch (e) {
  emit(DeleteProductError('Failed to delete product: ${e.toString()}'));
  }
  }
}
