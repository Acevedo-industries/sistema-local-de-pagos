import 'package:app/PagosWraper.dart';
import 'package:app/stateProcess.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:date_format/date_format.dart';
import 'package:path_provider/path_provider.dart';
import 'package:postgres/postgres.dart';
import 'Pago.dart';
import 'globals.dart' as globals;
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:device_info_plus/device_info_plus.dart';

class PagoState extends ChangeNotifier {
  var pagoList = <Pago>[];
  bool? stateBackup;
  bool readFromServer = true;
  stateProcess backupProcess = stateProcess(mystate: null, message: null);
  stateProcess pagoProcess = stateProcess(mystate: null, message: null);
  stateProcess searchProcess = stateProcess(mystate: null, message: null);
  stateProcess countProcess = stateProcess(mystate: null, message: null, value: null);
  int folioProccess = 0;
  final dataBaseSql3Name = 'sistemaData.db';
  var connectionUri = globals.connectionPostgreSQL;

// -----------------------------------------------------------------------------
  Future<String> getPathDB() async {
    var externalDir;
    if (Platform.isWindows) {
      // La aplicación se está ejecutando en Windows.
      externalDir = await getApplicationDocumentsDirectory();
    }

    if (Platform.isAndroid) {
      // Otra plataforma (por ejemplo, Android o iOS).
      externalDir = await getExternalStorageDirectory();
    }
    var pathFile = '${externalDir?.path}/copiaDB';
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
  Future<bool> checkAndRequestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidVersion = await DeviceInfoPlugin().androidInfo;
      if ((androidVersion.version.sdkInt ?? 0) >= 30) {
        final Map<Permission, PermissionStatus> permissionStatus =
            await [Permission.manageExternalStorage].request();
        return permissionStatus[Permission.manageExternalStorage] ==
            PermissionStatus.granted;
      } else {
        return await Permission.storage.request().isGranted;
      }
    }
    return true; // En otras plataformas, se asume que tienes permiso
  }

  void createBackupData() async {
    final hasPermission = await checkAndRequestStoragePermission();
    backupProcess.mystate = null;
    backupProcess.message = null;
    var filePath = await getPathDB();

    print(filePath);

    final directory = Directory(filePath);
    if (await directory.exists()) {
      print('El directorio ya existe.');
    } else {
      await directory.create(
          recursive: true); // Crea el directorio y sus padres si no existen.
      print('Directorio creado con éxito.');
    }

    // Solicitar permiso de almacenamiento
    if (hasPermission) {
      final response =
          await http.get(Uri.parse("${globals.urlServer}/sqlite3"));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        final file = File("$filePath/$dataBaseSql3Name");
        await file.writeAsBytes(bytes);
        print('Copia de seguridad descargada en $filePath');
        backupProcess.mystate = true;
        backupProcess.message = "La descarga se realizó con éxito.";
      } else {
        backupProcess.mystate = false;
        backupProcess.message =
            "Error al descargar la copia de seguridad. Código de estado: ${response.statusCode}. \n\n\n\n";
        print(
            'Error al descargar la copia de seguridad. Código de estado: ${response.statusCode}');
      }

      print('Se ha creado un dump de la base de datos en $filePath');
    } else {
      backupProcess.mystate = false;
      backupProcess.message =
          "No se tienen los permisos para guardar el archivo en el dispositivo. \n";
    }

    notifyListeners();
  }

  void createDumpSql() async {
    final hasPermission = await checkAndRequestStoragePermission();
    if (hasPermission) {
      final folderResult = await FilePicker.platform.getDirectoryPath();

      if (folderResult != null) {
        final now = DateTime.now();
        final dateFormat = formatDate(now, [dd, '-', mm, '-', yyyy]);
        final fileName = 'backup_$dateFormat.sql';
        print(folderResult);
        final filePath = '$folderResult/$fileName';

        final response =
            await http.get(Uri.parse("${globals.urlServer}/backupsql"));
        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          final file = File(filePath);
          await file.writeAsBytes(bytes);
          backupProcess.mystate = true;
          backupProcess.message = "La descarga se realizó con éxito.";
          print('Copia de seguridad descargada en $filePath');
        } else {
          backupProcess.mystate = false;
          backupProcess.message =
              "Error al descargar la copia de seguridad. Código de estado: ${response.statusCode}.";
          print(
              'Error al descargar la copia de seguridad. Código de estado: ${response.statusCode}');
        }
        print('Se ha creado un dump de la base de datos en $filePath');
      } else {
        backupProcess.mystate = false;
        backupProcess.message =
            "No se seleccionó ninguna carpeta para guardar los datos. \n";
        print('No se seleccionó ninguna carpeta para el respaldo.');
      }
    } else {
      backupProcess.mystate = false;
      backupProcess.message =
          "No se tienen los permisos para guardar el archivo en el dispositivo. \n";
    }
    notifyListeners();
  }

  void createDumpExcel() async {
    final hasPermission = await checkAndRequestStoragePermission();
    if (hasPermission) {
      final folderResult = await FilePicker.platform.getDirectoryPath();

      if (folderResult != null) {
        final now = DateTime.now();
        final dateFormat = formatDate(now, [dd, '-', mm, '-', yyyy]);
        final fileName = 'backup_$dateFormat.xlsx';
        print(folderResult);
        final filePath = '$folderResult/$fileName';

        final response =
            await http.get(Uri.parse("${globals.urlServer}/backupexcel"));
        if (response.statusCode == 200) {
          final bytes = response.bodyBytes;
          final file = File(filePath);
          await file.writeAsBytes(bytes);
          backupProcess.mystate = true;
          backupProcess.message = "La descarga se realizó con éxito.";
          print('Copia de seguridad descargada en $filePath');
        } else {
          backupProcess.mystate = false;
          backupProcess.message =
              "Error al descargar la copia de seguridad. Código de estado: ${response.statusCode}.";
          print(
              'Error al descargar la copia de seguridad. Código de estado: ${response.statusCode}');
        }

        print('Se ha creado un dump de la base de datos en $filePath');
      } else {
        backupProcess.mystate = false;
        backupProcess.message =
            "No se seleccionó ninguna carpeta para guardar los datos. \n";
        print('No se seleccionó ninguna carpeta para el respaldo.');
      }
    } else {
      backupProcess.mystate = false;
      backupProcess.message =
          "No se tienen los permisos para guardar el archivo en el dispositivo. \n";
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
          final result = await c.mappedResultsQuery("""
            (              
              (SELECT * FROM pagostequio UNION SELECT * FROM pagospredial) 
              UNION 
              (
                (SELECT "FECHA",0 as "FOLIO","NOMBRE","CANTIDAD","PERIODO", ' ' as "NOTA",tipo FROM "pagostequioAnteriores") 
                UNION 
                (SELECT "FECHA",0 as "FOLIO","NOMBRE","CANTIDAD","PERIODO", ' ' as "NOTA",tipo FROM "pagospredialAnteriores")
              )
            )""");
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

  Future<PagosWraper> getTablePostgreSQL(String tipoPago) async {
    var conn = await openConnection();
    var pagoTequios = <Pago>[];
    String tablename = "";
    String tablename2 = "";

    if (tipoPago == "tequio") {
      tablename = "pagostequio";
      tablename2 = "pagostequioAnteriores";
    }
    if (tipoPago == "predial") {
      tablename = "pagospredial";
      tablename2 = "pagospredialAnteriores";
    }

    await conn
        .transaction((c) async {
          final result = await c.mappedResultsQuery(
              "(SELECT * FROM $tablename) union (SELECT \"FECHA\",0 as \"FOLIO\",\"NOMBRE\",\"CANTIDAD\",\"PERIODO\", ' ' as \"NOTA\",tipo FROM \"$tablename2\") order by \"FOLIO\"");
          return result;
        })
        .then((value) => {
              print(""),
              pagoTequios = List.generate(value.length, (i) {
                return Pago.fromJson(value[i][""]);
              })
            })
        .onError((error, stackTrace) => {
              print(" error $error , stackTrace  $stackTrace"),
              pagoTequios = []
            });

    return PagosWraper(pagoPredial: pagoTequios, readServer: true);
  }

  Future<PagosWraper> getTableSql3(String tipoPago) async {
    var filePath = await getPathDB();
    var db = await openDatabase("$filePath/$dataBaseSql3Name");

    var pagoPredial = <Pago>[];
    bool readServer = true;
    await db
        .query("pagos",
            where: 'tipo = ?', whereArgs: [tipoPago], orderBy: 'FOLIO')
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
              }),
              readServer = false,
              notifyListeners()
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

    return PagosWraper(pagoPredial: pagoPredial, readServer: readServer);
  }

