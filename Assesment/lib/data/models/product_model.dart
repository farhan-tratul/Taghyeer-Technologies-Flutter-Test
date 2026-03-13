import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel extends Product {
  @JsonKey(name: 'id')
  final int productId;
  
  @JsonKey(name: 'title')
  final String productTitle;
  
  @JsonKey(name: 'description')
  final String productDescription;
  
  @JsonKey(name: 'price')
  final double productPrice;
  
  @JsonKey(name: 'rating')
  final double productRating;
  
  @JsonKey(name: 'stock')
  final int productStock;
  
  @JsonKey(name: 'thumbnail')
  final String? productThumbnail;
  
  @JsonKey(name: 'images')
  final List<String>? productImages;

  const ProductModel({
    required this.productId,
    required this.productTitle,
    required this.productDescription,
    required this.productPrice,
    required this.productRating,
    required this.productStock,
    this.productThumbnail,
    this.productImages,
  }) : super(
    id: productId,
    title: productTitle,
    description: productDescription,
    price: productPrice,
    rating: productRating,
    stock: productStock,
    thumbnail: productThumbnail,
    images: productImages,
  );

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
