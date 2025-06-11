part of 'edit_product_bloc.dart';

@immutable
sealed class EditProductState {}

final class EditProductInitial extends EditProductState {}
class GetIdProductLoading extends EditProductState {}

class GetIdProductLoaded extends EditProductState{
  final  Get_Products product;

  GetIdProductLoaded(this.product);
}

class GetIdProductError extends EditProductState {
  final String message;

  GetIdProductError(this.message);
}


class UpdateProductLoading extends EditProductState {}

class UpdateProductSuccess extends EditProductState {}

class UpdateProductError extends EditProductState {
  final String message;
  UpdateProductError(this.message);
}

class DeleteProductLoading extends EditProductState {}

class DeleteProductSuccess extends EditProductState {}

class DeleteProductError extends EditProductState {
  final String message;
  DeleteProductError(this.message);
}
