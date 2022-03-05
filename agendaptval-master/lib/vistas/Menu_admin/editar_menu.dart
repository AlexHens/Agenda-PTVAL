import 'dart:io';
import 'package:agendaptval/flutter_flow/flutter_flow_video_player.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/item.dart';
import 'package:agendaptval/modeloControlador/menus.dart';
import 'package:agendaptval/modeloControlador/platos.dart';
import 'package:agendaptval/modeloControlador/tarea.dart';
import 'package:agendaptval/modeloControlador/tipoTarea.dart';
import 'package:agendaptval/vistas/tareasAdmin/pictogramas_arasaac.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mysql1/mysql1.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import '../../flutter_flow/flutter_image_add_drag_sort.dart';
import 'package:path/path.dart' as p;

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class EditarMenuAdminWidget extends StatefulWidget {

  final Menus _idItem;
  EditarMenuAdminWidget(this._idItem);

  @override
  _EditarMenuAdminWidgetState createState() =>
      _EditarMenuAdminWidgetState(this._idItem);
}

class _EditarMenuAdminWidgetState extends StateMVC {

  final Menus _idItem;
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;
  TextEditingController textController1;
  TextEditingController textController2;
  TextEditingController textController3;
  bool noTipo = false;
  bool errorNombre = false;
  bool errorTipo = false;
  int contadorVideo = -1;

  final ImagePicker _picker = ImagePicker();
  List<ImageDataItem> imageList = [];
  List<ImageDataItem> videoList = [];
  List<ImageDataItem> audioList = [];
  List<ImageDataItem> pictogramaList = [];
  AudioPlayer audioPlayer = AudioPlayer();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _keyImagenes = GlobalKey();
  final GlobalKey<ScaffoldState> _keyPicto = GlobalKey();
  final GlobalKey<ScaffoldState> _keyVideo = GlobalKey();
  final GlobalKey<ScaffoldState> _keyAudio = GlobalKey();

  Platos dropDownValuePlato = Platos(0,"Seleccione un plato primero",null,null);
  String dropDownValuenombre;

  Platos platoSelect;

  Platos dropDownValuePlato2 = Platos(0,"Seleccione un plato segundo",null,null);

  Platos platoSelect2;

  Platos dropDownValuePlato3 = Platos(0,"Seleccione un postre",null,null);

  Platos platoSelect3;

