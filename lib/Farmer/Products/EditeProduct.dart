import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../Bloc/Farmer_bloc/Edit_product/edit_product_bloc.dart';

import '../Service/framwork.dart';

class EditProductDialog extends StatefulWidget {
  final Get_Products product;

  const EditProductDialog({Key? key, required this.product}) : super(key: key);

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late double _quantity;
  late double _price;
  late double _discount;
  File? _pickedImage;
  String? _pickedImagePath;

  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final Color _vegColor = Colors.green;
  final Color _fruitColor = Colors.yellow[700]!;

  @override
  void initState() {
    super.initState();
    print("[EditDialog] Sending GetIdProduct(${widget.product.id})");
    _quantity = widget.product.quantity;
    _price = widget.product.price;
    _discount = widget.product.discount ?? 0;

    _quantityController.text = _quantity.toStringAsFixed(1);
    _priceController.text = _price.toStringAsFixed(0);

    context.read<EditProductBloc>().add(GetIdProduct(widget.product.id));
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

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

  void _syncQuantity(String value) {
    final parsed = double.tryParse(value);
    if (parsed != null) {
      setState(() {
        _quantity = parsed;
      });
    }
  }

  void _syncPrice(String value) {
    final parsed = double.tryParse(value);
    if (parsed != null) {
      setState(() {
        _price = parsed;
      });
    }
  }

  bool get isFormValid =>
      _quantity > 0 && _price > 0 && _discount >= 0 && _discount <= 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: BlocListener<EditProductBloc, EditProductState>(
            listener: (context, state) {
              if (state is UpdateProductSuccess) {
                print("success");
                Navigator.pop(context); // أغلق النافذة عند النجاح
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Product updated successfully!'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              } else if (state is UpdateProductError) {
                print(state.message);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to update product: ${state.message}'),
                    backgroundColor: Colors.red,
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            }, child: BlocBuilder<EditProductBloc, EditProductState>(
            builder: (context, state) {
              print("[UI] BlocBuilder received state: $state");
              if (state is GetIdProductLoading) {
                return AlertDialog(
                  content: SizedBox(
                    height: 80,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else if (state is GetIdProductLoaded) {
                final product = state.product;
                final activeColor =
                product.category == 'fruit' ? _fruitColor : _vegColor;
                return AlertDialog(
                  title: Text('Edit Product', style: TextStyle(color: activeColor)),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // اسم المنتج (غير قابل للتعديل)
                        Text(
                          widget.product.name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: activeColor),
                        ),
                        const SizedBox(height: 20),

                        // الكمية
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Quantity',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: activeColor)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Slider(
                                value: _quantity,
                                min: 0,
                                max: 50000,
                                divisions: 100,
                                label: _quantity.toStringAsFixed(1),
                                activeColor: activeColor,
                                onChanged: (val) {
                                  setState(() {
                                    _quantity = val;
                                    _quantityController.text = val.toStringAsFixed(1);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 60,
                              child: TextField(
                                controller: _quantityController,
                                keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                  EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                ),
                                onChanged: _syncQuantity,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // السعر
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Price',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: activeColor)),
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Slider(
                                value: _price,
                                min: 0,
                                max: 20000,
                                divisions: 100,
                                label: _price.toStringAsFixed(0),
                                activeColor: activeColor,
                                onChanged: (val) {
                                  setState(() {
                                    _price = val;
                                    _priceController.text = val.toStringAsFixed(0);
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
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
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // الخصم (اختياري)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Discount % (optional)',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: activeColor)),
                        ),
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
                                activeColor: activeColor,
                                onChanged: (val) {
                                  setState(() {
                                    _discount = val;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 40,
                              child: Center(
                                child: Text('${_discount.toInt()}%',
                                    style: TextStyle(fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // صورة المنتج
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Product Image',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: activeColor)),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: _pickImage,
                          child: _pickedImage != null
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(_pickedImage!,
                                height: 100, width: 100, fit: BoxFit.cover),
                          )
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(widget.product.image,
                                height: 100, width: 100, fit: BoxFit.cover),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: Text('Cancel', style: TextStyle(color: activeColor)),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      onPressed: isFormValid && !(state is UpdateProductLoading)
                          ? () {
                        context.read<EditProductBloc>().add(
                          UpdateProductEvent(
                            id: widget.product.id,
                            idCategory: widget.product.category,
                            name: widget.product.name,
                            quantity: _quantity != widget.product.quantity
                                ? _quantity
                                : null,
                            price:
                            _price != widget.product.price ? _price : null,
                            discount: _discount !=
                                (widget.product.discount ?? 0)
                                ? _discount
                                : null,
                            imageFile: _pickedImage,
                          ),
                        );
                      }
                          : null,
                      style: ElevatedButton.styleFrom(backgroundColor: activeColor),
                      child: state is UpdateProductLoading
                          ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text('Save'),
                    ),
                  ],
                );
              } else {
                print("error");
                return SizedBox.shrink();
              }
            })));
  }
}
