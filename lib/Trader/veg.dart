import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../Trader/Service/Service.dart';



class Vegetables extends StatelessWidget {
  final List<Product> products;

  const Vegetables({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final vegetables = products.where((p) => p.category.toLowerCase() == 'vegetables').toList();

    return AnimationLimiter(
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
          childAspectRatio: 0.75,
        ),
        padding: EdgeInsets.symmetric(horizontal: 16),
        itemCount: vegetables.length,
        itemBuilder: (context, index) {
          final veg = vegetables[index];
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 500),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 5,
                  child: InkWell(

                    child: Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.lightGreen, width: 2),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      veg.url!,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                if (veg.discount != null && veg.discount > 0)
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.redAccent,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '-${veg.discount.toInt()}%',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Text("  ${veg.name}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          SizedBox(height: 10),
                          Text(' Quantity: ${veg.quantity}',
                              style: TextStyle(fontSize: 15, color: Colors.black)),
                          SizedBox(height: 5),
                          Text(' Price: ${veg.priceOfKilo}',
                              style: TextStyle(fontSize: 15, color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
