import 'dart:io';

import 'package:bloc/bloc.dart';

import 'package:meta/meta.dart';

import '../../../Service/framwork.dart';
import '../../../Service/repositories/products_repository.dart';



part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsRepository repo;

  ProductsBloc(this.repo) : super(ProductsInitial()) {
    on<fetchProducts>(_onFetch);
    on<Addproduct>(_onAdd);
  }

  Future<void> _onFetch(fetchProducts event,
      Emitter<ProductsState> emit) async {
    emit(ProductsLoading());
    try {
      final list = await repo.fetchByCategory(event.category);
      emit(ProductsLoaded(list.cast<Product>()));
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  Future<void> _onAdd(Addproduct event, Emitter<ProductsState> emit) async {
    emit(AddProductLoading());
    try {
      await repo.addProduct(
        idCategory: event.id_category,

        nameProduct: event.name_product,
        price: event.price,
        quantity: event.quantity,
        image: event.image! ,
        discount: event.discount,
      );
      emit(AddProductLoaded());
    } catch (e) {
      emit(AddProductError(e.toString()));
    }
  }

}