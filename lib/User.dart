class User {
  final String nombre;
  final String usuario;
  final String contrasenia;
  final String rol;

  User(this.nombre, this.usuario, this.contrasenia, this.rol);

  User.fromJson(Map<String, dynamic> json)
      : nombre = json['nombre'],
        usuario = json['usuario'],
        contrasenia = json['contrasenia'],
        rol = json['rol'];

  Map<String, dynamic> toJson() => {
        'nombre': nombre,
        'usuario': usuario,
        'contrasenia': contrasenia,
        'rol': rol
      };
}
