import 'package:agendaptval/flutter_flow/flutter_flow_widgets.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/tarea.dart';
import 'package:agendaptval/modeloControlador/tipoTarea.dart';
import 'package:agendaptval/modeloControlador/usuarios.dart';
import 'package:agendaptval/vistas/tareasAdmin/descripcion_tarea_admin.dart';
import 'package:agendaptval/vistas/tareasProf/asignar_tareas_prof.dart';
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

import 'crear_tarea_prof_widget.dart';
import 'descripcion_tarea_completada_prof.dart';
import 'descripcion_tarea_prof.dart';
import 'editar_tarea_prof.dart';


class ListaTareasProfCompletadasWidget extends StatefulWidget {
  const ListaTareasProfCompletadasWidget({Key key}) : super(key: key);



  @override
  _ListaTareasProfCompletadasWidgetState createState() => _ListaTareasProfCompletadasWidgetState();
}

class _ListaTareasProfCompletadasWidgetState extends StateMVC {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<Tarea>> tareas;
  Future<List<Usuarios>> alumnos;
  List<Usuarios> listaUsuarios = [];
  List<Tarea> listaTareas = [];
  Usuarios alumno;
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  List<Tarea> _searchResult = [];
  TextEditingController textEditing1 = new TextEditingController();
  String searchString = '';

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  _ListaTareasProfCompletadasWidgetState(): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {
    super.initState();

    // initial load
    tareas = _con.getTareasDeTuteladosCompletadasProfesor();
    alumnos = _con.getAlumnosTutelados();
    _searchResult.clear();
    _getAlumnosAsignados();
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 250));
    //tareas = _con.getTareasDeTutelados();
    setState(() {
      tareas = _con.getTareasDeTuteladosCompletadasProfesor();
      alumnos = _con.getAlumnosTutelados();
      _searchResult.clear();
    });
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _getAlumnosAsignados() async{

    listaUsuarios = await _con.getAlumnosTutelados();

  }

  @override
  Widget build(BuildContext context) {
    _searchResult.clear();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
            children: [
              Container(
                color: FlutterFlowTheme.laurelGreenDarker,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: ListTile(
                      leading: Icon(Icons.search),
                      title: TextField(
                        controller: textEditing1,
                        decoration: InputDecoration(
                            hintText: 'Buscar', border: InputBorder.none),
                        onChanged: (value) {
                          if (value.isEmpty) {
                            setState(() {
                              _searchResult.clear();
                              searchString = '';
                            });
                            return;
                          }
                          setState(() {
                            _searchResult.clear();
                            searchString = value.toLowerCase();
                          });
                        },
                      ),
                      trailing: IconButton(icon: new Icon(Icons.cancel), onPressed: () {
                        setState(() {
                          textEditing1.clear();
                          _searchResult.clear();
                          searchString = '';
                        });
                        return;
                      },),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: FutureBuilder<List<Tarea>>(
                  future: tareas,
                  builder: (BuildContext context, AsyncSnapshot<List<Tarea>> snapshot) {
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
                          listaTareas = snapshot.data;
                          listaTareas.forEach((tarea) {
                            if (tarea.nombre.toLowerCase().contains(searchString) || tarea.descripcion.toLowerCase().contains(searchString))
                              _searchResult.add(tarea);
                          });
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
                            child: _searchResult.length > 0 ? ListView.builder(
                              itemCount: _searchResult.length,
                              itemBuilder: (context, index) {
                                return
                                  Card(
                                    child: ListTile(
                                      title: Text(_searchResult[index].nombre),
                                      subtitle: getAlumnoNombre(_searchResult[index].idUsuarioRealiza, listaUsuarios),
                                      leading: Container(
                                          clipBehavior: Clip.antiAlias,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                          ),
                                          child:
                                          CachedNetworkImage(
                                            imageUrl: getAlumno(_searchResult[index].idUsuarioRealiza, listaUsuarios).profilePhoto,
                                            progressIndicatorBuilder: (context, url, downloadProgress) =>
                                                CircularProgressIndicator(value: downloadProgress.progress),
                                            errorWidget: (context, url, error) => Icon(Icons.error),
                                          ),),
                                          //Image.network()),
                                      trailing: Wrap(
                                        spacing: 12,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.deepOrange,
                                            ),
                                            onPressed: () async{
                                              await _con.eliminarAsignacion(_searchResult[index].idTarea, _searchResult[index].idUsuarioRealiza);
                                              _onRefresh();
                                            },
                                          ),
                                        ],
                                      ),

                                      onTap: () async{
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => DescripcionTareaCompletadaProfWidget(_searchResult[index].idTarea, getAlumno(_searchResult[index].idUsuarioRealiza, listaUsuarios)),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                              },
                            ) :
                            Expanded(
                              child: Center(
                                  child: ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Icon(Icons.feedback, size: 100, color: Colors.deepOrange,),
                                      SizedBox(height: 25,),
                                      Container(
                                        alignment: Alignment.center,
                                        child: searchString.isNotEmpty ? Text('No hay tareas completadas según su búsqueda', style: FlutterFlowTheme.title3, textAlign: TextAlign.center) : Text('No hay tareas completadas', style: FlutterFlowTheme.title3) ,
                                        padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                      ),
                                    ],
                                  )
                              ),
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
