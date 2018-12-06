import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './price_tag.dart';
import '../../models/product.dart';
import '../../scoped-models/main.dart';

  class ProductCard extends StatelessWidget {
    final Product products;
    final int productIndex;

  ProductCard(this.products, this.productIndex);  

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Image.asset(products.imgUrl),
          _buildTitlePriceRow(),
          DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0)),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
            child: Text('Union Square, San Fransisco'),)
          ),
          Text(products.userEmail),
          _buildActionButtonBar(context)
        ],
      ),
    );
  }

  Widget _buildTitlePriceRow() {
    return Container(
            margin: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  products.title,
                  style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oswald'),
                ),
                SizedBox(width: 8.0),
                PriceTag(products.price.toString())
              ],
            ),
          );
  }

  Widget _buildActionButtonBar(BuildContext context) {
    return ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Colors.blue,
                onPressed: () => Navigator.pushNamed<bool>(
                      context, '/product/' + productIndex.toString())),
              
              ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
                return IconButton(
                icon: Icon(model.allProducts[productIndex].isFavorite ? 
                Icons.favorite : Icons.favorite_border),
                color: Colors.red,
                onPressed: () {
                  model.selectedProduct(productIndex);
                  model.toggleIsCurrentlyFavorite();
                }
              );
              },)
            ],
          );
  }
}