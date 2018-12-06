import 'package:flutter/material.dart';

class Product {
  final String id, title, descProduct, imgUrl, userId, userEmail;
  final double price;
  final bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.descProduct,
      @required this.imgUrl,
      @required this.price,
      this.isFavorite = false,
      @required this.userId,
      @required this.userEmail});
}
