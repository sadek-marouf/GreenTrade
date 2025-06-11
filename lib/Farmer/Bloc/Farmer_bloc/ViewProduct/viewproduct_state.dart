part of 'viewproduct_bloc.dart';

@immutable
sealed class ViewproductState {}

final class ViewproductInitial extends ViewproductState {}
class ViewProductLoading extends ViewproductState {}

class ViewProductLoaded extends ViewproductState{
  final List<Get_Products> Get_products;

  ViewProductLoaded(this.Get_products);
}

class ViewProductError extends ViewproductState {
  final String message;

  ViewProductError(this.message);
}

