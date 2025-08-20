part of 'order_bloc.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}

final class OrderLoading extends OrderState {}

final class OrderSuccess extends OrderState {
  final OrderModel order;

  OrderSuccess({required this.order});
}

final class OrderFailure extends OrderState {
  final String message;

  OrderFailure({required this.message});
}
