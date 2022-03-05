

import 'item.dart';

class Pedidos {

  //Variables Privadas
  int _idPedido;
  var _fechaPedido;
  var _fechaLlegada;
  var _mapItems;
  List<Item> _items;

  //Constructor

  Pedidos(this._idPedido, this._fechaPedido, this._fechaLlegada,
      this._mapItems, this._items);

  //Get and set de _items

  List<Item> get items => _items;

  set items(List<Item> value) {
    _items = value;
  }

  //Get and set de _map_items

  get mapItems => _mapItems;

  set mapItems(value) {
    _mapItems = value;
  }

  //Get and set de _fecha_llegada

  get fechaLlegada => _fechaLlegada;

  set fechaLlegada(value) {
    _fechaLlegada = value;
  }

  //Get and set de _fecha_pedido

  get fechaPedido => _fechaPedido;

  set fechaPedido(value) {
    _fechaPedido = value;
  }

  //Get and set de _id_pedido

  int get idPedido => _idPedido;

  set idPedido(int value) {
    _idPedido = value;
  }

}