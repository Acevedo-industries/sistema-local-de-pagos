import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:provider/provider.dart';
import 'PagoState.dart';
import 'Pago.dart';

class PlutoGridExamplePage extends StatelessWidget {
  const PlutoGridExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PagoState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: PlutoGridExampleView(),
      ),
    );
  }
}

class PlutoGridExampleView extends StatefulWidget {
  @override
  PlutoGridState createState() => PlutoGridState();
}

class PlutoGridState extends State<PlutoGridExampleView> {
  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  late PagoState _pagoState;
  @override
  void initState() {
    super.initState();
    _pagoState = new PagoState();
    _pagoState.getTequios();
  }

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Id',
      field: 'id',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Fecha',
      field: 'fecha',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Folio',
      field: 'folio',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Nombre',
      field: 'nombre',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Cantidad',
      field: 'cantidad',
      type: PlutoColumnType.text(),
      /* footerRenderer: (rendererContext) {
        return PlutoAggregateColumnFooter(
          rendererContext: rendererContext,
          formatAsCurrency: true,
          type: PlutoAggregateColumnType.sum,
          format: '#,###',
          alignment: Alignment.center,
          titleSpanBuilder: (text) {
            return [
              const TextSpan(
                text: 'Total',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
              const TextSpan(text: ' : '),
              TextSpan(text: text),
            ];
          },
        );
      }, */
    ),
    PlutoColumn(
      title: 'Periodo',
      field: 'periodo',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Nota',
      field: 'nota',
      type: PlutoColumnType.text(),
    ),
  ];

  var rowsTable = <PlutoRow>[];

  void _changedRows(var myNewrows) {
    print("=====");
    setState(() {
      rowsTable = myNewrows;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<PagoState>();

    List<PlutoRow> newrows;
    ((value) => {
          print("value ___________________ $value"),
          newrows = <PlutoRow>[],
          for (var line in value)
            {
              newrows.add(
                PlutoRow(
                  cells: {
                    'id': PlutoCell(value: line.index),
                    'folio': PlutoCell(value: line.folio),
                    'fecha': PlutoCell(value: line.fecha),
                    'nombre': PlutoCell(value: line.nombre),
                    'cantidad': PlutoCell(value: line.cantidad),
                    'periodo': PlutoCell(value: line.periodo),
                    'nota': PlutoCell(value: line.nota),
                  },
                ),
              ),
            },
          _changedRows(newrows)
        })(appState.pagoTequios);

    return PlutoGrid(
      columns: columns,
      rows: rowsTable,
      //columnGroups: columnGroups,
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        stateManager.setShowColumnFilter(true);
      },
      onChanged: (PlutoGridOnChangedEvent event) {
        print(event);
      },
      configuration: const PlutoGridConfiguration(),
    );
  }
}
