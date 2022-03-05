


import 'emoticono.dart';
import 'tarea.dart';

class Retroalimentacion {

  //Variables Privadas
  int _idRetroalimentacion;
  String _descripcion;
  String _pictograma;
  int _calificacion;
  Emoticono _emoticono;
  int _mostrarCalificacion;

  //Constructor
  Retroalimentacion(this._idRetroalimentacion, this._descripcion, this._calificacion, this._pictograma, this._emoticono, this._mostrarCalificacion
    );

  //Get and set de _calificacion

  int get calificacion => _calificacion;

  set calificacion(int value) {
    _calificacion = value;
  }




  int get mostrarCalificacion => _mostrarCalificacion;

  set mostrarCalificacion(int value) {
    _mostrarCalificacion = value;
  }

  Emoticono get emoticono => _emoticono;

  set emoticono(Emoticono value) {
    _emoticono = value;
  }

  //Get and set de _pictograma
  String get pictograma => _pictograma;

  set pictograma(String value) {
    _pictograma = value;

  }
  //Get and set de _descripcion

  String get descripcion => _descripcion;

  set descripcion(String value) {
    _descripcion = value;
  }

  //Get and set de _id_retroalimentacion

  int get idRetroalimentacio => _idRetroalimentacion;

  set idRetroalimentacio(int value) {
    _idRetroalimentacion = value;
  }

}