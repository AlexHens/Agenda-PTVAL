import 'package:agendaptval/flutter_flow/flutter_flow_widgets.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/personalizacion.dart';
import 'package:agendaptval/modeloControlador/tarea.dart';
import 'package:agendaptval/modeloControlador/tipoInfo.dart';
import 'package:agendaptval/modeloControlador/tipoTarea.dart';
import 'package:agendaptval/modeloControlador/tipoUsuario.dart';
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


class EditarUsuarioWidgetState extends StatefulWidget {

  final Usuarios _idUsuario;
  EditarUsuarioWidgetState(this._idUsuario);

  @override
  _EditarUsuarioWidgetState createState() =>
      _EditarUsuarioWidgetState(this._idUsuario);
}

class _EditarUsuarioWidgetState extends StateMVC {

  final Usuarios _idUsuario;
  TextEditingController textController1;
  TextEditingController textController2;
  TextEditingController textController3;
  TextEditingController textController4;
  Usuarios dropDownValue3 = Usuarios(0,"Seleccione un profesor",null,null,null,null,null,null,null,null);
  String dropDownValuenombre;

  Usuarios usuarioSelect;

  // Initial Selected Value
  String dropdownvalue = "rol";
  String dropdownvalue2 = "";

  tipoUsuario tipo;
  tipoInfo info;

  // List of items in our dropdown menu

  var items = [
    'alumno',
    'profesor',
    'admin',
  ];

  var items2 = [
    '',
    'texto',
    'pictogramas',
  ];



  final scaffoldKey = GlobalKey<ScaffoldState>();

  _EditarUsuarioWidgetState(this._idUsuario): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {

    super.initState();

    textController1 = TextEditingController(text: this._idUsuario.nombre);
    textController2 = TextEditingController(text: this._idUsuario.apellidos);
    textController3 = TextEditingController(text: this._idUsuario.nombreUsuario);
    textController4 = TextEditingController(text: this._idUsuario.password);
    tipo = this._idUsuario.getRol();
    info = this._idUsuario.getFormatoAyuda();

    if (tipo == tipoUsuario.ALUMNO){
      dropdownvalue = "alumno";
    }
    else if (tipo == tipoUsuario.PROFESOR){
      dropdownvalue = "profesor";
    }
    else{
      dropdownvalue = "admin";
    }

    if (info == tipoInfo.TEXTO){
      dropdownvalue2 = "texto";
    }else if (info == tipoInfo.PICTOGRAMAS){
      dropdownvalue2 = "pictogramas";
    }else{
      dropdownvalue2 = "";
    }
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
            'Editar Usuario',
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
                await _con.setUsuario(this._idUsuario.idUsuario, textController1.text, textController2.text, textController3.text, dropdownvalue, dropdownvalue2,dropDownValue3.idUsuario.toString());
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

                child: ListView(
                  children: [

                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          10, 0, 10, 0),
                      child: CachedNetworkImage(
                        imageUrl: this._idUsuario.profilePhoto,
                        progressIndicatorBuilder: (context, url, downloadProgress) =>
                            CircularProgressIndicator(value: downloadProgress.progress),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          27, 25, 24, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Nombre',
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
                          24, 15, 24, 0),
                      child: TextField(
                        controller: textController1,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),


                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          27, 25, 24, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Apellidos',
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
                          24, 15, 24, 0),
                      child: TextField(
                        controller: textController2,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          27, 25, 24, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Nombre de usuario',
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
                          24, 15, 24, 0),
                      child: TextField(
                        controller: textController3,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          27, 25, 24, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Contraseña',
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
                          24, 15, 24, 0),
                      child: TextField(
                        controller: textController4,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          27, 25, 24, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Rol',
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

                    if(dropdownvalue == 'alumno')
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            27, 25, 24, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'Profesor asignado',
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
                    if(dropdownvalue == 'alumno')
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            30, 0, 10, 0),
                        child:
                        FutureBuilder<List<Usuarios>>(
                            future: _con.getProfesores(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Usuarios>> snapshot){
                              return snapshot.hasData
                                  ? Container(
                                child: DropdownButton<Usuarios>(
                                  hint: Text(dropDownValue3.nombre ?? 'Seleccione un alumno'),
                                  items: snapshot.data.map<DropdownMenuItem<Usuarios>>((item) {
                                    return DropdownMenuItem<Usuarios>(
                                      value: item,
                                      child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional.fromSTEB(15, 0, 20, 0),
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                clipBehavior: Clip.antiAlias,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Image.network(
                                                  item.profilePhoto,
                                                ),
                                              ),
                                            ),
                                            Text((item.nombre + " " + item.apellidos))
                                          ]),
                                    );
                                  }).toList(),
                                  onChanged: (Usuarios value) {
                                    usuarioSelect = value;
                                    print(value.apellidos);
                                    setState(() {
                                      dropDownValue3 = Usuarios(value.idUsuario,value.nombre,null,null,null,null,null,null,null,null);
                                      dropDownValuenombre = dropDownValue3.nombre;

                                    });
                                  },
                                ),
                              )
                                  : Container(
                                child: Center(
                                  child: Text('Cargando...'),
                                ),
                              );

                            }),),

                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          27, 25, 24, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'Forma de mostrar la información',
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

                  ],
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }

}