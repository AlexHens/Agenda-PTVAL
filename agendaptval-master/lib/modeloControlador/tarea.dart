
import 'package:agendaptval/modeloControlador/usuarios.dart';

import 'ayuda.dart';
import 'conversacion.dart';
import 'notificacion.dart';
import 'package:agendaptval/modeloControlador/tipoTarea.dart';
import 'retroalimentacion.dart';

class Tarea {

  //Variables Privadas
  int _idTarea;
  String _nombre;
  int _completada;
  String _descripcion;
  var fecha_inicio;
  var fecha_fin;
  var _duracion;
  List<String> _videos;
  List<String> _pictogramas;
  List<String> _imagenes;
  List<String> _audios;
  List<String> _autorizacion;
  Retroalimentacion _retroalimentacion;
  tipoTarea _tipo;
  int _idUsuarioRealiza;
  String _fotoResultado;

   //Constructor

  Tarea(
      this._idTarea,
      this._nombre,
      this._completada,
      this._descripcion,
      this._duracion,
      this.fecha_inicio,
      this.fecha_fin,
      this._videos,
      this._imagenes,
      this._audios,
      this._autorizacion,
      this._pictogramas,
      this._tipo,
      this._retroalimentacion,
      this._idUsuarioRealiza,
      this._fotoResultado
      );

  Retroalimentacion get retroalimentacion => _retroalimentacion;

  set retroalimentacion(Retroalimentacion value) {
    _retroalimentacion = value;
  } //Get and set de _retroalimentacion



  int get idUsuarioRealiza => _idUsuarioRealiza;

  set idUsuarioRealiza(int value) {
    _idUsuarioRealiza = value;
  }

  //Get and set de _imagenes

  List<String> get imagenes => _imagenes;

  set imagenes(List<String> value) {
    _imagenes = value;
  }

  //Get and set de _pictogramas

  List<String> get pictogramas => _pictogramas;

  set pictogramas(List<String> value) {
    _pictogramas = value;
  }

  //Get and set de _videos

  List<String> get videos => _videos;

  set videos(List<String> value) {
    _videos = value;
  }

  String get fotoResultado => _fotoResultado;

  set fotoResultado(String value) {
    _fotoResultado = value;
  } //Get and set de _duracion

  get duracion => _duracion;

  set duracion(value) {
    _duracion = value;
  }

  //Get and set de _descripcion

  String get descripcion => _descripcion;

  set descripcion(String value) {
    _descripcion = value;
  }

  //Get and set de _completada

  int get completada => _completada;

  set completada(int value) {
    _completada = value;
  }

  //Get and set de _nombre

  String get nombre => _nombre;

  set nombre(String value) {
    _nombre = value;
  }

  tipoTarea get tipo => _tipo;

  set tipo(tipoTarea value) {
    _tipo = value;
  } //Constructor

  //Get and set de _id_tarea

  int get idTarea => _idTarea;

  set idTarea(int value) {
    _idTarea = value;
  }

  List<String> get audios => _audios;

  set audios(List<String> value) {
    _audios = value;
  }
}