import 'package:flutter/material.dart';
import 'package:shiptransportmobile/models/Ship.dart';
import 'package:shiptransportmobile/models/Crew.dart';
import 'package:shiptransportmobile/pages/Final/DetailPage.dart';
import 'package:shiptransportmobile/scoped_models/MainScopedModel.dart';
import 'package:scoped_model/scoped_model.dart';

class CrewsPage extends StatefulWidget {
  final Ship ship;
  final MainScopedModel model;

  CrewsPage(this.model, this.ship);

  final String title = "";

  @override
  _CrewsPageState createState() => _CrewsPageState();
}

// Adapted from the data table demo in offical flutter gallery:
// https://github.com/flutter/flutter/blob/master/examples/flutter_gallery/lib/demo/material/data_table_demo.dart

class _CrewsPageState extends State<CrewsPage> {
  @override
  void initState() {
    widget.model.fetchAllCrewsRelatedWithShips();
    super.initState();
  }

  int _rowsPerPage = PaginatedDataTable.defaultRowsPerPage;
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainScopedModel>(
        builder: (BuildContext context, Widget child, MainScopedModel model) {
      final topAppBar = AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {},
          )
        ],
      );

      final makeBody = SingleChildScrollView(
        child: Column(children: <Widget>[
          PaginatedDataTable(
            header: Text('Crew List'),
            rowsPerPage: _rowsPerPage,
            availableRowsPerPage: <int>[5, 10, 20],
            onRowsPerPageChanged: (int value) {
              print('ahmet' + value.toString());
              setState(() {
                _rowsPerPage = value;
              });
            },
            columns: kTableColumns,
            source: CrewDataSource(model),
          ),
          FlatButton(
            child: Text('Bas Gelsin'),
            onPressed: () {
              setState(() {});
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          DetailPage(model.allTrips[model.selectedTripIndex])));
            },
          ),
        ]),
      );

      final makeBottom = Container(
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
                onPressed: () {},
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

      return Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: topAppBar,
        body: makeBody,
        bottomNavigationBar: makeBottom,
      );
    });
  }
}

////// Columns in table.
const kTableColumns = <DataColumn>[
  DataColumn(
    label: const Text('Crew Name'),
  ),
  DataColumn(
    label: const Text('CrewPositionId'),
    tooltip: 'The total amount of food energy in the given serving size.',
    // numeric: true,
  ),
  DataColumn(
    label: const Text('ContractorId'),
    // numeric: true,
  ),
  DataColumn(
    label: const Text('BirthDate'),
  ),
  DataColumn(
    label: const Text('IdentityDocTypeID'),
    // numeric: true,
  ),
  DataColumn(
    label: const Text('IdentityDocNumber'),
    // numeric: true,
  ),
  DataColumn(
    label: const Text('GenderID'),
    tooltip:
        'The amount of calcium as a percentage of the recommended daily amount.',
    numeric: true,
  ),
  DataColumn(
    label: const Text('Nationality ID'),
    tooltip: 'Nationality',
    numeric: true,
  ),
  DataColumn(
    label: const Text('Id'),
  ),
];

////// Data source class for obtaining row data for PaginatedDataTable.
class CrewDataSource extends DataTableSource {
  int _selectedCount = 0;
  final MainScopedModel model;

  CrewDataSource(this.model);

  @override
  @override
  DataRow getRow(int index) {
    assert(index >= 0);
    if (index >= model.allCrews.length) return null;
    final Crew crew = model.allCrews[index];
    return DataRow.byIndex(
        index: index,
        selected: crew.selected,
        onSelectChanged: (bool value) {
          if (crew.selected != value) {
            print(index.toString() + value.toString());
            print(crew.name);
            _selectedCount += value ? 1 : -1;
            assert(_selectedCount >= 0);
            crew.selected = value;
            notifyListeners();
          }
        },
        cells: <DataCell>[
          DataCell(Text('${crew.name}')),
          DataCell(Text('${crew.crewPositionId}')),
          DataCell(Text('${crew.contractorId}')),
          DataCell(Text('${crew.birthDate}')),
          DataCell(Text('${crew.identityDocTypeID}')),
          DataCell(Text('${crew.identityDocNumber}')),
          DataCell(Text('${crew.nationalityID}%')),
          DataCell(Text('${crew.genderID}%')),
          DataCell(Text('${crew.Id}%')),
        ]);
    // DataCell(Text('${crew.protein.toStringAsFixed(1)}')),
  }

  @override
  int get rowCount => model.allCrews.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => _selectedCount;
}
