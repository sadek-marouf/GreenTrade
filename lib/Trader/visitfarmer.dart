import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../Trader/veg.dart';
import '../Trader/tfruit.dart';
import 'Trader_Bloc/getproductfarmer/visitfarmer_bloc.dart';

class FarmerDetailsPage extends StatelessWidget {
  final int farmerId;
  const FarmerDetailsPage({super.key, required this.farmerId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:   Colors.lightGreen.shade200, // خليت الخلفية بيضاء مثل الواجهة
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
            final vegetables = farmer.products.where((p) => p.category.toLowerCase() == 'vegetable').toList();
            final fruits = farmer.products.where((p) => p.category.toLowerCase() == 'fruit').toList();

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ------------ Farmer Info -------------
                  Container(
                      padding: const EdgeInsets.all(16.0),
                      margin: EdgeInsets.symmetric(horizontal: 25,vertical: 10),

                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),color: Colors.white,),
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
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
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

                  // ------------ Discounted ------------
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
                          MaterialButton(onPressed: (){},child: Text("عرض الكل" ,style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          )))
                        ],
                      ),
                    ),
                  if (discounted.isNotEmpty)
                    CarouselSlider(
                      options: CarouselOptions(
                        height: 250,
                        viewportFraction: 0.85,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 4),
                      ),
                      items: discounted.map((product) {
                        final discountedPrice = (product.priceOfKilo * (1 - product.discount / 100));
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                child: Image.network(
                                  product.url ?? '',
                                  width: double.infinity,
                                  height: 150,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.network('https://i.imgur.com/BoN9kdC.png', fit: BoxFit.cover, height: 150, width: double.infinity),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(product.name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold, fontSize: 18)),
                                    const SizedBox(height: 6),
                                    Row(
                                      children: [
                                        Text(
                                          '${product.priceOfKilo} SYP',
                                          style: const TextStyle(
                                            decoration: TextDecoration.lineThrough,
                                            fontSize: 16,
                                            color: Colors.red,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          '${discountedPrice.toStringAsFixed(0)} SYP',
                                          style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.green.shade800,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  TabBarView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      Container(color: Colors.transparent, child: Vegetables(products:vegetables,)),
                      Container(color: Colors.transparent, child: Fruits(products: fruits,)),
                    ],
                  ),



                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
