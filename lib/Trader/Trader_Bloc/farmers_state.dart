part of 'farmers_bloc.dart';

@immutable
sealed class FarmersState {}

final class FarmersInitial extends FarmersState {}


class FarmersLoading extends FarmersState {}

class FarmersLoaded extends FarmersState {
  final List<Farmerd> farmers;

  FarmersLoaded(this.farmers);
}

class FarmersError extends FarmersState {
  final String message;

  FarmersError(this.message);
}
class SearchProductLoading extends FarmersState {}

class SearchProductLoaded extends FarmersState {
  final List<Farmerd> farmers;

  SearchProductLoaded(this.farmers);
}

class SearchProductError extends FarmersState {
  final String message;

  SearchProductError(this.message);
}
