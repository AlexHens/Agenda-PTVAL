

import 'mensaje.dart';
import 'tarea.dart';
import 'usuarios.dart';

class Conversacion{

  //Variables Privadas

  int _idConversacion;
  List<Mensaje> _mensajes;
  List<Usuarios> _usuarios;
  Tarea _tarea;

  //Constructor

  Conversacion(this._idConversacion);

  //Get and set de _id_conversacion

  int get id_conversacion => _idConversacion;

  set id_conversacion(int value) {
    _idConversacion = value;
  }

  //Get and set de _mensajes

  List<Mensaje> get mensajes => _mensajes;

  set mensajes(List<Mensaje> value) {
    _mensajes = value;
  }

  //Get and set de _usuarios

  List<Usuarios> getUsuario(){
    return _usuarios;
  }

  void setUsuario(List<Usuarios> l){
    _usuarios = l;
  }

  //Get and set de _tarea

  Tarea getTarea(){
    return _tarea;
  }

  void setTarea(Tarea t){
    _tarea = t;
  }

}