import 'package:flutter/material.dart';
import 'dart:async';
import 'package:postgres/postgres.dart';
import 'Usuario.dart';

class UserState extends ChangeNotifier {
  var usuariosList = <Usuario>[];

  Future<List<Usuario>> getUsuarios() async {
    var connection = PostgreSQLConnection("192.168.0.57", 5433, "pagos",
        username: "postgres", password: "josue");
    await connection.open();

    List<List<dynamic>> resultslist =
        await connection.query("SELECT username, rol FROM usuarios");

    print(resultslist);

    for (final row in resultslist) {
      usuariosList.add(
          Usuario(index: 1, username: row[0], contrasenia: "", rol: row[1]));
    }

    print(usuariosList);

    return usuariosList;
  }

  Future<Usuario> queryByUsernameAndPassword(
      String username, String password) async {
    final newUsername = username.trim();
    final newPassword = password.trim();

    var connection = PostgreSQLConnection("192.168.0.55", 5433, "pagos",
        username: "postgres", password: "josue");

    try {
      await connection.open();
    } on Exception catch (_) {
      return Usuario(
          index: 0,
          username: "sinConexion",
          contrasenia: "",
          rol: "sinConexion");
    }

    List<List<dynamic>> results = await connection.query(
        "SELECT username, rol FROM usuarios WHERE username = @aUsername and contrasenia = @aPassword",
        substitutionValues: {
          "aUsername": newUsername,
          "aPassword": newPassword,
        });

    print(results);

    Usuario findUser = Usuario(
        index: 0,
        username: "noEncontrado",
        contrasenia: "",
        rol: "noEncontrado");
    // Usuario(index: 0, username: "Anonymus", contrasenia: "", rol: "lector");

    if (results.isNotEmpty) {
      findUser = Usuario(
          index: 1,
          username: results[0][0],
          contrasenia: "",
          rol: results[0][1]);
    }
    print(findUser);

    return findUser;
  }
}
