import 'package:agendaptval/flutter_flow/flutter_flow_widgets.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/item.dart';
import 'package:agendaptval/modeloControlador/platos.dart';
import 'package:agendaptval/modeloControlador/tarea.dart';
import 'package:agendaptval/modeloControlador/tipoPlato.dart';
import 'package:agendaptval/modeloControlador/tipoTarea.dart';
import 'package:agendaptval/vistas/tareasAdmin/descripcion_tarea_admin.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'crear_plato.dart';
import 'editar_plato.dart';




class ListaPlatosWidget extends StatefulWidget {
  const ListaPlatosWidget({Key key}) : super(key: key);



  @override
  _ListaPlatosWidgetState createState() => _ListaPlatosWidgetState();
}

class _ListaPlatosWidgetState extends StateMVC {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<Platos>> items;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  _ListaPlatosWidgetState(): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {
    super.initState();

    // initial load
    items = _con.getAllPlatos();
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 250));
    //tareas = _con.getAllTareas();
    setState(() {
      items = _con.getAllPlatos();
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
          child: FutureBuilder<List<Platos>>(
              future: items,
              builder: (BuildContext context, AsyncSnapshot<List<Platos>> snapshot) {
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
                                  subtitle: platoToString(snapshot.data[index].tipo),
                                  leading: Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                    ),
                                    child:
                                    CachedNetworkImage(
                                      imageUrl: snapshot.data[index].pictograma,
                                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                                          CircularProgressIndicator(value: downloadProgress.progress),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                    ),),
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
                                              builder: (context) => EditarPlatoAdminWidget(snapshot.data[index]),
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
                                          await _con.eliminarPlato(snapshot.data[index].idPlato);
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
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add your onPressed code here!
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrearPlatoAdminWidget(),
            ),
          ).then((_) => _onRefresh());
        },
        backgroundColor: FlutterFlowTheme.laurelGreenDarker,
        child: const Icon(Icons.add),
      ),
    );
  }
  Text platoToString(tipoPlato tipo){
    switch(tipo){
      case (tipoPlato.PRIMERO):
        return Text('Primero');
        break;
      case (tipoPlato.SEGUNDO):
        return Text('Segundo');
        break;
      case (tipoPlato.POSTRE):
        return Text('Postre');
        break;
      default:
        return Text('Plato');
        break;
    }
  }

}
