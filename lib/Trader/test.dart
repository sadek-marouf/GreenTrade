import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Farmer/Service/framwork.dart';
import 'Trader_Bloc/order_bloc.dart';

class ProductItemWidget extends StatelessWidget {
  final Product prod;
  const ProductItemWidget({super.key, required this.prod});

  @override
  Widget build(BuildContext context) {
    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("جاري الإرسال...")),
          );
        } else if (state is OrderSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("تمت إضافة المنتج للسلة ✅")),
          );
        } else if (state is OrderFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("خطأ: ${state.message}")),
          );
        }
      },
      child: SizedBox(
        width: 140,
        child: ElevatedButton(
          onPressed: () {
            _showQuantityDialog(context, prod);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD6F5C9),
            foregroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text("أضف للسلة"),
        ),
      ),
    );
  }

  void _showQuantityDialog(BuildContext context, Product prod) {
    final TextEditingController qtyController = TextEditingController(text: "1");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text("تحديد الكمية"),
          content: TextField(
            controller: qtyController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "أدخل الكمية",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () {
                final int quantity = int.tryParse(qtyController.text) ?? 1;

                // 🔥 استدعاء BLoC
                context.read<OrderBloc>().add(
                  CreateOrderEvent(
                    farmerId: prod.id, // لازم تحط farmerId الصحيح من بياناتك
                    products: [
                      {"id": prod.id, "quantity": quantity},
                    ],
                    token: "ضع_التوكن_هنا", // غيّرها حسب تخزينك للتوكن
                  ),
                );

                Navigator.pop(context);
              },
              child: const Text("تأكيد"),
            ),
          ],
        );
      },
    );
  }
}
