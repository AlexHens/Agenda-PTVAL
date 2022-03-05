

import 'tarea.dart';

class Ayuda {

  //Variables Privadas
  int _idAyuda;
  String _descripcion;
  List<String> _imagenes;
  List<String> _videos;
  Tarea _tarea;

  //Constructor

  Ayuda(this._idAyuda, this._descripcion, this._imagenes, this._videos,
      this._tarea);

  //Get and set de _tarea

  Tarea getTarea(){
    return _tarea;
  }

  void setTarea(Tarea t){
    _tarea = t;
  }

  //Get and set de _videos

  List<String> get videos => _videos;

  set videos(List<String> value) {
    _videos = value;
  }

  //Get and set de _imagenes

  List<String> get imagenes => _imagenes;

  set imagenes(List<String> value) {
    _imagenes = value;
  }

  //Get and set de _descripcion

  String get descripcion => _descripcion;

  set descripcion(String value) {
    _descripcion = value;
  }

  //Get and set de _id_ayuda

  int get id_ayuda => _idAyuda;

  set id_ayuda(int value) {
    _idAyuda = value;
  }


}