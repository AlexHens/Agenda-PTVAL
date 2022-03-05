

class Item {

  //Variables Privadas
  int _idItem;
  String _nombre;
  int _cantidad;
  String _pictograma;

  //Constructor

  Item(this._idItem, this._nombre,  this._cantidad, this._pictograma);


  String get pictograma => _pictograma;

  set pictograma(String value) {
    _pictograma = value;
  }

  int get cantidad => _cantidad;

  set cantidad(int value) {
    _cantidad = value;
  } //Get and set de _nombre

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  //Get and set de _id_item

  int get idItem => _idItem;

  set idItem(int value) {
    _idItem = value;
  }





}