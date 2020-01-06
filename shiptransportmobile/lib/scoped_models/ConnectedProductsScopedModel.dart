import 'package:scoped_model/scoped_model.dart';
import 'package:shiptransportmobile/models/Passenger.dart';

import 'dart:convert';
// // import 'dart:async';
import 'package:shiptransportmobile/models/Product.dart';
import 'package:shiptransportmobile/models/User.dart';
import 'package:shiptransportmobile/models/Trip.dart';
import 'package:shiptransportmobile/models/Ship.dart';
import 'package:shiptransportmobile/models/Crew.dart';
// import 'package:shiptransportmobile/models/Passenger.dart';
import 'package:http/http.dart' as httpDart;
import 'package:shiptransportmobile/models/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectedProductsScopedModel extends Model {
  List<Product> _products = [];
  List<Trip> _trips = [];
  List<Ship> _ships = [];
  List<Crew> _crews = [];
  String _selTripId;
  String _selShipId;
  String _selCrewId;
  Ship _selectedShip;
  Trip _selectedTrip;
  String _selProductId;
  User _authenticatedUser;
  String _scannedPassengerName;
  String screenTitle = "";
  bool _isLoading = false;
  String _persentage = "0/10";
}

//  888888ba                                   dP                        dP
//  88    `8b                                  88                        88
// a88aaaa8P'    88d888b.    .d8888b.    .d888b88    dP    dP .d8888b. d8888P
//  88           88'  `88    88'  `88    88'  `88    88    88 88'  `""   88
//  88           88          88.  .88    88.  .88    88.  .88 88.  ...   88
//  dP           dP          `88888P'    `88888P8    `88888P' `88888P'   dP

class ProductsModel extends ConnectedProductsScopedModel {
  bool _showFavorites = false;

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    print(_authenticatedUser.email);

    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'http://cdn.kaltura.com/p/0/thumbnail/entry_id/1_psg64epw/quality/80/width//height//src_x//src_y//src_w/NaN/src_h/NaN/vid_sec/0.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    try {
      final httpDart.Response response = await httpDart.post(
          'https://ucuzapp.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
          body: json.encode(productData));
      // .then((httpDart.Response response) {
      //   if (response.statusCode != 200 || response.statusCode != 201) {
      //     _isLoading = false;
      //     notifyListeners();
      //     return false;
      //   }

      final Map<String, dynamic> responseData = json.decode(response.body);

      print('firebase responseData :' + responseData.toString());

      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners(); //scoped modeli haberdar ediyor.
      return true;
      // _selProductIndex=null;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("ERROR GELDİ");
      return false;
    }

    // ).catchError((error) {
    //     _isLoading = false;
    //     notifyListeners();
    //     return false;
    //     print("ERROR GELDİ");
    //   });
  }

  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  String get selectedProductId {
    return _selProductId;
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  Product get selectedProduct {
    print('MEtod  selectedProduct :' + selectedProductId.toString());
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _selProductId;
    });
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) {
    _isLoading = true;
    print('selected product ID for update : ' + selectedProduct.id);
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'title': title,
      'description': description,
      'image':
          'http://cdn.kaltura.com/p/0/thumbnail/entry_id/1_psg64epw/quality/80/width//height//src_x//src_y//src_w/NaN/src_h/NaN/vid_sec/0.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    return httpDart
        .put(
            'https://ucuzapp.firebaseio.com/products/${selectedProduct.id}.json?auth=${_authenticatedUser.token}',
            body: jsonEncode(updateData))
        .then((httpDart.Response response) {
      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);

      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final deletedProductId = selectedProduct.id;

    _products.removeAt(selectedProductIndex);
    _selProductId = null;

    notifyListeners();
    return httpDart
        .delete(
            'https://ucuzapp.firebaseio.com/products/${deletedProductId}.json?auth=${_authenticatedUser.token}')
        .then((httpDart.Response response) {
      _isLoading = false;

      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });

    // _selProductId = null; //seçili bir product kalmadı.
  }

  Future<Null> fetchProducts() {
    _isLoading = true;
    notifyListeners();
    print('fetchProducts çalıştı.');
    return httpDart.get(
        'https://ucuzapp.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
        headers: {
          "Accept": "application/json"
        }).then<Null>((httpDart.Response response) {
      print(response);
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);

      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      productListData.forEach((String prodcutId, dynamic productData) {
        final Product product = Product(
          id: prodcutId,
          title: productData['title'],
          description: productData['description'],
          image: productData['image'],
          price: productData['price'],
          userEmail: productData['userEmail'],
          userId: productData['userId'],
        );
        fetchedProductList.add(product);
      });
      // print(fetchedProductList.first.id);
      _products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
      _selProductId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = selectedProduct.isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId,
        isFavorite: newFavoriteStatus);
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
  }

  void selectProduct(String prodcutId) {
    _selProductId = prodcutId;
    print('_selProductIndex : ' + _selProductId);
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }
}

