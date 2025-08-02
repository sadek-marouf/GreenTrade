import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart';

import '../../WelcomPage.dart';
import '../Bloc/Farmer_bloc/Edit_product/edit_product_bloc.dart';
import '../Bloc/Farmer_bloc/ViewProduct/viewproduct_bloc.dart';

import '../Service/repositories/products_repository.dart';

class Fruits extends StatefulWidget {
  Fruits({super.key});

  @override
  State<Fruits> createState() => _FruitsState();
}


class _FruitsState extends State<Fruits> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ViewproductBloc, ViewproductState>(
        builder: (context, state) {
      if (state is ViewProductLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is ViewProductLoaded) {


        final fruits =
            state.Get_products.where((p) => p.category.toString() == 'fruit').toList();

        return AnimationLimiter(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.75,
            ),
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: fruits.length,
            itemBuilder: (context, index) {
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
                              final client = Client();
                              final repo = ProductsRepository(client);
                              return BlocProvider(
                                create: (_) => EditProductBloc(repo),
                                child: DetailsBottomSheet(
                                    prod: fruits[index]),
                              );
                            },
                          );
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
                                          border:  Border.all(color: Colors.lightGreen,width: 2)
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          fruits[index].image,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    if (fruits[index].discount != null &&
                                        fruits[index].discount! > 0)
                                      Positioned(
                                        top: 8,
                                        left: 8,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.redAccent,
                                            borderRadius:
                                            BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            '-${fruits[index].discount!.toInt()}%',
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
                              Text("  ${fruits[index].name}",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 10),
                              Text(' Quantity: ${fruits[index].quantity}',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black)),
                              SizedBox(height: 5),
                              Text(' Price: ${fruits[index].price}',
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black)),
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
        );;
      } else if (state is ViewProductError) {
        print("${state.message}");
        return Center(child: Text("Error: ${state.message}"));
      } else {

        return Center(child: Text("Unexpected state"));
      }
    });
  }
}
