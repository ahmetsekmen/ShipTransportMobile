import 'package:flutter/material.dart';
import 'package:shiptransportmobile/scoped_models/MainScopedModel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shiptransportmobile/widgets/products/Products.dart';

class ProductsPage extends StatefulWidget {
  final MainScopedModel model;

  ProductsPage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _ProductsPageState();
  }
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  initState() {
    print('_ProductsPageState');
    widget.model.fetchProducts();
    super.initState();
  }

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Menu'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Trips'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Information'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/admin');
            },
          )
        ],
      ),
    );
  }

  Widget _buildProductsList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainScopedModel model) {
        Widget content = Center(child: Text('There is no trip!'));
        if (model.displayedProducts.length > 0 && !model.isLoading) {
          content = Products();
        } else if (model.isLoading) {
          content = Center(
            child: CircularProgressIndicator(),
          );
        }
        // return content;
        return RefreshIndicator(
          onRefresh: model.fetchProducts,
          child: content,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('Ship Transport'),
        actions: <Widget>[
          // IconButton(
          //   icon: Icon(Icons.search),
          //   tooltip: 'Search',
          //   // onPressed: _Search,
          // ),
          ScopedModelDescendant<MainScopedModel>(
            builder:
                (BuildContext context, Widget child, MainScopedModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toggleDisplayMode();
                },
                tooltip: 'Likes',
              );
            },
          ),
        ],
      ),
      body: _buildProductsList(),
    );
  }
}
