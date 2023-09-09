import 'dart:convert';

import 'package:app/User.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:postgres/postgres.dart';
import 'Usuario.dart';
import 'globals.dart' as globals;

class UserState extends ChangeNotifier {
  var usuariosList = <Usuario>[];
  Usuario? findUser;

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
                      index: 1,
                      username: value[0][0],
                      contrasenia: "",
                      rol: value[0][1])
                }
              else
                {
                  findUser = Usuario(
                      index: 0,
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
                  index: 0,
                  username: "sinConexion",
                  contrasenia: "",
                  rol: "sinConexion"),
              print("findUser $findUser"),
              notifyListeners()
            });
  }
}
