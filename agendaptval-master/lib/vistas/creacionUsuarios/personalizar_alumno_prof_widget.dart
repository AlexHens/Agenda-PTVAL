import 'package:agendaptval/flutter_flow/flutter_flow_widgets.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/personalizacion.dart';
import 'package:agendaptval/modeloControlador/tarea.dart';
import 'package:agendaptval/modeloControlador/tipoTarea.dart';
import 'package:agendaptval/modeloControlador/usuarios.dart';
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


class PersonalizarAlumnoWidgetState extends StatefulWidget {

  final Usuarios _idUsuario;
  PersonalizarAlumnoWidgetState(this._idUsuario);

  @override
  _PersonalizarAlumnoWidgetState createState() =>
      _PersonalizarAlumnoWidgetState(this._idUsuario);
}

class _PersonalizarAlumnoWidgetState extends StateMVC {

  bool _isChecked1 = true;
  bool _isChecked2 = true;
  final Usuarios _idUsuario;
  bool primeraVez = true;


  // Initial Selected Value
  String dropdownvalue = 'tareas,chats,notificaciones,historial,';
  String dropdownvalue2 = 'Normal';
  String dropdownvalue3 = '4';

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  // List of items in our dropdown menu
  var items = [
    'tareas,chats,notificaciones,historial,',
    'tareas,notificaciones,chats,historial,',
    'tareas,historial,chats,notificaciones,',
    'chats,tareas,historial,notificaciones,',
  ];

  var items2 = [
    'Pequeña',
    'Normal',
    'Grande',
  ];

  var items3 = [
    '1',
    '2',
    '3',
    '4',
  ];


  final scaffoldKey = GlobalKey<ScaffoldState>();

