import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';

import '../../../Service/framwork.dart';
import '../../../Service/repositories/products_repository.dart';




part 'edit_product_event.dart';
part 'edit_product_state.dart';
// class EditProductBloc extends Bloc<EditProductEvent, EditProductState> {
//   final ProductsRepository productRepository;
//
//   EditProductBloc(this.productRepository) : super(EditProductInitial()) {
//     on<GetIdProduct>((event, emit) async {
//       emit(GetIdProductLoading());
//
//       // ننتظر شوي حتى يظهر الـ Loading
//       await Future.delayed(Duration(seconds: 1));
//
//       // بيانات وهمية لغرض الاختبار
//       final dummyProduct = Get_Products(
//         id: event.productId,
//         name: 'Test Apple',
//         image: 'images/farmer.jpg', // صورة وهمية
//         category: 'fruit',
//         quantity: 30.0,
//         price: 70.0,
//         discount: 15.0,
//       );
//
//       emit(GetIdProductLoaded(dummyProduct));
//     });
//   }
// }


class EditProductBloc extends Bloc<EditProductEvent, EditProductState> {
  final ProductsRepository productRepository;
  EditProductBloc(this.productRepository) : super(EditProductInitial()) {
    on<GetIdProduct>((event, emit) => ongetidproduct(event, emit));
    on<UpdateProductEvent>(_onAdd);  //
    on<DeleteProductEvent>(_ondelet) ;
  }

  Future<void> ongetidproduct(
      GetIdProduct event , Emitter<EditProductState> state
      ) async{
    emit(GetIdProductLoading());
    try{
      final Get_Products product =await productRepository.GetIdProduct(event.productId);
      emit(GetIdProductLoaded(product  ));
    }catch(e){emit(GetIdProductError('Failed to load product: ${e.toString()}'));}

}
  Future<void> _onAdd(UpdateProductEvent event, Emitter<EditProductState> emit) async {
    emit(UpdateProductLoading());
    try {
      await productRepository.addEditProduct(
        idCategory: event.id_category,

        nameProduct: event.name,
        price: event.price,
        quantity: event.quantity,
        image: event.imageFile! ,
        discount: event.discount, id: event.id,
      );
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
