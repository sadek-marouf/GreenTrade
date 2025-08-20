import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Trader/veg.dart';
import '../Trader/tfruit.dart';
import '../Trader/Service/Service.dart';
import 'Trader_Bloc/getproductfarmer/visitfarmer_bloc.dart';
import 'Trader_Bloc/order_bloc.dart';
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverTabBarDelegate(this.child);

  @override
  double get minExtent => _getChildHeight();
  @override
  double get maxExtent => _getChildHeight();

  double _getChildHeight() {
    if (child is PreferredSizeWidget) {
      return (child as PreferredSizeWidget).preferredSize.height;
    }
    return kToolbarHeight; // قيمة افتراضية
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}



class FarmerDetailsPage extends StatelessWidget {

  final int farmerId;
  const FarmerDetailsPage({super.key, required this.farmerId});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
    length: 2,
    child: Scaffold(
      backgroundColor: Colors.lightGreen.shade200,
      appBar: AppBar(
        title: const Text("المزارع"),
        backgroundColor: Colors.lightGreen,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: BlocBuilder<VisitfarmerBloc, VisitfarmerState>(
        builder: (context, state) {
          if (state is VisitfarmerLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is VisitfarmerError) {
            return Center(child: Text('Error: ${state.Message}'));
          }
          if (state is VisitfarmerLoaded) {
            final farmer = state.farmer;
            final discounted = farmer.products.where((p) => p.discount > 0).toList();
            final vegetables = farmer.products.where((p) => p.category.toLowerCase() == 'vegetables').toList();
            final fruits = farmer.products.where((p) => p.category.toLowerCase() == 'fruit').toList();

            return Column(
              children: [
                Expanded(
                  child: NestedScrollView(
                    headerSliverBuilder: (context, _) {
                      return [
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              // ----- معلومات المزارع -----
                              Container(
                                padding: const EdgeInsets.all(16.0),
                                margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 45,
                                      backgroundImage: NetworkImage(
                                        farmer.products.isNotEmpty && farmer.products.first.url != null
                                            ? farmer.products.first.url!
                                            : "https://i.imgur.com/BoN9kdC.png",
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${farmer.firstName} ${farmer.lastName}",
                                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(Icons.phone, size: 18, color: Colors.green),
                                              const SizedBox(width: 6),
                                              Text(farmer.phone, style: const TextStyle(fontSize: 16)),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.email, size: 18, color: Colors.green),
                                              const SizedBox(width: 6),
                                              Text(farmer.email, style: const TextStyle(fontSize: 16)),
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on, size: 18, color: Colors.green),
                                              const SizedBox(width: 6),
                                              Text("${farmer.city} ${farmer.governorate ?? ''}", style: const TextStyle(fontSize: 16)),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              // ----- قسم العروض -----
                              if (discounted.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        ' العروض 🔥',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green.shade900,
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {

                                        },
                                        child: Text(
                                          "عرض الكل",
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green.shade900,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              if (discounted.isNotEmpty)
                                CarouselSlider(
                                  options: CarouselOptions(
                                    height: 160,
                                    viewportFraction: 0.85,
                                    enlargeCenterPage: true,
                                    autoPlay: true,
                                    autoPlayInterval: const Duration(seconds: 4),
                                  ),
                                  items: discounted.map((product) {
                                    final discountedPrice = (product.totalPrice * (1 - product.discount / 100));
                                    return InkWell(
                                      onTap: () {
                                        print(context);
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (_) {
                                            return BlocProvider.value(
                                              value: context.read<OrderBloc>(), // 👈 تمرير OrderBloc
                                              child: DetailsBottomSheetTrader(
                                                prod: product,
                                                farmerid: farmer.id,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                      child: Card(
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        margin: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Row(
                                          children: [
                                            Stack(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
                                                  child: Image.network(
                                                    product.url ?? '',
                                                    width: 150,
                                                    height: 150,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 8,
                                                  right: 8,
                                                  child: Container(
                                                    padding: const EdgeInsets.all(4),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.circular(8),
                                                    ),
                                                    child: Text(
                                                      "-${product.discount}%",
                                                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(12.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,

                                                  children: [
                                                    Text(product.name,
                                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                                    const SizedBox(height: 10),
                                                    Row(children: [
                                                      Text("سعر الكيلو :  ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),


                                                      SizedBox(width: 10,),
                                                      Text(
                                                        discountedPrice.toStringAsFixed(0),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.green.shade800,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],),
                                                    const SizedBox(height: 10),
                                                    Row(children: [
                                                      Text("السعر :  ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),

                                                      Text(
                                                        '${product.priceOfKilo}',
                                                        style: const TextStyle(
                                                          decoration: TextDecoration.lineThrough,
                                                          fontSize: 16,
                                                          color: Colors.green,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10,),
                                                      Text(
                                                        discountedPrice.toStringAsFixed(0),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.green.shade800,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],),
                                                    SizedBox(height: 10,),
                                                    Row(children: [
                                                      Text("الكمية :  ",style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold))
                                                      ,Text(" Kg ",style: TextStyle(fontSize: 12,color: Colors.green),)
                                                      ,Text(product.quantity.toString(), style: TextStyle(
                                                        fontSize: 15,
                                                        color: Colors.green,
                                                        fontWeight: FontWeight.bold,
                                                      ),),
                                                    ],)
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              SizedBox(height: 20,)
                            ],
                          ),
                        ),

                        SliverPersistentHeader(
                          pinned: true,
                          delegate: _SliverTabBarDelegate(
                            TabBar(
                              indicatorColor: Colors.green,
                              labelColor: Colors.green,
                              tabs: [
                                Tab(text: 'الخضار 🥦'),
                                Tab(text: 'الفواكه 🍎'),
                              ],
                            ),
                          ),
                        ),
                      ];
                    },
                    body: TabBarView(
                      children: [
                        Vegetables(products: vegetables ,farmerid: farmerId,),
                        Fruits(products: fruits , farmerid: farmerId,),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    ),
    );
    ;
  }
}


class DetailsBottomSheetTrader extends StatelessWidget {
  final Product prod;
  final int farmerid;

  const DetailsBottomSheetTrader({
    super.key,
    required this.prod,
    required this.farmerid,
  });

  @override
  Widget build(BuildContext context) {
    // تحديد صورة المنتج
    final imageUrl = (prod.url != null && prod.url!.isNotEmpty)
        ? prod.url!
        : "https://via.placeholder.com/150";

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // صورة المنتج
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.lightGreen, width: 3),
                borderRadius: BorderRadius.circular(22),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // الاسم + السعر (+ خصم إن وجد)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  prod.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (prod.discount > 0) // فقط إذا فيه خصم
                  Row(
                    children: [
                      Text(
                        "\$${(prod.totalPrice * (1 - prod.discount / 100)).toStringAsFixed(2)}",
                        style: const TextStyle(
                            fontSize: 18, color: Colors.orange),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.keyboard_double_arrow_right,
                          color: Colors.green),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          "-${prod.discount}%",
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // تفاصيل (كمية – سعر الكيلو – السعر الكلي)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // الكمية
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Text(" Kg",
                              style: TextStyle(color: Colors.green)),
                          Text(prod.quantity.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("الكمية",
                        style: TextStyle(
                            color: (prod.category.toLowerCase() == "veg")
                                ? Colors.green
                                : Colors.yellow[700],
                            fontSize: 18)),
                  ],
                ),

                // سعر الكيلو
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          const Text("SYP  ",
                              style: TextStyle(color: Colors.green)),
                          Text(prod.priceOfKilo.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text("سعر الكيلو",
                        style: TextStyle(
                            color: (prod.category.toLowerCase() == "veg")
                                ? Colors.green
                                : Colors.yellow[700],
                            fontSize: 18)),
                  ],
                ),

                // السعر الكلي
                Column(
                  children: [
                    if (prod.discount > 0) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          "\$${prod.totalPrice}",
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("السعر الكلي",
                          style: TextStyle(
                              color: (prod.category.toLowerCase() == "veg")
                                  ? Colors.green
                                  : Colors.yellow[700],
                              fontSize: 18)),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Text("SYP  ",
                                style: TextStyle(color: Colors.green)),
                            Text(
                              prod.totalPrice.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("السعرالكلي",
                          style: TextStyle(
                              color: (prod.category.toLowerCase() == "veg")
                                  ? Colors.green
                                  : Colors.yellow[700],
                              fontSize: 18)),
                    ]
                  ],
                )
              ],
            ),

            const SizedBox(height: 24),

            // الوصف
            if (prod.description != null && prod.description!.isNotEmpty) ...[
              Container(
                width: 300,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(width: 2, color: Colors.green),
                ),
                child: Center(
                  child: Text(
                    prod.description!,
                    style:
                    const TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],

            // زر الإضافة للسلة
            SizedBox(
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  _showQuantityDialog(context, prod, farmerid);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD6F5C9),
                  foregroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text("أضف لسلة"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


void _showQuantityDialog(BuildContext context, Product prod, int farmerId) {
  final parentContext = context; // 👈 هذا هو الـ context يلي فيه الـ Bloc
  final TextEditingController qtyController =
  TextEditingController(text: "1");

  showDialog(
    context: context,
    builder: (dialogContext) {
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
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("إلغاء"),
          ),
          ElevatedButton(
            onPressed: () async {
              final int quantity = int.tryParse(qtyController.text) ?? 1;

              // جلب التوكن
              final prefs = await SharedPreferences.getInstance();
              final token = prefs.getString("token") ?? "";

              if (token.isEmpty) {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  const SnackBar(content: Text("لم يتم العثور على التوكن")),
                );
                return;
              }

              // استعمل parentContext (اللي فيه الـ Bloc)
              parentContext.read<OrderBloc>().add(
                CreateOrderEvent(
                  farmerId: farmerId,
                  products: [
                    {"id": prod.id, "quantity": quantity},
                  ],
                  token: token,
                ),
              );

              Navigator.pop(dialogContext);
            },
            child: const Text("تأكيد"),
          ),
        ],
      );
    },
  );
}
