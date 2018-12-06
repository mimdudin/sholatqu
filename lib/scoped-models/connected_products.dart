import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

import '../models/product.dart';
import '../models/user.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  int _selProductIndex;
  bool _isLoading = false;

  Future<Null> addProduct(
      String title, String descProduct, String imgUrl,  double price) async {
      _isLoading = true;
      notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'descProduct': descProduct,
      'imgUrl': 'https://budianto88.files.wordpress.com/2010/11/box-of-chocolate-candy-chocolate-2317057-1024-768.jpg',
      'price': price,
      'userId': _authenticatedUser.id,
      'userEmail': _authenticatedUser.email
    };    

  try {
    final http.Response response = await 
    http.post('https://crud-mahasiswa-11590.firebaseio.com/products.json', 
    body: json.encode(productData));

      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          imgUrl: imgUrl,
          descProduct: descProduct,
          price: price,
          userId: _authenticatedUser.id,
          userEmail: _authenticatedUser.email);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
    }
   }
  }

class ProductsModel extends ConnectedProductsModel {
    bool _showFavorites = false;

    List<Product> get allProducts {
      return List.from(_products);
    }

// GETTER 

  int get returnSelectedIndex {
    return _selProductIndex;
  }

  List<Product> get displayedProducts {
    if(_showFavorites){
      return List.from(_products.where((Product products) => products.isFavorite).toList());
    }

    return List.from(_products);
  }
  
  bool get onlyShowFavMode {
    return _showFavorites;
  }
//GETTER

  Product get getSelectedProduct {
    if(_selProductIndex == null) {
      return null;
    }
    return _products[_selProductIndex];
  }

  void deleteProduct(){
      _isLoading = true;
      final deletedProduct = getSelectedProduct.id;
      _products.removeAt(_selProductIndex);
      _selProductIndex = null;
      notifyListeners();

      http.delete('https://crud-mahasiswa-11590.firebaseio.com/products/$deletedProduct.json')
        .then((http.BaseResponse response){
          _isLoading = false;
          notifyListeners();
        });

  }


  Future<Null> fetchProducts () {
    _isLoading = true;
    notifyListeners();
    
    return http.get('https://crud-mahasiswa-11590.firebaseio.com/products.json')
      .then((http.Response response) {
        final List<Product> fetchedProductList = [];
        final Map<String, dynamic> productListData = json.decode(response.body);
        if(productListData == null){
          _isLoading = false;
          notifyListeners();
          return;
        }
        productListData.forEach((String productId, dynamic productData) {
            final Product products = Product(
              id: productId,
              title: productData['title'],
              descProduct: productData['descProduct'],
              // imgUrl: productData['imgUrl'],
              imgUrl: 'assets/food.jpg',
              price: productData['price'],
              userId: productData['userId'],
              userEmail: productData['userEmail']);

            fetchedProductList.add(products);
        });
        _products = fetchedProductList;
        _isLoading = false;
        notifyListeners();
      });
  }

  Future<Null> updateProduct(String title, String descProduct, String imgUrl,  double price) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'descProduct': descProduct,
      'imgUrl': 'https://budianto88.files.wordpress.com/2010/11/box-of-chocolate-candy-chocolate-2317057-1024-768.jpg',
      'price': price,
      'userId': getSelectedProduct.id,
      'userEmail': getSelectedProduct.userEmail
    };

    return http.put('https://crud-mahasiswa-11590.firebaseio.com/products/${getSelectedProduct.id}.json', 
    body: json.encode(updateData)).then((http.Response response){
      _isLoading = false;
      final Product updateProduct = Product(
          id:  getSelectedProduct.id,
          title: title,
          imgUrl: 'assets/food.jpg',
          descProduct: descProduct,
          price: price,
          userId: getSelectedProduct.userId,
          userEmail: getSelectedProduct.userEmail);
        _products[_selProductIndex] = updateProduct;
         notifyListeners();


    });
  }

  void selectedProduct(int index) {
    _selProductIndex = index; 
    notifyListeners();

  }

  void toggleIsCurrentlyFavorite() {
    final bool isCurrentlyStatus = getSelectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyStatus;
    final Product updateProduct = Product(
      id: null,
      title: getSelectedProduct.title,
      descProduct: getSelectedProduct.descProduct,
      imgUrl: getSelectedProduct.imgUrl,
      price: getSelectedProduct.price,
      isFavorite: newFavoriteStatus,
      userId: getSelectedProduct.userId,
      userEmail: getSelectedProduct.userEmail);

      _products[_selProductIndex] = updateProduct;
      notifyListeners();

  }

  void toggleDisplayMode () {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
  
}

class UserModel extends ConnectedProductsModel {

  void login(String email, String password){
    _authenticatedUser = User(id: 'asdadasda', email: email, password: password);
  }

}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}