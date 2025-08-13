import 'package:farm1/Farmer/Service/repositories/products_repository.dart';
import 'package:farm1/Trader/visitfarmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'Trader_Bloc/farmers_bloc.dart';

import 'Trader_Bloc/getproductfarmer/visitfarmer_bloc.dart';

class TraderProductsPage extends StatefulWidget {
  @override
  _TraderProductsPageState createState() => _TraderProductsPageState();
}

class _TraderProductsPageState extends State<TraderProductsPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _listAnimationController;

  List<String> searchSuggestions = [];
  Map<int, bool> expandedStates = {};

  @override
  void initState() {
    super.initState();

    context.read<FarmersBloc>().add(FetchFarmers());

    _listAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _listAnimationController.forward();
  }

  @override
  void dispose() {
    _listAnimationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.lightGreen],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text('العروض المتاحة'),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(Icons.shopping_cart)),
            IconButton(onPressed: () {}, icon: Icon(Icons.notifications))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Search + Filter
             InkWell(
               onTap: (){
                 Navigator.of(context).pushNamed('serch');
               },
               child: Container(
                 decoration: BoxDecoration(
                   border: Border.all(color: Colors.black,width: 1)
                   ,borderRadius: BorderRadius.circular(30),
                   color: Colors.lightGreen[400]

                 ),
                 padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                 margin: EdgeInsets.symmetric(vertical: 2,horizontal: 30),
                 child: Row(children: [
                   Icon(Icons.search,color: Colors.white,),SizedBox(width: 20,),Text("ابحث عن منتج " , style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),)
                 ],),
               ),
             ),

              const SizedBox(height: 16),

              Expanded(
                child: BlocBuilder<FarmersBloc, FarmersState>(
                  builder: (context, state) {
                    if (state is FarmersLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FarmersLoaded) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: state.farmers.length,
                        itemBuilder: (context, index) {
                          final farmer = state.farmers[index];
                          final isExpanded = expandedStates[index] ?? false;
                          final topProducts = farmer.products.take(2).toList();

                          return GestureDetector(
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${farmer.firstName} ${farmer.lastName}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.phone,
                                          size: 16, color: Colors.green),
                                      const SizedBox(width: 4),
                                      Text(
                                        farmer.phone ?? 'unknown',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          size: 16, color: Colors.green),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          "${farmer.governorate ?? 'unknown'} - ${farmer.city ?? 'unknown'} - ${farmer.village ?? 'unknown'}",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'images/picfarmer.jpg',
                                      height: 150,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.lightGreen,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                      ),
                                      onPressed: () {
                                        // نقرأ الـ Bloc من الـ context الحالي (تحت الـ MultiBlocProvider)
                                        final visitBloc = context.read<VisitfarmerBloc>()..add(VisitFarmer(farmer.id));

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => BlocProvider.value(
                                              value: visitBloc,
                                              child: FarmerDetailsPage(farmerId: farmer.id),
                                            ),
                                          ),
                                        );
                                      },

                                      icon: const Icon(Icons.shopping_bag),
                                      label: const Text("عرض المنتجات"),
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      setState(() {
                                        expandedStates[index] = !isExpanded;
                                      });
                                    },
                                    icon: Icon(
                                      isExpanded
                                          ? Icons.expand_less
                                          : Icons.expand_more,
                                      color: Colors.green,
                                    ),
                                    label: Text(
                                      isExpanded
                                          ? "إخفاء"
                                          : "افضل العروض للمزارع",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  if (isExpanded)
                                    Column(
                                      children: topProducts
                                          .map(
                                            (product) => ListTile(
                                          contentPadding:
                                          EdgeInsets.symmetric(
                                              horizontal: 0),
                                          title: Text(product.name),
                                          subtitle: Text(
                                              "${product.priceOfKilo} SP/Kg"),
                                          leading: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            child: Image.asset(
                                              "images/picfarmer.jpg"


                                            ),
                                          ),
                                        ),
                                      )
                                          .toList(),
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is FarmersError) {
                      return Center(child: Text("خطأ: ${state.message}"));
                    } else {
                      return const Center(child: Text("تحميل البيانات..."));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class DiscountBadge extends StatefulWidget {
  final double discount;

  const DiscountBadge({Key? key, required this.discount}) : super(key: key);

  @override
  _DiscountBadgeState createState() => _DiscountBadgeState();
}

class _DiscountBadgeState extends State<DiscountBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 0.7)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
                color: Colors.green.shade700,
                blurRadius: 6,
                offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.local_offer, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              '-${widget.discount.toStringAsFixed(0)}%',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/*
*
*
*
*
*
*
*
*
*
*
* */
