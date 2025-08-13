import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../Trader/Service/Service.dart';
import 'Trader_Bloc/getproductfarmer/visitfarmer_bloc.dart';

class FarmerDetailsPage extends StatelessWidget {
  final int farmerId;
  const FarmerDetailsPage({super.key, required this.farmerId});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.lightGreen.shade200,
      appBar: AppBar(
        title: const Text('Farmer Details'),
        backgroundColor: Colors.green.shade700,
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
                children: [
                  // ------------ Farmer Info ------------
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                farmer.products.isNotEmpty && farmer.products.first.url != null
                                    ? farmer.products.first.url!
                                    : "https://i.imgur.com/BoN9kdC.png",
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text("${farmer.firstName} ${farmer.lastName}",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.phone, size: 16),
                                const SizedBox(width: 5),
                                Text(farmer.phone),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.email, size: 16),
                                const SizedBox(width: 5),
                                Text(farmer.email),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.location_on, size: 16),
                                const SizedBox(width: 5),
                                Text("${farmer.city} ${farmer.governorate ?? ''}"),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ------------ Discounted Products Slider ------------
                  if (discounted.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text('🔥 Discounted Products',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade900)),
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 220,
                            viewportFraction: 1.0,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            enlargeCenterPage: false,
                          ),
                          items: discounted.map((product) {
                            return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      child: Image.network(
                                        product.url ?? '',
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Text(product.name,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        Text.rich(TextSpan(children: [
                                          TextSpan(
                                              text: '${product.priceOfKilo} SYP  ',
                                              style: const TextStyle(
                                                  decoration: TextDecoration.lineThrough,
                                                  color: Colors.red)),
                                          TextSpan(
                                              text: '${(product.priceOfKilo * (1 - product.discount / 100)).toStringAsFixed(0)} SYP',
                                              style: TextStyle(color: Colors.green.shade800)),
                                        ])),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),

                  if (vegetables.isNotEmpty)
                    buildProductSection(title: '🥦 Vegetables', list: vegetables),

                  if (fruits.isNotEmpty)
                    buildProductSection(title: '🍎 Fruits', list: fruits),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),

    );
  }

  Widget buildProductSection({
    required String title,
    required List<Product> list,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(title,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade900)),
        ),
        GridView.builder(
          itemCount: list.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10),
          itemBuilder: (context, index) {
            final product = list[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        product.url ?? '',
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(product.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 4),
                        Text('${product.priceOfKilo} SYP',
                            style: TextStyle(
                                color: Colors.green.shade800,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
