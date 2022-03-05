

import 'platos.dart';

class Menus {

  //Variables Privadas
  int _idMenu;
  String _nombre;
  int _cantidad;
  List<Platos> _platos;

  //Constructor

  Menus(this._idMenu, this._nombre, this._cantidad, this._platos);


  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  List<Platos> get platos => _platos;

  set platos(List<Platos> value) {
    _platos = value;
  }


  int get cantidad => _cantidad;

  set cantidad(int value) {
    _cantidad = value;
  } //Get and set de _id_menu

  int get idMenu => _idMenu;

  set idMenu(int value) {
    _idMenu = value;
  }


}