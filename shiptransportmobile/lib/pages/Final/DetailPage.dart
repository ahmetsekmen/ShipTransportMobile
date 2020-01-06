import 'package:shiptransportmobile/models/Trip.dart';
import 'package:flutter/material.dart';
import 'package:shiptransportmobile/pages/Final/QRScreen.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shiptransportmobile/scoped_models/MainScopedModel.dart';

class DetailPage extends StatelessWidget {
  final Trip trip;
  DetailPage(this.trip);
  @override
  Widget build(BuildContext context) {
    // return ScopedModelDescendant(
    //   builder: (BuildContext context, Widget child, MainScopedModel model) {

    //   },
    // );

    final levelIndicator = Container(
      child: Container(
        child: LinearProgressIndicator(
            backgroundColor: Color.fromRGBO(209, 224, 224, 0.2),
            value: trip.indicatorValue,
            valueColor: AlwaysStoppedAnimation(Colors.green)),
      ),
    );

    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    final coursePrice = Container(
      padding: const EdgeInsets.all(7.0),
      decoration: new BoxDecoration(
          border: new Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(5.0)),
      child: new Text(
        "\$" + trip.price.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );

    final topContentText = SingleChildScrollView(child: ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainScopedModel model) {
        return Container(
          child: Form(
            // key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 40.0),
                // Icon(
                //   Icons.airline_seat_recline_normal,
                //   color: Colors.white,
                //   size: 40.0,
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(flex: 4, child: levelIndicator),
                    Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: Icon(Icons.airline_seat_recline_normal,
                                    color: Colors.white, size: 30.0),
                                tooltip: 'Increase volume by 10',
                                onPressed: () {
                                  // model.SetPassengerPersent("2/10");
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          // builder: (context) => DetailPage(lesson: lesson)
                                          builder: (BuildContext context) =>
                                              QRScreen()));
                                },
                              ),
                              Text(model.PassengerPersent,
                                  style: TextStyle(
                                      color: Colors.amber.withOpacity(0.6),
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                          // Icon(Icons.airline_seat_recline_normal,
                          //     color: Colors.white,
                          //     size: 30.0,
                          //     semanticLabel: "asd"
                          // ),
                          // Text(
                          //   trip.level,
                          //   style: TextStyle(color: Colors.red),
                          // )
                        )),
                    Expanded(flex: 1, child: coursePrice)
                  ],
                ),
                SizedBox(height: 10.0),
                Text(
                  model.GetSelectedShip().title,
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
                Text(
                  model.GetSelectedTrip().title,
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
                Container(
                  width: 290.0,
                  child: new Divider(color: Colors.green),
                ),
                SizedBox(height: 90.0),
              ],
            ),
          ),
        );
      },
    ));

    final topContent = Stack(
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 10.0),
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: new AssetImage("port2.jpg"),
                fit: BoxFit.cover,
              ),
            )),
        Container(
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.all(40.0),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, .9)),
          child: Center(
            child: topContentText,
          ),
        ),
        Positioned(
          left: 8.0,
          top: 60.0,
          child: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back, color: Colors.white),
          ),
        )
      ],
    );

    final bottomContentText = Text(
      trip.content,
      style: TextStyle(fontSize: 18.0),
    );
    final readButton = Container(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        width: MediaQuery.of(context).size.width,
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    // builder: (context) => DetailPage(lesson: lesson)
                    builder: (BuildContext context) => QRScreen()));
          },
          // onPressed: () => {
          //   Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           // builder: (context) => DetailPage(lesson: lesson)
          //           builder: (BuildContext context) => DetailPage(lesson)));
          // },
          color: Color.fromRGBO(58, 66, 86, 1.0),
          child: Text("Start Ship", style: TextStyle(color: Colors.white)),
        ));

    final bottomContentPassengers = Container(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[readButton],
      ),
    );

    final bottomContent = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(30.0),
      child: Center(
        child: Column(
          children: <Widget>[
            bottomContentText,
            // readButton,
            bottomContentPassengers
          ],
        ),
      ),
    );

    // final double deviceWidth = MediaQuery.of(context).size.width;
    // final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            // width: targetWidth,
            child: Form(
              // key: _formKey,
              child: Column(
                children: <Widget>[topContent, bottomContent],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
