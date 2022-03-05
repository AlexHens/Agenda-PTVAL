import 'package:agendaptval/flutter_flow/flutter_flow_widgets.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/tarea.dart';
import 'package:agendaptval/modeloControlador/tipoTarea.dart';
import 'package:agendaptval/vistas/tareasAdmin/descripcion_tarea_admin.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'crear_tarea_admin.dart';
import 'editar_tarea_admin.dart';


class ListaTareasAdminWidget extends StatefulWidget {
  const ListaTareasAdminWidget({Key key}) : super(key: key);



  @override
  _ListaTareasAdminWidgetState createState() => _ListaTareasAdminWidgetState();
}

class _ListaTareasAdminWidgetState extends StateMVC {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<Tarea>> tareas;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  _ListaTareasAdminWidgetState(): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {
    super.initState();

    // initial load
    tareas = _con.getAllTareas();
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 250));
    //tareas = _con.getAllTareas();
    setState(() {
      tareas = _con.getAllTareas();
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
              padding: EdgeInsets.zero,
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
                                    subtitle: tareaToString(snapshot.data[index].tipo),
                                    trailing:
                                    Wrap(
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
                                                builder: (context) => EditarTareaAdminWidget(snapshot.data[index]),
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
                                            await _con.eliminarTarea(snapshot.data[index].idTarea);
                                            _onRefresh();
                                          },
                                        ),

                                      ],
                                    ),

                                    onTap: () async{
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DescripcionTareaAdminWidget(snapshot.data[index].idTarea),
                                        ),
                                      );
                                    },
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add your onPressed code here!
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrearTareaAdminWidget(),
            ),
          ).then((value) => _onRefresh());
        },
        backgroundColor: FlutterFlowTheme.laurelGreenDarker,
        child: const Icon(Icons.add),
      ),
    );
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
