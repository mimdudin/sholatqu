import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './product_card.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';

class Products extends StatelessWidget {

  Widget _buildProductList(List<Product> products) {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.builder(
            itemBuilder: (BuildContext context, int i) => ProductCard(products[i], i), 
            itemCount: products.length);
    } else {
      productCards = Center(
            child: Text('Tidak ada product satupun, tolong ditambahkan yaa...'));
   
    }
    return productCards;
}

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      return _buildProductList(model.displayedProducts);
    },);
  }

  // Widget _buildProductList() {
  //   Widget productCard;

  //   return productCard;
  // }
}
