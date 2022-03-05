import 'package:agendaptval/flutter_flow/flutter_flow_widgets.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/item.dart';
import 'package:agendaptval/modeloControlador/tarea.dart';
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

import 'crear_material_admin.dart';
import 'editar_material_admin.dart';



class ListaMaterialesAdminWidget extends StatefulWidget {
  const ListaMaterialesAdminWidget({Key key}) : super(key: key);



  @override
  _ListaMaterialesAdminWidgetState createState() => _ListaMaterialesAdminWidgetState();
}

class _ListaMaterialesAdminWidgetState extends StateMVC {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  Future<List<Item>> items;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  _ListaMaterialesAdminWidgetState(): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {
    super.initState();

    // initial load
    items = _con.getAllItems();
  }

  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 250));
    //tareas = _con.getAllTareas();
    setState(() {
      items = _con.getAllItems();
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
                child: FutureBuilder<List<Item>>(
                  future: items,
                  builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
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
                                      subtitle: Text(snapshot.data[index].cantidad.toString()),
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
                                                  builder: (context) => EditarMaterialAdminWidget(snapshot.data[index]),
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
                                              await _con.eliminarMaterial(snapshot.data[index].idItem);
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Add your onPressed code here!
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CrearMaterialAdminWidget(),
            ),
          ).then((_) => _onRefresh());
        },
        backgroundColor: FlutterFlowTheme.laurelGreenDarker,
        child: const Icon(Icons.add),
      ),
    );
  }


}
