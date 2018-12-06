import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../models/product.dart';
import '../scoped-models/main.dart';

class ProductCreatePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyProductCreateState();
  }
}

class _MyProductCreateState extends State<ProductCreatePage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'descProduct': null,
    'price': null,
    'imgUrl': 'assets/food.jpg'
  };
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();

  Widget _buildTitleTextField(Product products) {
    return TextFormField(
      // autovalidate: true,
      focusNode: _titleFocusNode,
      validator: (String valueCheck) {
        if (valueCheck.isEmpty || valueCheck.length < 5) {
          return 'Title is required more than 5';
        }
      },
      initialValue: products == null ? '' : products.title,
      decoration: InputDecoration(labelText: 'Enter title of product'),
      onSaved: (String value) {
        _formData['title'] = value;
      },
    );
  }

  Widget _buildDescTextField(Product products) {
    return TextFormField(
      focusNode: _descriptionFocusNode,
      validator: (String valueCheck) {
        if (valueCheck.isEmpty || valueCheck.length < 10) {
          return 'Description is required more than 10';
        }
      },
      maxLines: 4,
      decoration: InputDecoration(labelText: 'Enter description'),
      initialValue: products == null ? '' : products.descProduct,
      onSaved: (String value) {
        _formData['descProduct'] = value;
      },
    );
  }

  Widget _buildPriceTextField(Product products) {
    return TextFormField(
      focusNode: _priceFocusNode,
      validator: (String valueCheck) {
        //pakai REGULAR EXPRESSIONS UNTOK ALGORITMA JIKE YG DIINPUTKAN HARUS NUMBER

        if (valueCheck.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(valueCheck)) {
          return 'Price is required number input';
        }
      },
      decoration: InputDecoration(labelText: 'Enter price of product'),
      initialValue: products == null ? '' : products.price.toString(),
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        _formData['price'] = double.parse(value);
      },
    );
  }

  Widget _buildSaveButton() {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
      return model.isLoading ? Center(child: CircularProgressIndicator()) : 
      RaisedButton(
                child: Text('SAVE'),
                color: Colors.blue,
                textColor: Colors.white,
                onPressed: () => _saveForm(model.addProduct, model.updateProduct, model.selectedProduct, model.returnSelectedIndex),
              );
  
    },); }

  void _saveForm(Function addProduct, Function updateProduct, Function setSelectProduct, [int selectedProductIndex]) {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    if (selectedProductIndex == null) {
      addProduct(
          _formData['title'],
          _formData['descProduct'],
          _formData['imgUrl'],
          _formData['price']
      ).then((_){
          Navigator.pushReplacementNamed(context, '/home').then((_) => setSelectProduct(null));
          //gunakan 'widget.' kalau maok pakai addProduct method di stateful    
      });
    } else {
      updateProduct( 
          _formData['title'],
          _formData['descProduct'],
          _formData['imgUrl'],
          _formData['price']
        ).then((_){
          Navigator.pushReplacementNamed(context, '/home').then((_) => setSelectProduct(null));
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model){
      final Widget pageContent = GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              _buildTitleTextField(model.getSelectedProduct),
              _buildDescTextField(model.getSelectedProduct),
              _buildPriceTextField(model.getSelectedProduct),

              SizedBox(
                height: 10.0,
              ),
            
              _buildSaveButton()

              // GestureDetector(
              //   onTap: _saveForm,
              //   child: Container(
              //     padding: EdgeInsets.all(5.0),
              //     child: Text('SAVE'),
              //     color: Colors.green,
              //     ),
              //   )
            ],
          ),
        ),
      ),
    );
      return model.returnSelectedIndex == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(
              title: Text('Edit Page'),
            ),
            body: pageContent,
          );

    },); 
    
    
  }
}
