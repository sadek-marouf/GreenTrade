part of 'visitfarmer_bloc.dart';

@immutable
sealed class VisitfarmerEvent {}
class VisitFarmer extends VisitfarmerEvent{
  final int id ;
  VisitFarmer(this.id);
}