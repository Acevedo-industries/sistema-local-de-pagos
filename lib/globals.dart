library my_prj.globals;

import 'Usuario.dart';

Usuario userLogged = Usuario(index: 0, username: "", contrasenia: "", rol: "");

bool enablefield = false;

calculateIsEnableField() {
  enablefield = (userLogged.rol == "superadmin") || (userLogged.rol == "admin");
}
