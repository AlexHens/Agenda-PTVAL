import 'dart:io';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/tarea.dart';
import 'package:agendaptval/modeloControlador/tipoTarea.dart';
import 'package:agendaptval/modeloControlador/usuarios.dart';
import 'package:agendaptval/vistas/tareasAdmin/pictogramas_arasaac.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysql1/mysql1.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../flutter_flow/flutter_image_add_drag_sort.dart';

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class RevisarTareaProfWidget extends StatefulWidget {

  final Tarea _idTarea;
  final Usuarios _idUsuario;
  RevisarTareaProfWidget(this._idTarea,this._idUsuario);

  @override
  _RevisarTareaProfWidgetState createState() =>
      _RevisarTareaProfWidgetState(this._idTarea,this._idUsuario);
}

class _RevisarTareaProfWidgetState extends StateMVC {

  final Tarea _idTarea;
  final Usuarios _idUsuario;

  TextEditingController textController1;
  TextEditingController textController2;
  TextEditingController textController3;
  bool noTipo = false;
  bool errorNombre = false;
  bool errorTipo = false;
  int contadorVideo = -1;
  bool _isChecked1 = false;
  bool _isChecked2 = false;

  List<ImageDataItem> imageList = [];
  List<ImageDataItem> videoList = [];
  List<ImageDataItem> audioList = [];
  List<ImageDataItem> pictogramaList = [];
  AudioPlayer audioPlayer = AudioPlayer();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _keyPicto = GlobalKey();
  final ImagePicker _picker = ImagePicker();
  int dropDownValue;
  int calificacionSelect;
  List<int> calificaciones = [1,2,3,4,5,6,7,8,9,10];

  int tareaRealizada;

  _RevisarTareaProfWidgetState(this._idTarea,this._idUsuario): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController(text: _idTarea.descripcion);
    //textController3 = TextEditingController(text: _idTarea.duracion);

