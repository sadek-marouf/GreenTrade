import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';
import '../../Farmer/Service/framwork.dart';
import '../Service/Service.dart';


part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final Dio dio;

  OrderBloc({required this.dio}) : super(OrderInitial()) {
    on<CreateOrderEvent>(_onCreateOrder);
  }

  Future<void> _onCreateOrder(
      CreateOrderEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoading());

    try {
      final response = await dio.post(
        'http://$ip:8000/api/store-order', // غيّرها حسب رابط الـ API
        data: {
          "farmer_id": event.farmerId,
          "products": event.products
              .map((p) => {
            "id": p["id"],
            "quantity": p["quantity"],
          })
              .toList(),
        },
        options: Options(
          headers: {
            "Authorization": "Bearer ${event.token}",
          },
        ),
      );

      if (response.statusCode == 201) {
        print("======================================================${response.statusCode}");
        final order = OrderModel.fromJson(response.data['order']);
        emit(OrderSuccess(order: order));
      } else {
        emit(OrderFailure(message: "حدث خطأ غير متوقع"));
      }
    } catch (e) {
      print("======================================================${e}");

      emit(OrderFailure(message: e.toString()));
    }
  }
}
