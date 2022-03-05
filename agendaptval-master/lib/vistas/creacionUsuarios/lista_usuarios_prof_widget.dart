import 'package:agendaptval/flutter_flow/flutter_flow_widgets.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/personalizacion.dart';
import 'package:agendaptval/modeloControlador/tarea.dart';
import 'package:agendaptval/modeloControlador/tipoTarea.dart';
import 'package:agendaptval/modeloControlador/tipoUsuario.dart';
import 'package:agendaptval/modeloControlador/usuarios.dart';
import 'package:agendaptval/vistas/creacionUsuarios/personalizar_alumno_prof_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class ListaUsuariosProfWidgetState extends StatefulWidget {
  const ListaUsuariosProfWidgetState({Key key}) : super(key: key);



  @override
  _ListaUsuariosProfWidgetState createState() => _ListaUsuariosProfWidgetState();
}

class _ListaUsuariosProfWidgetState extends StateMVC {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<Usuarios>> alumnos;
  List<Usuarios> listaUsuarios = [];
  Usuarios alumno;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  Personalizacion p;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  _ListaUsuariosProfWidgetState(): super(){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {
    super.initState();

    // initial load
    alumnos = _con.getAlumnosTutelados();

  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 250));
    //tareas = _con.getTareasDeTutelados();
    setState(() {
      alumnos = _con.getAlumnosTutelados();
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      key: scaffoldKey,
      backgroundColor: Colors.white,

      body: SafeArea(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.8,
                padding: const EdgeInsets.all(5.0),
                margin: EdgeInsets.only(top: 20),
                child: FutureBuilder<List<Usuarios>>(
                  future: alumnos,
                  builder: (BuildContext context, AsyncSnapshot<List<Usuarios>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return Container(
                          child: SpinKitRotatingCircle(
                            color: FlutterFlowTheme.laurelGreen,
                            size: 50.0,
                          ),
                        );
                      default:
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else{
                          //listaTareas = snapshot.data;
                          return SmartRefresher(
                            enablePullDown: true,
                            header: WaterDropHeader(),
                            footer: CustomFooter(
                              builder: (BuildContext context,LoadStatus mode){
                                Widget body ;
                                if(mode==LoadStatus.idle){
                                  body =  Text("pull up load");
                                }
                                else if(mode==LoadStatus.loading){
                                  body =  CupertinoActivityIndicator();
                                }
                                else if(mode == LoadStatus.failed){
                                  body = Text("Load Failed!Click retry!");
                                }
                                else if(mode == LoadStatus.canLoading){
                                  body = Text("release to load more");
                                }
                                else{
                                  body = Text("No more Data");
                                }
                                return Container(
                                  height: 55.0,
                                  child: Center(child:body),
                                );
                              },
                            ),
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {

                                return
                                  Card(

                                    child: ListTile(
                                      title: Text(snapshot.data[index].nombre),
                                      subtitle: Text(snapshot.data[index].getRol() == tipoUsuario.ALUMNO ? 'Alumno': 'Profesor'),
                                      leading: Container(
                                        clipBehavior: Clip.antiAlias,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child:
                                        CachedNetworkImage(
                                          imageUrl: snapshot.data[index].profilePhoto,
                                          progressIndicatorBuilder: (context, url, downloadProgress) =>
                                              CircularProgressIndicator(value: downloadProgress.progress),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ),
                                      ),
                                      //Image.network()),
                                      trailing: Wrap(
                                        spacing: 12,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                            ),
                                            onPressed: () async{
                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PersonalizarAlumnoWidgetState(snapshot.data[index]),
                                                ),
                                              ).then((_) => _onRefresh());
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.deepOrange,
                                            ),
                                            onPressed: () async{
                                              await _con.eliminarUsuario(snapshot.data[index]);
                                              _onRefresh();
                                            },
                                          ),
                                        ],
                                      ),

                                    ),
                                  );

                              },
                            ),
                          );
                        }
                    }
                  },
                ),
              ),
            ],
          )

      ),

    );
  }

  Text getAlumnoNombre(int id, List<Usuarios> usuarios){

    for(int i = 0; i < usuarios.length; i++){
      if(id == usuarios[i].idUsuario)
        return Text((usuarios[i].nombre + " " + usuarios[i].apellidos));

    }
  }

  Usuarios getAlumno(int id, List<Usuarios> usuarios){

    for(int i = 0; i < usuarios.length; i++){
      if(id == usuarios[i].idUsuario)
        return usuarios[i];

    }
  }

  Text tareaToString(tipoTarea tipo){
    switch(tipo){
      case (tipoTarea.FIJA):
        return Text('Tarea Fija');
        break;
      default:
        return Text('Tarea Comanda');
        break;
    }
  }


}
