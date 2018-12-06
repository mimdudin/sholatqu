import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';

import '../scoped-models/main.dart';
import '../models/product.dart';

class ProductPage extends StatelessWidget {
  final int productIndex;

  ProductPage(this.productIndex);

  Widget _buildAddressPriceRow(double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Union square, Fransisco',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '\$' + price.toString(),
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () {
      Navigator.pop(context, false);
      //  Navigator.pop(context, false); --> false artinye kt ndk maok delete product detail page

      return Future.value(false);
      // jk true == allowed leave the page, tp pakai false jk gunekan navigator dan tak mau ad error.
    }, child: ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Product product = model.allProducts[productIndex];
        return Scaffold(
          appBar: AppBar(
            title: Text(product.title),
          ),
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(product.imgUrl),
              // Image.asset('assets/food.jpg'),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(product.title),
              ),
              _buildAddressPriceRow(product.price),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(product.descProduct, textAlign: TextAlign.center),
              )
              // pakai Container() misal maok setting padding.
              // kalau maok nambah Text, button dll gunekan named child:
            ],
          ),
        );
      },
    ));
  }
}

// implementation 'com.google.firebase:firebase-core:16.0.1'