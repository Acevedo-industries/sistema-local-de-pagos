import 'package:app/stateProcess.dart';
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
  bool? stateBackup;
  stateProcess backupProcess = stateProcess(mystate: null, message: null);
  stateProcess pagoProcess = stateProcess(mystate: null, message: null);
  stateProcess searchProcess = stateProcess(mystate: null, message: null);
  int folioProccess = 0;
  final dataBaseSql3Name = 'sistemaData.db';
  var connectionUri = globals.connectionPostgreSQL;

// -----------------------------------------------------------------------------
  Future<String> getPathDB() async {
    String path = await getDatabasesPath();
    var pathFile = join(path, dataBaseSql3Name);
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
      backupProcess.mystate = true;
      backupProcess.message = "La descarga se realizo con exito.";
      return true;
    } on Exception catch (e) {
      print(e);
      backupProcess.mystate = false;
      backupProcess.message =
          "Ocurrio un error al realizar la descarga. \n\n\n\n $e";
      return false;
    }
  }

// -----------------------------------------------------------------------------+

  void createBackupData() async {
    backupProcess.mystate = null;
    backupProcess.message = null;
    var pathFile = await getPathDB();
    print(pathFile);
    var pagoList = await getDataPostgreSQL();
    if (pagoList.isEmpty) {
      backupProcess.mystate = false;
      backupProcess.message = "No se encontro el servidor de Base de Datos.";
    } else {
      await createBackup(pathFile, pagoList);
    }
    notifyListeners();
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

  Future<List<Pago>> getDataPostgreSQL() async {
    var conn = await openConnection();
    var pagoData = <Pago>[];

    await conn
        .transaction((c) async {
          final result = await c.mappedResultsQuery(
              "SELECT * FROM (SELECT * FROM pagostequio UNION SELECT * FROM pagospredial) as consulta1");
          return result;
        })
        .then((value) => {
              print(""),
              pagoData = List.generate(value.length, (i) {
                return Pago.fromJson(value[i]['']);
              })
            })
        .onError((error, stackTrace) =>
            {print(" error $error , stackTrace  $stackTrace"), pagoData = []});

    //print(pagoData);
    return pagoData;
  }

  Future<List<Pago>> getTablePostgreSQL(String tipoPago) async {
    var conn = await openConnection();
    var pagoTequios = <Pago>[];
    String tablename = "";

    if (tipoPago == "tequio") {
      tablename = "pagostequio";
    }
    if (tipoPago == "predial") {
      tablename = "pagospredial";
    }

    await conn
        .transaction((c) async {
          final result = await c.mappedResultsQuery("SELECT * FROM $tablename");
          return result;
        })
        .then((value) => {
              //print("$value"),
              pagoTequios = List.generate(value.length, (i) {
                return Pago.fromJson(value[i][tablename]);
              })
            })
        .onError((error, stackTrace) => {
              // print(" error $error , stackTrace  $stackTrace"),
              pagoTequios = []
            });

    return pagoTequios;
  }

  Future<List<Pago>> getTableSql3(String tipoPago) async {
    var db = await openDatabase(dataBaseSql3Name);

    var pagoPredial = <Pago>[];
    await db
        .query("pagos", where: 'tipo = ?', whereArgs: [tipoPago])
        .then((value) => {
              print(""),
              pagoPredial = List.generate(value.length, (i) {
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
              pagoPredial = [
                Pago(
                    nombre:
                        "No existe el archivo $dataBaseSql3Name\n Por favor primero descarge una copia de los datos",
                    fecha: null,
                    folio: null,
                    cantidad: null,
                    periodo: null,
                    nota: null,
                    tipo: null)
              ]
            });

    await db.close();

    return pagoPredial;
  }

// *****************************************************************************

  Future<List<Pago>> getTequios() async {
    var resultPosgreql = await getTablePostgreSQL("tequio");
    if (resultPosgreql.isEmpty) {
      print("buscando en sqlite3");
      return getTableSql3("tequio");
    } else {
      print("regresando el resultado de postgresql");
      return resultPosgreql;
    }
  }

  Future<List<Pago>> getPrediales() async {
    var resultPosgreql = await getTablePostgreSQL("predial");
    if (resultPosgreql.isEmpty) {
      print("buscando en sqlite3");
      return getTableSql3("predial");
    } else {
      print("regresando el resultado de postgresql");
      return resultPosgreql;
    }
  }

  // *****************************************************************************

  void queryByName(String name) async {
    final newname = name.trim().toLowerCase().replaceAll(RegExp(r' '), '%');
    return queryByNamePostgreSQL(newname);
  }

  void queryByNamePostgreSQL(String name) async {
    searchProcess.mystate = null;
    var conn = await openConnection();
    pagoList = <Pago>[];
    await conn
        .transaction((c) async {
          final result = await c.mappedResultsQuery(
              "SELECT * FROM (SELECT * FROM pagostequio UNION SELECT * FROM pagospredial) as consulta1 WHERE LOWER (\"NOMBRE\") like @aNombre ",
              substitutionValues: {"aNombre": "%$name%"});
          return result;
        })
        .then((value) => {
              if (value.length > 0)
                {
                  pagoList = List.generate(value.length, (i) {
                    return Pago.fromJson(value[i]['']);
                  }),
                  searchProcess.mystate = true,
                  searchProcess.message = "",
                }
              else
                {
                  searchProcess.mystate = false,
                  searchProcess.message = "noEncontrado",
                },
              notifyListeners()
            })
        .onError((error, stackTrace) => {
              print(" error $error , stackTrace  $stackTrace"),
              searchProcess.mystate = false,
              searchProcess.message = "error",
              queryByNameSql3(name)
            });
  }

  void queryByNameSql3(String name) async {
    var db = await openDatabase(dataBaseSql3Name);
    pagoList = <Pago>[];
    await db
        .query("pagos", where: 'nombre LIKE ?', whereArgs: [("%$name%")])
        .then((value) => {
              print(""),
              pagoList = List.generate(value.length, (i) {
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
              pagoList = [
                Pago(
                    nombre:
                        "No existe el archivo $dataBaseSql3Name\n Por favor primero descarge una copia de los datos",
                    fecha: null,
                    folio: null,
                    cantidad: null,
                    periodo: null,
                    nota: null,
                    tipo: null)
              ]
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

  void updatePago(Pago myPago) async {
    var conn = await openConnection();

    String tablename = "";
    if (myPago.tipo == "tequio") {
      tablename = "pagostequio";
    }
    if (myPago.tipo == "predial") {
      tablename = "pagospredial";
    }

    await conn
        .transaction((c) async {
          final result = await c.mappedResultsQuery(
              "UPDATE $tablename SET \"FECHA\"=@uFecha, \"NOMBRE\"=@uNombre, \"CANTIDAD\"=@uCantidad, \"PERIODO\"=@uPeriodo, \"NOTA\"=@uNota WHERE \"FOLIO\" = @uFolio",
              substitutionValues: {
                "uFecha": myPago.fecha,
                "uNombre": myPago.nombre,
                "uCantidad": myPago.cantidad,
                "uPeriodo": myPago.periodo,
                "uNota": myPago.nota,
                "uFolio": myPago.folio
              });
          return result;
        })
        .then((value) => {
              print("$value"),
              pagoProcess.mystate = true,
              pagoProcess.message = "Registro de pago actualizado con exito",
              folioProccess = myPago.folio!,
              notifyListeners()
            })
        .onError((error, stackTrace) => {
              print(" error $error , stackTrace  $stackTrace"),
              pagoProcess.mystate = false,
              pagoProcess.message =
                  "Hubo un error al actualizar el registro del pago, por favor verifique los datos o intente mas tarde. \n\n\n\n $error",
              folioProccess = myPago.folio!,
              notifyListeners()
            });
  }

  void createPago(Pago myPago) async {
    var conn = await openConnection();

    String tablename = "";

    if (myPago.tipo == "tequio") {
      tablename = "pagostequio";
    }
    if (myPago.tipo == "predial") {
      tablename = "pagospredial";
    }

    await conn
        .transaction((c) async {
          final result = await c.mappedResultsQuery(
              "INSERT INTO $tablename (\"FECHA\", \"NOMBRE\", \"CANTIDAD\", \"PERIODO\", \"NOTA\", tipo) values (@uFecha, @uNombre, @uCantidad, @uPeriodo, @uNota, @uTipo)",
              substitutionValues: {
                "uFecha": myPago.fecha,
                "uNombre": myPago.nombre,
                "uCantidad": myPago.cantidad,
                "uPeriodo": myPago.periodo,
                "uNota": myPago.nota,
                "uTipo": myPago.tipo
              });
          return result;
        })
        .then((value) => {
              print("$value"),
              pagoProcess.mystate = true,
              pagoProcess.message = "Registro de pago creado con exito",
              notifyListeners()
            })
        .onError((error, stackTrace) => {
              print(" error $error , stackTrace  $stackTrace"),
              pagoProcess.mystate = false,
              pagoProcess.message =
                  "Hubo un error al crear el registro del pago, por favor verifique los datos o intente mas tarde. \n\n\n\n $error",
              notifyListeners()
            });
  }
}
