import 'package:flutter/material.dart';
import 'package:shiptransportmobile/models/Trip.dart';
import 'package:shiptransportmobile/pages/Crews/CrewsPage.dart';
import 'package:shiptransportmobile/pages/Crews/CrewsPage.dart';
import 'package:shiptransportmobile/pages/Ships/Ships.dart';
import 'package:shiptransportmobile/scoped_models/MainScopedModel.dart';
import 'package:scoped_model/scoped_model.dart';

class ShipsPage extends StatefulWidget {
  final Trip trip;
  final MainScopedModel model;

  ShipsPage(this.model, this.trip);

  final String title = "";

  @override
  _ShipsPageState createState() => _ShipsPageState();
}

class _ShipsPageState extends State<ShipsPage> {
  // Future<List> lessons;

  @override
  void initState() {
    widget.model.fetchAllShips();
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

  Widget _buildBottom() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainScopedModel model) {
        return Container(
          height: 55.0,
          child: BottomAppBar(
            color: Color.fromRGBO(58, 66, 86, 1.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.home, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.blur_on, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ShipsPage(model, model.selectedTrip)));
                  },
                ),
                IconButton(
                  icon: Icon(Icons.hotel, color: Colors.white),
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.account_box, color: Colors.white),
                  onPressed: () {},
                )
              ],
            ),
          ),
        );
      },
    );
  }


  Widget _buildShipsList() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainScopedModel model) {
        Widget content = Center(child: Text('There is no ship!'));
        if (model.displayedShips.length > 0 && !model.isLoading) {
          content = Ships();
        } else if (model.isLoading) {
          content = Center(
            child: CircularProgressIndicator(),
          );
        }

        // return content;
        return RefreshIndicator(
          onRefresh: model.fetchAllShips,
          child: content,
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      drawer: _buildSideDrawer(context),
      appBar: AppBar(
        title: Text('Ships'),
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
      body: _buildShipsList(),
      bottomNavigationBar: _buildBottom(),
    );
  }
}
