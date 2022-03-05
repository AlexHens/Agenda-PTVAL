import 'package:agendaptval/modeloControlador/opcionesHomepage.dart';

class Personalizacion{
  int _homepageReloj;
  int _tamTexto;
  int _textoEnPictogramas;
  List<OpcionesHomepage> _opcionesMenu;
  int _homepageElementos;
  int _tareasElementosPp;
  String _pictogramaTareas;
  String _pictogramaNotificaciones;
  String _pictogramaChats;
  String _pictogramaHistorial;

  Personalizacion(
      this._homepageReloj,
      this._tamTexto,
      this._textoEnPictogramas,
      this._opcionesMenu,
      this._homepageElementos,
      this._tareasElementosPp,
      this._pictogramaTareas,
      this._pictogramaNotificaciones,
      this._pictogramaChats,
      this._pictogramaHistorial);

  int get homepageReloj => _homepageReloj;

  set homepageReloj(int value) {
    _homepageReloj = value;
  }

  int get tamTexto => _tamTexto;

  set tamTexto(int value) {
    _tamTexto = value;
  }

  int get textoEnPictogramas => _textoEnPictogramas;

  set textoEnPictogramas(int value) {
    _textoEnPictogramas = value;
  }

  List<OpcionesHomepage> get opcionesMenu => _opcionesMenu;

  set opcionesMenu(List<OpcionesHomepage> value) {
    _opcionesMenu = value;
  }

  int get homepageElementos => _homepageElementos;

  set homepageElementos(int value) {
    _homepageElementos = value;
  }

  int get tareasElementosPp => _tareasElementosPp;

  set tareasElementosPp(int value) {
    _tareasElementosPp = value;
  }

  String get pictogramaTareas => _pictogramaTareas;

  set pictogramaTareas(String value) {
    _pictogramaTareas = value;
  }

  String get pictogramaNotificaciones => _pictogramaNotificaciones;

  set pictogramaNotificaciones(String value) {
    _pictogramaNotificaciones = value;
  }

  String get pictogramaChats => _pictogramaChats;

  set pictogramaChats(String value) {
    _pictogramaChats = value;
  }

  String get pictogramaHistorial => _pictogramaHistorial;

  set pictogramaHistorial(String value) {
    _pictogramaHistorial = value;
  }
}