


import 'package:agendaptval/modeloControlador/tipoPlato.dart';

class Platos {

  //Variables Privadas
  int _idPlato;
  tipoPlato _tipo;
  String _nombre;
  String _pictograma;

  //Constructor

  Platos(this._idPlato, this._nombre, this._tipo, this._pictograma);


  String get pictograma => _pictograma;

  set pictograma(String value) {
    _pictograma = value;
  } //Get and set de _nombre

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }


  tipoPlato get tipo => _tipo;

  set tipo(tipoPlato value) {
    _tipo = value;
  }

  //Get and set de _id_plato

  int get idPlato => _idPlato;

  set idPlato(int value) {
    _idPlato = value;
  }




}