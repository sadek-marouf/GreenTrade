part of 'farmers_bloc.dart';

@immutable
sealed class FarmersEvent {}
class FetchFarmers extends FarmersEvent {}
class SearchProduct extends FarmersEvent {
  final String type;
  final String name;

  SearchProduct({required this.type, required this.name});
}