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

class EditarTareaProfWidget extends StatefulWidget {

  final Tarea _idTarea;
  final Usuarios _idUsuario;
  EditarTareaProfWidget(this._idTarea,this._idUsuario);

  @override
  _EditarTareaProfWidgetState createState() =>
      _EditarTareaProfWidgetState(this._idTarea,this._idUsuario);
}

class _EditarTareaProfWidgetState extends StateMVC {

  final Tarea _idTarea;
  final Usuarios _idUsuario;
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
  Usuarios dropDownValue;
  String dropDownValuenombre;
  Usuarios usuarioSelect;

  DateTime fecha_inicio;
  DateTime fecha_fin;
  int duracion;
  String _setTime;
  TextEditingController _timeController = TextEditingController();
  TimeOfDay selectedTime;
  String _hour, _minute, _time;

  int tareaRealizada;

  _EditarTareaProfWidgetState(this._idTarea,this._idUsuario): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController(text: _idTarea.nombre);
    textController2 = TextEditingController(text: _idTarea.descripcion);
    //textController3 = TextEditingController(text: _idTarea.duracion);
    fecha_fin = _idTarea.fecha_fin;
    fecha_inicio = _idTarea.fecha_inicio;
    _timeController.text = '${fecha_inicio.hour}:${fecha_inicio.minute == 0 ? 00 : fecha_inicio.minute}';
    selectedTime = TimeOfDay(hour: fecha_inicio.hour, minute: fecha_inicio.minute);
    _hour = fecha_inicio.hour.toString();
    _minute = fecha_inicio.minute.toString();
    dropDownValue = Usuarios(_idUsuario.idUsuario,"${_idUsuario.nombre}",null,null,null,null,null,null,null,null);

    tareaRealizada = _idTarea.completada;

    print(_idTarea.tipo);

    switch(_idTarea.tipo) {
      case tipoTarea.FIJA:
        _isChecked1 = true;
        break;
      case tipoTarea.COMANDA_INVENTARIO:
        _isChecked2 = true;
        break;
      case tipoTarea.COMANDA_FOTOCOPIADORA:
        _isChecked3 = true;
        break;
      case tipoTarea.COMANDA_MENU:
        _isChecked4 = true;
        break;
    }

    if(_idTarea.imagenes != null && _idTarea.imagenes.isNotEmpty) {
      for (int i = 0; i < _idTarea.imagenes.length; i++) {
        imageList.add(ImageDataItem(_idTarea.imagenes[i], key: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString()));
      }
    }
    if(_idTarea.pictogramas != null && _idTarea.pictogramas.isNotEmpty) {
      for (int i = 0; i < _idTarea.pictogramas.length; i++) {
        pictogramaList.add(ImageDataItem(_idTarea.pictogramas[i], key: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString()));
      }
    }

    /// No funciona recuperar los v??deos de editar una tarea
    if(_idTarea.videos != null && _idTarea.videos.isNotEmpty) {
      for (int i = 0; i < _idTarea.videos.length; i++) {
        videoList.add(ImageDataItem(_idTarea.videos[i], key: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString()));
        print(_idTarea.videos[i]);
      }
    }

