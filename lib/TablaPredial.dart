import 'package:app/components/LoadMessage.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'PagoState.dart';
import 'Pago.dart';
import 'tables/TablePagos.dart';

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
        future: _pagoState.getPrediales(),
        builder: (context, AsyncSnapshot<List<Pago>> tequios) {
          if (tequios.hasData) {
            return PlutoGrid(
              columns: columnsTablePagos,
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
          } else {
            return LoadMessage("Cargando ....");
          }
        });
  }
}
