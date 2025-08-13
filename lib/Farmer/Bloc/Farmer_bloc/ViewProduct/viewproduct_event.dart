part of 'viewproduct_bloc.dart';

@immutable
sealed class ViewproductEvent {}
class GetProducts extends ViewproductEvent{}
class RefreshProducts extends ViewproductEvent {}