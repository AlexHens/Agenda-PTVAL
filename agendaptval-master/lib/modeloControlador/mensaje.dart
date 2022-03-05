

class Mensaje {

  //Variables Privadas

  int _idMensaje;
  String _contenido;
  var _fecha;

  //Constructor

  Mensaje(this._idMensaje, this._contenido, this._fecha);

  //Get and set de _fecha

  get fecha => _fecha;

  set fecha(value) {
    _fecha = value;
  }

  //Get and set de _contenido

  String get contenido => _contenido;

  set contenido(String value) {
    _contenido = value;
  }

  //Get and set de _id_mensaje

  int get idMensaje => _idMensaje;

  set idMensaje(int value) {
    _idMensaje = value;
  }


}
