library my_prj.globals;

import 'package:flutter/material.dart';
import 'package:pluto_grid/pluto_grid.dart';

final List<PlutoColumn> columnsTablePagos = <PlutoColumn>[
  PlutoColumn(
    title: 'Folio',
    field: 'folio',
    type: PlutoColumnType.number(),
    width: 100,
  ),
  PlutoColumn(
    title: 'Fecha',
    field: 'fecha',
    type: PlutoColumnType.date(),
    width: 150,
  ),
  PlutoColumn(
    title: 'Nombre',
    field: 'nombre',
    type: PlutoColumnType.text(),
  ),
  PlutoColumn(
    title: 'Cantidad',
    field: 'cantidad',
    type: PlutoColumnType.currency(format: '#,###.###', locale: 'es_MX'),
    footerRenderer: (rendererContext) {
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
    },
  ),
  PlutoColumn(
    title: 'Periodo',
    field: 'periodo',
    type: PlutoColumnType.text(),
    width: 100,
  ),
  PlutoColumn(
    title: 'Nota',
    field: 'nota',
    type: PlutoColumnType.text(),
  ),
];
