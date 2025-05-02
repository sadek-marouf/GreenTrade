part of 'counter_bloc.dart';

@immutable
abstract class RegistrationState {}

class RegisterInitial extends RegistrationState {}
class RegisterLoading extends RegistrationState {}
class RegisterSuccess extends RegistrationState {}
class RegisterError extends RegistrationState {
  final String message;
  RegisterError(this.message);
}

