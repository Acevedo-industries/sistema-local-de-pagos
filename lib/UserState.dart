import 'package:app/User.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:postgresql2/postgresql.dart';
import 'Usuario.dart';
import 'globals.dart' as globals;

class UserState extends ChangeNotifier {
  var usuariosList = <Usuario>[];
  var connectionUri = globals.connectionPostgreSQL;

  Usuario? findUser;

  void queryByUsernameAndPassword(String username, String password) async {
    final newUsername = username.trim();
    final newPassword = password.trim();

    try {
      return await connect('postgres://postgres:root@192.168.0.57:5433/pagos')
          .then((conn) {
        conn
            .query(
                "SELECT username, rol FROM usuarios WHERE username = @aUsername and contrasenia = @aPassword",
                {
                  "aUsername": newUsername,
                  "aPassword": newPassword,
                })
            .toList()
            .then((result) {
              if (result.isNotEmpty) {
                findUser = Usuario(
                    index: 1,
                    username: result[0][0],
                    contrasenia: "",
                    rol: result[0][1]);
              } else {
                findUser = Usuario(
                    index: 0,
                    username: "noEncontrado",
                    contrasenia: "",
                    rol: "noEncontrado");
              }
              print("findUser $findUser");
              conn.close();
              notifyListeners();
            });
      });
    } on Exception catch (e) {
      print(" error ____ $e");
      findUser = Usuario(
          index: 0,
          username: "sinConexion",
          contrasenia: "",
          rol: "sinConexion");
      print("findUser $findUser");
      notifyListeners();
    }
  }
}
