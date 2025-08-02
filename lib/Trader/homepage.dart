import 'package:farm1/Trader/Service/showproductdetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Service/Service.dart';
import 'Trader_Bloc/getproductfarmer/get_list_product_bloc.dart';



class TraderProductsPage extends StatefulWidget {
  @override
  _TraderProductsPageState createState() => _TraderProductsPageState();
}

class _TraderProductsPageState extends State<TraderProductsPage> with SingleTickerProviderStateMixin {
  String searchQuery = '';
  String selectedType = 'All';


  late AnimationController _listAnimationController;
  late FocusNode _searchFocusNode;
  List<String> searchSuggestions = [];



  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    context.read<GetListProductBloc>().add(GetList());

    _listAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _listAnimationController.forward();
  }


  @override
  void dispose() {
    _listAnimationController.dispose();
    _searchFocusNode.dispose();
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
        backgroundColor:  Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.lightGreen,
          title: Text('Available Offers'),
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.shopping_cart)),
            IconButton(onPressed: (){}, icon: Icon(Icons.notifications))
          ],


        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              // Search + Filter
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      focusNode: _searchFocusNode,
                      textInputAction: TextInputAction.search,

                      onChanged: (value) {
                        context.read<GetListProductBloc>().add(
                          value.isEmpty ? GetList() : SearchProducts(value),
                        );
                        setState(() {
                          searchQuery = value;
                          if (value.isNotEmpty && !searchSuggestions.contains(value)) {
                            searchSuggestions.add(value);
                          }
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search by product name...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.lightGreen.shade100,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.lightGreen.shade100,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      items: ['All', 'Fruits', 'Vegetables']
                          .map((type) => DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedType = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),

              if (_searchFocusNode.hasFocus &&
                  searchQuery.isNotEmpty &&
                  searchSuggestions.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 6)],
                  ),
                  child: ListView(
                    shrinkWrap: true,
                    children: searchSuggestions
                        .where((s) =>
                        s.toLowerCase().contains(searchQuery.toLowerCase()))
                        .map((suggestion) => ListTile(
                      title: Text(suggestion),
                      onTap: () {
                        setState(() {
                          searchQuery = suggestion;
                          _searchFocusNode.unfocus();
                        });
                        context
                            .read<GetListProductBloc>()
                            .add(SearchProducts(suggestion));
                      },
                    ))
                        .toList(),
                  ),
                ),
            ],
          ),

              const SizedBox(height: 16),

              // Products List (Full Width) مع أنميشن على كل كارد
              Expanded(
                child:BlocBuilder<GetListProductBloc,GetListProductState>(builder:(context ,state){
                  if(state is GetListProductLoading){
                    return Center(child: CircularProgressIndicator(),) ;
                  }
                  if(state is GetListProductLoaded){
                    final products = state.Tproducts.where((product) {
                      final matchesType = selectedType == 'All' || product.type == selectedType;
                      final matchesSearch = product.name.toLowerCase().contains(searchQuery.toLowerCase());
                      return matchesType && matchesSearch;
                    }).toList();
                    if (products.isEmpty) {
                      return Center(
                        child: Text('No products found for your search.'),
                      );
                    }


                    return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        // Animation for each card with delay based on index
                        final animation = Tween<Offset>(
                          begin: const Offset(0, 0.2),
                          end: Offset.zero,
                        ).animate(
                          CurvedAnimation(
                            parent: _listAnimationController,
                            curve: Interval(
                              (index / products.length),
                              1.0,
                              curve: Curves.easeOut,
                            ),
                          ),
                        );

                        final fadeAnimation = Tween<double>(
                          begin: 0,
                          end: 1,
                        ).animate(
                          CurvedAnimation(
                            parent: _listAnimationController,
                            curve: Interval(
                              (index / products.length),
                              1.0,
                              curve: Curves.easeIn,
                            ),
                          ),
                        );


                        return AnimatedBuilder(
                          animation: _listAnimationController,
                          builder: (context, child) {
                            return Opacity(
                              opacity: fadeAnimation.value,
                              child: Transform.translate(
                                offset: animation.value * 30,
                                child: child,
                              ),
                            );
                          },
                          child: InkWell(
                            onTap: () async{
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) {
                                  return ProductBottomSheet(product: product);
                                },
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.lightGreen,width: 2),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade300,
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Product image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    ////////////////////don't forget change asset to network/////////////////////////////////
                                    child: Image.asset(
                                      product.imageUrl,
                                      height: 90,
                                      width: 90,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Product details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Farmer: ${product.farmerName}',
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${product.quantity} kg • \$${product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Discount tag (if exists)
                                  if (product.discountPercentage != null)
                                    DiscountBadge(discount: product.discountPercentage!),
                                ],
                              ),
                            ),
                          ),
                        );

                      },
                    );
                  }
                  else if (state is GetListProductError) {
                    return Center(child: Text("Error: ${state.message}"));
                  } else {
                    return Center(child: Text("Something Was Range"),);
                  }
                }),

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

class _DiscountBadgeState extends State<DiscountBadge> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 0.7).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
            BoxShadow(color: Colors.green.shade700, blurRadius: 6, offset: const Offset(0, 2)),
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