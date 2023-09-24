import 'package:app/components/ErrorMessage.dart';
import 'package:app/components/LoadMessage.dart';
import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'PagoState.dart';
import 'PagosWraper.dart';
import 'tables/TablePagos.dart';

class PlutoGridExamplePage extends StatefulWidget {
  const PlutoGridExamplePage({super.key});

  @override
  State<PlutoGridExamplePage> createState() => PlutoGridState();
}

class PlutoGridState extends State<PlutoGridExamplePage> {
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
        builder: (context, AsyncSnapshot<PagosWraper> tequios) {
          if (tequios.hasData) {
            if (tequios.data!.pagoPredial[0].tipo == null) {
              return ErrorMessage(
                  tequios.data!.pagoPredial[0].nombre.toString());
            } else {
              return Scaffold(
                body: Center(
                    child: Column(
                  children: <Widget>[
                    if (tequios.data!.readServer == false)
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "* Está leyendo los datos de la copia que obtuvo de la base de datos, esta información puede NO estar actualizada",
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.clip,
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.normal,
                              fontSize: 14,
                              color: Color(0xff7a0606),
                            ),
                          ),
                        ),
                      ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                        child: Center(
                            child: PlutoGrid(
                          columns: columnsTablePagos,
                          rows: List.generate(tequios.data!.pagoPredial.length,
                              (i) {
                            return PlutoRow(
                              cells: {
                                'folio': PlutoCell(
                                    value: tequios.data!.pagoPredial[i].folio),
                                'fecha': PlutoCell(
                                    value: tequios.data!.pagoPredial[i].fecha),
                                'nombre': PlutoCell(
                                    value: tequios.data!.pagoPredial[i].nombre),
                                'cantidad': PlutoCell(
                                    value:
                                        tequios.data!.pagoPredial[i].cantidad),
                                'periodo': PlutoCell(
                                    value:
                                        tequios.data!.pagoPredial[i].periodo),
                                'nota': PlutoCell(
                                    value: tequios.data!.pagoPredial[i].nota),
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
                        )),
                      ),
                    ),
                  ],
                )),
              );
            }
          } else {
            return LoadMessage("Cargando ....");
          }
        });
  }
}
