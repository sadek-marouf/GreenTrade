part of 'visitfarmer_bloc.dart';

@immutable
sealed class VisitfarmerState {}

final class VisitfarmerInitial extends VisitfarmerState {}
class VisitfarmerLoading extends VisitfarmerState{}
class VisitfarmerLoaded extends VisitfarmerState{
  final TraderProduct products ;
  VisitfarmerLoaded(this.products) ;
}
class VisitfarmerError extends VisitfarmerState{
  String Message ;
  VisitfarmerError(this.Message)  ;
}