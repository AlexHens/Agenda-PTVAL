

class Emoticono {

  //Variables Privadas
  int _idEmoticono;
  String _imagen;

  //Constructor
  Emoticono(this._idEmoticono, this._imagen
      );



  String get imagen => _imagen;

  set imagen(String value) {
    _imagen = value;
  }

  int get idEmoticono => _idEmoticono;

  set idEmoticono(int value) {
    _idEmoticono = value;
  }
}