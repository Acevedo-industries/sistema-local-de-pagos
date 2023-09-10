import 'dart:ffi';

import 'package:date_format/date_format.dart';

class Pago {
  final String? nombre;
  final DateTime? fecha;
  final int? folio;
  final double? cantidad;
  final String? periodo;
  final String? nota;
  final String? tipo;

  Pago(
      {this.nombre,
      this.fecha,
      this.folio,
      this.cantidad,
      this.periodo,
      this.nota,
      this.tipo});

  String? fechaString() {
    if (fecha != null) {
      return formatDate(
          fecha!, [yyyy, '-', mm, '-', dd, ' ', HH, ':', nn, ':', ss]);
    } else {
      return null;
    }
  }

  Pago.fromJson(Map<String, dynamic> json)
      : nombre = json['NOMBRE'],
        fecha = json['FECHA'],
        folio = json['FOLIO'],
        cantidad = json['CANTIDAD'],
        periodo = json['PERIODO'],
        nota = json['NOTA'],
        tipo = json['tipo'];

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'fecha': fecha,
        'folio': folio,
        'cantidad': cantidad,
        'periodo': periodo,
        'nota': nota,
        'tipo': tipo
      };

  Map<String, dynamic> toJsonSqlite3() => {
        'nombre': nombre,
        'fecha': fechaString(),
        'folio': folio,
        'cantidad': cantidad,
        'periodo': periodo,
        'nota': nota,
        'tipo': tipo
      };

  @override
  String toString() {
    return 'Pago{ nombre: $nombre, fecha: $fecha, folio: $folio, cantidad: $cantidad, periodo: $periodo, nota: $nota, tipo: $tipo }';
  }
}
