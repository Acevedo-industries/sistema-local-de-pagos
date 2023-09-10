import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:postgres/postgres.dart';
import 'Pago.dart';
import 'globals.dart' as globals;
import 'dart:io';

class PagoState extends ChangeNotifier {
  var pagoList = <Pago>[];

  var connectionUri = globals.connectionPostgreSQL;

// -----------------------------------------------------------------------------
  Future<String> getPathDBTequios() async {
    String path = await getDatabasesPath();
    var pathFile = join(path, 'sistemaTequios.db');
    return pathFile;
  }

  Future<String> getPathDBPredial() async {
    String path = await getDatabasesPath();
    var pathFile = join(path, 'sistemaPredial.db');
    return pathFile;
  }

  Future<Database> initializeDB(String pathFile) async {
    return openDatabase(
      pathFile,
      onCreate: (database, version) async {
        await database.execute(
          "CREATE TABLE pagos(FECHA TIMESTAMP, FOLIO INTEGER, NOMBRE TEXT, CANTIDAD REAL, PERIODO TEXT, NOTA TEXT, tipo TEXT)",
        );
      },
      version: 1,
    );
  }

  void deleteFile(String pathFile) {
    try {
      var filedatabase = File(pathFile);
      filedatabase.delete();
    } on Exception catch (e) {}
  }

  Future<bool> createBackup(String pathFile, var pagoTequiosList) async {
    deleteFile(pathFile);
    try {
      final Database db = await initializeDB(pathFile);

      for (var element in pagoTequiosList) {
        await db.insert('pagos', element.toJsonSqlite3(),
            conflictAlgorithm: ConflictAlgorithm.replace);
      }
    } on Exception catch (e) {
      print(e);
      return false;
    }

    return true;
  }

// -----------------------------------------------------------------------------+

  Future<bool> createBackupTequio() async {
    var pathFile = await getPathDBTequios();
    print(pathFile);
    var pagoTequiosList = await getTequiosPostgreSQL();
    return createBackup(pathFile, pagoTequiosList);
  }

  Future<bool> createBackupPredial() async {
    var pathFile = await getPathDBPredial();
    print(pathFile);
    var pagoPredialesList = await getPredialesPostgreSQL();
    return createBackup(pathFile, pagoPredialesList);
  }

// -----------------------------------------------------------------------------+

  Future<bool> createBackupTequioAndPredial() async {
    var backupTequio = await createBackupTequio();
    var backupPredial = await createBackupPredial();
    return (backupTequio && backupPredial);
  }

// -----------------------------------------------------------------------------+

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

// *****************************************************************************
  Future<List<Pago>> getTequios() async {
    if (globals.enablefield) return getTequiosPostgreSQL();
    return getTequiosSql3();
  }

  Future<List<Pago>> getTequiosPostgreSQL() async {
    var conn = await openConnection();
    var pagoTequios = <Pago>[];

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
    var db = await openDatabase('sistemaTequios.db');
    print("from getTequiosSql3");

    var pagoTequios = <Pago>[];
    await db
        .query("pagos", where: 'tipo = ?', whereArgs: ["tequio"])
        .then((value) => {
              print(""),
              pagoTequios = List.generate(value.length, (i) {
                DateTime? miFecha;
                if (value[i]['FECHA'] != null) {
                  miFecha = DateTime.parse(value[i]['FECHA'].toString());
                }
                var mipago = Pago.fromJson({
                  'NOMBRE': value[i]["NOMBRE"],
                  'FECHA': miFecha,
                  'FOLIO': value[i]["FOLIO"],
                  'CANTIDAD': value[i]["CANTIDAD"],
                  'PERIODO': value[i]["PERIODO"],
                  'NOTA': value[i]["NOTA"],
                  'tipo': value[i]["tipo"]
                });
                return mipago;
              })
            })
        .onError((error, stackTrace) => {
              print(" error $error , stackTrace  $stackTrace"),
              pagoTequios = []
            });

    await db.close();

    return pagoTequios;
  }

// *****************************************************************************

  Future<List<Pago>> getPrediales() async {
    if (globals.enablefield) return getPredialesPostgreSQL();
    return getPredialesSql3();
  }

  Future<List<Pago>> getPredialesPostgreSQL() async {
    var conn = await openConnection();
    var pagoTequios = <Pago>[];

    await conn
        .transaction((c) async {
          final result = await c.mappedResultsQuery(
              "SELECT * FROM pagos WHERE tipo = @aTipo ",
              substitutionValues: {"aTipo": "predial"});
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

  Future<List<Pago>> getPredialesSql3() async {
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
    if (globals.enablefield) return queryByNamePostgreSQL(newname);
    return queryByNameSql3(newname);
  }

  void queryByNamePostgreSQL(String name) async {
    var conn = await openConnection();
    pagoList = <Pago>[];
    await conn
        .transaction((c) async {
          final result = await c.mappedResultsQuery(
              "SELECT * FROM pagos WHERE \"NOMBRE\" like @aNombre ",
              substitutionValues: {"aNombre": "%$name%"});
          return result;
        })
        .then((value) => {
              print(""),
              pagoList = List.generate(value.length, (i) {
                value[i]['pagos']['index'] = i;
                return Pago.fromJson(value[i]['pagos']);
              })
            })
        .onError((error, stackTrace) => {
              print(" error $error , stackTrace  $stackTrace"),
              pagoList = <Pago>[]
            });

    notifyListeners();
  }

  void queryByNameSql3(String name) async {
    print("&&&&& jajaja");
    var db = await openDatabase('pagos.db');

    final List<Map<String, dynamic>> pagosquery = await db
        .query("pagos", where: 'nombre LIKE ?', whereArgs: [("%$name%")]);

    await db.close();

    pagoList = List.generate(pagosquery.length, (i) {
      return Pago.fromJson(pagosquery[i]);
    });
    notifyListeners();
  }

  void addPago() {
    //favorites.remove(current);
    pagoList.add(Pago(
        nombre: "Grisel Garcia Ramirez",
        fecha: DateTime.now(),
        folio: 1901,
        cantidad: 50.0,
        periodo: "2023",
        nota: "",
        tipo: "predial"));
    pagoList.add(Pago(
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