// *****************************************************************************

  Future<PagosWraper> getDataPagos(String nombrePago) async {
    var resultPosgreql = await getTablePostgreSQL(nombrePago);
    if (resultPosgreql.pagoPredial.isEmpty) {
      print("buscando en sqlite3");
      return getTableSql3(nombrePago);
    } else {
      print("regresando el resultado de postgresql");
      return resultPosgreql;
    }
  }

  Future<PagosWraper> getTequios() async {
    return getDataPagos("tequio");
  }

  Future<PagosWraper> getPrediales() async {
    return getDataPagos("predial");
  }

  // *****************************************************************************

  void queryByName(String name) async {
    final newname = name.trim().toLowerCase().replaceAll(RegExp(r' '), '%');
    return queryByNamePostgreSQL(newname);
  }

  void queryByNamePostgreSQL(String name) async {
    searchProcess.mystate = null;
    var conn = await openConnection();
    readFromServer = true;
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
              queryByNameSql3(name)
            });
  }

  void queryByNameSql3(String name) async {
    var filePath = await getPathDB();
    var db = await openDatabase("$filePath/$dataBaseSql3Name");
    pagoList = <Pago>[];
    readFromServer = false;
    await db
        .query("pagos",
            where: ' FOLIO != 0 and LOWER(nombre) LIKE ?',
            whereArgs: [("%$name%")])
        .then((value) => {
              print(""),
              if (value.length > 0)
                {
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
                  }),
                  searchProcess.mystate = true,
                  searchProcess.message = "",
                }
              else
                {
                  searchProcess.mystate = false,
                  searchProcess.message = "noEncontrado",
                },
            })
        .onError((error, stackTrace) => {
              print(" error $error , stackTrace  $stackTrace"),
              searchProcess.mystate = false,
              searchProcess.message = "",
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


  void getUltimoPagoTequio() async {
    var conn = await openConnection();
    countProcess.mystate = null;
    
    await conn
        .transaction((c) async {
          final result = await c.mappedResultsQuery(
              "SELECT count(\"FOLIO\") FROM pagostequio");
          return result;
        })
        .then((value) => {
              if (value.length > 0) {
                  countProcess.mystate = true,
                  countProcess.value = value[0][""]["count"] + 1,
                }else{
                  countProcess.mystate = false,
                  countProcess.value = -1,
                },
              notifyListeners()
            })
        .onError((error, stackTrace) => {
              print(" error $error , stackTrace  $stackTrace"),
            });
  }


    void getUltimoPagoPredial() async {
      var conn = await openConnection();
      countProcess.mystate = null;
      
      await conn
          .transaction((c) async {
            final result = await c.mappedResultsQuery(
                "SELECT count(\"FOLIO\") FROM pagospredial");
            return result;
          })
          .then((value) => {
                if (value.length > 0) {
                    countProcess.mystate = true,
                    countProcess.value = value[0][""]["count"] + 1,
                  }else{
                    countProcess.mystate = false,
                    countProcess.value = -1,
                  },
                notifyListeners()
              })
          .onError((error, stackTrace) => {
                print(" error $error , stackTrace  $stackTrace"),
              });
  }
}
