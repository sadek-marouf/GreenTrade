import 'package:farm1/Trader/visitfarmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../Trader/Service/Service.dart';

class Fruits extends StatelessWidget {
  final List<Product> products;
  final int farmerid ;

  const Fruits({super.key, required this.products,required this.farmerid});

  @override
  Widget build(BuildContext context) {
    final fruits = products.where((p) => p.category.toLowerCase() == 'fruit').toList();

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
        itemCount: fruits.length,
        itemBuilder: (context, index) {
          final fruit = fruits[index];
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

                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(24)),
                          ),
                          builder: (context) {
                            return DetailsBottomSheetTrader(
                              prod: fruit,
                              farmerid: farmerid,
                            );
                          });
                    },

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
                                      fruit.url ?? "",
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                if (fruit.discount != null && fruit.discount > 0)
                                  Positioned(
                                    top: 8,
                                    left: 8,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '-${fruit.discount.toInt()}%',
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
                          Text("  ${fruit.name}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          SizedBox(height: 10),
                          Text(' الكمية : ${fruit.quantity}',
                              style: TextStyle(fontSize: 15, color: Colors.black)),
                          SizedBox(height: 5),
                          Text(' السعر :  ${fruit.totalPrice} ',
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
