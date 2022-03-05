import 'package:agendaptval/flutter_flow/flutter_flow_video_player.dart';
import 'package:agendaptval/flutter_flow/flutter_flow_widgets.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/tarea.dart';
import 'package:agendaptval/modeloControlador/usuarios.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:toggle_switch/toggle_switch.dart';


import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class DescripcionTareaCompletadaProfWidget extends StatefulWidget {

  final int _idTarea;
  final Usuarios _idUsuario;

  DescripcionTareaCompletadaProfWidget(this._idTarea,this._idUsuario);

  @override
  _DescripcionTareaCompletadaProfWidgetState createState() =>
      _DescripcionTareaCompletadaProfWidgetState(this._idTarea,this._idUsuario);
}

class _DescripcionTareaCompletadaProfWidgetState extends StateMVC {

  final int _idTarea;
  final Usuarios _idUsuario;
  bool audioReproduciendo = false;
  AudioPlayer audioPlayer = AudioPlayer();

  List<Usuarios> listaUsuarios = [];


  final scaffoldKey = GlobalKey<ScaffoldState>();

  _DescripcionTareaCompletadaProfWidgetState(this._idTarea,this._idUsuario): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {
    super.initState();
    _getAlumnosAsignados();
  }

  void _getAlumnosAsignados() async{

    listaUsuarios = await _con.getAlumnosTutelados();

  }



