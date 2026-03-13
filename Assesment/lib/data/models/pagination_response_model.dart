import 'package:json_annotation/json_annotation.dart';

part 'pagination_response_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class PaginationResponseModel<T> {
  @JsonKey(name: 'total')
  final int total;
  
  @JsonKey(name: 'skip')
  final int skip;
  
  @JsonKey(name: 'limit')
  final int limit;
  
  final List<T> items;

  PaginationResponseModel({
    required this.total,
    required this.skip,
    required this.limit,
    required this.items,
  });

  factory PaginationResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$PaginationResponseModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T) toJsonT) =>
      _$PaginationResponseModelToJson(this, toJsonT);
}