    dropDownValue = 0;
    tareaRealizada = _idTarea.completada;
  }

  doAddPictograma(List<ImageDataItem> uploading, onBegin) async {
    File pictograma = await Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => ArasaacWidget(),
      ),
    );
    if (pictograma == null)
      return null;
    if (onBegin != null) await onBegin();
    await sleep(Duration(seconds: 1));
    return ImageDataItem(pictograma.absolute.path, key: DateTime.now().millisecondsSinceEpoch.toString());
  }

  @override
  Widget build(BuildContext context) {
    var imgSize = (MediaQuery.of(context).size.width - 30) / 4.0;
    var videoSize = (MediaQuery.of(context).size.width - 30) / 3.0;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.laurelGreen,
        automaticallyImplyLeading: true,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.close,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () async {
            await Navigator.pop(context);
          },
        ),
        title: Text(
          'Retroalimentación',
          style: FlutterFlowTheme.title1,
        ),
        actions: [
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: Icon(
              Icons.check,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () async {

              int mostrarCalificacion;

              if(_isChecked1)
                mostrarCalificacion = 1;
              else if (_isChecked2)
                mostrarCalificacion = 0;
              else{
                noTipo = true;
              }

              if(!noTipo && dropDownValue != 0) {

                Results r = await _con.postRetroalimentacion(this._idTarea.idTarea, this._idUsuario.idUsuario,
                    textController1.text, tareaRealizada, dropDownValue, pictogramaList, mostrarCalificacion);

                await Navigator.pop(context);
              }
              else{
                if(noTipo && dropDownValue == 0) {
                  noTipo = false;
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: new Text(
                            'Error: Debe introducir una calificación y si se debe mostrar'),
                        duration: new Duration(seconds: 7),
                      )
                  );
                  throw 'Debe introducir una calificación y si se debe mostrar';

                }
                if(dropDownValue == 0) {
                  noTipo = false;
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: new Text(
                            'Error: Debe introducir una calificación'),
                        duration: new Duration(seconds: 7),
                      )
                  );
                  throw 'Debe introducir una calificación';

                }
                else if(noTipo) {
                  noTipo = false;
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: new Text(
                            'Error: Debe seleccionar si se debe mostrar la calificación'),
                        duration: new Duration(seconds: 7),
                      )
                  );
                  throw 'Debe seleccionar si se debe mostrar la calificación';

                }
              }
            },
          ),
        ],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        24, 25, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          '${_idTarea.nombre}',
                          style: FlutterFlowTheme.title1.override(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF090F13),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                            child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                                child: Row(
                                  children: [
                                    Row(
                                        children: [
                                          Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(00, 15, 00, 0),
                                              child:
                                              Text(
                                                (this._idUsuario.nombre + " " + this._idUsuario.apellidos),
                                                style: FlutterFlowTheme.bodyText2.override(
                                                  fontFamily: 'Lexend Deca',
                                                  color: Color(0xFF262D34),
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                          ),
                                          Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(15, 15, 20, 0),
                                              child:
                                              Container(
                                                width: 30,
                                                height: 30,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: //Image.network(this._idUsuario.profilePhoto)
                                                CachedNetworkImage(
                                                  imageUrl: this._idUsuario.profilePhoto,
                                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                      CircularProgressIndicator(value: downloadProgress.progress),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                ),
                                              )),
                                        ]
                                    ),
                                  ],
                                )
                            )

                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'DESCRIPCIÓN',
                          style: FlutterFlowTheme.bodyText2.override(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF262D34),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                            child: Text(
                              '${_idTarea.descripcion}',
                              style: FlutterFlowTheme.bodyText2.override(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF8B97A2),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'FOTO ENTREGADA',
                          style: FlutterFlowTheme.bodyText2.override(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF262D34),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  (_idTarea.fotoResultado.isNotEmpty) ?
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                            child: CachedNetworkImage(
                              imageUrl: this._idTarea.fotoResultado,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  CircularProgressIndicator(value: downloadProgress.progress),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ) :
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                            EdgeInsetsDirectional.fromSTEB(0, 0, 0, 24),
                            child: Text(
                              'No entregada',
                              style: FlutterFlowTheme.bodyText2.override(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF8B97A2),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    child:ToggleSwitch(
                    minWidth: 120.0,
                    initialLabelIndex: tareaRealizada,
                    cornerRadius: 20.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 3,
                    labels: ['En Progreso', 'En Revisión', 'Completada'],
                    //icons: [Icons.close, Icons.done],
                    activeBgColors: [[Colors.pink],[Colors.amber],[Colors.green]],
                    onToggle: (index) {
                      print('switched to: $index');
                      tareaRealizada = index;
                    },
                  ),),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        24, 20, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'RETROALIMENTACIÓN',
                          style:
                          FlutterFlowTheme.bodyText2.override(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF262D34),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        24, 15, 24, 0),
                    child: TextField(
                      controller: textController1,
                      decoration: InputDecoration(
                        hintText: 'Escribe aquí la retroalimentación',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: null,
                    ),
                  ),

                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        24, 20, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'PICTOGRAMA',
                          style:
                          FlutterFlowTheme.bodyText2.override(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF262D34),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ImageAddDragContainer(
                    key: _keyPicto,
                    data: pictogramaList,
                    maxCount: 1,
                    readOnly: false,
                    draggableMode: false,
                    itemSize: Size(imgSize, imgSize),
                    addWidget: Material(
                      color: Colors.transparent,
                      child: Center(
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: FlutterFlowTheme.laurelGreenDarker,
                            shape: CircleBorder(),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.add, color: Colors.white,),
                          ),
                        ),
                      ),
                    ),
                    onAddImage: (uploading, onBegin) async {
                      return await doAddPictograma(uploading, onBegin);
                    },
                    onChanged: (items) async {
                      pictogramaList = items;
                    },
                    onTapItem: (item, index) {
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("click item: $index, ${item.key}")));
                    },
                    builderItem: (context, key, url, type) {
                      return Container(
                        color: Colors.white,
                        child: url == null || url.isEmpty ? null : url.contains('http') ?
                        CachedNetworkImage(
                          imageUrl: "${url}",
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          placeholder: (context, url) => SpinKitRotatingCircle(
                            color: FlutterFlowTheme.laurelGreen,
                            size: 50.0,
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ) : Container(child: Image.file(File(url)),),
                      );
                    },
                  ),

                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        24, 25, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'CALIFICACIÓN',
                          style:
                          FlutterFlowTheme.bodyText2.override(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF262D34),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          24, 15, 24, 0),
                      child: DropdownButton<int>(
                        hint: Text(dropDownValue.toString() ?? 'Seleccione una calificación'),
                        items: calificaciones.map<DropdownMenuItem<int>>((item) {
                          return DropdownMenuItem<int>(
                            value: item,
                            child: Row(
                                children: [

                                  Text((item.toString()))
                                ]),
                          );
                        }).toList(),
                        onChanged: (int value) {
                          calificacionSelect = value;
                          setState(() {
                            dropDownValue = value;

                          });
                        },
                      )
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        24, 25, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'MOSTRAR LA CALIFICACIÓN NUMÉRICA',
                          style:
                          FlutterFlowTheme.bodyText2.override(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF262D34),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          10, 0, 10, 0),
                      child: Container(
                        child: CheckboxListTile(
                          title: const Text('Sí'),
                          activeColor:
                          FlutterFlowTheme.laurelGreenDarker,
                          selected: _isChecked1,
                          value: _isChecked1,
                          onChanged: (bool value) {
                            if(value) {
                              if (_isChecked2)
                                _isChecked2 = false;
                            }
                            setState(() {
                              _isChecked1 = value;
                            });
                          },
                        ),
                      )),
                  Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          10, 0, 10, 15),
                      child: Container(
                        child: CheckboxListTile(
                          title:
                          const Text('No'),
                          activeColor:
                          FlutterFlowTheme.laurelGreenDarker,
                          selected: _isChecked2,
                          value: _isChecked2,
                          onChanged: (bool value) {
                            if(value) {
                              if (_isChecked1)
                                _isChecked1 = false;
                            }
                            setState(() {
                              _isChecked2 = value;
                            });
                          },
                        ),
                      )),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
