
import 'package:agendaptval/modeloControlador/usuarios.dart';
import 'inventario.dart';

class ComandaMaterialEscolar {

  //Variables Privadas
  int _idComanda;
  var _fecha;
  List<Usuarios> _alumnos;
  Inventario _inventario;

  //Constructor

  ComandaMaterialEscolar(
      this._idComanda, this._fecha, this._alumnos, this._inventario);

  //Get and set de _inventario

  Inventario getInventario(){
    return _inventario;
  }

  void setInventario(Inventario i){
    _inventario = i;
  }

  //Get and set de _alumnos

  List<Usuarios> get alumnos => _alumnos;

  set alumnos(List<Usuarios> value) {
    _alumnos = value;
  }

  //Get and set de _fecha

  get fecha => _fecha;

  set fecha(value) {
    _fecha = value;
  }

  //Get and set de _id_comanda

  int get idComanda => _idComanda;

  set idComanda(int value) {
    _idComanda = value;
  }





}