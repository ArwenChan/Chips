// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Product _$ProductFromJson(Map<String, dynamic> json) {
  return Product()
    ..id = json['id'] as String
    ..name = json['name'] as String
    ..price = json['price'] as int
    ..promotionPrice = json['promotionPrice'] as int
    ..langFrom = json['langFrom'] as String
    ..langTo = json['langTo'] as String;
}

Map<String, dynamic> _$ProductToJson(Product instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'promotionPrice': instance.promotionPrice,
      'langFrom': instance.langFrom,
      'langTo': instance.langTo,
    };
