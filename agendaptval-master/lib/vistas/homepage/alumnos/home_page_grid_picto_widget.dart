import 'package:agendaptval/flutter_flow/flutter_flow_theme.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/opcionesHomepage.dart';
import 'package:agendaptval/vistas/chats/conversaciones.dart';
import 'package:agendaptval/vistas/historial/lista_tareas_completadas.dart';
import 'package:agendaptval/vistas/tareasAlumno/lista_tarea_hora_alumno.dart';
import 'package:agendaptval/vistas/unimplemented_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePageGridPicto extends StatelessWidget {
  final List<OpcionesHomepage> opciones;

  HomePageGridPicto(List<OpcionesHomepage> this.opciones, {Key key}) : super(key: key);

  final List<dynamic> paginas = [ListaTareaHoraAlumnoWidget(), ListaConversacionesWidget(), Unimplemented(), ListaTareasCompletadasWidget(),]; // Tareas, chats, notificaciones, historial

  textoAPagina(String texto){
    switch(texto.toUpperCase()){
      case ('TAREAS'):
        return paginas[0];
        break;
      case('CHATS'):
        return paginas[1];
        break;
      case('NOTIFICACIONES'):
        return paginas[2];
        break;
      case('HISTORIAL'):
        return paginas[3];
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var sizeGrid = MediaQuery.of(context).size.width * 0.48;
    var sizePictograma = MediaQuery.of(context).size.width * 0.30;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        if(opciones.length >= 3)
          Container(
              height: MediaQuery.of(context).size.height * 0.29,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.tertiaryColor,
              ),
              child:
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  //Padding
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => textoAPagina(opciones[0].nombre),
                        ),
                      );
                    },
                    child: Container(
                        width: sizeGrid,
                        height: sizeGrid,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.tertiaryColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 3,
                          ),
                        ),
                        child:
                        //DEFAULT
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: Image.network(
                                '${opciones[0].enlacePicto}',
                                width: sizePictograma,
                                height: sizePictograma,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if(Model.personalizacion.textoEnPictogramas == 1)
                              Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Text(
                                  '${opciones[0].nombre}',
                                  style: FlutterFlowTheme.pictogramas,
                                ),
                              )
                          ],
                        )
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 10, 0)
                  ),
                  GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => textoAPagina(opciones[1].nombre),
                        ),
                      );
                    },
                    child: Container(
                        width: sizeGrid,
                        height: sizeGrid,
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.tertiaryColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 3,
                          ),
                        ),
                        child:
                        //DEFAULT
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                              child: Image.network(
                                '${opciones[1].enlacePicto}',
                                width: sizePictograma,
                                height: sizePictograma,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if(Model.personalizacion.textoEnPictogramas == 1)
                              Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Text(
                                  '${opciones[1].nombre}',
                                  style: FlutterFlowTheme.pictogramas,
                                ),
                              )
                          ],
                        )
                    ),
                  ),
                ],
              )
          ),
        if(opciones.length == 1)
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => textoAPagina(opciones[0].nombre),
                ),
              );
            },
            child:
            Container(
                width: sizeGrid * 2,
                height: sizeGrid * 2,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.tertiaryColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 3,
                  ),
                ),
                child:
                //DEFAULT
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: Image.network(
                        '${opciones[0].enlacePicto}',
                        width: sizePictograma * 2.5,
                        height: sizePictograma * 2.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if(Model.personalizacion.textoEnPictogramas == 1)
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Text(
                          '${opciones[0].nombre}',
                          style: FlutterFlowTheme.pictogramas,
                        ),
                      ),
                  ],
                )
            ),
          ),
        if(opciones.length == 2)
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => textoAPagina(opciones[0].nombre),
                ),
              );
            },
            child:
            Container(
                width: sizeGrid * 2,
                height: sizeGrid,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.tertiaryColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 3,
                  ),
                ),
                child:
                //DEFAULT
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                      child: Image.network(
                        '${opciones[0].enlacePicto}',
                        width: sizePictograma,
                        height: sizePictograma,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if(Model.personalizacion.textoEnPictogramas == 1)
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Text(
                          '${opciones[0].nombre}',
                          style: FlutterFlowTheme.pictogramas,
                        ),
                      )
                  ],
                )
            ),
          ),
        Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        ),
        if(opciones.length == 4)
          Container(
            height: MediaQuery.of(context).size.height * 0.29,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.tertiaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                //Padding
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => textoAPagina(opciones[2].nombre),
                      ),
                    );
                  },
                  child:
                  Container(
                      width: sizeGrid,
                      height: sizeGrid,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.tertiaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 3,
                        ),
                      ),
                      child:
                      //DEFAULT
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: Image.network(
                              '${opciones[2].enlacePicto}',
                              width: sizePictograma,
                              height: sizePictograma,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if(Model.personalizacion.textoEnPictogramas == 1)
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Text(
                                '${opciones[2].nombre}',
                                style: FlutterFlowTheme.pictogramas,
                              ),
                            )
                        ],
                      )
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 0)
                ),
                GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => textoAPagina(opciones[3].nombre),
                      ),
                    );
                  },
                  child:
                  Container(
                      width: sizeGrid,
                      height: sizeGrid,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.tertiaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 3,
                        ),
                      ),
                      child:
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: Image.network(
                              '${opciones[3].enlacePicto}',
                              width: sizePictograma,
                              height: sizePictograma,
                              fit: BoxFit.cover,
                            ),
                          ),
                          if(Model.personalizacion.textoEnPictogramas == 1)
                            Align(
                              alignment: AlignmentDirectional(0, 0),
                              child: Text(
                                '${opciones[3].nombre}',
                                style: FlutterFlowTheme.pictogramas,
                              ),
                            )
                        ],
                      )
                  ),
                ),
              ],
            ),
          ),
        if(opciones.length == 2 || opciones.length == 3)
          Container(
            height: MediaQuery.of(context).size.height * 0.29,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.tertiaryColor,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                //Padding
                Container(
                    width: sizeGrid*2,
                    height: sizeGrid,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.tertiaryColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        width: 3,
                      ),
                    ),
                    child:
                    //DEFAULT
                    opciones.length == 2 ?
                    GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => textoAPagina(opciones[1].nombre),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                              child: Image.network(
                                '${opciones[1].enlacePicto}',
                                width: sizePictograma,
                                height: sizePictograma,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if(Model.personalizacion.textoEnPictogramas == 1)
                              Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Text(
                                  '${opciones[1].nombre}',
                                  style: FlutterFlowTheme.pictogramas,
                                ),
                              )
                          ],
                        ) ):
                    GestureDetector(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => textoAPagina(opciones[2].nombre),
                            ),
                          );
                        },
                        child:
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 15, 0),
                              child: Image.network(
                                '${opciones[2].enlacePicto}',
                                width: sizePictograma,
                                height: sizePictograma,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if(Model.personalizacion.textoEnPictogramas == 1)
                              Align(
                                alignment: AlignmentDirectional(0, 0),
                                child: Text(
                                  '${opciones[2].nombre}',
                                  style: FlutterFlowTheme.pictogramas,
                                ),
                              )
                          ],
                        ))

                ),
              ],
            ),
          ),
      ],
    );
  }

}