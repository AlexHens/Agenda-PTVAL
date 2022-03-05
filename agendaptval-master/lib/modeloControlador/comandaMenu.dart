

import 'menus.dart';

class ComandaMenu {

  //Variables Privadas
  int _idComanda;
  var _fecha;
  List<Menus> _menus;

  //Constructor

  ComandaMenu(this._idComanda, this._fecha, this._menus);

  //Get and set de _fecha

  List<Menus> getMenus(){
    return _menus;
  }

  void setMenus(List<Menus> m){
    _menus = m;
  }

  //Get and set de _fecha

  get fecha => _fecha;

  set fecha(value) {
    _fecha = value;
  }

  //Get and set de _fecha

  int get idComanda => _idComanda;

  set idComanda(int value) {
    _idComanda = value;
  }


}