library my_prj.globals;

import 'Usuario.dart';

String urlServer = "http://neomatrix.servehttp.com:8080";

Usuario? userLogged = Usuario(username: "", contrasenia: "", rol: "");

Map<String, dynamic> connectionPostgreSQL = {
  'host': '192.168.1.65',
  'port': 5433,
  'databaseName': 'sistema',
  'username': 'postgres',
  'password': 'root'
};

bool enablefield = false;
int intRol = 4;
calculateIsEnableField() {
  if (userLogged != null) {
    enablefield = (userLogged?.rol == "superadmin") ||
        (userLogged?.rol == "administrador");

    if (userLogged?.rol == "superadmin") {
      intRol = 1;
    } else if (userLogged?.rol == "administrador") {
      intRol = 2;
    } else {
      intRol = 3;
    }
  }
}
