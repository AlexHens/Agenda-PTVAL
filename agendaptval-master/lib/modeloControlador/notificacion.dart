
import 'tarea.dart';
import 'usuarios.dart';

class Notificacion {

  //Variables Privadas

  int _idNotificacion;
  String _nombre;
  String _descripcion;
  Tarea _tarea;
  Usuarios _usuario;

  //Constructor

  Notificacion(this._idNotificacion, this._nombre, this._descripcion,
      this._tarea, this._usuario);

  //Get and set de _usuario

  Usuarios getUsuario(){
    return _usuario;
  }

  void setUsuario(Usuarios u){
    _usuario = u;
  }

  //Get and set de _tarea

  Tarea getTarea(){
    return _tarea;
  }

  void setTarea(Tarea t){
    _tarea = t;
  }

  //Get and set de _descripcion

  String get descripcion => _descripcion;

  set descripcion(String value) {
    _descripcion = value;
  }

  //Get and set de _nombre

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  //Get and set de _id_notificacion

  int get idNotificacion => _idNotificacion;

  set idNotificacion(int value) {
    _idNotificacion = value;
  }
}