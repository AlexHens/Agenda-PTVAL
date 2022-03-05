import 'dart:io';

import 'package:agendaptval/flutter_flow/flutter_flow_video_player.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/tarea.dart';
import 'package:agendaptval/modeloControlador/tipoInfo.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mysql1/mysql1.dart';

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VistaDeTareaCompletadaUltimaWidget extends StatefulWidget {
  const VistaDeTareaCompletadaUltimaWidget(this.tarea, {Key key})
      : super(key: key);
  final Tarea tarea;

  @override
  _VistaDeTareaCompletadaUltimaWidgetState createState() =>
      _VistaDeTareaCompletadaUltimaWidgetState(this.tarea);
}

class _VistaDeTareaCompletadaUltimaWidgetState extends StateMVC {
  bool checkboxListTileValue;
  Tarea tarea;
  int indice, pagsTotales, elemsUltPag;
  AudioPlayer audioPlayer = AudioPlayer();
  bool value;
  XFile fotoPerfil;
  final ImagePicker _picker = ImagePicker();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _VistaDeTareaCompletadaUltimaWidgetState(this.tarea) : super(Controller()) {
    _con = Controller.con;
  }

  Controller _con;

  @override
  void initState() {
    // TODO: implement initState
    indice = 0;
    pagsTotales = ((tarea.descripcion.split('\n').length / 3)).toInt();
    if (tarea.descripcion.split('\n').length % 3 != 0) {
      pagsTotales++;
      elemsUltPag = tarea.descripcion.split('\n').length % 3;
    } else {
      elemsUltPag = 3;
    }
    value = true;
    super.initState();
  }

  Future<String> _imgFromCamera() async {
    XFile image =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 100);
    setState(() {
      if (image != null) {
        //_con.subirFotoPerfil(File(image.path), Model.usuario.idUsuario.toString());
      }
      fotoPerfil = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.tertiaryColor,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.025,),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Model.personalizacion.homepageReloj == 1 ?
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.tertiaryColor,
                    borderRadius: BorderRadius.circular(0),
                    border: Border.all(
                      color: Colors.black,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children:[
                      tarea.pictogramas.isNotEmpty ?
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: CachedNetworkImage(
                          imageUrl: tarea.pictogramas[0],
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              Center(child: Container(
                                child: const SpinKitPouringHourGlassRefined(
                                  color: FlutterFlowTheme.laurelGreen,
                                  size: 50.0,
                                ),
                              )),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ) : tarea.imagenes.isNotEmpty ?
                      Container(
                        height: MediaQuery.of(context).size.height * 0.1,
                        child: CachedNetworkImage(
                          imageUrl: tarea.imagenes[0],
                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                              Center(child: Container(
                                child: const SpinKitPouringHourGlassRefined(
                                  color: FlutterFlowTheme.laurelGreen,
                                  size: 50.0,
                                ),
                              )),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ) : Container(
                        height: MediaQuery.of(context).size.height * 0.1,
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
                ):
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.18,
                ),
                SizedBox(width: 50,),
                GestureDetector(
                  onTap: () async {
                    await Navigator.pop(context);
                    await Navigator.pop(context);
                  },
                  child: Semantics(
                    label: 'Ir a Inicio',
                    child : Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: MediaQuery.of(context).size.height * 0.18,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.tertiaryColor,
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.025,
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
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.height * 0.18,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.tertiaryColor,
                                  borderRadius: BorderRadius.circular(0),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child:
                                (Model.usuario.formatoAyuda == tipoInfo.TEXTO ? tarea.imagenes : tarea.pictogramas).isNotEmpty ?
                                CachedNetworkImage(
                                  imageUrl: Model.usuario.formatoAyuda == tipoInfo.TEXTO ? tarea.imagenes[index+indice*3] : tarea.pictogramas[index+indice*3],
                                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                                      Center(child: Container(
                                        child: const SpinKitPouringHourGlassRefined(
                                          color: FlutterFlowTheme.laurelGreen,
                                          size: 50.0,
                                        ),
                                      )),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ) : AutoSizeText(
                                  '${index+indice*3}º.',
                                  style: FlutterFlowTheme.tareasPasosEscolar,
                                  textAlign: TextAlign.center,
                                  minFontSize: 10,
                                  stepGranularity: 10,
                                  maxLines: 12,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height: MediaQuery.of(context).size.height * 0.18,
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
                                      tarea.descripcion.split('\n')[index+indice*3].toUpperCase(),
                                      style: FlutterFlowTheme.tareasPasosEscolar,
                                      textAlign: TextAlign.center,
                                      minFontSize: 10,
                                      stepGranularity: 10,
                                      maxLines: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  )

                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                        ],
                      );
                    }
                ),
              ),

