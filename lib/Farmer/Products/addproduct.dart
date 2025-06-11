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
                  selected: _category == 'veg',
                  selectedColor: _vegColor.withOpacity(0.3),
                  onSelected: (_) => setState(() {
                    _category = 'veg';
                    _selectedProduct = null;
                    context.read<ProductsBloc>().add(fetchProducts('veg'));
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
              BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is ProductsLoaded) {
                    final filtered = state.products
                        .where((p) => p.name
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()))
                        .toList();

                    return Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: filtered.map((name) {
                        return GestureDetector(
                          onTap: () => setState(
                              () => _selectedProduct = name as String?),
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            padding: EdgeInsets.all(8),
                            width: 100,
                            decoration: BoxDecoration(
                              color: _selectedProduct == name
                                  ? activeColor.withOpacity(0.2)
                                  : _lightGreen.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: _selectedProduct == name
                                    ? activeColor
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(name as String,
                                  style:
                                      TextStyle(fontWeight: FontWeight.w500)),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else if (state is ProductsError) {
                    return Center(child: Text('Error loading products'));
                  } else {
                    return SizedBox.shrink();
                  }
                },
              )

              // Wrap(
              //   spacing: 12,
              //   runSpacing: 12,
              //   children: _filteredProducts.map((product) {
              //     final name = product['name']!;
              //     final image = product['image']!;
              //     return GestureDetector(
              //       onTap: () => setState(() => _selectedProduct = name),
              //       child: AnimatedContainer(
              //         duration: Duration(milliseconds: 300),
              //         padding: EdgeInsets.all(8),
              //         width: 100,
              //         decoration: BoxDecoration(
              //           color: _selectedProduct == name
              //               ? activeColor.withOpacity(0.2)
              //               : _lightGreen.withOpacity(0.2),
              //           borderRadius: BorderRadius.circular(16),
              //           border: Border.all(
              //             color: _selectedProduct == name ? activeColor : Colors.transparent,
              //             width: 2,
              //           ),
              //         ),
              //         child: Column(
              //           mainAxisSize: MainAxisSize.min,
              //           children: [
              //             Image.network(image, height: 40, width: 40),
              //             SizedBox(height: 8),
              //             Text(name, style: TextStyle(fontWeight: FontWeight.w500))
              //           ],
              //         ),
              //       ),
              //     );
              //   }).toList(),
              // ),
              ,
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
              Text('Price',
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
              Text('Product Image',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: activeColor)),
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
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Product added successfully!')),
                      );
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
                        Addproduct(id_category: _category!, name_product: _selectedProduct!, price: _price, quantity: _quantity, image: _pickedImage)
                      );
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
