import 'Pago.dart';
import 'dart:collection';

class PagosWraper {
  List<Pago> pagoPredial = [];
  final bool readServer;

  PagosWraper({required this.pagoPredial, required this.readServer});

/*   PagosWraper.fromJson(Map<String, dynamic> json)
      : pagoPredial = json['pagoPredial'],
        readServer = json['readServer'];

  Map<String, dynamic> toJson() =>
      {'pagoPredial': pagoPredial, 'readServer': readServer}; */

  @override
  String toString() {
    return 'Pago{ readServer: $readServer, pagoPredial: $pagoPredial }';
  }
}
