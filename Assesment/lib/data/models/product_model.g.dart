// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      productId: (json['id'] as num).toInt(),
      productTitle: json['title'] as String,
      productDescription: json['description'] as String,
      productPrice: (json['price'] as num).toDouble(),
      productRating: (json['rating'] as num).toDouble(),
      productStock: (json['stock'] as num).toInt(),
      productThumbnail: json['thumbnail'] as String?,
      productImages:
          (json['images'] as List<dynamic>?)?.map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.productId,
      'title': instance.productTitle,
      'description': instance.productDescription,
      'price': instance.productPrice,
      'rating': instance.productRating,
      'stock': instance.productStock,
      'thumbnail': instance.productThumbnail,
      'images': instance.productImages,
    };