// dP     dP
// 88     88
// 88     88    .d8888b.    .d8888b.    88d888b.
// 88     88    Y8ooooo.    88ooood8    88'  `88
// Y8.   .8P          88    88.  ...    88
// `Y88888P'    `88888P'    `88888P'    dP

class UserModel extends ConnectedProductsScopedModel {
  User get user {
    return _authenticatedUser;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, String> authData = {
      'Username': email,
      'Password': password
      // 'returnSecureToken': true
    };
    // var body = json.encode({"foo": "bar"});

    Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json"
    };

    httpDart.Response response;
    if (mode == AuthMode.Login) {
      //Firebase Login
      // response = await httpDart.post(
      //   'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyDHxRvXQQm23n9C3C0JGruh--6R16VCb_Y',
      //   body: json.encode(authData),
      //   headers: {'Content-Type': 'application/json'},
      // );
      // print(response);
      //Firebase Login--

      //Webapi Login
      print('loigndeyiz');
      print(authData);
      try {
        response = await httpDart.post(
            'http://193.124.56.237:8099/Account/createtoken',
            // 'http://10.0.2.2:58845/Account/createtoken',
            headers: headers,
            body: json.encode(authData));
      } catch (e) {
        print(e);
      }

      print(response);
      print('loign bitiş');
      //Webapi Login--
    } else {
      response = await httpDart.post(
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyDHxRvXQQm23n9C3C0JGruh--6R16VCb_Y',
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Hata oluştu!';
    if (responseData.containsKey('token')) {
      hasError = false;
      message = 'Auth Succeded';

      _authenticatedUser = User(
          // id: responseData['localId'],
          email: email,
          token: responseData['token'],
          id: responseData['userId']);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['token']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', responseData['userId']);
      prefs.setString('expiration', responseData['expiration']);
      // prefs.setString('userId', responseData['localId']);
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'Email Not found';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Password Invalid';
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'Email exists';
    }

    _isLoading = false;
    notifyListeners();

    print(json.decode(response.body));
    return {'success': !hasError, 'message': message};
  }

  void AutoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    if (token != null) {
      _authenticatedUser = User(
          id: prefs.getString('userEmail'),
          email: prefs.getString('userId'),
          token: token);

      notifyListeners();
    }
  }
}

// d888888P                oo
//    88
//    88       88d888b.    dP    88d888b.
//    88       88'  `88    88    88'  `88
//    88       88          88    88.  .88
//    dP       dP          dP    88Y888P'
//                               88
//                               dP

class TripModel extends ConnectedProductsScopedModel {
  List<Trip> get allTrips {
    return List.from(_trips);
  }

  List<Trip> get displayedTrips {
    // if (_showFavorites) {
    //   return _trips.where((Trip trip) => trip.isFavorite).toList();
    // }
    return List.from(_trips);
  }

  String get selectedTripId {
    return _selTripId;
  }

  int get selectedTripIndex {
    return _trips.indexWhere((Trip trip) {
      return trip.Id == _selTripId;
    });
  }

  Trip get selectedTrip {
    print('MEtod  selectedTrip :' + selectedTripId.toString());
    if (selectedTripId == null) {
      return null;
    }
    return _trips.firstWhere((Trip trip) {
      return trip.Id == _selTripId;
    });
  }

  void SetSelectedTrip(Trip trip) {
    _selectedTrip = trip;
  }

  Trip GetSelectedTrip() {
    return _selectedTrip;
  }

  // bool get displayFavoritesOnly {
  //   return _showFavorites;
  // }

  void selectTrip(String tripId) {
    _selTripId = tripId;
    print('_selTripId : ' + _selTripId);
    notifyListeners();
  }

  Future<Null> fetchAllTrips() {
    print(_authenticatedUser.token);

    _isLoading = true;
    print('fetchAllTrips çalıştı.');

    Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + _authenticatedUser.token
    };

