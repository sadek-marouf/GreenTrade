part of 'edit_product_bloc.dart';

@immutable
sealed class EditProductEvent {}

class GetIdProduct extends EditProductEvent {
  final int productId;

  GetIdProduct(this.productId);
}

class UpdateProductEvent extends EditProductEvent {
  final id_category;
  final int id;
  final String name ;
  final double quantity;
  final double price;
  final double discount;
  final File? imageFile; // صورة جديدة لو اختيرت

  UpdateProductEvent({
    required this.id_category ,
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.discount,
    this.imageFile,
  });
}


class DeleteProductEvent extends EditProductEvent {
  final int id;

  DeleteProductEvent(this.id);
}
