import 'dart:async';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shiptransportmobile/models/Passenger.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shiptransportmobile/scoped_models/MainScopedModel.dart';

class QRScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return QRScreenState();
  }
}

class QRScreenState extends State<QRScreen> {
  String _content = '';
  bool isCustomer = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF6F8FA),
      appBar: AppBar(
        elevation: 0.1, // Check Platform if android
        backgroundColor: const Color(0xFFF6F8FA),
        title: new Center(
          child: new Text(
            'QR SCAN',
            style: TextStyle(
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
      body: Container(
        color: const Color(0xFFF6F8FA),
        margin: EdgeInsets.only(top: 20.0, left: 30.0, right: 30.0),
        child: ListView(
          children: <Widget>[
            Center(
              child: Container(
                //width: 260.0,
                height: 220.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(
                    new Radius.circular(16.0),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/ic_scan.png',
                    width: 110.0,
                    height: 110.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 4.0),
                width: double.infinity,
                //height: 80.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.white,
                  borderRadius: new BorderRadius.all(
                    new Radius.circular(16.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    _content != null ? _content : '',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            ScopedModelDescendant<MainScopedModel>(
              builder:
                  (BuildContext context, Widget child, MainScopedModel model) {
                return InkWell(
                  onTap: () => _openQRScanner(model),
                  child: new Center(
                    child: Container(
                      margin: EdgeInsets.only(top: 30.0),
                      width: 180.0,
                      height: 48.0,
                      decoration: new BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.red,
                        borderRadius: new BorderRadius.all(
                          new Radius.circular(24.0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'SCAN',
                          style: TextStyle(
                            color: Colors.white,
//                    /fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Visibility(
              child: InkWell(
                // onTap: () => _openQRScanner(),
                child: new Center(
                  child: Container(
                    margin: EdgeInsets.only(top: 30.0),
                    width: 180.0,
                    height: 48.0,
                    decoration: new BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.red,
                      borderRadius: new BorderRadius.all(
                        new Radius.circular(24.0),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Accept to Ship',
                        style: TextStyle(
                          color: Colors.white,
//                    /fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              visible: isCustomer,
            ),
          ],
        ),
      ),
    );
  }

  Future _openQRScanner(MainScopedModel model) async {
    try {
      String _content = await BarcodeScanner.scan();
      String scannedPassenger = await model.GetPasengerInformation(_content);
      setState(() {
        this._content = scannedPassenger;
        // Here will be Succes Message.
        this.isCustomer = true;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        showSnackBar('Please grant camera permission!');
        setState(() {
          this._content = null;
        });
      } else {
        showSnackBar('Error: $e');
        setState(() {
          this._content = null;
        });
      }
    } on FormatException {
      showSnackBar('User pressed "back" button before scanning');
      setState(() {
        this._content = null;
      });
    } catch (e) {
      showSnackBar('Error: $e');
      setState(() {
        this._content = null;
      });
    }
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    );

    _scaffoldKey.currentState.showSnackBar(snackBar);
  }
}