  _EditarMenuAdminWidgetState(this._idItem): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController(text: _idItem.nombre);
    textController3 = TextEditingController(text: _idItem.cantidad.toString());
    dropDownValuePlato = Platos(_idItem.platos[0].idPlato, _idItem.platos[0].nombre, _idItem.platos[0].tipo, _idItem.platos[0].pictograma);
    dropDownValuePlato2 = Platos(_idItem.platos[1].idPlato, _idItem.platos[1].nombre, _idItem.platos[1].tipo, _idItem.platos[1].pictograma);
    dropDownValuePlato3 = Platos(_idItem.platos[2].idPlato, _idItem.platos[2].nombre, _idItem.platos[2].tipo, _idItem.platos[2].pictograma);
    platoSelect = Platos(_idItem.platos[0].idPlato, _idItem.platos[0].nombre, _idItem.platos[0].tipo, _idItem.platos[0].pictograma);
    platoSelect2 = Platos(_idItem.platos[1].idPlato, _idItem.platos[1].nombre, _idItem.platos[1].tipo, _idItem.platos[1].pictograma);
    platoSelect3 = Platos(_idItem.platos[2].idPlato, _idItem.platos[2].nombre, _idItem.platos[2].tipo, _idItem.platos[2].pictograma);
  }



  doAddImageGallery(List<ImageDataItem> uploading, onBegin) async {
    XFile Ximage = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 85,
    );
    File image = File(Ximage.path);
    if (image == null)
      return null;
    if (onBegin != null) await onBegin();
    await sleep(new Duration(seconds: 1));
    print(image.absolute.path);
    return ImageDataItem(image.absolute.path, key: DateTime.now().millisecondsSinceEpoch.toString());
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

  doAddVideoGallery(List<ImageDataItem> uploading, onBegin) async {
    XFile Ximage = await _picker.pickVideo(
      source: ImageSource.gallery,
    );
    File image = File(Ximage.path);
    if (image == null)
      return null;
    if (onBegin != null) await onBegin();
    await sleep(new Duration(seconds: 1));
    print(image.absolute.path);
    return ImageDataItem(image.absolute.path, key: DateTime.now().millisecondsSinceEpoch.toString());
  }

  doAddAudio(List<ImageDataItem> uploading, onBegin) async {
    File file;
    FilePickerResult result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['m4a', 'wav', 'ogg'],
    );
    if (result != null) {
      file = File(result.files.single.path);
    } else {
      return null;
    }
    if (onBegin != null) await onBegin();
    await sleep(new Duration(seconds: 1));
    print(file.absolute.path);
    return ImageDataItem(file.absolute.path, key: DateTime.now().millisecondsSinceEpoch.toString());
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var imgSize = (MediaQuery.of(context).size.width - 30) / 4.0;
    var videoSize = (MediaQuery.of(context).size.width - 30) / 3.0;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
            'Editar menú',
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

                String tipo;
                if(_isChecked1)
                  tipo = 'primero';
                else if (_isChecked2)
                  tipo = 'segundo';
                else if (_isChecked3)
                  tipo = 'tercero';
                else{
                  noTipo = true;
                }

                if(!textController1.text.isEmpty) {

                  Results r = await _con.editarMenu( _idItem.idMenu, textController1.text, platoSelect.idPlato, platoSelect2.idPlato, platoSelect3.idPlato, int.parse(textController3.text));
                  print(r.toString());

                  await Navigator.pop(context);
                }
                else{
                  if(textController1.text.isEmpty) {
                    noTipo = false;
                    scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                          content: new Text(
                              'Error: Debe introducir un nombre'),
                          duration: new Duration(seconds: 7),
                        )
                    );
                    throw 'Debe introducir un nombre';

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
                            'NOMBRE',
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
                      child: TextField(
                        controller: textController1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          24, 25, 24, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'CANTIDAD',
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
                      child: TextField(
                        controller: textController3,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 5, 24, 0),
                        child:
                        FutureBuilder<List<Platos>>(
                            future: _con.getAllPlatosTipo('primero'),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Platos>> snapshot){

                              return snapshot.hasData
                                  ? Container(
                                child: DropdownButton<Platos>(
                                  hint: Text(dropDownValuePlato.nombre ?? 'Seleccione un plato primero'),
                                  items: snapshot.data.map<DropdownMenuItem<Platos>>((item) {
                                    return DropdownMenuItem<Platos>(
                                      value: item,
                                      child: Text(item.nombre),
                                    );
                                  }).toList(),
                                  onChanged: (Platos value) {
                                    platoSelect = value;
                                    print(value.nombre);
                                    setState(() {
                                      dropDownValuePlato = Platos(value.idPlato,value.nombre,value.tipo,value.pictograma);
                                    });
                                  },
                                ),
                              )
                                  : Container(
                                child: Center(
                                  child: Text('Cargando...'),
                                ),
                              );

                            })
                    ),

                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 5, 24, 0),
                        child:
                        FutureBuilder<List<Platos>>(
                            future: _con.getAllPlatosTipo('segundo'),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Platos>> snapshot){

                              return snapshot.hasData
                                  ? Container(
                                child: DropdownButton<Platos>(
                                  hint: Text(dropDownValuePlato2.nombre ?? 'Seleccione un plato segundo'),
                                  items: snapshot.data.map<DropdownMenuItem<Platos>>((item) {
                                    return DropdownMenuItem<Platos>(
                                      value: item,
                                      child: Text(item.nombre),
                                    );
                                  }).toList(),
                                  onChanged: (Platos value) {
                                    platoSelect2 = value;
                                    print(value.nombre);
                                    setState(() {
                                      dropDownValuePlato2 = Platos(value.idPlato,value.nombre,value.tipo,value.pictograma);
                                    });
                                  },
                                ),
                              )
                                  : Container(
                                child: Center(
                                  child: Text('Cargando...'),
                                ),
                              );

                            })
                    ),

                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 5, 24, 0),
                        child:
                        FutureBuilder<List<Platos>>(
                            future: _con.getAllPlatosTipo('postre'),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Platos>> snapshot){

                              return snapshot.hasData
                                  ? Container(
                                child: DropdownButton<Platos>(
                                  hint: Text(dropDownValuePlato3.nombre ?? 'Seleccione un postre'),
                                  items: snapshot.data.map<DropdownMenuItem<Platos>>((item) {
                                    return DropdownMenuItem<Platos>(
                                      value: item,
                                      child: Text(item.nombre),
                                    );
                                  }).toList(),
                                  onChanged: (Platos value) {
                                    platoSelect3 = value;
                                    print(value.nombre);
                                    setState(() {
                                      dropDownValuePlato3 = Platos(value.idPlato,value.nombre,value.tipo,value.pictograma);
                                    });
                                  },
                                ),
                              )
                                  : Container(
                                child: Center(
                                  child: Text('Cargando...'),
                                ),
                              );

                            })
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
