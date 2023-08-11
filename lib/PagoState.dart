import 'package:flutter/material.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'Pago.dart';

class PagoState extends ChangeNotifier {
  var pagoList = <Pago>[];

  void queryByName(String name) async {
    //var databasesPath = await getDatabasesPath();
    //String path = join(databasesPath, 'pagos.db');
    var db = await openDatabase('pagos.db');

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> pagosquery = await db.query("pagos",
        //columns: [columnId, columnDone, columnTitle],
        where: 'nombre = ?',
        whereArgs: [name]);

    //if (pagos.length > 0) {
    //  return pagos.fromMap(maps.first);
    //}
    //return null;

    //db.query('select * from pagos where nombre = '$name'');

    await db.close();

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    pagoList = List.generate(pagosquery.length, (i) {
      return Pago.fromJson(pagosquery[i]);
    });
    notifyListeners();
  }

  void addPago() {
    //favorites.remove(current);
    pagoList.add(Pago(
        index: 1,
        nombre: "Grisel Garcia Ramirez",
        fecha: "21/05/2023",
        folio: 1901,
        cantidad: "50",
        periodo: "2023",
        nota: "",
        tipo: "predial"));
    pagoList.add(Pago(
        index: 2,
        nombre: "Grisel Garcia Ramirez",
        fecha: "21/05/2023",
        folio: 1902,
        cantidad: "50",
        periodo: "2022",
        nota: "",
        tipo: "tequio"));
    notifyListeners();
  }
}
