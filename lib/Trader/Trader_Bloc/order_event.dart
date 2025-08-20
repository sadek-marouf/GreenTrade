part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

class CreateOrderEvent extends OrderEvent {
  final int farmerId;
  final List<Map<String, dynamic>> products;
  final String token;

  CreateOrderEvent({
    required this.farmerId,
    required this.products,
    required this.token,
  });
}
