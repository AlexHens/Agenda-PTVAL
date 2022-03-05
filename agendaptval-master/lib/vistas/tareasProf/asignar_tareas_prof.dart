

import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/tarea.dart';
import 'package:agendaptval/modeloControlador/usuarios.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mysql1/mysql1.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../../flutter_flow/flutter_flow_icon_button.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';
import '../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'lista_tareas_prof_pendientes_widget.dart';


class AsignarTareaProfWidget extends StatefulWidget {
  const AsignarTareaProfWidget({Key key}) : super(key: key);

  @override
  _AsignarTareaProfWidgetState createState() => _AsignarTareaProfWidgetState();
}

class _AsignarTareaProfWidgetState extends StateMVC {
  TextEditingController textController1;
  TextEditingController textController2;
  TextEditingController textController3;
  bool _loadingButton1 = false;
  bool _loadingButton2 = false;
  bool _loadingButton3 = false;
  Usuarios dropDownValue = Usuarios(0,"Seleccione un alumno",null,null,null,null,null,null,null,null);
  Tarea dropDownValueTarea = Tarea(0,"Seleccione una tarea",null,null,null,null,null,null,null,null,null,null,null,null,null,null);
  String dropDownValuenombre;

  Usuarios usuarioSelect;
  Tarea tareaSelect;

  DateTime fecha_inicio;
  DateTime fecha_fin;
  int duracion;
  TimeOfDay selectedTime;
  String _hour, _minute, _time;
  TextEditingController _timeController = TextEditingController();
  String _setTime;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _AsignarTareaProfWidgetState(): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;
  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController(text: '');
    textController2 = TextEditingController(text: '');
    textController3 = TextEditingController(text: '');
    _timeController.text = '${DateTime.now().hour}:${DateTime.now().minute}';
    selectedTime = TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
    _hour = DateTime.now().hour.toString();
    _minute = DateTime.now().minute.toString();

  }

  listaNombreAlumnos(List<Usuarios> usuarios){
    List<String> nombreAlumnos  = [];
    for(int i = 0; i < usuarios.length; i++){
      nombreAlumnos.add(usuarios[i].nombre);
    }
    return nombreAlumnos;
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
      });
    }
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {

    setState(() {
      if (args.value is PickerDateRange) {
        if(DateFormat('dd/MM/yyyy').format(args.value.startDate).toString() == DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate).toString()) {
          fecha_inicio = args.value.startDate;
          fecha_fin = args.value.startDate;
        }
        else{
          fecha_inicio = args.value.startDate;
          fecha_fin = args.value.endDate;
          duracion = fecha_fin.difference(fecha_inicio).inDays;
          print(duracion);
        }
      }

    });
  }

  @override
  Widget build(BuildContext context) {

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
          'Asignar tarea',
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
              print(tareaSelect.idTarea);
              print(usuarioSelect.idUsuario);
              Results r = await _con.asignarTarea(tareaSelect.idTarea, usuarioSelect.idUsuario,
                  DateTime.utc(fecha_inicio.year, fecha_inicio.month, fecha_inicio.day, int.parse(_hour), int.parse(_minute)),
                  DateTime.utc(fecha_fin.year, fecha_fin.month, fecha_fin.day));
              print(r.toString());
              await Navigator.pop(context);
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
              child: ListView(children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 25, 24, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'ALUMNO',
                        style: FlutterFlowTheme.bodyText2.override(
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
                    padding: EdgeInsetsDirectional.fromSTEB(24, 5, 24, 0),
                    child:
                    FutureBuilder<List<Usuarios>>(
                        future: _con.getAlumnosTutelados(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Usuarios>> snapshot){

                          return snapshot.hasData
                              ? Container(
                            child: DropdownButton<Usuarios>(
                              hint: Text(dropDownValue.nombre ?? 'Seleccione un alumno'),
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
                                  dropDownValue = Usuarios(value.idUsuario,value.nombre,null,null,null,null,null,null,null,null);
                                  dropDownValuenombre = dropDownValue.nombre;

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
                  padding: EdgeInsetsDirectional.fromSTEB(24, 25, 24, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'TAREA',
                        style: FlutterFlowTheme.bodyText2.override(
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
                    padding: EdgeInsetsDirectional.fromSTEB(24, 5, 24, 0),
                    child:
                    FutureBuilder<List<Tarea>>(
                        future: _con.getAllTareas(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<Tarea>> snapshot){

                          return snapshot.hasData
                              ? Container(
                            child: DropdownButton<Tarea>(
                              hint: Text(dropDownValueTarea.nombre ?? 'Seleccione una tarea'),
                              items: snapshot.data.map<DropdownMenuItem<Tarea>>((item) {
                                return DropdownMenuItem<Tarea>(
                                  value: item,
                                  child: Text(item.nombre),
                                );
                              }).toList(),
                              onChanged: (Tarea value) {
                                tareaSelect = value;
                                print(value.nombre);
                                setState(() {
                                  dropDownValueTarea = Tarea(value.idTarea,value.nombre,value.completada,value.descripcion,null,null,null,null,null,null,null,null,null,null,null,null);
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
                  padding: EdgeInsetsDirectional.fromSTEB(24, 25, 24, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'DURACIÓN',
                        style: FlutterFlowTheme.bodyText2.override(
                          fontFamily: 'Lexend Deca',
                          color: Color(0xFF262D34),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SfDateRangePicker(
                    onSelectionChanged: _onSelectionChanged,
                    selectionMode: DateRangePickerSelectionMode.range,
                    view: DateRangePickerView.month,
                    monthViewSettings: DateRangePickerMonthViewSettings(firstDayOfWeek: 1),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24, 25, 24, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'HORA DE COMIENZO',
                        style: FlutterFlowTheme.bodyText2.override(
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
                  child: InkWell(
                    onTap: () {
                      _selectTime(context);
                    },
                    child:TextFormField(
                      style: TextStyle(fontSize: 40),
                      textAlign: TextAlign.center,
                      onSaved: (String val) {
                        _setTime = val;
                      },
                      enabled: false,
                      keyboardType: TextInputType.text,
                      controller: _timeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }



}
