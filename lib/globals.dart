library my_prj.globals;

import 'package:postgres/postgres.dart';
import 'Usuario.dart';

Usuario userLogged = Usuario(index: 0, username: "", contrasenia: "", rol: "");

var connectionPostgreSQL = PostgreSQLConnection("192.168.0.57", 5433, "pagos",
    username: "postgres", password: "josue");

bool enablefield = false;

calculateIsEnableField() {
  enablefield = (userLogged.rol == "superadmin") || (userLogged.rol == "admin");
}
