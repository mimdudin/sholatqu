import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';

import './pages/auth.dart';
import './pages/home.dart';
import './pages/product.dart';
import './pages/products_admin.dart';
import './scoped-models/main.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
    State<StatefulWidget> createState() {
      // TODO: implement createState
      return _MyAppState();
    }
}

class _MyAppState extends State<MyApp>{

  @override
  Widget build(BuildContext context) {
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
      theme: ThemeData(primarySwatch: Colors.deepOrange),
      // home: AuthPage(),
      routes: {
        //GLOBAL ROUTES

        '/': (BuildContext context) => AuthPage(),
        '/home': (BuildContext context) => HomePage(model),
        '/admin': (BuildContext context) => ProductsAdminPage(model)
        },
        onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');
            if(pathElements[0] != ''){
              return null;
            }

            if(pathElements[1] == 'product'){
              final int i = int.parse(pathElements[2]);
              return MaterialPageRoute<bool>(builder: (BuildContext context) => ProductPage(i));
              }
            return null;     
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(builder: (BuildContext context) => HomePage(model));
          }
    )
  );}
}