  _PersonalizarAlumnoWidgetState(this._idUsuario): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {

    super.initState();


  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var imgSize = (MediaQuery.of(context).size.width - 30) / 4.0;
    var videoSize = (MediaQuery.of(context).size.width - 30) / 3.0;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
              Icons.close,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () async {
              await Navigator.pop(context);
            },
          ),
          title: Text(
            'Personalizar Alumno',
            style: FlutterFlowTheme.title1,
          ),
          actions: [
            FlutterFlowIconButton(
              borderColor: Colors.transparent,
              borderRadius: 30,
              borderWidth: 1,
              buttonSize: 60,
              icon: Icon(
                Icons.check,
                color: Colors.black,
                size: 30,
              ),
              onPressed: () async {

                int reloj, text_pict, tam_text, elementos;

                if (_isChecked1){
                  reloj = 1;
                }
                else{
                  reloj = 2;
                }

                if (_isChecked2){
                  text_pict = 1;
                }
                else{
                  text_pict = 0;
                }

                if (dropdownvalue2 == "Pequeña" ){
                  tam_text = -2;
                }
                else if (dropdownvalue2 == "Normal" ){
                  tam_text = 0;
                }
                else{
                  tam_text = 2;
                }

                if (dropdownvalue3 == "1" ){
                  elementos = 1;
                }
                else if (dropdownvalue3 == "2" ){
                  elementos = 2;
                }
                else if (dropdownvalue3 == "3" ){
                  elementos = 3;
                }
                else{
                  elementos = 4;
                }

                await _con.setPersonalizacion(this._idUsuario.idUsuario, reloj, tam_text, dropdownvalue, text_pict, elementos);
                await Navigator.pop(context);

              },
            ),
          ],
          centerTitle: true,
          elevation: 4,
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [

              Expanded(

              child: FutureBuilder<Personalizacion>(
                  future: _con.getPersonalizacion(_idUsuario.idUsuario),
                  builder: (BuildContext context,
                    AsyncSnapshot<Personalizacion> snapshot){

                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: Container(
                            child: const SpinKitRotatingCircle(
                              color: FlutterFlowTheme.laurelGreen,
                              size: 50.0,
                            ),
                          ));
                          default:
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {

                                if (primeraVez){



                                  _isChecked1 = snapshot.data.homepageReloj == 1 ? true : false;
                                  _isChecked2 = snapshot.data.textoEnPictogramas == 1 ? true : false;

                                  String opciones = "";

                                  for (int i = 0; i < snapshot.data.opcionesMenu.length; i++){
                                    opciones = opciones + snapshot.data.opcionesMenu[i].nombre + ",";
                                  }

                                  if (snapshot.data.tamTexto == -2){
                                    dropdownvalue2 = "Pequeña";
                                  }
                                  else if (snapshot.data.tamTexto == 0){
                                    dropdownvalue2 = "Normal";
                                  }
                                  else{
                                    dropdownvalue2 = "Grande";
                                  }

                                  dropdownvalue3 = snapshot.data.homepageElementos.toString();

                                  print(snapshot.data.homepageElementos.toString());

                                  primeraVez = false;

                                }


                        return ListView(
                          children: [

                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  10, 0, 10, 0),
                              child: CachedNetworkImage(
                                imageUrl: this._idUsuario.profilePhoto,
                                progressIndicatorBuilder: (context, url,
                                    downloadProgress) =>
                                    CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),

                            Padding(

                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 10, 0),
                                child: Container(
                                  child: CheckboxListTile(
                                    title: Text(
                                      'Reloj en la Homepage',
                                      style:
                                      FlutterFlowTheme.bodyText2.override(
                                        fontFamily: 'Lexend Deca',
                                        color: Color(0xFF262D34),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    activeColor:
                                    FlutterFlowTheme.laurelGreenDarker,
                                    selected: _isChecked1,
                                    value: _isChecked1,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _isChecked1 = value;
                                      });
                                    },
                                  ),
                                )
                            ),

                            Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    10, 0, 10, 0),
                                child: Container(
                                  child: CheckboxListTile(
                                    title: Text(
                                      'Poner texto en pictogramas',
                                      style:
                                      FlutterFlowTheme.bodyText2.override(
                                        fontFamily: 'Lexend Deca',
                                        color: Color(0xFF262D34),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    activeColor:
                                    FlutterFlowTheme.laurelGreenDarker,
                                    selected: _isChecked2,
                                    value: _isChecked2,
                                    onChanged: (bool value) {
                                      setState(() {
                                        _isChecked2 = value;
                                      });
                                    },
                                  ),
                                )
                            ),

                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  27, 25, 24, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Opciones en la Homepage',
                                    style:
                                    FlutterFlowTheme.bodyText2.override(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF262D34),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Padding(

                              padding: EdgeInsetsDirectional.fromSTEB(
                                  30, 0, 10, 0),

                              child: DropdownButton(

                                // Initial Value
                                value: dropdownvalue,

                                borderRadius: BorderRadius.circular(5),

                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),

                                isExpanded: false,

                                dropdownColor: FlutterFlowTheme.laurelGreen,

                                // Array list of items
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownvalue = newValue;
                                  });
                                },
                              ),

                            ),

                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  27, 25, 24, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Tamaño de letra',
                                    style:
                                    FlutterFlowTheme.bodyText2.override(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF262D34),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Padding(

                              padding: EdgeInsetsDirectional.fromSTEB(
                                  30, 0, 10, 0),

                              child: DropdownButton(

                                // Initial Value
                                value: dropdownvalue2,

                                borderRadius: BorderRadius.circular(5),

                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),

                                isExpanded: false,

                                dropdownColor: FlutterFlowTheme.laurelGreen,

                                // Array list of items
                                items: items2.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownvalue2 = newValue;
                                  });
                                },
                              ),

                            ),

                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  24, 25, 24, 0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    'Nº de elementos en el Homepage',
                                    style:
                                    FlutterFlowTheme.bodyText2.override(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF262D34),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),

                            Padding(

                              padding: EdgeInsetsDirectional.fromSTEB(
                                  30, 0, 10, 0),

                              child: DropdownButton(

                                // Initial Value
                                value: dropdownvalue3,

                                borderRadius: BorderRadius.circular(5),

                                // Down Arrow Icon
                                icon: const Icon(Icons.keyboard_arrow_down),

                                isExpanded: false,

                                dropdownColor: FlutterFlowTheme.laurelGreen,

                                // Array list of items
                                items: items3.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String newValue) {
                                  setState(() {
                                    dropdownvalue3 = newValue;
                                  });
                                },
                              ),

                            ),

                          ],
                        );
                    }
                    }


                })



              ),
            ],
          ),

        ),
      ),
    );
  }

}