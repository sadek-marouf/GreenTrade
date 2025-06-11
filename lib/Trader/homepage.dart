import 'package:farm1/Trader/Service/showproductdetails.dart';
import 'package:flutter/material.dart';

class TraderProduct {
  final String name;
  final String type; // "Fruits" or "Vegetables"
  final String imageUrl;
  final double price;
  final int quantity;
  final String farmerName;
  final double? discountPercentage; // null إذا ما في عرض

  TraderProduct({
    required this.name,
    required this.type,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.farmerName,
    this.discountPercentage,
  });
}

class TraderProductsPage extends StatefulWidget {
  @override
  _TraderProductsPageState createState() => _TraderProductsPageState();
}

class _TraderProductsPageState extends State<TraderProductsPage> with SingleTickerProviderStateMixin {
  String searchQuery = '';
  String selectedType = 'All';

  List<TraderProduct> allProducts = [
    TraderProduct(
      name: 'Apple',
      type: 'Fruits',
      imageUrl: 'https://i.imgur.com/QlRphfQ.jpg',
      price: 2.5,
      quantity: 20,
      farmerName: 'Abu Ahmed',
      discountPercentage: 15,
    ),
    TraderProduct(
      name: 'Banana',
      type: 'Fruits',
      imageUrl: 'https://i.imgur.com/RCx2lQ0.jpg',
      price: 1.8,
      quantity: 30,
      farmerName: 'Farmer Samir',
    ),
    TraderProduct(
      name: 'Tomato',
      type: 'Vegetables',
      imageUrl: 'https://i.imgur.com/DWJP5zT.jpg',
      price: 1.2,
      quantity: 25,
      farmerName: 'Farmer Lina',
      discountPercentage: 10,
    ),
    TraderProduct(
      name: 'Cucumber',
      type: 'Vegetables',
      imageUrl: 'https://i.imgur.com/kiQxV6a.jpg',
      price: 1.4,
      quantity: 40,
      farmerName: 'Abu Tarek',
    ),
  ];

  List<TraderProduct> get filteredProducts {
    return allProducts.where((product) {
      final matchesType = selectedType == 'All' || product.type == selectedType;
      final matchesSearch = product.name.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesType && matchesSearch;
    }).toList();
  }

  late AnimationController _listAnimationController;

  @override
  void initState() {
    super.initState();
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
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },

                      decoration: InputDecoration(
                        hintText: 'Search by product name...',
                        prefixIcon: const Icon(Icons.search),

                        filled: true,
                        fillColor:  Colors.lightGreen.shade100,
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
              const SizedBox(height: 16),

              // Products List (Full Width) مع أنميشن على كل كارد
              Expanded(
                child: InkWell(
                  onTap: (){
                    showModalBottomSheet(context: context, builder: (context) {
                      return ProductBottomSheet(product: filteredProducts[index],) ;
                    },) ;
                  },
                  child: ListView.builder(
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

                      // Animation for each card with delay based on index
                      final animation = Tween<Offset>(
                        begin: const Offset(0, 0.2),
                        end: Offset.zero,
                      ).animate(
                        CurvedAnimation(
                          parent: _listAnimationController,
                          curve: Interval(
                            (index / filteredProducts.length),
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
                            (index / filteredProducts.length),
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
                                child: Image.network(
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
                      );
                    },
                  ),
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
