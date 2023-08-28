library my_prj.globals;

import 'Usuario.dart';

Usuario? userLogged = Usuario(index: 0, username: "", contrasenia: "", rol: "");

var connectionPostgreSQL = 'postgres://postgres:josue@192.168.0.57:5433/pagos';

bool enablefield = false;

calculateIsEnableField() {
  if (userLogged != null) {
    enablefield =
        (userLogged?.rol == "superadmin") || (userLogged?.rol == "admin");
  }
}
