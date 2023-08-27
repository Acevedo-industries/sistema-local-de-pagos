import 'dart:ffi';

class Usuario {
  final String? username;
  final String? contrasenia;
  final String? rol;
  final int index;

  Usuario({this.username, this.contrasenia, this.rol, required this.index});

  Usuario.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        contrasenia = json['contrasenia'],
        rol = json['rol'],
        index = json['index'];

  Map<String, dynamic> toJson() => {
        'username': username,
        'contrasenia': contrasenia,
        'rol': rol,
        'index': index
      };

  @override
  String toString() {
    return 'Usuario{index: $index, username: $username, contrasenia: $contrasenia, rol: $rol}';
  }
}
