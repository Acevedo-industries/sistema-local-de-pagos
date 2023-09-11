library my_prj.globals;

import 'Usuario.dart';

Usuario? userLogged = Usuario(username: "", contrasenia: "", rol: "");

Map<String, dynamic> connectionPostgreSQL = {
  'host': '192.168.0.57',
  'port': 5433,
  'databaseName': 'sistema',
  'username': 'postgres',
  'password': 'root'
};

bool enablefield = false;

calculateIsEnableField() {
  if (userLogged != null) {
    enablefield = (userLogged?.rol == "superadmin") ||
        (userLogged?.rol == "administrador");
  }
}
