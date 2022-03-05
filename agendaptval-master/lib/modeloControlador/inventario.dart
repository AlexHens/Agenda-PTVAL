

import 'item.dart';

class Inventario {

  //Variables Privadas
  var _mapItems;
  List<Item> _items;

  //Constructor

  Inventario(this._mapItems, this._items);

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




}