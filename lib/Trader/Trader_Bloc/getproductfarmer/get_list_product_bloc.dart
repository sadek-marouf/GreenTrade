import 'package:bloc/bloc.dart';
import 'package:farm1/Trader/Service/Service.dart';
import 'package:meta/meta.dart';

import '../../Service/repositories/Trader_Repo.dart';

part 'get_list_product_event.dart';

part 'get_list_product_state.dart';

class GetListProductBloc
    extends Bloc<GetListProductEvent, GetListProductState> {
  final TraderRepo repo;

  GetListProductBloc(this.repo) : super(GetListProductInitial()) {
    on<GetList>(_ongetlist);
    on<SearchProducts>(_onSearch);
  }

  Future<void> _ongetlist(
    GetListProductEvent event,
    Emitter<GetListProductState> emit,
  ) async {
    emit(GetListProductLoading());

    try {
      //final products = await repo.GetListProduct(); //
      // بيانات ثابتة لتجربة العرض
      await Future.delayed(Duration(seconds: 1)); // محاكاة تأخير الشبكة

      final products = [
        TraderProduct(
          id: 1,
          name: "Red Apple",
          farmerName: "Ali",
          farmerNumber: 099658326541,
          farmerEmail: "alifarmer@gmail.com",
          farmerLocation: "Tartou-Alqadmos",
          quantity: 100,
          price: 2.5,
          type: "Fruits",
          imageUrl: "images/trader.jpg",
          discountPercentage: 10,
        ),
        TraderProduct(
          id: 2,
          name: "Tomato",
          farmerName: "Ahmad",
          farmerNumber: 099658326541,
          farmerEmail: "alifarmer@gmail.com",
          farmerLocation: "Tartou-Alqadmos",
          quantity: 200,
          price: 1.5,
          type: "Vegetables",
          imageUrl: "images/trader.jpg",
          discountPercentage: null,
        ),
        TraderProduct(
          id: 3,
          name: "Banana",
          farmerName: "Sara",
          farmerNumber: 099658326541,
          farmerEmail: "alifarmer@gmail.com",
          farmerLocation: "Tartou-Alqadmos",
          quantity: 80,
          price: 3.0,
          type: "Fruits",
          imageUrl: "images/trader.jpg",
          discountPercentage: 15,
        ),
      ];
      emit(GetListProductLoaded(products)); // عرض المنتجات في الواجهة
    } catch (e) {
      emit(GetListProductError(e.toString())); // في حال حدوث خطأ
    }
  }
  Future<void> _onSearch(
      SearchProducts event,
      Emitter<GetListProductState> emit,
      ) async {
    emit(GetListProductLoading());
    try {
     // final filtered = await repo.searchProducts(event.query);
      final allProducts = [
        TraderProduct(
          id: 1,
          name: "Red Apple",
          farmerName: "Ali",
          farmerNumber: 099658326541,
          farmerEmail: "alifarmer@gmail.com",
          farmerLocation: "Tartou-Alqadmos",
          quantity: 100,
          price: 2.5,
          type: "Fruits",
          imageUrl: "images/trader.jpg",
          discountPercentage: 10,
        ),
        TraderProduct(
          id: 2,
          name: "Tomato",
          farmerName: "Ahmad",
          farmerNumber: 099658326541,
          farmerEmail: "alifarmer@gmail.com",
          farmerLocation: "Tartou-Alqadmos",
          quantity: 200,
          price: 1.5,
          type: "Vegetables",
          imageUrl: "images/trader.jpg",
          discountPercentage: null,
        ),
        TraderProduct(
          id: 3,
          name: "Banana",
          farmerName: "Sara",
          farmerNumber: 099658326541,
          farmerEmail: "alifarmer@gmail.com",
          farmerLocation: "Tartou-Alqadmos",
          quantity: 80,
          price: 3.0,
          type: "Fruits",
          imageUrl: "images/trader.jpg",
          discountPercentage: 15,
        ),
      ];

      final filtered = allProducts.where((product) =>
          product.name.toLowerCase().contains(event.query.toLowerCase())).toList();
      emit(GetListProductLoaded(filtered));
    } catch (e) {
      emit(GetListProductError(e.toString()));
    }
  }

}
