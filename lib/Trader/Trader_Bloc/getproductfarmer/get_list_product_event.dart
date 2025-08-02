part of 'get_list_product_bloc.dart';

@immutable
sealed class GetListProductEvent {}
class GetList extends GetListProductEvent{}
class SearchProducts extends GetListProductEvent {
  final String query;
  SearchProducts(this.query);
}