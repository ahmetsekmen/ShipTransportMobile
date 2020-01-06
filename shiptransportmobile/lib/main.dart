import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shiptransportmobile/pages/Trips/TripsPage.dart';
import 'package:shiptransportmobile/scoped_models/MainScopedModel.dart';

import 'package:shiptransportmobile/pages/AuthPage.dart';
import 'package:shiptransportmobile/pages/ProductsPage.dart';
import 'package:shiptransportmobile/pages/ProductsAdminPage.dart';

import 'package:shiptransportmobile/pages/ProductPage.dart';
import 'package:shiptransportmobile/models/Product.dart';

void main() {
  // debugPaintSizeEnabled = true;
  // debugPaintBaselinesEnabled = true;
  // debugPaintPointersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  final MainScopedModel _model = MainScopedModel();

  @override
  void initState() {
    // _model.AutoAuthenticate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainScopedModel>(
      model: _model,
      child: MaterialApp(
        title: "asdasd", //_model.screenTitle,
        theme: new ThemeData(
            primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
            buttonColor: Colors.blueAccent,
            brightness: Brightness.light,
            primarySwatch: Colors.teal),
        // theme: ThemeData(
        //     brightness: Brightness.light,
        //     primarySwatch: Colors.teal,
        //     accentColor: Colors.deepPurple,
        //     buttonColor: Colors.blueAccent),
        routes: {
          '/': (BuildContext context) => ScopedModelDescendant(
                builder: (BuildContext context, Widget child,
                    MainScopedModel model) {
                  // return model.user == null ? AuthPage() : ProductsPage(_model);
                  return model.user == null ? AuthPage() : TripsPage(_model);
                },
              ),
          '/products': (BuildContext context) => ProductsPage(_model),
          '/trips': (BuildContext context) => TripsPage(_model),
          '/admin': (BuildContext context) => ProductsAdminPage(_model),
        },
        onGenerateRoute: (RouteSettings settings) {
          print('onGenerateRoute a geldi');
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            print('onGenerateRoute  pathElements[1] == "product"');
            final String productId = pathElements[2];
            final Product product =
                _model.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => ProductPage(product),
            );
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          print('onUnknownRoute a geldi');
          return MaterialPageRoute(
              builder: (BuildContext context) => ProductsPage(_model));
        },
      ),
    );
  }
}
