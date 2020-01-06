import 'package:scoped_model/scoped_model.dart';
import 'package:shiptransportmobile/scoped_models/ConnectedProductsScopedModel.dart';

class MainScopedModel extends Model
    with
        ConnectedProductsScopedModel,
        UserModel,
        ProductsModel,
        TripModel,
        ShipModel,
        CrewModel,
        PassengerModel,
        UtilityModel {}
