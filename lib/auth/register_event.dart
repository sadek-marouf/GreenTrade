part of 'register_bloc.dart';

@immutable
sealed class RegistrationEvent {}

class SubmitRegistrationEvent extends RegistrationEvent {}

