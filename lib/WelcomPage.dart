import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import 'dart:async';

import 'Farmer/Bloc/Farmer_bloc/Edit_product/edit_product_bloc.dart';
import 'Farmer/Bloc/Farmer_bloc/ViewProduct/viewproduct_bloc.dart';
import 'Farmer/Products/EditeProduct.dart';
import 'Farmer/Products/fruit.dart';
import 'Farmer/Products/vegetables.dart';
import 'Farmer/Service/framwork.dart';
import 'Farmer/Service/repositories/products_repository.dart';

class FarmerHomePage extends StatefulWidget {
  const FarmerHomePage({super.key});

  @override
  _FarmerHomePageState createState() => _FarmerHomePageState();
}

class _FarmerHomePageState extends State<FarmerHomePage> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _pageTimer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);
    context.read<ViewproductBloc>().add(GetProducts());
  }

  @override
  void dispose() {
    _pageTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _refreshProducts(BuildContext context) async {
    print("🔄 Refresh started");
    final completer = Completer();

    final subscription = context.read<ViewproductBloc>().stream.listen((state) {
      if (state is ViewProductLoaded || state is ViewProductError) {
        completer.complete();
      }
    });

    context.read<ViewproductBloc>().add(RefreshProducts());

    await completer.future;
    await subscription.cancel();
    print("✅ Refresh complete");
  }

  void startAutoScroll(int itemCount) {
    _pageTimer?.cancel();
    if (itemCount > 1) {
      _pageTimer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (_pageController.hasClients) {
          _currentPage++;
          if (_currentPage >= itemCount) _currentPage = 0;
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      color: Colors.lightGreen.shade200,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight + 20),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(24),
            ),
            child: AppBar(
              backgroundColor: Colors.lightGreen[500],
              elevation: 6,
              shadowColor: Colors.greenAccent.shade100,
              actions: [
                Icon(Icons.shopping_cart, color: Colors.white.withOpacity(0.9)),
                SizedBox(width: 20),
                Icon(Icons.notifications, color: Colors.white.withOpacity(0.9)),
                SizedBox(width: 10),
              ],
            ),
          ),
        ),
        drawer: Container(),
        body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          // أضف physics هنا أيضاً للتأكد من إمكانية السحب دوماً
          child: DefaultTabController(
            length: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightGreen.shade200,
              ),
              child: NestedScrollView(
                physics: const AlwaysScrollableScrollPhysics(),  // لازم حتى لو المحتوى صغير يسمح بالسحب
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: size.height * 0.02),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                "Your Deals",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                  color: Colors.green.shade900,
                                ),
                              ),
                            ),
                            BlocBuilder<ViewproductBloc, ViewproductState>(
                              builder: (context, state) {
                                if (state is ViewProductLoaded) {
                                  final discountedProducts = state.Get_products.where((p) => p.discount != null && p.discount! > 0).toList();

                                  startAutoScroll(discountedProducts.length);

                                  return SizedBox(
                                    height: size.height * 0.17,
                                    child: PageView.builder(
                                      controller: _pageController,
                                      itemCount: discountedProducts.length,
                                      itemBuilder: (context, index) {
                                        final prod = discountedProducts[index];
                                        return GestureDetector(
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                                              ),
                                              builder: (context) {
                                                final client = Client();
                                                final repo = ProductsRepository(client);
                                                return BlocProvider(
                                                  create: (_) => EditProductBloc(repo)..add(GetIdProduct(prod.id)),
                                                  child: DetailsBottomSheet(prod: prod),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.lightGreen.shade400,
                                              borderRadius: BorderRadius.circular(16),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.green.shade200.withOpacity(0.6),
                                                  blurRadius: 8,
                                                  offset: Offset(0, 3),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Image.network(
                                                    prod.image,
                                                    width: 120,
                                                    height: size.height * 0.15,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        prod.name,
                                                        style: const TextStyle(
                                                          fontSize: 20,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                        'Price: \$${prod.price}',
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white70,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                                        decoration: BoxDecoration(
                                                          color: Colors.red.shade700,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          '-${prod.discount!.toInt()}% OFF',
                                                          style: const TextStyle(
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const Icon(Icons.chevron_right, color: Colors.white, size: 28),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                } else if (state is ViewProductLoading) {
                                  return SizedBox(
                                    height: size.height * 0.15,
                                    child: Center(child: CircularProgressIndicator()),
                                  );
                                } else {
                                  return SizedBox(height: size.height * 0.15);
                                }
                              },
                            ),
                            SizedBox(height: 20),
                            Divider(
                              thickness: 1,
                              color: Colors.green.shade300,
                              indent: 16,
                              endIndent: 16,
                            ),
                            SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _SliverAppBarDelegate(
                        Container(
                          color: Colors.lightGreen.shade200,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5, left: 15),
                                child: Text(
                                  "All Products",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.green.shade900,
                                  ),
                                ),
                              ),
                              TabBar(
                                indicatorColor: Colors.green.shade700,
                                labelColor: Colors.green[800],
                                unselectedLabelColor: Colors.grey,
                                tabs: [
                                  Tab(text: 'Vegetables'),
                                  Tab(text: 'Fruits'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  physics: const AlwaysScrollableScrollPhysics(),  // مهم عشان السحب في التبويب يشتغل
                  children: [
                    Container(color: Colors.transparent, child: Vegetables()),
                    Container(color: Colors.transparent, child: Fruits()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}




class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget _widget;

  _SliverAppBarDelegate(this._widget);

  @override
  double get minExtent => kToolbarHeight + 45;

  @override
  double get maxExtent => kToolbarHeight + 45;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return _widget;
  }

  @override
  bool shouldRebuild(covariant _SliverAppBarDelegate oldDelegate) => false;
}

class DetailsBottomSheet extends StatefulWidget {
  final Get_Products prod;

  const DetailsBottomSheet({super.key, required this.prod});

  @override
  State<DetailsBottomSheet> createState() => _DetailsBottomSheetState();
}

class _DetailsBottomSheetState extends State<DetailsBottomSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _openEditDialog(Get_Products product) async {
      final result = await showDialog(
        context: context,
        builder: (_) {
          return BlocProvider.value(
            value: context.read<EditProductBloc>(),
            child: EditProductDialog(product: product),
          );
        },
      );

      if (result != null) {
        print('Edited data: $result');
        // context.read<ProductsBloc>().add(UpdateProductEvent(...));
      }
    }

    return BlocListener<EditProductBloc, EditProductState>(
        listener: (context, state) {
          if (state is DeleteProductSuccess) {
            Navigator.pop(context); // إغلاق النافذة بعد الحذف
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Product deleted successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          } else if (state is DeleteProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        child: Container(
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
                      borderRadius: BorderRadius.circular(22)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Image.network(
                      widget.prod.image,
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
                      widget.prod.name.toLowerCase(),
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            if (widget.prod.discount != null &&
                                widget.prod.discount! > 0) ...[
                              const SizedBox(width: 8),
                              Text(
                                "\$${(widget.prod.price * (1 - widget.prod.discount! / 100)).toStringAsFixed(2)}",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.orange),
                              ),
                            ] else
                              Text(
                                "\$${widget.prod.price}",
                                style: const TextStyle(
                                    fontSize: 18, color: Colors.orange),
                              ),
                          ],
                        ),
                        if (widget.prod.discount != null &&
                            widget.prod.discount! > 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              "-${widget.prod.discount!.toInt()}%",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 12),
                            ),
                          ),
                        ],
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 20),

                // معلومات غذائية ثابتة
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(widget.prod.quantity.toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                        ),
                        const SizedBox(height: 4),
                        Text("Quantity",
                            style: TextStyle(
                                color:
                                    (widget.prod.category.toString() == "veg")
                                        ? Colors.green
                                        : Colors.yellow[700],
                                fontSize: 18)),
                      ],
                    ),
                    Column(children: [
                      if (widget.prod.discount != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            "\$${widget.prod.price}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(" Total Price",
                            style: TextStyle(
                                color:
                                    (widget.prod.category.toString() == "veg")
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
                          child: Text(
                            "\$${widget.prod.price}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text("Price",
                            style: TextStyle(
                                color:
                                    (widget.prod.category.toString() == "veg")
                                        ? Colors.green
                                        : Colors.yellow[700],
                                fontSize: 18)),
                      ]
                    ])
                  ],
                ),

                const SizedBox(height: 24),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          print("Tapped on product to edit");

                          _openEditDialog(widget.prod);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD6F5C9),
                          foregroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text("Update"),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: ElevatedButton(
                        onPressed: () {
                          print(widget.prod.id) ;
                          context
                              .read<EditProductBloc>()
                              .add(DeleteProductEvent(widget.prod.id));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD6F5C9),
                          foregroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

//////
}
