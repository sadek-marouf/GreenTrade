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
    on<ResetAddProductState>((event, emit) {
      emit(ProductsInitial());
    });
  }

  Future<void> _onFetch(fetchProducts event,
      Emitter<ProductsState> emit) async {
    emit(ProductsLoading());
    try {
      final list = await repo.fetchProductNamesByType(event.category);
      emit(ProductsLoaded(list));
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
        priceofkilo: event.priceofkilo,

        quantity: event.quantity,
        image: event.image! ,
        discount: event.discount,
      );
      emit(AddProductLoaded());
    } catch (e) {
      print(e);
      emit(AddProductError(e.toString()));
    }
  }

}