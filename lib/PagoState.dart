import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:postgres/postgres.dart';
import 'Pago.dart';
import 'globals.dart' as globals;

class PagoState extends ChangeNotifier {
  var pagoList = <Pago>[];
  var pagoTequios = <Pago>[];
  var connectionUri = globals.connectionPostgreSQL;

  static Future<PostgreSQLConnection> openConnection() async {
    Map<String, dynamic> jsonData = globals.connectionPostgreSQL;
    var connection = PostgreSQLConnection(
        jsonData['host'], jsonData['port'], jsonData['databaseName'],
        username: jsonData['username'], password: jsonData['password']);
    try {
      await connection.open();
    } on Exception catch (e) {
      return connection;
    }
    return connection;
  }

  Future<List<Pago>> getTequios() async {
    if (globals.enablefield) return getTequiosPostgreSQL();
    return getTequiosSql3();
  }

  Future<List<Pago>> getTequiosPostgreSQL() async {
    var conn = await openConnection();
    pagoTequios = [];

    await conn
        .transaction((c) async {
          final result = await c.mappedResultsQuery(
              "SELECT * FROM pagos WHERE tipo = @aTipo ",
              substitutionValues: {"aTipo": "tequio"});
          return result;
        })
        .then((value) => {
              //print(""),
              pagoTequios = List.generate(value.length, (i) {
                value[i]['pagos']['index'] = i;
                return Pago.fromJson(value[i]['pagos']);
              })
            })
        .onError((error, stackTrace) => {
              // print(" error $error , stackTrace  $stackTrace"),
              pagoTequios = []
            });

    //print(pagoTequios);
    return pagoTequios;
  }

  Future<List<Pago>> getTequiosSql3() async {
    var db = await openDatabase('pagos.db');
    print("from getTequiosSql3");
    final List<Map<String, dynamic>> tequiosquery =
        await db.query("pagos", where: 'tipo = ?', whereArgs: ["tequio"]);

    await db.close();

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(tequiosquery.length, (i) {
      return Pago.fromJson(tequiosquery[i]);
    });
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
        fecha: DateTime.now(),
        folio: 1901,
        cantidad: 50.0,
        periodo: "2023",
        nota: "",
        tipo: "predial"));
    pagoList.add(Pago(
        index: 2,
        nombre: "Grisel Garcia Ramirez",
        fecha: DateTime.now(),
        folio: 1902,
        cantidad: 50.0,
        periodo: "2022",
        nota: "",
        tipo: "tequio"));
    notifyListeners();
  }
}
