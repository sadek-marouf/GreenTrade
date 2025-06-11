part of 'getfarmer_bloc.dart';

@immutable
sealed class GetfarmerState {}

final class GetFarmerInitial extends GetfarmerState {}
class GetFarmerLoading extends GetfarmerState{}

class GetFarmerLoaded extends GetfarmerState{
 final List<Farmer> Get_Farmer ;
 GetFarmerLoaded(this.Get_Farmer);

}
class GetFarmerError extends GetfarmerState {
  final String Error ;
  GetFarmerError(this.Error) ;
}
