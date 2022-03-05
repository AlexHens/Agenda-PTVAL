import 'dart:io';

import 'package:agendaptval/flutter_flow/flutter_image_add_drag_sort.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/tipoInfo.dart';
import 'package:agendaptval/modeloControlador/tipoUsuario.dart';
import 'package:agendaptval/modeloControlador/usuarios.dart';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


class CrearUsuarioWidgetState extends StatefulWidget {

  CrearUsuarioWidgetState();

  @override
  _CrearUsuarioWidgetState createState() =>
      _CrearUsuarioWidgetState();
}

class _CrearUsuarioWidgetState extends StateMVC {

  TextEditingController textController1;
  TextEditingController textController2;
  TextEditingController textController3;
  TextEditingController textController4;
  TextEditingController textController5;
  List<ImageDataItem> imageList = [];
  final GlobalKey<ScaffoldState> _keyImagenes = GlobalKey();
  final ImagePicker _picker = ImagePicker();

  // Initial Selected Value
  String dropdownvalue = "alumno";
  String dropdownvalue2 = "";
  Usuarios dropDownValue3 = Usuarios(0,"Seleccione un profesor",null,null,null,null,null,null,null,null);
  String dropDownValuenombre;

  Usuarios usuarioSelect;


  tipoUsuario tipo;
  tipoInfo info;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

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

  _CrearUsuarioWidgetState(): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {

    textController1 = TextEditingController(text: "");
    textController2 = TextEditingController(text: "");
    textController3 = TextEditingController(text: "");
    textController4 = TextEditingController(text: "");
    textController5 = TextEditingController(text: "");

    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  doAddImageCamera(List<ImageDataItem> uploading, onBegin) async {
    XFile Ximage = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 2048,
      maxHeight: 2048,
      imageQuality: 85,
    );
    File image = File(Ximage.path);
    if (image == null)
      return null;
    if (onBegin != null) await onBegin();
    await sleep(new Duration(seconds: 1));
    return ImageDataItem(image.absolute.path, key: DateTime.now().millisecondsSinceEpoch.toString());
  }


  @override
  Widget build(BuildContext context) {
    var imgSize = (MediaQuery.of(context).size.width - 30) / 4.0;
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
            'Crear Usuario',
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

                await _con.crearUsuario(textController1.text, textController2.text, textController3.text,imageList[0], textController4.text, '', dropdownvalue, dropdownvalue2, dropDownValue3.idUsuario.toString());

                var sbar = SnackBar(
                  //backgroundColor: Colors.red,
                  content: Row(
                      children: <Widget>[
                        Icon(
                          Icons.check_circle_outlined,
                          color: Colors.green,
                          size: 25,
                        ),
                        Padding(padding: EdgeInsets.fromLTRB(0, 0, 15, 0),),
                        Text('Usuario creado',style: TextStyle(fontSize: 18),),
                      ]
                  ),
                  duration: Duration(milliseconds: 2000),
                );

                ScaffoldMessenger.of(context).showSnackBar(sbar);

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
                            24, 20, 24, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              'FOTO DE PERFIL',
                              style:
                              FlutterFlowTheme.bodyText2.override(
                                fontFamily: 'Lexend Deca',
                                color: Color(0xFF262D34),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ImageAddDragContainer(
                        key: _keyImagenes,
                        data: imageList,
                        maxCount: 1,
                        readOnly: false,
                        draggableMode: false,
                        itemSize: Size(imgSize, imgSize),
                        addWidget: Material(
                          color: Colors.transparent,
                          child: Center(
                            child: Ink(
                              decoration: const ShapeDecoration(
                                color: FlutterFlowTheme.laurelGreenDarker,
                                shape: CircleBorder(),
                              ),
                              child: IconButton(
                                icon: Icon(Icons.add, color: Colors.white,),
                              ),
                            ),
                          ),
                        ),
                        onAddImage: (uploading, onBegin) async {
                          return await doAddImageCamera(uploading, onBegin);
                        },
                        onChanged: (items) async {
                          imageList = items;
                        },
                        builderItem: (context, key, url, type) {
                          return Container(
                            color: Colors.white,
                            child: url == null || url.isEmpty ? null : Image.file(File(url)),
                          );
                        },
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
                            'Nombre de Usuario',
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