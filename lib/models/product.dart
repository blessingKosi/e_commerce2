import 'package:flutter/cupertino.dart';

class Product {
  String id, name, description;
  num price;
  Map<String, dynamic> picture;

  Product(
      {@required this.id,
      @required this.name,
      @required this.description,
      @required this.price,
      @required this.picture});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      picture: json['picture'],
      price: json['price'],
    );
  }
}
