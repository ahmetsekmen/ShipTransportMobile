import 'package:flutter/material.dart';
import 'package:shiptransportmobile/pages/ProductEditPage.dart';
import 'package:shiptransportmobile/pages/ProductListPage.dart';
import 'package:shiptransportmobile/scoped_models/MainScopedModel.dart';

class ProductsAdminPage extends StatelessWidget {
  final MainScopedModel model;

  ProductsAdminPage(this.model);

  Widget _buildSideDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text('Seçim'),
          ),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Bütün Ürünler'),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/products');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: _buildSideDrawer(context),
        appBar: AppBar(
          title: Text('Ship Panel'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.create),
                text: 'Passengers',
              ),
              Tab(
                icon: Icon(Icons.list),
                text: 'Dates',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[ProductEditPage(), ProductListPage(model)],
        ),
      ),
    );
  }
}
