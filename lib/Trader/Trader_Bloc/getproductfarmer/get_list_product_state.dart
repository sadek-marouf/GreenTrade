part of 'get_list_product_bloc.dart';

@immutable
sealed class GetListProductState {}

final class GetListProductInitial extends GetListProductState {}
class GetListProductLoading extends GetListProductState{}
class GetListProductLoaded extends GetListProductState{
final List<TraderProduct> Tproducts ;
GetListProductLoaded(this.Tproducts);
}
class GetListProductError extends GetListProductState{
  final String message  ;
  GetListProductError(this.message) ;
}