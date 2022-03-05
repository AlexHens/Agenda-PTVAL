import 'dart:io';

import 'package:agendaptval/flutter_flow/flutter_flow_video_player.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/item.dart';
import 'package:agendaptval/modeloControlador/tarea.dart';
import 'package:agendaptval/modeloControlador/tipoInfo.dart';
import 'package:agendaptval/modeloControlador/tipoTarea.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mysql1/mysql1.dart';

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VistaDeTareaInventarioAlumnoWidget extends StatefulWidget {
  const VistaDeTareaInventarioAlumnoWidget(this.tarea,{Key key}) : super(key: key);
  final Tarea tarea;

  @override
  _VistaDeTareaInventarioAlumnoWidgetState createState() => _VistaDeTareaInventarioAlumnoWidgetState(this.tarea);
}

class _VistaDeTareaInventarioAlumnoWidgetState extends StateMVC {
  bool checkboxListTileValue;
  Tarea tarea;
  int indice, pagsTotales, elemsUltPag;
  AudioPlayer audioPlayer = AudioPlayer();
  bool value;
  XFile fotoPerfil;
  XFile fotoResultado = null;
  final ImagePicker _picker = ImagePicker();
  List<Item> items = [];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _VistaDeTareaInventarioAlumnoWidgetState(this.tarea): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;



  @override
  void initState() {
    // TODO: implement initState
    indice = 0;
    value = tarea.completada == 0 ? false : tarea.completada == 2 ? true : true;
    super.initState();
  }

  calcularPagTotales(int elementos){
    pagsTotales = (elementos / 3).toInt();
    if(elementos % 3 != 0){
      pagsTotales++;
      elemsUltPag = elementos % 3 ;
    }
    else{
      elemsUltPag = 3;
    }
  }

