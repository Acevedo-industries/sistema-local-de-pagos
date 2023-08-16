import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'PagoState.dart';
import 'Pago.dart';

/// PlutoGrid Example
//
/// For more examples, go to the demo web link on the github below.
class PlutoGridExamplePage extends StatefulWidget {
  //const PlutoGridExamplePage({Key? key}) : super(key: key);

  PlutoGridExamplePage({super.key});

  @override
  State<PlutoGridExamplePage> createState() => _PlutoGridExamplePageState();
}

class _PlutoGridExamplePageState extends State<PlutoGridExamplePage> {
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

  /// [PlutoGridStateManager] has many methods and properties to dynamically manipulate the grid.
  /// You can manipulate the grid dynamically at runtime by passing this through the [onLoaded] callback.
  late final PlutoGridStateManager stateManager;

  late PagoState _pagoState;
  @override
  void initState() {
    super.initState();
    _pagoState = new PagoState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _pagoState.getTequios(),
        builder: (context, AsyncSnapshot<List<Pago>> tequios) {
          return PlutoGrid(
            columns: columns,
            rows: List.generate(tequios.data!.length, (i) {
              return PlutoRow(
                cells: {
                  'id': PlutoCell(value: tequios.data![i].index),
                  'folio': PlutoCell(value: tequios.data![i].folio),
                  'fecha': PlutoCell(value: tequios.data![i].fecha),
                  'nombre': PlutoCell(value: tequios.data![i].nombre),
                  'cantidad': PlutoCell(value: tequios.data![i].cantidad),
                  'periodo': PlutoCell(value: tequios.data![i].periodo),
                  'nota': PlutoCell(value: tequios.data![i].nota),
                },
              );
              //return Pago.fromJson(pagosquery[i]);
            }),
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
        });
  }
}
