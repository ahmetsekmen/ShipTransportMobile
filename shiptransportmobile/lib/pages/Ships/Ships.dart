import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:shiptransportmobile/models/Ship.dart';
import 'package:shiptransportmobile/pages/Crews/CrewsPage.dart';

import 'package:shiptransportmobile/scoped_models/MainScopedModel.dart';

class Ships extends StatelessWidget {
  Widget _buildShipsList(BuildContext context, MainScopedModel model) {
    //, List<Ship> ships : dispalyed ships like falan
    ListTile makeListTile(Ship ship) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Icon(Icons.autorenew, color: Colors.white),
          ),
          title: Text(
            ship.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

          subtitle: Row(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    // tag: 'hero',
                    child: LinearProgressIndicator(
                        backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
                        value: ship.indicatorValue,
                        valueColor: AlwaysStoppedAnimation(Colors.green)),
                  )),
              Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(ship.level,
                        style: TextStyle(color: Colors.white))),
              )
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            model.SetSelectedShip(ship);

            Navigator.push(
                context,
                MaterialPageRoute(
                    // builder: (context) => DetailPage(lesson: lesson)
                    // builder: (BuildContext context) => DetailPage(ship)));
                    builder: (BuildContext context) => CrewsPage(model, ship)));
          },
        );

    Card makeCard(Ship ship) => Card(
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
            child: makeListTile(ship),
          ),
        );

    return Container(
      // color: Colors.blueGrey.shade400,
      // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: model.allShips.length, // lessons.length,
        itemBuilder: (BuildContext context, int index) {
          return makeCard(model.allShips[index]);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(' Ürün widget ı build oluyor.');
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainScopedModel model) {
        return _buildShipsList(context, model); //model.displayedShips
      },
    );
  }
}