    return httpDart
        .get(
            'http://193.124.56.237:8099/api/tripapi/Queryble?\$Expand=Captain&\$filter=IsDeleted+eq+false+and+Captain/StoreUserId+eq+' +
                _authenticatedUser.id
            // 'http://193.124.56.237:8099/api/tripapi/Queryble?\$Expand=Captain&\$filter=Captain/StoreUserId+eq+'+_authenticatedUser.id
            // 'http://193.124.56.237:8099/api/tripapi'
            ,
            headers: headers)
        .then<Null>((httpDart.Response response) {
      print(response.body);
      final List<Trip> fetchedTripList = [];

      // var jsonResult = json.decode(response.body)['data'];  //Web.Api Custom Succes result node But not works with Odata Actions
      var jsonResult = json.decode(response.body);

      final List<dynamic> tripListData = jsonResult;

      if (tripListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      tripListData.forEach((dynamic tripData) {
        final Trip trip = Trip(
          Id: tripData['Id'],
          title: tripData['Number'],
          indicatorValue: 0.20, //tripData['level'],
          level: "Level",
          // image: tripData['image'],
          price: 10, //tripData['price'],
          content:
              // "Start by taking a couple of minutes to read the info in this section.",
              "List of entered Passenger; Start by taking a couple of minutes to read the info in this section. Launch your app and click on the Settings menu.  While on the settings page, click the Save button.  You should see a circular progress indicator display in the middle of the page and the user interface elements cannot be clicked due to the modal barrier that is constructed.",
          // userEmail: tripData['userEmail'],
          // userId: tripData['userId'],
        );
        fetchedTripList.add(trip);
      });
      // print(fetchedProductList.first.id);
      _trips = fetchedTripList;
      _isLoading = false;
      notifyListeners();
      _selTripId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }
}

// .d8888.      db   db      d888888b      d8888b.
// 88'  YP      88   88        `88'        88  `8D
// `8bo.        88ooo88         88         88oodD'
//   `Y8b.      88~~~88         88         88~~~
// db   8D      88   88        .88.        88
// `8888Y'      YP   YP      Y888888P      88

class ShipModel extends ConnectedProductsScopedModel {
  List<Ship> get allShips {
    return List.from(_ships);
  }

  List<Ship> get displayedShips {
    // if (_showFavorites) {
    //   return _ships.where((Ship ship) => ship.isFavorite).toList();
    // }
    return List.from(_ships);
  }

  void SetSelectedShip(Ship ship) {
    _selectedShip = ship;
  }

  Ship GetSelectedShip() {
    return _selectedShip;
  }

  String get selectedShipId {
    return _selShipId;
  }

  int get selectedShipIndex {
    return _ships.indexWhere((Ship ship) {
      return ship == _selShipId;
    });
  }

  Ship get selectedShip {
    print('MEtod  selectedShip :' + selectedShipId.toString());
    if (selectedShipId == null) {
      return null;
    }
    return _ships.firstWhere((Ship ship) {
      return ship.Id == _selShipId;
    });
  }

  // bool get displayFavoritesOnly {
  //   return _showFavorites;
  // }

  Future<Null> fetchAllShips() {
    print(_authenticatedUser.token);

    _isLoading = true;
    print('fetchAllShips çalıştı.');

    Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + _authenticatedUser.token
    };

    return httpDart
        .get(
            // 'http://193.124.56.237:8099/api/shipapi/Queryble?\$Expand=Captain&\$filter=Captain/StoreUserId+eq+'+_authenticatedUser.id
            'http://193.124.56.237:8099/api/shipapi/Queryble?\$filter=IsDeleted+eq+false',
            headers: headers)
        .then<Null>((httpDart.Response response) {
      print(response.body);
      final List<Ship> fetchedShipList = [];

      // var jsonResult = json.decode(response.body)['data'];  //Web.Api Custom Succes result node But not works with Odata Actions
      var jsonResult = json.decode(response.body);

      final List<dynamic> shipListData = jsonResult;

      if (shipListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      shipListData.forEach((dynamic shipData) {
        final Ship ship = Ship(
          Id: shipData['Id'],
          title: shipData['Name'],
          indicatorValue: 0.20, //shipData['level'],
          level: "Level",
          // image: shipData['image'],
          price: 10, //shipData['price'],
          content:
              "Start by taking a couple of minutes to read the info in this section.",
        );
        fetchedShipList.add(ship);
      });
      // print(fetchedProductList.first.id);
      _ships = fetchedShipList;
      _isLoading = false;
      notifyListeners();
      _selShipId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }
}

//  .o88b.      d8888b.      d88888b      db   d8b   db
// d8P  Y8      88  `8D      88'          88   I8I   88
// 8P           88oobY'      88ooooo      88   I8I   88
// 8b           88`8b        88~~~~~      Y8   I8I   88
// Y8b  d8      88 `88.      88.          `8b d8'8b d8'
//  `Y88P'      88   YD      Y88888P       `8b8' `8d8'

class CrewModel extends ConnectedProductsScopedModel {
  List<Crew> get allCrews {
    return List.from(_crews);
  }

  List<Crew> get displayedCrews {
    // if (_showFavorites) {
    //   return _crews.where((Crew crew) => crew.isFavorite).toList();
    // }
    return List.from(_crews);
  }

  String get selectedCrewId {
    return _selCrewId;
  }

  int get selectedCrewIndex {
    return _crews.indexWhere((Crew crew) {
      return crew == _selCrewId;
    });
  }

  Crew get selectedCrew {
    print('MEtod  selectedCrew :' + selectedCrewId.toString());
    if (selectedCrewId == null) {
      return null;
    }
    return _crews.firstWhere((Crew crew) {
      return crew.Id == _selCrewId;
    });
  }

  // bool get displayFavoritesOnly {
  //   return _showFavorites;
  // }

  Future<Null> fetchAllCrewsRelatedWithShips() {
    print(_authenticatedUser.token);

    _isLoading = true;
    print('fetchAllCrews çalıştı.');

    Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer " + _authenticatedUser.token
    };

    return httpDart
        .get(
            // 'http://193.124.56.237:8099/api/crewapi/Queryble?\$Expand=Captain&\$filter=Captain/StoreUserId+eq+'+_authenticatedUser.id
            'http://193.124.56.237:8099/api/crewitemapi/Queryble?\$filter=IsDeleted+eq+false',
            headers: headers)
        .then<Null>((httpDart.Response response) {
      print(response.body);
      final List<Crew> fetchedCrewList = [];

      // var jsonResult = json.decode(response.body)['data'];  //Web.Api Custom Succes result node But not works with Odata Actions
      var jsonResult = json.decode(response.body);

      final List<dynamic> crewListData = jsonResult;

      if (crewListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }

      crewListData.forEach((dynamic crewData) {
        final Crew crew = new Crew(
            crewData['Id'],
            crewData['Name'],
            crewData['CrewPositionId'],
            crewData['ContractorId'],
            DateTime.now(),
            crewData['IdentityDocTypeID'],
            crewData['IdentityDocNumber'],
            crewData['NationalityID'],
            crewData['GenderID']);
        fetchedCrewList.add(crew);
      });
      // print(fetchedProductList.first.id);
      _crews = fetchedCrewList;
      _isLoading = false;
      notifyListeners();
      _selCrewId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }
}

class UtilityModel extends ConnectedProductsScopedModel {
  bool get isLoading {
    return _isLoading;
  }
}

// 88""Yb        db        .dP"Y8     .dP"Y8     888888     88b 88      dP""b8     888888     88""Yb
// 88__dP       dPYb       `Ybo."     `Ybo."     88__       88Yb88     dP   `"     88__       88__dP
// 88"""       dP__Yb      o.`Y8b     o.`Y8b     88""       88 Y88     Yb  "88     88""       88"Yb
// 88         dP""""Yb     8bodP'     8bodP'     888888     88  Y8      YboodP     888888     88  Yb

class PassengerModel extends ConnectedProductsScopedModel {
  String get PassengerPersent {
    return _persentage;
  }

  void SetPassengerPersent(String persentage) {
    _persentage = persentage;
  }

  Future<String> GetPasengerInformation(String ticketToken) async {
    print(_authenticatedUser.token);

    _isLoading = true;
    print('GetPasengerInformation çalıştı.');

    Map<String, String> headers = {
      "Accept": "application/json",
      "content-type": "application/json",
      // "Authorization": "Bearer " + _authenticatedUser.token
    };

    return httpDart
        .get(
            // 'http://193.124.56.237:8099/api/crewapi/Queryble?\$Expand=Captain&\$filter=Captain/StoreUserId+eq+'+_authenticatedUser.id
            'http://193.124.56.237:8099/Account/GetName?token=' + ticketToken,
            headers: headers)
        .then<String>((httpDart.Response response) {
      print(response.body);
      _scannedPassengerName = response.body;
      _isLoading = false;
      notifyListeners();
      return response.body;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }
}
