import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:postgresql2/postgresql.dart';
import 'Pago.dart';
import 'globals.dart' as globals;

class PagoState extends ChangeNotifier {
  var pagoList = <Pago>[];
  var pagoTequios = <Pago>[];
  var connectionUri = globals.connectionPostgreSQL;

  void getTequios() async {
    if (globals.enablefield) return getTequiosPostgreSQL();
    return getTequiosSql3();
  }

  void getTequiosPostgreSQL() async {
    try {
      return await connect('postgres://postgres:root@192.168.0.57:5433/pagos')
          .then((conn) {
        conn
            .query(
                "SELECT * FROM pagos WHERE tipo = @aTipo ", {"aTipo": "tequio"})
            .toList()
            .then((result) {
              pagoTequios = List.generate(result.length, (i) {
                return Pago.fromJson({
                  'nombre': result[i][2],
                  'fecha': result[i][0],
                  'folio': result[i][1],
                  'cantidad': result[i][3],
                  'periodo': result[i][4],
                  'nota': result[i][5],
                  'tipo': result[i][6],
                  'index': result[i][1],
                });
              });

              print(pagoTequios.length);
              conn.close();
              notifyListeners();
            });
      });
    } on Exception catch (e) {
      print(" error ____ $e");
      notifyListeners();
    }
    notifyListeners();
  }

  void getTequiosSql3() async {
    var db = await openDatabase('pagos.db');
    print("from getTequiosSql3");
    final List<Map<String, dynamic>> tequiosquery =
        await db.query("pagos", where: 'tipo = ?', whereArgs: ["tequio"]);

    await db.close();

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    pagoTequios = List.generate(tequiosquery.length, (i) {
      return Pago.fromJson(tequiosquery[i]);
    });

    print("tequios");
    print(pagoTequios.length);
    notifyListeners();
  }

  Future<List<Pago>> getPrediales() async {
    var db = await openDatabase('pagos.db');

    final List<Map<String, dynamic>> pagosquerytequios =
        await db.query("pagos", where: 'tipo = ?', whereArgs: ["predial"]);

    await db.close();

    return List.generate(pagosquerytequios.length, (i) {
      return Pago.fromJson(pagosquerytequios[i]);
    });
  }

  void queryByName(String name) async {
    final newname = name.trim().replaceAll(RegExp(r' '), '%');
    //var databasesPath = await getDatabasesPath();
    //String path = join(databasesPath, 'pagos.db');
    var db = await openDatabase('pagos.db');

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> pagosquery = await db.query("pagos",
        //columns: [columnId, columnDone, columnTitle],
        where: 'nombre LIKE ?',
        whereArgs: [("%$newname%")]);

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
