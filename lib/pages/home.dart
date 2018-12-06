import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import '../widgets/products/products.dart';
import '../scoped-models/main.dart';

class HomePage extends StatefulWidget {
  final MainModel model;

  HomePage(this.model);

  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return _MyHomeState();
    }
}

class _MyHomeState extends State<HomePage> {

  @override
    void initState() {
      widget.model.fetchProducts();
      super.initState();
    }

  Widget _buildProductList() {
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      Widget content = Center(child: Text('No products found!'));
      if(model.displayedProducts.length > 0 && !model.isLoading ){
         content = Products(); 
      } else if(model.isLoading){
        content = Center(child: CircularProgressIndicator());
      }
    return RefreshIndicator(onRefresh: model.fetchProducts, child: content);
    },);
  }    

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ScopedModelDescendant<MainModel>(builder: (BuildContext context, Widget child, MainModel model) {
      return Scaffold(
            drawer: Drawer(
              child: Column(
                children: <Widget>[
                  AppBar(
                    automaticallyImplyLeading: false,
                    title: Text('Choose'),
                  ),
                  ListTile(
                    leading: Icon(Icons.edit),
                    title: Text('Manage Products'),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/admin');
                    },
                  )
                ],
              ),
            ),
            appBar: AppBar(
              title: Text('EasyList'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(model.onlyShowFavMode ? 
                  Icons.favorite : Icons.favorite_border),
                  onPressed: (){
                    model.toggleDisplayMode();
                  },
                )
              ],
            ),
            body: _buildProductList()); 
    },);  
  }
}