            if(indice == pagsTotales)
              (tarea.videos.isNotEmpty) ?
              Expanded(
                child: ListView.builder(
                  // This next line does the trick.
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: tarea.videos.length,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                        child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              FlutterFlowVideoPlayer(
                                path: tarea.videos[index],
                                videoType: VideoType.network,
                                autoPlay: true,
                                looping: true,
                                showControls: false,
                                allowFullScreen: true,
                                allowPlaybackSpeedMenu: false,
                              ),
                            ]
                        ),
                      );
                    }
                ),
              ) :

              Expanded(
                  child:
                  Column(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(0.05, 1),
                            child: Icon(
                              Icons.warning,
                              color: Color(0xFFAB9F3D),
                              size: 200,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Align(
                            alignment: AlignmentDirectional(0.05, -1),
                            child: Text(
                              'No hay vídeo'.toUpperCase(),
                              style: FlutterFlowTheme.tareasPasosEscolar,
                            ),
                          ),
                        ),
                      ]
                  )),

            if(indice == pagsTotales+1)
              Expanded(
                child:
                tarea.audios.length > 0 ?
                ListView.builder(
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
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.height * 0.18,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.tertiaryColor,
                                  borderRadius: BorderRadius.circular(0),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    AutoSizeText(
                                      '${index*2+1}º.',
                                      style: FlutterFlowTheme.tareasPasosEscolar,
                                      textAlign: TextAlign.center,
                                      minFontSize: 10,
                                      stepGranularity: 10,
                                      maxLines: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        IconButton(onPressed: () async {
                                          await audioPlayer.play('${tarea.audios[index*2]}');
                                        }, icon: Icon(Icons.play_circle, size: 75,),iconSize: 50,),
                                        IconButton(onPressed: () async {
                                          await audioPlayer.pause();
                                        }, icon: Icon(Icons.pause_circle, size: 75,), iconSize: 50,),
                                      ],
                                    )

                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 50,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height: MediaQuery.of(context).size.height * 0.18,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.tertiaryColor,
                                  borderRadius: BorderRadius.circular(0),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    AutoSizeText(
                                      '${index*2+2}º.',
                                      style: FlutterFlowTheme.tareasPasosEscolar,
                                      textAlign: TextAlign.center,
                                      minFontSize: 10,
                                      stepGranularity: 10,
                                      maxLines: 12,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Row(
                                      children: [
                                        IconButton(onPressed: () async {
                                          await audioPlayer.play('${tarea.audios[index*2+1]}');
                                        }, icon: Icon(Icons.play_circle, size: 75,),iconSize: 50,),
                                        IconButton(onPressed: () async {
                                          await audioPlayer.pause();
                                        }, icon: Icon(Icons.pause_circle, size: 75,), iconSize: 50,),
                                      ],
                                    )

                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                        ],
                      );
                    }
                ) :
                Column(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional(0.05, 1),
                          child: Icon(
                            Icons.warning,
                            color: Color(0xFFAB9F3D),
                            size: 200,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional(0.05, -1),
                          child: Text(
                            'No hay audio'.toUpperCase(),
                            style: FlutterFlowTheme.tareasPasosEscolar,
                          ),
                        ),
                      ),
                    ]
                ),
              ),

            if(indice == pagsTotales+2)
              Expanded(
                  child: Column(
                    children: [
                      tarea.retroalimentacion != null ?
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
                            child:
                                tarea.retroalimentacion.pictograma != null ?
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height: MediaQuery.of(context).size.height * 0.18,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.tertiaryColor,
                                    borderRadius: BorderRadius.circular(0),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: tarea.retroalimentacion.pictograma,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                        Center(
                                            child: Container(
                                              child: const SpinKitPouringHourGlassRefined(
                                                color: FlutterFlowTheme.laurelGreen,
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
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height * 0.18,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.tertiaryColor,
                                      borderRadius: BorderRadius.circular(0),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: AutoSizeText(
                                        tarea.retroalimentacion.descripcion
                                            .toUpperCase(),
                                        style: FlutterFlowTheme.tareasPasosEscolar,
                                        textAlign: TextAlign.center,
                                        minFontSize: 10,
                                        stepGranularity: 10,
                                        maxLines: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )),
                              ],
                            ) :
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: MediaQuery.of(context).size.width * 0.8,
                                        height: MediaQuery.of(context).size.height * 0.18,
                                        decoration: BoxDecoration(
                                          color: FlutterFlowTheme.tertiaryColor,
                                          borderRadius: BorderRadius.circular(0),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 2,
                                          ),
                                        ),
                                        child: Center(
                                          child: AutoSizeText(
                                            tarea.retroalimentacion.descripcion
                                                .toUpperCase(),
                                            style: FlutterFlowTheme.tareasPasosEscolar,
                                            textAlign: TextAlign.center,
                                            minFontSize: 10,
                                            stepGranularity: 10,
                                            maxLines: 12,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )),
                                  ],
                                ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 58),
                            child:
                            (tarea.retroalimentacion.mostrarCalificacion == 0) ?
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height * 0.18,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.tertiaryColor,
                                      borderRadius: BorderRadius.circular(0),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child:
                                    //(Model.usuario.formatoAyuda == tipoInfo.TEXTO ? tarea.imagenes : tarea.pictogramas).isNotEmpty ?
                                    CachedNetworkImage(
                                      imageUrl:
                                      tarea.retroalimentacion.emoticono.imagen,
                                    )),
                                SizedBox(
                                  width: 50,
                                ),

                              ],
                            ) :
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height * 0.18,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.tertiaryColor,
                                      borderRadius: BorderRadius.circular(0),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child:
                                    //(Model.usuario.formatoAyuda == tipoInfo.TEXTO ? tarea.imagenes : tarea.pictogramas).isNotEmpty ?
                                    CachedNetworkImage(
                                      imageUrl:
                                      tarea.retroalimentacion.emoticono.imagen,
                                    )),
                                SizedBox(
                                  width: 50,
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height * 0.18,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.tertiaryColor,
                                      borderRadius: BorderRadius.circular(0),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: AutoSizeText(
                                        tarea.retroalimentacion.calificacion.toString(),
                                        style: FlutterFlowTheme.tareasPasosEscolar,
                                        textAlign: TextAlign.center,
                                        minFontSize: 10,
                                        stepGranularity: 10,
                                        maxLines: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                        ],
                      ) :
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 70, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height: MediaQuery.of(context).size.height * 0.18,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.tertiaryColor,
                                    borderRadius: BorderRadius.circular(0),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),

                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height * 0.18,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.tertiaryColor,
                                      borderRadius: BorderRadius.circular(0),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: AutoSizeText(
                                        'Sin retroalimentación'.toUpperCase(),
                                        style: FlutterFlowTheme.tareasPasosEscolar,
                                        textAlign: TextAlign.center,
                                        minFontSize: 10,
                                        stepGranularity: 10,
                                        maxLines: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 58),
                            child:
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  height: MediaQuery.of(context).size.height * 0.18,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.tertiaryColor,
                                    borderRadius: BorderRadius.circular(0),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 50,
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width * 0.4,
                                    height: MediaQuery.of(context).size.height * 0.18,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.tertiaryColor,
                                      borderRadius: BorderRadius.circular(0),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 2,
                                      ),
                                    ),
                                    child: Center(
                                      child: AutoSizeText(
                                        'Sin calificación'.toUpperCase(),
                                        style: FlutterFlowTheme.tareasPasosEscolar,
                                        textAlign: TextAlign.center,
                                        minFontSize: 10,
                                        stepGranularity: 10,
                                        maxLines: 12,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.025,
                          ),
                        ],
                      ),
                    ],
                  )
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
                        if(indice -1 >= 0)
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
                            width: MediaQuery.of(context).size.width * 0.49,
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
                          if(indice + 2 <= pagsTotales + 3){
                            setState(() {
                              // ontap of each card, set the defined int to the grid view index
                              indice += 1;
                            });
                          }
                        },
                        child: Semantics(
                            label: 'Siguiente página',
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.49,
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
        ),
      ),
    );
  }
}
