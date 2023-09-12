import 'package:app/stateProcess.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:postgres/postgres.dart';
import 'Usuario.dart';
import 'globals.dart' as globals;

class UserState extends ChangeNotifier {
  var usuariosList = <Usuario>[];
  Usuario? findUser;
  stateProcess userProcess = stateProcess(mystate: null, message: null);

  static Future<PostgreSQLConnection> openConnection() async {
    Map<String, dynamic> jsonData = globals.connectionPostgreSQL;
    var connection = PostgreSQLConnection(
        jsonData['host'], jsonData['port'], jsonData['databaseName'],
        username: jsonData['username'], password: jsonData['password']);
    try {
      await connection.open();
    } on Exception catch (e) {
      print(e);
      return connection;
    }
    return connection;
  }

  void saveUser(Usuario newUsuario) async {
    var conn = await openConnection();

    if (newUsuario.username == "" || newUsuario.contrasenia == "") {
      userProcess.mystate = false;
      userProcess.message =
          "El usuario y la contraseña no pueden estar vacios, intente nuevamente";
      notifyListeners();
    } else {
      conn
          .transaction((c) async {
            final result = await c.execute(
                "INSERT INTO usuarios (username, contrasenia, rol) values (@aUsername, @aPassword, @aRol)",
                substitutionValues: {
                  "aUsername": newUsuario.username.toString().trim(),
                  "aPassword": newUsuario.contrasenia.toString().trim(),
                  "aRol": "administrador"
                });
            return result;
          })
          .then((value) => {
                print("---------------------->> $value"),
                userProcess.mystate = true,
                userProcess.message = "Usuario Creado con exito",
                print(userProcess),
                notifyListeners()
              })
          .onError((error, stackTrace) => {
                print("================> $error"),
                userProcess.mystate = false,
                userProcess.message =
                    "Hubo un error al crear al usuario por favor verifique que el usuario no se registro previamente o intente mas tarde. \n\n\n\n $error",
                notifyListeners()
              });
    }
  }

  void queryByUsernameAndPassword(String username, String password) async {
    final newUsername = username.trim();
    final newPassword = password.trim();

    var conn = await openConnection();

    conn
        .transaction((c) async {
          final result = await c.query(
              "SELECT username, rol FROM usuarios WHERE username = @aUsername and contrasenia = @aPassword",
              substitutionValues: {
                "aUsername": newUsername,
                "aPassword": newPassword,
              });
          return result;
        })
        .then((value) => {
              print("---------------------->> $value"),
              if (value.isNotEmpty)
                {
                  findUser = Usuario(
                      username: value[0][0], contrasenia: "", rol: value[0][1])
                }
              else
                {
                  findUser = Usuario(
                      username: "noEncontrado",
                      contrasenia: "",
                      rol: "noEncontrado")
                },
              print("findUser $findUser"),
              notifyListeners()
            })
        .onError((error, stackTrace) => {
              print("================> $error"),
              findUser = Usuario(
                  username: "sinConexion", contrasenia: "", rol: "sinConexion"),
              print("findUser $findUser"),
              notifyListeners()
            });
  }
}
