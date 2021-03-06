import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/tarea.dart';
import 'package:agendaptval/modeloControlador/tipoInfo.dart';
import 'package:agendaptval/vistas/tareasAlumno/vista_tarea_inventario_alumno.dart';
import 'package:agendaptval/vistas/tareasAlumno/vista_tarea_ultima_alumno.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_analog_clock/flutter_analog_clock.dart';
import '../Comida/primer_plato/primer_plato_widget.dart';

import 'package:agendaptval/modeloControlador/tipoTarea.dart';

class ListaTareaHoraAlumnoWidget extends StatefulWidget {
  const ListaTareaHoraAlumnoWidget({Key key}) : super(key: key);

  @override
  _ListaTareaHoraAlumnoWidgetState createState() =>
      _ListaTareaHoraAlumnoWidgetState();
}

class _ListaTareaHoraAlumnoWidgetState extends StateMVC {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Tarea> listaTareas = [];
  int indice, pagsTotales;

  _ListaTareaHoraAlumnoWidgetState(): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {
    // TODO: implement initState
    indice = 0;
    super.initState();
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
                  child: FlutterAnalogClock(),
                ) :
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.18,
                ),
                SizedBox(width: 50,),
                GestureDetector(
                  onTap: () async {
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
            SizedBox(height: MediaQuery.of(context).size.height * 0.025,),
            FutureBuilder<List<Tarea>>(
                future: _con.getTareasAlumno(),
                builder: (BuildContext context, AsyncSnapshot<List<Tarea>> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return Center(child: Container(
                        child: const SpinKitPouringHourGlassRefined(
                          color: FlutterFlowTheme.laurelGreen,
                          size: 50.0,
                        ),
                      ));
                    default:
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.data.isNotEmpty) {
                        pagsTotales = snapshot.data.length-1;
                        return Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.135,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.tertiaryColor,
                                borderRadius: BorderRadius.circular(0),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              child: FlutterAnalogClock(
                                dateTime: snapshot.data[indice].fecha_inicio,
                                isLive: false,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.005,
                            ),
                            GestureDetector(
                              onTap: () async {

                                if(snapshot.data[indice].tipo == tipoTarea.COMANDA_INVENTARIO){
                                  await Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) => VistaDeTareaInventarioAlumnoWidget(snapshot.data[indice]),
                                    ),
                                  );

                                }
                                if(snapshot.data[indice].tipo == tipoTarea.COMANDA_MENU){
                                  await Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) => PrimerPlatoWidget(),
                                    ),
                                  );
                                }
                                else{
                                  await Navigator.push(context,
                                    MaterialPageRoute(
                                      builder: (context) => VistaDeTareaUltimaAlumnoWidget(snapshot.data[indice]),
                                    ),
                                  );
                                }


                              },
                              child:
                              Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                height: MediaQuery.of(context).size.height * 0.4,
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
                                    snapshot.data[indice].pictogramas.isNotEmpty && Model.usuario.formatoAyuda == tipoInfo.PICTOGRAMAS ?
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.3,
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data[indice].pictogramas[0],
                                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                                            Center(child: Container(
                                              child: const SpinKitPouringHourGlassRefined(
                                                color: FlutterFlowTheme.laurelGreen,
                                                size: 50.0,
                                              ),
                                            )),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ) : snapshot.data[indice].imagenes.isNotEmpty && Model.usuario.formatoAyuda == tipoInfo.TEXTO ?
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.3,
                                      child: CachedNetworkImage(
                                        imageUrl: snapshot.data[indice].imagenes[0],
                                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                                            Center(child: Container(
                                              child: const SpinKitPouringHourGlassRefined(
                                                color: FlutterFlowTheme.laurelGreen,
                                                size: 50.0,
                                              ),
                                            )),
                                        errorWidget: (context, url, error) => Icon(Icons.error),
                                      ),
                                    ) : snapshot.data[indice].tipo == tipoTarea.COMANDA_INVENTARIO ?
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.3,
                                      child: Image.asset('assets/pictogramas/menuppal/inventario.png')
                                    )
                                    : snapshot.data[indice].tipo == tipoTarea.COMANDA_MENU ?
                                    Container(
                                        height: MediaQuery.of(context).size.height * 0.3,
                                        child: Image.asset('assets/pictogramas/menuppal/menu.png')
                                    ):
                                    Container(
                                      height: MediaQuery.of(context).size.height * 0.3,
                                    ),
                                    if(Model.personalizacion.textoEnPictogramas == 1)
                                      Align(
                                        alignment: AlignmentDirectional(0, 0),
                                        child: Text(
                                          '${snapshot.data[indice].nombre.toUpperCase()}',
                                          style: FlutterFlowTheme.pictogramas,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      else {
                        return Expanded(
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
                                        'No hay tareas'.toUpperCase(),
                                        style: FlutterFlowTheme.tareasPasosEscolar,
                                      ),
                                    ),
                                  ),
                                ]
                            ));

                      }
                  }
                }
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
                          label: 'Anterior p??gina',
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
                          if(indice + 1 <= pagsTotales){
                            setState(() {
                              // ontap of each card, set the defined int to the grid view index
                              indice += 1;
                            });
                          }
                        },
                        child: Semantics(
                            label: 'Siguiente p??gina',
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