  Future<String> _imgFromCamera(int idTarea) async {
    XFile image = await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 100
    );
    setState(() {
      if(image != null) {
        _con.subirFotoResultado(idTarea, Model.usuario.idUsuario,
            File(image.path) );
      }
      fotoResultado = image;
    });
  }

  Future<void> _imgFromGallery(int idTarea) async {
    XFile image = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 100
    );
    setState(() {
      if (image != null) {
        _con.subirFotoResultado(idTarea, Model.usuario.idUsuario,
            File(image.path) );
      }
      fotoResultado = image;
    });
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 250));
    //tareas = _con.getAllTareas();
    setState(() async{
      tarea = await _con.getTareaAlumno(tarea.idTarea);
    });
  }


  void _showPicker(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galería de Fotos'),
                      onTap: () async {
                        _imgFromGallery(tarea.idTarea);
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Cámara'),
                    onTap: () async {
                      _imgFromCamera(tarea.idTarea);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
    _onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.tertiaryColor,
        body: SafeArea(
          child:FutureBuilder<List<Item>>(
              future: this._con.getAllItems(),
              builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot)
              {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: Container(
                      child: SpinKitRotatingCircle(
                        color: FlutterFlowTheme.laurelGreen,
                        size: 50.0,
                      ),
                    ));
                  default:
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      calcularPagTotales(snapshot.data.length);
                      return Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.025,),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Model.personalizacion.homepageReloj == 1 ?
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.4,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.18,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.lilac,
                                  borderRadius: BorderRadius.circular(0),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    tarea.tipo == tipoTarea.COMANDA_INVENTARIO ?
                                    Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.lilac,

                                      ),
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.1,
                                      child: Image.asset('assets/pictogramas/menuppal/inventario.png'),
                                    )
                                        : tarea.pictogramas.isNotEmpty ?
                                    Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.lilac,

                                      ),
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.1,
                                      child: CachedNetworkImage(
                                        imageUrl: tarea.pictogramas[0],
                                        progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                            Center(child: Container(
                                              child: const SpinKitPouringHourGlassRefined(
                                                color: FlutterFlowTheme.laurelGreen,
                                                size: 50.0,
                                              ),
                                            )),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ) : tarea.imagenes.isNotEmpty ?
                                    Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.lilac,

                                      ),
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.1,
                                      child: CachedNetworkImage(
                                        imageUrl: tarea.imagenes[0],
                                        progressIndicatorBuilder: (context, url,
                                            downloadProgress) =>
                                            Center(child: Container(
                                              child: const SpinKitPouringHourGlassRefined(
                                                color: FlutterFlowTheme.laurelGreen,
                                                size: 50.0,
                                              ),
                                            )),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ) : Container(
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.lilac,

                                      ),
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height * 0.1,
                                    ),
                                    if(Model.personalizacion.textoEnPictogramas == 1)
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Text(
                                          '${tarea.nombre.toUpperCase()}',
                                          style: FlutterFlowTheme.pictogramas,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                  ],
                                ),
                              ) :
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 0.4,
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.18,
                              ),
                              SizedBox(width: 50,),
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.pop(context);
                                  await Navigator.pop(context);
                                },
                                child: Semantics(
                                  label: 'Ir a Inicio',
                                  child: Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.4,
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.18,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.primaryColor,
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child: Image.asset(
                                      'assets/pictogramas/menuppal/home.png',
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            thickness: 3,
                            color: Colors.black,
                          ),

                          if(indice + 1 <= pagsTotales)
                            Expanded(
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: indice + 1 != pagsTotales ? 3 : elemsUltPag,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.4,
                                                height: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height * 0.18,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.tertiaryColor,
                                                  borderRadius: BorderRadius.circular(0),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 2,
                                                  ),
                                                ),
                                                child:

                                                CachedNetworkImage(
                                                  imageUrl: snapshot.data[index + indice * 3]
                                                      .pictograma,
                                                  progressIndicatorBuilder: (context, url,
                                                      downloadProgress) =>
                                                      Center(child: Container(
                                                        child: const SpinKitPouringHourGlassRefined(
                                                          color: FlutterFlowTheme
                                                              .laurelGreen,
                                                          size: 50.0,
                                                        ),
                                                      )),
                                                  errorWidget: (context, url, error) =>
                                                      Icon(Icons.error),
                                                )
                                            ),
                                            SizedBox(
                                              width: 50,
                                            ),
                                            Container(
                                                width: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .width * 0.4,
                                                height: MediaQuery
                                                    .of(context)
                                                    .size
                                                    .height * 0.18,
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.tertiaryColor,
                                                  borderRadius: BorderRadius.circular(0),
                                                  border: Border.all(
                                                    color: Colors.black,
                                                    width: 2,
                                                  ),
                                                ),
                                                child:
                                                Center(
                                                  child: AutoSizeText(
                                                    (snapshot.data[index + indice * 3].nombre
                                                        .toUpperCase() + '\n' +
                                                        snapshot.data[index + indice * 3].cantidad.toString()),
                                                    style: FlutterFlowTheme
                                                        .tareasPasosEscolar,
                                                    textAlign: TextAlign.center,
                                                    minFontSize: 10,
                                                    stepGranularity: 10,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                )


                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .height * 0.025,
                                        ),
                                      ],
                                    );
                                  }
                              ),
                            ),
                          if(indice == pagsTotales)
                            Expanded(
                              child: Column(
                                children: [
                                  (tarea.fotoResultado == null) ?
                                  Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.8,
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .height * 0.3,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.tertiaryColor,
                                            borderRadius: BorderRadius.circular(0),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 2,
                                            ),
                                          ),
                                          child:
                                          // fotoPerfil == null ? CachedNetworkImage(
                                          //   imageUrl: "${Model.usuario.profilePhoto}",
                                          //   fit: BoxFit.cover,
                                          //   width: 100,
                                          //   height: 100,
                                          //   placeholder: (context, url) => SpinKitPouringHourGlassRefined(
                                          //     color: FlutterFlowTheme.laurelGreen,
                                          //     size: 50.0,
                                          //   ),
                                          //   errorWidget: (context, url, error) => Icon(Icons.error),
                                          // ) :
                                          //Icon(Icons.add_a_photo, size: 100,),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add_a_photo,
                                              size: 100,
                                            ),
                                            onPressed: () async {
                                              _showPicker(context);
                                            },
                                          ),
                                        ),
                                      ]
                                  ) :
                                  Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.4,
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .height * 0.18,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.tertiaryColor,
                                            borderRadius: BorderRadius.circular(0),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 2,
                                            ),
                                          ),
                                          child: fotoResultado == null
                                              ? CachedNetworkImage(
                                            imageUrl: tarea.fotoResultado,
                                            progressIndicatorBuilder: (context, url,
                                                downloadProgress) =>
                                                Center(child: Container(
                                                  child: const SpinKitPouringHourGlassRefined(
                                                    color: FlutterFlowTheme.laurelGreen,
                                                    size: 50.0,
                                                  ),
                                                )),
                                            errorWidget: (context, url, error) =>
                                                Icon(Icons.error),
                                          )
                                              : Image.file(File(fotoResultado.path)),
                                        ),
                                        SizedBox(
                                          width: 50,
                                        ),
                                        Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.4,
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .height * 0.18,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.tertiaryColor,
                                            borderRadius: BorderRadius.circular(0),
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 2,
                                            ),
                                          ),
                                          child:
                                          // fotoPerfil == null ? CachedNetworkImage(
                                          //   imageUrl: "${Model.usuario.profilePhoto}",
                                          //   fit: BoxFit.cover,
                                          //   width: 100,
                                          //   height: 100,
                                          //   placeholder: (context, url) => SpinKitPouringHourGlassRefined(
                                          //     color: FlutterFlowTheme.laurelGreen,
                                          //     size: 50.0,
                                          //   ),
                                          //   errorWidget: (context, url, error) => Icon(Icons.error),
                                          // ) :
                                          //Icon(Icons.add_a_photo, size: 100,),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add_a_photo,
                                              size: 100,
                                            ),
                                            onPressed: () async {
                                              _showPicker(context);
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          height: MediaQuery
                                              .of(context)
                                              .size
                                              .height * 0.025,
                                        ),
                                      ]
                                  ),
                                  SizedBox(height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.05,),
                                  Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.4,
                                    height: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.18,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.tertiaryColor,
                                      borderRadius: BorderRadius.circular(0),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child: Transform.scale(
                                      scale: 3.0,
                                      child: Checkbox(
                                        activeColor: Colors.orange,
                                        value: this.value,
                                        onChanged: (bool value) async {
                                          Results r = await _con.marcarTareaCompletada(
                                              tarea.idTarea, Model.usuario.idUsuario,
                                              value ? 1 : 0);
                                          setState(() {
                                            this.value = value;
                                          });
                                        },
                                      ),),
                                  ),
                                ],
                              ),
                            ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFFEEEEEE),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (indice - 1 >= 0)
                                        setState(() {
                                          // ontap of each card, set the defined int to the grid view index
                                          indice -= 1;
                                        });
                                    },
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(2, 0, 2, 0),
                                      child: Semantics(
                                        label: 'Anterior página',
                                        child: Container(
                                          width: MediaQuery
                                              .of(context)
                                              .size
                                              .width * 0.49,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.tertiaryColor,
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.arrow_back,
                                            color: Colors.black,
                                            size: 100,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        if (indice + 2 <= pagsTotales +1) {
                                          setState(() {
                                            // ontap of each card, set the defined int to the grid view index
                                            indice += 1;
                                          });
                                        }
                                      },
                                      child: Semantics(
                                          label: 'Siguiente página',
                                          child: Container(
                                            width: MediaQuery
                                                .of(context)
                                                .size
                                                .width * 0.49,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: FlutterFlowTheme.tertiaryColor,
                                              border: Border.all(
                                                color: Colors.black,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.arrow_forward,
                                              color: Colors.black,
                                              size: 100,
                                            ),
                                          )
                                      )
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                }
              }
          ),
        )
    );
  }
}