    if(_idTarea.audios != null && _idTarea.audios.isNotEmpty) {
      for (int i = 0; i < _idTarea.audios.length; i++) {
        audioList.add(ImageDataItem(_idTarea.audios[i], key: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString()));
      }
    }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
      });
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {

    setState(() {
      if (args.value is PickerDateRange) {
        if(DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() == DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate).toString()) {
          fecha_inicio = args.value.startDate;
          fecha_fin = args.value.startDate;
        }
        else{
          fecha_inicio = args.value.startDate;
          fecha_fin = args.value.endDate;
          duracion = fecha_fin.difference(fecha_inicio).inDays;
          print(duracion);
        }
      }

    });
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
          'Editar tarea',
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

                Results r = await _con.editarTareaAsignada(
                    _idTarea.idTarea, dropDownValue.idUsuario,
                    textController1.text, textController2.text,
                    DateTime.utc(fecha_inicio.year, fecha_inicio.month, fecha_inicio.day, int.parse(_hour), int.parse(_minute)),
                    fecha_fin, tareaRealizada, imageList, pictogramaList, videoList, audioList, tipo);
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
                          'DESCRIPCI??N',
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
                        24, 25, 24, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(child: Text(
                          'DURACI??N',
                          style:
                          FlutterFlowTheme.bodyText2.override(
                            fontFamily: 'Lexend Deca',
                            color: Color(0xFF262D34),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        ToggleSwitch(
                          minWidth: 90.0,
                          initialLabelIndex: tareaRealizada,
                          cornerRadius: 20.0,
                          activeFgColor: Colors.white,
                          inactiveBgColor: Colors.grey,
                          inactiveFgColor: Colors.white,
                          totalSwitches: 2,
                          labels: ['', ''],
                          icons: [Icons.close, Icons.loop],
                          activeBgColors: [[Colors.pink],[Colors.amber]],
                          onToggle: (index) {
                            print('switched to: $index');
                            tareaRealizada = index;
                          },
                        ),
                      ],
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SfDateRangePicker(
                      onSelectionChanged: _onSelectionChanged,
                      selectionMode: DateRangePickerSelectionMode.range,
                      view: DateRangePickerView.month,
                      initialSelectedRange: PickerDateRange(
                          fecha_inicio,
                          fecha_fin),
                      monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        24, 25, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'HORA COMIENZO',
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
                    child: InkWell(
                      onTap: () {
                        _selectTime(context);
                      },
                      child:TextFormField(
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                      onSaved: (String val) {
                        _setTime = val;
                      },
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _timeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
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
                          'ALUMNO ASIGNADO',
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
                      child:
                      FutureBuilder<List<Usuarios>>(
                          future: _con.getAlumnosTutelados(),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Usuarios>> snapshot){
                            return snapshot.hasData
                                ? DropdownButton<Usuarios>(
                                hint: Text(dropDownValue.nombre ?? 'Seleccione un alumno'),
                                items: snapshot.data.map<DropdownMenuItem<Usuarios>>((item) {
                                  return DropdownMenuItem<Usuarios>(
                                    value: item,
                                    child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsetsDirectional.fromSTEB(15, 0, 20, 0),
                                            child: Container(
                                              width: 30,
                                              height: 30,
                                              clipBehavior: Clip.antiAlias,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: Image.network(
                                                item.profilePhoto,
                                              ),
                                            ),
                                          ),
                                          Text((item.nombre + " " + item.apellidos))
                                        ]),
                                  );
                                }).toList(),
                                onChanged: (Usuarios value) {
                                  usuarioSelect = value;
                                  print(value.apellidos);
                                  setState(() {
                                    dropDownValue = Usuarios(value.idUsuario,value.nombre,null,null,null,null,null,null,null,null);
                                    dropDownValuenombre = dropDownValue.nombre;

                                  });
                                },
                            )
                                : Container(
                              child: Center(
                                child: Text('Cargando...'),
                              ),
                            );

                          })),
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
                          'IM??GENES',
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
                          child: url == null || url.isEmpty ? null :
                          url.contains('http') ?
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
                          ) : Container(child: Image.file(File(url)),)
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
                  if(_isChecked1)
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        24, 20, 24, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          'V??DEOS',
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
                    maxCount: 9,
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
                          child: IconButton(
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
                      // return Container(
                      //     color: Colors.white,
                      //     child: url == null || url.isEmpty ? null : Container(color: Colors.red, child:
                      //     FlutterFlowVideoPlayer(
                      //       path: url,
                      //       videoType: VideoType.network,
                      //       autoPlay: false,
                      //       looping: true,
                      //       showControls: true,
                      //       allowFullScreen: true,
                      //       allowPlaybackSpeedMenu: false,
                      //     ),)
                      // );
                      contadorVideo++;
                      return Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('V??deo ${contadorVideo}')
                          ],),
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
                    maxCount: 9,
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
        ),
      ),
    );
  }

}