  Padding getAlumnoNombre(int id, List<Usuarios> usuarios){

    for(int i = 0; i < usuarios.length; i++){
      if(id == usuarios[i].idUsuario)
        return Padding(
            padding: EdgeInsetsDirectional.fromSTEB(00, 15, 00, 0),
            child:
            Text(
              (usuarios[i].nombre + " " + usuarios[i].apellidos),
              style: FlutterFlowTheme.bodyText2.override(
                fontFamily: 'Lexend Deca',
                color: Color(0xFF262D34),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ));

    }
  }


  @override
  Widget build(BuildContext context) {

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
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () async{
            await Navigator.pop(context);
          },
        ),
        title: Text(
          'Detalle Tarea',
          style: FlutterFlowTheme.title1,
        ),
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child:
        FutureBuilder<Tarea>(
            future: _con.getTareaAsignada(this._idTarea,this._idUsuario.idUsuario),
            builder: (BuildContext context, AsyncSnapshot<Tarea> snapshot) {
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
                    return Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: ListView(
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(24, 20, 24, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      '${snapshot.data.nombre}',
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
                                padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      snapshot.data.fecha_fin.difference(DateTime.now()).inDays >= 0 ?
                                      '${snapshot.data.fecha_fin.difference(DateTime.now()).inDays} días y ${(snapshot.data.fecha_fin.difference(DateTime.now()).inHours < 0) ? 0 : snapshot.data.fecha_fin.difference(DateTime.now()).inHours % 24} horas restantes '
                                          :
                                      'Retrasada por ${DateTime.now().difference(snapshot.data.fecha_fin).inDays} días y ${(DateTime.now().difference(snapshot.data.fecha_fin).inHours < 0) ? 0 : snapshot.data.fecha_fin.difference(DateTime.now()).inHours % 24} horas ',
                                      style: FlutterFlowTheme.bodyText2.override(
                                        fontFamily: 'Lexend Deca',
                                        color: Color(0xFF8B97A2),
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              (snapshot.data.retroalimentacion != null) ?
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      '${snapshot.data.retroalimentacion.calificacion}',
                                      style: FlutterFlowTheme.bodyText2.override(
                                        fontFamily: 'Lexend Deca',
                                        color: Color(0xFF8B97A2),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(15, 0, 20, 0),
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
                                            imageUrl: snapshot.data.retroalimentacion.emoticono.imagen,
                                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                CircularProgressIndicator(value: downloadProgress.progress),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),
                                        )),

                                  ],
                                ),
                              ) :
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(24, 4, 24, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'Sin calificación',
                                      style: FlutterFlowTheme.bodyText2.override(
                                        fontFamily: 'Lexend Deca',
                                        color: Color(0xFF8B97A2),
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
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
                                                              fontSize: 14,
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
                                                snapshot.data.completada == 0 ? ToggleSwitch(
                                                  minWidth: 125.0,
                                                  initialLabelIndex: 0,
                                                  cornerRadius: 20.0,
                                                  activeFgColor: Colors.white,
                                                  inactiveBgColor: Colors.grey,
                                                  inactiveFgColor: Colors.white,
                                                  totalSwitches: 1,
                                                  labels: ['En Progreso'],
                                                  icons: [Icons.loop],
                                                  activeBgColors: [[Colors.pink]],
                                                  onToggle: (index) {
                                                    print('switched to: $index');
                                                    //tareaRealizada = index;
                                                  },
                                                ) : snapshot.data.completada == 1 ?
                                                ToggleSwitch(
                                                  minWidth: 125.0,
                                                  initialLabelIndex: 0,
                                                  cornerRadius: 20.0,
                                                  activeFgColor: Colors.white,
                                                  inactiveBgColor: Colors.grey,
                                                  inactiveFgColor: Colors.white,
                                                  totalSwitches: 1,
                                                  labels: ['En Revisión'],
                                                  icons: [Icons.assignment_turned_in],
                                                  activeBgColors: [[Colors.amber]],
                                                  onToggle: (index) {
                                                    print('switched to: $index');
                                                    //tareaRealizada = index;
                                                  },
                                                ) :
                                                ToggleSwitch(
                                                  minWidth: 125.0,
                                                  initialLabelIndex: 0,
                                                  cornerRadius: 20.0,
                                                  activeFgColor: Colors.white,
                                                  inactiveBgColor: Colors.grey,
                                                  inactiveFgColor: Colors.white,
                                                  totalSwitches: 1,
                                                  labels: ['Completada'],
                                                  icons: [Icons.done_all],
                                                  activeBgColors: [[Colors.green]],
                                                  onToggle: (index) {
                                                    print('switched to: $index');
                                                    //tareaRealizada = index;
                                                  },
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
                                        fontSize: 14,
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
                                          '${snapshot.data.descripcion}',
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
                              (snapshot.data.fotoResultado != null) ?
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
                                          imageUrl: snapshot.data.fotoResultado,
                                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                                              SpinKitRotatingCircle(
                                                color: Colors.greenAccent,
                                                size: 50.0,
                                              ),
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
                                padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'RETROALIMENTACIÓN',
                                      style: FlutterFlowTheme.bodyText2.override(
                                        fontFamily: 'Lexend Deca',
                                        color: Color(0xFF262D34),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              (snapshot.data.retroalimentacion != null) ?
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
                                          '${snapshot.data.retroalimentacion.descripcion}',
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
                                          'Sin retroalimentación',
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
                                      'PASOS EN IMÁGENES',
                                      style: FlutterFlowTheme.bodyText2.override(
                                        fontFamily: 'Lexend Deca',
                                        color: Color(0xFF262D34),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              snapshot.data.imagenes.length > 0 ?
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.2,
                                child: ListView.builder(
                                  // This next line does the trick.
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.imagenes.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: Stack(
                                            children: <Widget>[
                                              CachedNetworkImage(
                                                imageUrl: snapshot.data.imagenes[index],
                                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                    CircularProgressIndicator(value: downloadProgress.progress),
                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                child: ElevatedButton(
                                                  child: Text((index+1).toString()),
                                                  onPressed: () {
                                                    print('Pressed');
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    primary: FlutterFlowTheme.laurelGreenDarker,
                                                  ),
                                                ),
                                              ),
                                            ]
                                        ),
                                      );
                                    }
                                ),
                              ) : Padding(padding: EdgeInsets.fromLTRB(25, 10, 0, 0),child: Text('No hay imágenes asociadas a la tarea', style: FlutterFlowTheme.bodyText2.override(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF8B97A2),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),)),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'PASOS EN PICTOGRAMAS',
                                      style: FlutterFlowTheme.bodyText2.override(
                                        fontFamily: 'Lexend Deca',
                                        color: Color(0xFF262D34),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              snapshot.data.pictogramas.length > 0 ?
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.2,
                                child: ListView.builder(
                                  // This next line does the trick.
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.pictogramas.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: Stack(
                                            children: <Widget>[
                                              CachedNetworkImage(
                                                imageUrl: snapshot.data.pictogramas[index],
                                                progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                    CircularProgressIndicator(value: downloadProgress.progress),
                                                errorWidget: (context, url, error) => Icon(Icons.error),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                child: ElevatedButton(
                                                  child: Text((index+1).toString()),
                                                  onPressed: () {
                                                    print('Pressed');
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    primary: FlutterFlowTheme.laurelGreenDarker,
                                                  ),
                                                ),
                                              ),
                                            ]
                                        ),
                                      );
                                    }
                                ),
                              ) : Padding(padding: EdgeInsets.fromLTRB(25, 10, 0, 0),child: Text('No hay pictogramas asociados a la tarea', style: FlutterFlowTheme.bodyText2.override(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF8B97A2),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),)),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'PASOS EN VÍDEOS',
                                      style: FlutterFlowTheme.bodyText2.override(
                                        fontFamily: 'Lexend Deca',
                                        color: Color(0xFF262D34),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              snapshot.data.videos.length > 0 ?
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.2,
                                child: ListView.builder(
                                  // This next line does the trick.
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.videos.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                        child: Stack(
                                            children: <Widget>[
                                              FlutterFlowVideoPlayer(
                                                path: snapshot.data.videos[index],
                                                videoType: VideoType.network,
                                                autoPlay: false,
                                                looping: true,
                                                showControls: true,
                                                allowFullScreen: true,
                                                allowPlaybackSpeedMenu: false,
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                                child: ElevatedButton(
                                                  child: Text((index+1).toString()),
                                                  onPressed: () {
                                                    print('Pressed');
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    primary: FlutterFlowTheme.laurelGreenDarker,
                                                  ),
                                                ),
                                              ),
                                            ]
                                        ),
                                      );
                                    }
                                ),
                              ) : Padding(padding: EdgeInsets.fromLTRB(25, 10, 0, 0),child: Text('No hay vídeos asociados a la tarea', style: FlutterFlowTheme.bodyText2.override(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF8B97A2),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),)),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(24, 16, 24, 0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'PASOS EN AUDIO',
                                      style: FlutterFlowTheme.bodyText2.override(
                                        fontFamily: 'Lexend Deca',
                                        color: Color(0xFF262D34),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              snapshot.data.audios.length > 0 ?
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height * 0.15,
                                child: ListView.builder(
                                  // This next line does the trick.
                                    scrollDirection: Axis.horizontal,
                                    itemCount: snapshot.data.audios.length,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(0, 0, 5, 10),
                                        child: Container(
                                          width: MediaQuery.of(context).size.width * 0.3,
                                          child: Column(
                                            children: [
                                              Text('Paso ${index+1}', style: FlutterFlowTheme.subtitle2,),
                                              Row(
                                                children: [
                                                  IconButton(onPressed: () async {
                                                    await audioPlayer.play('${snapshot.data.audios[index]}');
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
                                    }
                                ),
                              )  : Padding(padding: EdgeInsets.fromLTRB(25, 10, 0, 10),child: Text('No hay audios asociadas a la tarea', style: FlutterFlowTheme.bodyText2.override(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF8B97A2),
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                              ),)),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
              }
            }
        ),
      ),
    );
  }


}
