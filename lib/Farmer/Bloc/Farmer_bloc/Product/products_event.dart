part of 'products_bloc.dart';

@immutable
sealed class ProductsEvent {}
class fetchProducts extends ProductsEvent{
  final String category ;
   fetchProducts(this.category);
}
class Addproduct extends ProductsEvent{


  final String id_category ;

  final String name_product ;
  final double price ;
  final double quantity ;
  final int?  discount ;
  final File? image ;
  Addproduct(
      {
    required this.id_category,

    required this.name_product,
    required this.price,
    required this.quantity,
    required this.image,
    this.discount,
  }) ;
}