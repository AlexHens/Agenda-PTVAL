import 'dart:io';
import 'package:agendaptval/flutter_flow/flutter_flow_video_player.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/item.dart';
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

import 'package:agendaptval/modeloControlador/tipoPlato.dart';

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class EditarPlatoAdminWidget extends StatefulWidget {

  final Platos _idItem;
  EditarPlatoAdminWidget(this._idItem);

  @override
  _EditarPlatoAdminWidgetState createState() =>
      _EditarPlatoAdminWidgetState(this._idItem);
}

class _EditarPlatoAdminWidgetState extends StateMVC {

  final Platos _idItem;
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


  _EditarPlatoAdminWidgetState(this._idItem): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController(text: _idItem.nombre);

    switch(_idItem.tipo) {
      case tipoPlato.PRIMERO:
        _isChecked1 = true;
        break;
      case tipoPlato.SEGUNDO:
        _isChecked2 = true;
        break;
      case tipoPlato.POSTRE:
        _isChecked3 = true;
        break;
    }

    if(_idItem.pictograma != null ) {

      pictogramaList.add(ImageDataItem(_idItem.pictograma, key: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString()));

    }

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
            'Editar plato',
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

                  Results r = await _con.editarPlato(
                      _idItem.idPlato,
                      textController1.text, tipo, pictogramaList);
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
                            'TIPO',
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
                            title: const Text('Primero'),
                            activeColor:
                            FlutterFlowTheme.laurelGreenDarker,
                            selected: _isChecked1,
                            value: _isChecked1,
                            onChanged: (bool value) {
                              if(value) {
                                if (_isChecked2)
                                  _isChecked2 = false;
                                else if (_isChecked3)
                                  _isChecked3 = false;
                              }
                              setState(() {
                                _isChecked1 = value;
                              });
                            },
                          ),
                        )),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10, 0, 10, 0),
                        child: Container(
                          child: CheckboxListTile(
                            title:
                            const Text('Segundo'),
                            activeColor:
                            FlutterFlowTheme.laurelGreenDarker,
                            selected: _isChecked2,
                            value: _isChecked2,
                            onChanged: (bool value) {
                              if(value) {
                                if (_isChecked1)
                                  _isChecked1 = false;
                                else if (_isChecked3)
                                  _isChecked3 = false;
                              }
                              setState(() {
                                _isChecked2 = value;
                              });
                            },
                          ),
                        )),
                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            10, 0, 10, 0),
                        child: Container(
                          child: CheckboxListTile(
                            title: const Text(
                                'Postre'),
                            activeColor:
                            FlutterFlowTheme.laurelGreenDarker,
                            selected: _isChecked3,
                            value: _isChecked3,
                            onChanged: (bool value) {
                              if(value) {
                                if (_isChecked2)
                                  _isChecked2 = false;
                                else if (_isChecked1)
                                  _isChecked1 = false;
                              }
                              setState(() {
                                _isChecked3 = value;
                              });
                            },
                          ),
                        )),


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
