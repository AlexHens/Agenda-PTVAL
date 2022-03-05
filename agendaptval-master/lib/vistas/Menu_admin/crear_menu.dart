import 'package:agendaptval/flutter_flow/flutter_flow_video_player.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/platos.dart';
import 'package:agendaptval/vistas/tareasAdmin/pictogramas_arasaac.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:io';
import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';
import '../../flutter_flow/flutter_image_add_drag_sort.dart';


class CrearMenuAdminWidget extends StatefulWidget {
  const CrearMenuAdminWidget({Key key}) : super(key: key);

  @override
  _CrearMenuAdminWidgetState createState() => _CrearMenuAdminWidgetState();
}

class _CrearMenuAdminWidgetState extends StateMVC {
  TextEditingController textController1;
  TextEditingController textController2;
  TextEditingController textController3;
  bool _isChecked1 = false;
  bool _isChecked2 = false;
  bool _isChecked3 = false;
  bool _isChecked4 = false;
  bool noTipo = false;
  final ImagePicker _picker = ImagePicker();
  List<ImageDataItem> pictogramaList = [];
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _keyPicto = GlobalKey();


  Platos dropDownValuePlato = Platos(0,"Seleccione un plato primero",null,null);
  String dropDownValuenombre;

  Platos platoSelect;

  Platos dropDownValuePlato2 = Platos(0,"Seleccione un plato segundo",null,null);

  Platos platoSelect2;

  Platos dropDownValuePlato3 = Platos(0,"Seleccione un postre",null,null);

  Platos platoSelect3;


  _CrearMenuAdminWidgetState(): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;
  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController(text: null);
    textController2 = TextEditingController(text: null);
    textController3 = TextEditingController(text: null);
  }


  doAddPictograma(List<ImageDataItem> uploading, onBegin) async {
    File pictograma = await Navigator.push(context,
      MaterialPageRoute(
        builder: (context) => ArasaacWidget(),
      ),
    );
    if (pictograma == null)
      return null;
    if (onBegin != null) await onBegin();
    await sleep(Duration(seconds: 1));
    return ImageDataItem(pictograma.absolute.path, key: DateTime.now().millisecondsSinceEpoch.toString());
  }

  @override
  Widget build(BuildContext context) {
    var imgSize = (MediaQuery.of(context).size.width - 30) / 4.0;
    var videoSize = (MediaQuery.of(context).size.width - 30) / 3.0;
    return Scaffold(
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
          'Nuevo menú',
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
              if(!textController1.text.isEmpty) {

                Results r = await _con.postMenu(textController1.text, platoSelect.idPlato, platoSelect2.idPlato, platoSelect3.idPlato, int.parse(textController3.text));
                print(r.toString());

                await Navigator.pop(context);
              }
              else{
                if(textController1.text.isEmpty) {
                  noTipo = false;
                  scaffoldKey.currentState.showSnackBar(
                      SnackBar(
                        content: new Text(
                            'Error: Debe introducir un nombre'),
                        duration: new Duration(seconds: 7),
                      )
                  );
                  throw 'Debe introducir un nombre';

                }
              }
            },
          ),
        ],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child:
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                          24, 25, 24, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'NOMBRE',
                            style:
                            FlutterFlowTheme.bodyText2.override(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF262D34),
                              fontSize: 14,
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
                          24, 25, 24, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            'CANTIDAD',
                            style:
                            FlutterFlowTheme.bodyText2.override(
                              fontFamily: 'Lexend Deca',
                              color: Color(0xFF262D34),
                              fontSize: 14,
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
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 5, 24, 0),
                        child:
                        FutureBuilder<List<Platos>>(
                            future: _con.getAllPlatosTipo('primero'),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Platos>> snapshot){

                              return snapshot.hasData
                                  ? Container(
                                child: DropdownButton<Platos>(
                                  hint: Text(dropDownValuePlato.nombre ?? 'Seleccione un plato primero'),
                                  items: snapshot.data.map<DropdownMenuItem<Platos>>((item) {
                                    return DropdownMenuItem<Platos>(
                                      value: item,
                                      child: Text(item.nombre),
                                    );
                                  }).toList(),
                                  onChanged: (Platos value) {
                                    platoSelect = value;
                                    print(value.nombre);
                                    setState(() {
                                      dropDownValuePlato = Platos(value.idPlato,value.nombre,value.tipo,value.pictograma);
                                    });
                                  },
                                ),
                              )
                                  : Container(
                                child: Center(
                                  child: Text('Cargando...'),
                                ),
                              );

                            })
                    ),

                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 5, 24, 0),
                        child:
                        FutureBuilder<List<Platos>>(
                            future: _con.getAllPlatosTipo('segundo'),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Platos>> snapshot){

                              return snapshot.hasData
                                  ? Container(
                                child: DropdownButton<Platos>(
                                  hint: Text(dropDownValuePlato2.nombre ?? 'Seleccione un plato segundo'),
                                  items: snapshot.data.map<DropdownMenuItem<Platos>>((item) {
                                    return DropdownMenuItem<Platos>(
                                      value: item,
                                      child: Text(item.nombre),
                                    );
                                  }).toList(),
                                  onChanged: (Platos value) {
                                    platoSelect2 = value;
                                    print(value.nombre);
                                    setState(() {
                                      dropDownValuePlato2 = Platos(value.idPlato,value.nombre,value.tipo,value.pictograma);
                                    });
                                  },
                                ),
                              )
                                  : Container(
                                child: Center(
                                  child: Text('Cargando...'),
                                ),
                              );

                            })
                    ),

                    Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(24, 5, 24, 0),
                        child:
                        FutureBuilder<List<Platos>>(
                            future: _con.getAllPlatosTipo('postre'),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<Platos>> snapshot){

                              return snapshot.hasData
                                  ? Container(
                                child: DropdownButton<Platos>(
                                  hint: Text(dropDownValuePlato3.nombre ?? 'Seleccione un postre'),
                                  items: snapshot.data.map<DropdownMenuItem<Platos>>((item) {
                                    return DropdownMenuItem<Platos>(
                                      value: item,
                                      child: Text(item.nombre),
                                    );
                                  }).toList(),
                                  onChanged: (Platos value) {
                                    platoSelect3 = value;
                                    print(value.nombre);
                                    setState(() {
                                      dropDownValuePlato3 = Platos(value.idPlato,value.nombre,value.tipo,value.pictograma);
                                    });
                                  },
                                ),
                              )
                                  : Container(
                                child: Center(
                                  child: Text('Cargando...'),
                                ),
                              );

                            })
                    ),
                  ],
                ),
              ),
            ],
          )
      ),
    );

  }

}
