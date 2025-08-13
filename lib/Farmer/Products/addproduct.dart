import 'dart:io';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../Bloc/Farmer_bloc/Product/products_bloc.dart';


class AddProductModal extends StatefulWidget {
  @override
  _AddProductModalState createState() => _AddProductModalState();
}

class _AddProductModalState extends State<AddProductModal> {
  String? _category; // 'veg' or 'fruit'
  String? _selectedProduct;
  double _quantity = 0;
  double _price = 0;
  double _discount = 0;
  final TextEditingController _searchController = TextEditingController();


  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();


  final Color _lightGreen = Color(0xFFA8E6A1);
  final Color _vegColor = Colors.green;
  final Color _fruitColor = Colors.yellow[700]!;
  File? _pickedImage;
  String? _pickedImagePath;

  ///-----------اختيار صورة ---------------//
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        _pickedImagePath = pickedFile.path;
      });
    }
  }
  @override
  void initState() {
    super.initState();

    // تصفير القيم
    _category = null;
    _selectedProduct = null;
    _quantity = 0;
    _price = 0;
    _discount = 0;
    _pickedImage = null;

    _searchController.clear();
    _quantityController.clear();
    _priceController.clear();
  }
  @override
  void dispose() {
    _searchController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }



  void _syncQuantity(String value) {
    final parsed = double.tryParse(value);
    if (parsed != null) setState(() => _quantity = parsed);
  }

  void _syncPrice(String value) {
    final parsed = double.tryParse(value);
    if (parsed != null) setState(() => _price = parsed);
  }

  @override
  Widget build(BuildContext context) {

    final activeColor = _category == 'fruit' ? _fruitColor : _vegColor;
    final isFormValid = _selectedProduct != null && _quantity > 0 && _price > 0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Product',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                    context.read<ProductsBloc>().add(fetchProducts('vegetables'));
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
                  hintText: 'Search products...',
                  prefixIcon: Icon(Icons.search, color: activeColor),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: activeColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: activeColor, width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 10),

              // ✅ عرض المنتجات أو المنتج المختار فقط
              _selectedProduct == null
                  ? BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is ProductsError) {
                    return Center(child: Text('Error loading products'));
                  } else if (state is ProductsLoaded) {
                    final products = state.products;
                    final filtered = products.where((p) => p.name
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase())).toList();

                    if (filtered.isEmpty) {
                      return Center(child: Text('No products found'));
                    }

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: filtered.map((product) {
                        final isSelected = _selectedProduct == product.name;
                        return GestureDetector(
                          onTap: () => setState(() {
                            _selectedProduct = product.name;
                          }),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            padding: EdgeInsets.all(8),
                            width: 110,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? activeColor.withOpacity(0.25)
                                  : _lightGreen.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                isSelected ? activeColor : Colors.transparent,
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
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    product.image,
                                    height: 70,
                                    width: 70,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.broken_image,
                                            size: 70, color: Colors.grey),
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
                        border: Border.all(color: activeColor, width: 2),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              selected.image,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(Icons.broken_image, size: 60),
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
                            icon: Icon(Icons.close, color: Colors.red),
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

              SizedBox(height: 20),
            ],

            if (_selectedProduct != null) ...[
              Text('Quantity',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: activeColor)),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Slider(
                      value: _quantity,
                      onChanged: (val) {
                        setState(() {
                          _quantity = val;
                          _quantityController.text = val.toStringAsFixed(1);
                        });
                      },
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: _quantity.toStringAsFixed(1),
                      activeColor: activeColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 60,
                    child: TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      onChanged: _syncQuantity,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text('Price of Kilo',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: activeColor)),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Slider(
                      value: _price,
                      min: 0,
                      max: 1000,
                      divisions: 100,
                      label: _price.toStringAsFixed(0),
                      onChanged: (val) => setState(() {
                        _price = val;
                        _priceController.text = val.toStringAsFixed(0);
                      }),
                      activeColor: activeColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                      width: 60,
                      child: TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        ),
                        onChanged: _syncPrice,
                      ))
                ],
              ),
              const SizedBox(height: 10),
              Text('Discount % (optional)',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: activeColor)),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Slider(
                      value: _discount,
                      min: 0,
                      max: 100,
                      divisions: 10,
                      label: '${_discount.toInt()}%',
                      onChanged: (val) => setState(() => _discount = val),
                      activeColor: activeColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40,
                    alignment: Alignment.center,
                    child: Text('${_discount.toInt()}%',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(decoration: BoxDecoration(
                  border: Border.all(color: activeColor)
                      ,borderRadius: BorderRadius.circular(40)
                ),
                  margin: EdgeInsets.symmetric(horizontal: 80,vertical: 20),
                  padding: EdgeInsets.all(20),
                  child: Row(children: [

                   Text('Total Price : ' ,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)
                   , Text(
                      '${( (_quantity * _price) * (1 - _discount / 100) ).toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: activeColor,
                        fontSize: 16,
                      ),
                    ),
                  ],),
                ),
              ),
              Text("Add Image to Product", style:TextStyle(
                fontWeight: FontWeight.bold,
                color: activeColor,
                fontSize: 16,
              ),),

              SizedBox(height: 10),
              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: _pickedImage != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_pickedImage!,
                              height: 100, width: 100, fit: BoxFit.cover),
                        )
                      : Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: activeColor),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(Icons.add_a_photo, color: activeColor),
                        ),
                ),
              ),
              SizedBox(height: 20),
            ],
            Center(
              child: BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  if (state is AddProductLoading) {
                    return CircularProgressIndicator();
                  }

                  if (state is AddProductLoaded) {
                    Future.microtask(() {
                      Navigator.pop(context, true);
                      context.read<ProductsBloc>().add(ResetAddProductState()); // 🟢 Reset الحالة
                    });
                    return SizedBox.shrink();
                  }

                  if (state is AddProductError) {
                    Future.microtask(() {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.message)),
                      );
                    });
                  }

                  return ElevatedButton(
                    onPressed: isFormValid && _pickedImage != null
                        ? () {
                      context.read<ProductsBloc>().add(
                        Addproduct(
                          id_category: _category!,
                          name_product: _selectedProduct!,
                          priceofkilo: _price,
                          quantity: _quantity,
                          image: _pickedImage,
                        ),
                      );
                      // لا تسكر المودال هون! خليه يسكر لما Bloc يرجع حالة النجاح
                    }
                        : null,
                    child: Text("Add Product"),
                  );
                },
              ),
            ),

          ],
        ),
      ),
    );
  }
}
