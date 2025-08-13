part of 'edit_product_bloc.dart';

@immutable
sealed class EditProductEvent {}

class GetIdProduct extends EditProductEvent {
  final int productId;

  GetIdProduct(this.productId);
}

class UpdateProductEvent extends EditProductEvent {
  final int id;
  final String? idCategory;
  final String? name;
  final double? quantity;
  final double? price;
  final double? discount;
  final File? imageFile;

  UpdateProductEvent({
    required this.id,
    this.idCategory,
    this.name,
    this.quantity,
    this.price,
    this.discount,
    this.imageFile,
  });
}


class DeleteProductEvent extends EditProductEvent {
  final int id;

  DeleteProductEvent(this.id);
}
