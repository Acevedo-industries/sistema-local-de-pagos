import 'package:app/stateProcess.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:postgres/postgres.dart';
import 'Usuario.dart';
import 'globals.dart' as globals;
import 'package:dbcrypt/dbcrypt.dart';

class UserState extends ChangeNotifier {
  var usuariosList = <Usuario>[];
  Usuario? findUser;
  stateProcess userProcess = stateProcess(mystate: null, message: null);
  String salt = '\$2b\$12\$WIRSi4IQLlApudMNKIlfl.';

  String hashedPassword(String plainPassword) {
    return DBCrypt().hashpw(plainPassword, salt);
  }

  bool isCorrect(plain, hashed) {
    return DBCrypt().checkpw(plain, hashed);
  }

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

  void changePasswordUser(Usuario newUsuario) async {
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
                "UPDATE usuarios SET contrasenia=@aPassword WHERE username = @aUsername",
                substitutionValues: {
                  "aUsername": newUsuario.username.toString().trim(),
                  "aPassword": newUsuario.contrasenia.toString().trim()
                });
            return result;
          })
          .then((value) => {
                print("---------------------->> $value"),
                if (value == 1)
                  {
                    userProcess.mystate = true,
                    userProcess.message = "Contraseña cambiada con exito",
                  }
                else
                  {
                    userProcess.mystate = false,
                    userProcess.message =
                        "Hubo un error al cambiar la contraseña del usuario por favor verifique que el usuario existe o intente mas tarde.",
                  },
                print(userProcess),
                notifyListeners()
              })
          .onError((error, stackTrace) => {
                print("================> $error"),
                userProcess.mystate = false,
                userProcess.message =
                    "Hubo un error al cambiar la contraseña del usuario por favor verifique que el usuario existe o intente mas tarde. \n\n\n\n $error",
                notifyListeners()
              });
    }
  }

  void saveUser(Usuario newUsuario, String confirmPasswordController,
      String passwordSuperadminController) async {
    var conn = await openConnection();

    if (newUsuario.username == "" || newUsuario.contrasenia == "") {
      userProcess.mystate = false;
      userProcess.message =
          "El usuario y la contraseña no pueden estar vacios, intente nuevamente";
      notifyListeners();
    } else if (newUsuario.contrasenia?.compareTo(confirmPasswordController) !=
        0) {
      userProcess.mystate = false;
      userProcess.message =
          "Las contraseñas no son iguales, intente nuevamente";
      notifyListeners();
    } else if (isCorrect(
        passwordSuperadminController, globals.userLogged!.contrasenia!)) {
      userProcess.mystate = false;
      userProcess.message =
          "La contraseña del superadministrador es incorrecta, intente nuevamente";
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
    final newPassword = hashedPassword(password.trim());

    var conn = await openConnection();

    conn
        .transaction((c) async {
          final result = await c.query(
              "SELECT username, rol, contrasenia  FROM usuarios WHERE username = @aUsername and contrasenia = @aPassword",
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
                      username: value[0][0],
                      contrasenia: value[0][2],
                      rol: value[0][1])
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
