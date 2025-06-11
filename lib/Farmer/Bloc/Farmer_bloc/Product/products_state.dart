part of 'products_bloc.dart';

@immutable
sealed class ProductsState {}

final class ProductsInitial extends ProductsState {}
class ProductsLoading extends ProductsState{}
class ProductsLoaded extends ProductsState {
  final List<Product> products;
  ProductsLoaded(this.products);
}
class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}

class AddProductLoading extends ProductsState{}
class AddProductLoaded extends ProductsState{}
class AddProductError extends ProductsState{
  final String message;
  AddProductError(this.message);
}