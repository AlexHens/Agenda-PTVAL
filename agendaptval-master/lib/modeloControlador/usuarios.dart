import 'package:agendaptval/modeloControlador/personalizacion.dart';
import 'package:agendaptval/modeloControlador/tipoInfo.dart';
import 'package:agendaptval/modeloControlador/tipoUsuario.dart';

import 'conversacion.dart';
import 'notificacion.dart';

class Usuarios {

  //Variables Privadas

  int _idUsuario;
  String _nombre;
  String _apellidos;
  String _nombreUsuario;
  String _password;
  String _profilePhoto;
  tipoInfo _formatoAyuda;
  tipoUsuario _rol;
  List<Notificacion> _notificaciones;
  List<Conversacion> _conversaciones;

  //Constructor

  Usuarios(
      this._idUsuario,
      this._nombre,
      this._apellidos,
      this._nombreUsuario,
      this._password,
      this._profilePhoto,
      String formato,
      String tipoUser,
      this._notificaciones,
      this._conversaciones){
    switch(formato){
      case ('pictogramas'):
        this._formatoAyuda = tipoInfo.PICTOGRAMAS;
        break;
      case ('texto'):
        this._formatoAyuda = tipoInfo.TEXTO;
        break;
    }

    switch(tipoUser){
      case ('profesor'):
        _rol = tipoUsuario.PROFESOR;
        break;
      case ('alumno'):
        _rol = tipoUsuario.ALUMNO;
        break;
      case ('admin'):
        _rol = tipoUsuario.ADMINISTRADOR;
        break;
    }
  }

  //Get and set de _conversaciones

  List<Conversacion> get conversaciones => _conversaciones;

  set conversaciones(List<Conversacion> value) {
    _conversaciones = value;
  }

  //Get and set de _notificaciones

  List<Notificacion> get notificaciones => _notificaciones;

  set notificaciones(List<Notificacion> value) {
    _notificaciones = value;
  }

  //Get and set de _formato_ayuda

  tipoInfo getFormatoAyuda(){
    return this._formatoAyuda;
  }

  void setFormatoAyuda(String value){
    switch(value){
      case ('pictogramas'):
        this._formatoAyuda = tipoInfo.PICTOGRAMAS;
        break;
      case ('texto'):
        this._formatoAyuda = tipoInfo.TEXTO;
        break;
    }
  }

  tipoInfo get formatoAyuda => _formatoAyuda;

  set formatoAyuda(tipoInfo value) {
    _formatoAyuda = value;
  }

  //Get and set de _password

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  //Get and set de _nombre_usuario

  String get nombreUsuario => _nombreUsuario;

  set nombreUsuario(String value) {
    _nombreUsuario = value;
  }

  //Get and set de _apellidos

  String get apellidos => _apellidos;

  set apellidos(String value) {
    _apellidos = value;
  }

  //Get and set de _nombre

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  //Get and set de _id_usuario

  int get idUsuario => _idUsuario;

  set idUsuario(int value) {
    _idUsuario = value;
  }

  //Get and set de _rol

  tipoUsuario getRol(){
    return this._rol;
  }

  void setRol(String value){
    switch(value){
      case ('profesor'):
        _rol = tipoUsuario.PROFESOR;
        break;
      case ('alumno'):
        _rol = tipoUsuario.ALUMNO;
        break;
      case ('administrador'):
        _rol = tipoUsuario.ADMINISTRADOR;
        break;
    }
  }

  //Get and set de _id_usuario

  String get profilePhoto => _profilePhoto;

  set profilePhoto(String image) {
    _profilePhoto = image;
  }

  void copiarUsuario(Usuarios usu){

    this._idUsuario = usu._idUsuario;
    this._nombre = usu.nombre;
    this._apellidos = usu.apellidos;
    this._nombreUsuario = nombreUsuario;
    this._password = usu.password;
    this._profilePhoto = usu.profilePhoto;


  }


}