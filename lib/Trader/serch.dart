import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import '../Farmer/Bloc/Farmer_bloc/Product/products_bloc.dart';
import '../Farmer/Service/repositories/products_repository.dart';

import '../Farmer/Service/framwork.dart';
import 'Trader_Bloc/farmers_bloc.dart';

class Bserch extends StatelessWidget {
  const Bserch({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ProductsRepository(http.Client());
    // -- هنا أضفت FarmersBloc كـ provider بجانب ProductsBloc
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ProductsBloc(repository)),
        BlocProvider(create: (context) => FarmersBloc()),
      ],
      child: serch(),
    );
  }
}

class serch extends StatefulWidget {
  const serch({super.key});

  @override
  State<serch> createState() => _serchState();
}

class _serchState extends State<serch> {
  String? _category; // 'veg' or 'fruit'
  String? _selectedProduct;
  final Color _lightGreen = Color(0xFFA8E6A1);
  final Color _vegColor = Colors.green;
  final Color _fruitColor = Colors.yellow;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final activeColor = _category == 'fruit' ? _fruitColor : _vegColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('البحث عن منتج '),
      ),
      body: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: SingleChildScrollView(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(" اختر نوع المنتج قبل البحث ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.lightGreen)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ChoiceChip(
                          label: Text('Vegetables'),
                          selected: _category == 'vegetables',
                          selectedColor: _vegColor.withOpacity(0.3),
                          onSelected: (_) => setState(() {
                            _category = 'vegetables';
                            _selectedProduct = null;
                            context
                                .read<ProductsBloc>()
                                .add(fetchProducts('vegetables'));
                          }),
                        ),
                        const SizedBox(width: 12),
                        ChoiceChip(
                          label: Text('Fruits'),
                          selected: _category == 'fruit',
                          selectedColor: _fruitColor.withOpacity(0.3),
                          onSelected: (_) => setState(() {
                            _category = 'fruit';
                            _selectedProduct = null;
                            context.read<ProductsBloc>().add(fetchProducts('fruit'));
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_category != null) ...[
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'بحث....',
                          prefixIcon: Icon(Icons.search, color: activeColor),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: activeColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: activeColor, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 10),

                      // -------------------------
                      // نفس عرض المنتجات اللي عندك بالضبط
                      // -------------------------
                      _selectedProduct == null
                          ? BlocBuilder<ProductsBloc, ProductsState>(
                        builder: (context, state) {
                          if (state is ProductsLoading) {
                            return Center(
                                child: CircularProgressIndicator());
                          } else if (state is ProductsError) {
                            return Center(
                                child: Text('Error loading products'));
                          } else if (state is ProductsLoaded) {
                            final products = state.products;
                            final filtered = products
                                .where((p) => p.name
                                .toLowerCase()
                                .contains(_searchController.text
                                .toLowerCase()))
                                .toList();

                            if (filtered.isEmpty) {
                              return Center(
                                  child: Text('ليس هناك منتجات مطابقة'));
                            }

                            return Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: filtered.map((product) {
                                final isSelected =
                                    _selectedProduct == product.name;
                                return GestureDetector(
                                  onTap: () {
                                    // **هنا**: فقط أرسلت حدث البحث إلى FarmersBloc مع النوع والاسم
                                    setState(() {
                                      _selectedProduct = product.name;
                                    });
                                    context.read<FarmersBloc>().add(
                                      SearchProduct(
                                        type: _category!,
                                        name: product.name,
                                      ),
                                    );
                                  },
                                  child: AnimatedContainer(
                                    duration: Duration(milliseconds: 300),
                                    padding: EdgeInsets.all(8),
                                    width: 110,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? activeColor.withOpacity(0.25)
                                          : _lightGreen.withOpacity(0.15),
                                      borderRadius:
                                      BorderRadius.circular(16),
                                      border: Border.all(
                                        color: isSelected
                                            ? activeColor
                                            : Colors.transparent,
                                        width: 2,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(12),
                                          child: Image.network(
                                            product.image,
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error,
                                                stackTrace) =>
                                                Icon(Icons.broken_image,
                                                    size: 70,
                                                    color: Colors.grey),
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          product.name,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: isSelected
                                                ? activeColor
                                                : Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      )
                          : BlocBuilder<ProductsBloc, ProductsState>(
                        builder: (context, state) {
                          if (state is ProductsLoaded) {
                            final selected = state.products.firstWhere(
                                  (p) => p.name == _selectedProduct,
                              orElse: () => state.products.first,
                            );

                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 12),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _lightGreen.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                    color: activeColor, width: 2),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(8),
                                    child: Image.network(
                                      selected.image,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Icon(
                                          Icons.broken_image,
                                          size: 60),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      selected.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: activeColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close,
                                        color: Colors.red),
                                    onPressed: () => setState(() {
                                      _selectedProduct = null;
                                    }),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),

                      SizedBox(height: 12),

                      // -------------------------
                      // هنا نعرض نتائج البحث من FarmersBloc (قائمة مزارعين لديهم هذا المنتج)
                      // -------------------------
                      if (_selectedProduct != null)
                        BlocBuilder<FarmersBloc, FarmersState>(
                          builder: (context, state) {
                            if (state is SearchProductLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is SearchProductError) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 12.0),
                                child: Center(child: Text(state.message)),
                              );
                            } else if (state is SearchProductLoaded) {
                              final farmers = state.farmers;
                              if (farmers.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Center(child: Text('لا توجد نتائج لهذا المنتج')),
                                );
                              }

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: farmers.length,
                                itemBuilder: (context, index) {
                                  final farmer = farmers[index];
                                  // نحاول نأخذ المنتج المطابق داخل كل مزارع، أو أول منتج إن ما وجد تطابق
                                  final matchedProduct = farmer.products.firstWhere(
                                        (p) => p.name == _selectedProduct,
                                    orElse: () => farmer.products.first,
                                  );

                                  // بناء رابط الصورة: لو الرابط يبدأ بـ http نستخدمه كما هو،
                                  // وإلا نبني رابط كامل باستخدام متغير ip الموجود في framwork.dart
                                  String? imageUrl;
                                  if (matchedProduct.url != null && matchedProduct.url!.isNotEmpty) {
                                    imageUrl = matchedProduct.url!;
                                    if (!imageUrl.startsWith('http')) {
                                      imageUrl = 'http://$ip:8000/$imageUrl';
                                    }
                                  }

                                  final farmerName = ((farmer.firstName ?? '').trim() +
                                      ' ' +
                                      (farmer.lastName ?? '').trim())
                                      .trim();
                                  final displayFarmerName =
                                  farmerName.isNotEmpty ? farmerName : (farmer.email ?? 'مزارع');

                                  return Card(
                                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    elevation: 6,
                                    shadowColor: activeColor.withOpacity(0.4),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color: activeColor.withOpacity(0.15),
                                            offset: Offset(0, 6),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(16),
                                      child: Row(
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          // صورة المنتج مع ظل بسيط وحدود مستديرة أكبر
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(16),
                                            child: imageUrl != null && imageUrl.isNotEmpty
                                                ? Image.network(
                                              imageUrl,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Container(
                                                width: 100,
                                                height: 100,
                                                color: Colors.grey[100],
                                                child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                                              ),
                                            )
                                                : Container(
                                              width: 100,
                                              height: 100,
                                              color: Colors.grey[100],
                                              child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                                            ),
                                          ),

                                          SizedBox(width: 20),

                                          // معلومات المنتج والمزارع بتنسيق حديث
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  matchedProduct.name,
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: activeColor,
                                                    letterSpacing: 0.5,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  "السعر (لكل كغ): ${matchedProduct.priceOfKilo.toStringAsFixed(2)} ل.س",
                                                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                                ),
                                                Text(
                                                  "الكمية المتوفرة: ${matchedProduct.quantity} كغ",
                                                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                                                ),
                                                if (matchedProduct.discount != 0)
                                                  Text(
                                                    "الخصم: ${matchedProduct.discount} %",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.redAccent,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                if (matchedProduct.description != null && matchedProduct.description!.isNotEmpty)
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 6.0),
                                                    child: Text(
                                                      matchedProduct.description!,
                                                      style: TextStyle(fontSize: 13, color: Colors.grey[600], fontStyle: FontStyle.italic),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                SizedBox(height: 12),
                                                Divider(color: Colors.grey[300]),
                                                SizedBox(height: 8),
                                                Text(
                                                  "المزارع: $displayFarmerName",
                                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                                                ),
                                                Text(
                                                  "المدينة: ${farmer.city ?? '-'}",
                                                  style: TextStyle(color: Colors.black54),
                                                ),
                                                Text(
                                                  "الهاتف: ${farmer.phone ?? '-'}",
                                                  style: TextStyle(color: Colors.black54),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                  ;
                                },
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),

                      SizedBox(height: 20),
                    ]
                  ]))),
    );
  }
}
