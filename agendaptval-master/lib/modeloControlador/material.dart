
class Material {

  //Variables Privadas
  String _nombre;
  int _cantidad;

  //Constructor

  Material(this._nombre, this._cantidad);

  int get cantidad => _cantidad;

  set cantidad(int value) {
    _cantidad = value;
  }

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }


}