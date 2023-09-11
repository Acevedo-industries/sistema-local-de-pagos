class Usuario {
  final String? username;
  final String? contrasenia;
  final String? rol;

  Usuario({this.username, this.contrasenia, this.rol});

  Usuario.fromJson(Map<String, dynamic> json)
      : username = json['username'],
        contrasenia = json['contrasenia'],
        rol = json['rol'];

  Map<String, dynamic> toJson() =>
      {'username': username, 'contrasenia': contrasenia, 'rol': rol};

  @override
  String toString() {
    return 'Usuario{username: $username, contrasenia: $contrasenia, rol: $rol}';
  }
}
