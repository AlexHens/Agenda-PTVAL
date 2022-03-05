import 'package:agendaptval/flutter_flow/flutter_flow_video_player.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/vistas/tareasAdmin/pictogramas_arasaac.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:io';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import '../../flutter_flow/flutter_image_add_drag_sort.dart';


class CrearTareaAdminWidget extends StatefulWidget {
  const CrearTareaAdminWidget({Key key}) : super(key: key);

  @override
  _CrearTareaAdminWidgetState createState() => _CrearTareaAdminWidgetState();
}

class _CrearTareaAdminWidgetState extends StateMVC {
  TextEditingController textController1;
  TextEditingController textController2;
  TextEditingController textController3;
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;
  bool noTipo = false;
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


  _CrearTareaAdminWidgetState(): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;
  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController(text: null);
    textController2 = TextEditingController(text: null);
    textController3 = TextEditingController(text: null);
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

  doAddImageCamera(List<ImageDataItem> uploading, onBegin) async {
    XFile Ximage = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 85,
    );
    File image = File(Ximage.path);
    if (image == null)
      return null;
    if (onBegin != null) await onBegin();
    await sleep(new Duration(seconds: 1));
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
    sleep(const Duration(seconds: 1));
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
          'Nueva tarea',
          style: FlutterFlowTheme.title1,
        ),
        actions: [
          FlutterFlowIconButton(
            borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,
            icon: const Icon(
              Icons.check,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () async {

              String tipo;
              if(_isChecked1)
                tipo = 'fija';
              else if (_isChecked2)
                tipo = 'comanda_inventario';
              else if (_isChecked3)
                tipo = 'comanda_fotocopiadora';
              else if (_isChecked4)
                tipo = 'comanda_comedor';
              else{
                noTipo = true;
              }

              if(!noTipo && !textController1.text.isEmpty) {

                Results r = await _con.postTarea(
                    textController1.text, textController2.text,
                    '', imageList, pictogramaList, videoList, audioList, tipo);
                print(r.toString());

                await Navigator.pop(context);
              }
              else{
                if(noTipo && textController1.text.isEmpty) {
                  noTipo = false;
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: new Text(
                            'Error: Debe introducir un nombre y un tipo de tarea'),
                        duration: new Duration(seconds: 7),
                      )
                  );
                  throw 'Debe introducir un nombre y un tipo de tarea';
                }
                else if(noTipo) {
                  noTipo = false;
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: new Text(
                            'Error: Debe seleccionar un tipo de tarea'),
                        duration: new Duration(seconds: 7),
                      )
                  );
                  throw 'Debe seleccionar un tipo de tarea';

                }
                else if(textController1.text.isEmpty) {
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
        child:
        Column(
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
                          'DESCRIPCIÓN',
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
                      controller: textController2,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      maxLines: null,
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
                          title: const Text('Fija'),
                          activeColor:
                          FlutterFlowTheme.laurelGreenDarker,
                          selected: _isChecked1,
                          value: _isChecked1,
                          onChanged: (bool value) {
                            if(value) {
                              if (_isChecked4)
                                _isChecked4 = false;
                              else if (_isChecked2)
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
                          const Text('Comanda de inventario'),
                          activeColor:
                          FlutterFlowTheme.laurelGreenDarker,
                          selected: _isChecked2,
                          value: _isChecked2,
                          onChanged: (bool value) {
                            if(value) {
                              if (_isChecked4)
                                _isChecked4 = false;
                              else if (_isChecked1)
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
                              'Comanda de fotocopiadora'),
                          activeColor:
                          FlutterFlowTheme.laurelGreenDarker,
                          selected: _isChecked3,
                          value: _isChecked3,
                          onChanged: (bool value) {
                            if(value) {
                              if (_isChecked4)
                                _isChecked4 = false;
                              else if (_isChecked2)
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
                          10, 0, 10, 0),
                      child: Container(
                        child: CheckboxListTile(
                          title: const Text('Comanda de comedor'),
                          activeColor:
                          FlutterFlowTheme.laurelGreenDarker,
                          selected: _isChecked4,
                          value: _isChecked4,
                          onChanged: (bool value) {
                            if(value) {
                              if (_isChecked1)
                                _isChecked1 = false;
                              else if (_isChecked2)
                                _isChecked2 = false;
                              else if (_isChecked3)
                                _isChecked3 = false;
                            }
                            setState(() {
                              _isChecked4 = value;
                            });
                          },
                        ),
                      )),
                  if(_isChecked1)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        24, 20, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'IMÁGENES',
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
                  if(_isChecked1)
                  ImageAddDragContainer(
                    key: _keyImagenes,
                    data: imageList,
                    maxCount: 9,
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
                      return await doAddImageGallery(uploading, onBegin);
                    },
                    onChanged: (items) async {
                      imageList = items;
                    },
                    builderItem: (context, key, url, type) {
                      return Container(
                        color: Colors.white,
                        child: url == null || url.isEmpty ? null : Image.file(File(url)),
                      );
                    },
                  ),
                  if(_isChecked1)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        24, 20, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'PICTOGRAMAS',
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
                  if(_isChecked1)
                  ImageAddDragContainer(
                    key: _keyPicto,
                    data: pictogramaList,
                    maxCount: 9,
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
                        child: url == null || url.isEmpty ? null : Image.file(File(url)),
                      );
                    },
                  ),
                  if(_isChecked1)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        24, 20, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'VÍDEOS',
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
                  if(_isChecked1)
                  ImageAddDragContainer(
                    key: _keyVideo,
                    data: videoList,
                    maxCount: 1,
                    readOnly: false,
                    draggableMode: false,
                    itemSize: Size(videoSize, (videoSize*9)/16),
                    addWidget: Material(
                      color: Colors.transparent,
                      child: Center(
                        child: Ink(
                          decoration: const ShapeDecoration(
                            color: FlutterFlowTheme.laurelGreenDarker,
                            shape: CircleBorder(),
                          ),
                          child: const IconButton(
                            icon: Icon(Icons.add, color: Colors.white,),
                          ),
                        ),
                      ),
                    ),
                    onAddImage: (uploading, onBegin) async {
                      return await doAddVideoGallery(uploading, onBegin);
                    },
                    onChanged: (items) async {
                      videoList = items;
                    },
                    builderItem: (context, key, url, type) {
                      return Container(
                        color: Colors.white,
                        child: url == null || url.isEmpty ? null :
                        FlutterFlowVideoPlayer(
                          path: url,
                          videoType: VideoType.network,
                          autoPlay: false,
                          looping: true,
                          showControls: true,
                          allowFullScreen: true,
                          allowPlaybackSpeedMenu: false,
                        ),
                      );
                    },
                  ),
                  if(_isChecked1)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        24, 20, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'AUDIOS',
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
                  if(_isChecked1)
                  ImageAddDragContainer(
                    key: _keyAudio,
                    data: audioList,
                    maxCount: 6,
                    readOnly: false,
                    draggableMode: false,
                    itemSize: Size(videoSize, videoSize),
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
                      return await doAddAudio(uploading, onBegin);
                    },
                    onChanged: (items) async {
                      audioList = items;
                    },
                    builderItem: (context, key, url, type) {
                      return Container(
                        color: Colors.white,
                        child: url == null || url.isEmpty ? null :
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(onPressed: () async {
                                    await audioPlayer.play('${url}');
                                  }, icon: Icon(Icons.play_circle, size: 50,),iconSize: 25,),
                                  IconButton(onPressed: () async {
                                    await audioPlayer.pause();
                                  }, icon: Icon(Icons.pause_circle, size: 50,), iconSize: 25,),
                                ],
                              )
                            ],
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              width: 3,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );

  }

}
