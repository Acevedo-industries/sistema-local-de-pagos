import 'dart:ffi';

class Pago {
  final String? nombre;
  final String? fecha;
  final int? folio;
  final String? cantidad;
  final String? periodo;
  final String? nota;
  final String? tipo;
  final int index;

  Pago(
      {this.nombre,
      this.fecha,
      this.folio,
      this.cantidad,
      this.periodo,
      this.nota,
      this.tipo,
      required this.index});

  Pago.fromJson(Map<String, dynamic> json)
      : nombre = json['NOMBRE'],
        fecha = json['FECHA'],
        folio = json['FOLIO'],
        cantidad = json['CANTIDAD'],
        periodo = json['PERIODO'],
        nota = json['NOTA'],
        tipo = json['tipo'],
        index = json['index'];

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'fecha': fecha,
        'folio': folio,
        'cantidad': cantidad,
        'periodo': periodo,
        'nota': nota,
        'tipo': tipo,
        'index': index
      };

  @override
  String toString() {
    return 'Pago{index: $index, nombre: $nombre, fecha: $fecha, folio: $folio, cantidad: $cantidad, periodo: $periodo, nota: $nota, tipo: $tipo }';
  }
}
