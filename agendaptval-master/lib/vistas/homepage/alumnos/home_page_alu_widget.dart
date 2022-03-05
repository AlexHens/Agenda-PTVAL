import 'dart:async';

import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/opcionesHomepage.dart';
import 'package:agendaptval/modeloControlador/tipoInfo.dart';
import 'package:agendaptval/vistas/homepage/alumnos/home_page_grid_picto_widget.dart';
import 'package:agendaptval/vistas/homepage/alumnos/home_page_grid_text_widget.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../../../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

import '../../login_alum_widget.dart';

class HomePageAluWidget extends StatefulWidget {
  HomePageAluWidget({Key key}) : super(key: key);

  @override
  _HomePageAluWidgetState createState() => _HomePageAluWidgetState();
}

class _HomePageAluWidgetState extends StateMVC {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  /// Para mostrar la fecha de hoy en la pantalla
  static var dateTime = new DateTime.now();
  static DateFormat dia = DateFormat.EEEE('es_ES');
  static  DateFormat diaSemana = new DateFormat.d('es_ES');
  static DateFormat mes = new DateFormat.MMMM('es_ES');
  static DateFormat hora = new DateFormat.Hm('es_ES');

  var pagActual = 0;
  var totalPaginas = 0;
  var elemsUltPag = 0;
  var elementosRecorridos = 0;
  List<OpcionesHomepage> opciones = [];

  String _timeString = '${dia.format(dateTime)} ${diaSemana.format(dateTime)} de ${mes.format(dateTime)} ${hora.format(dateTime)}';

  _HomePageAluWidgetState(): super(Controller()){
    _con = Controller.con;
    initializeDateFormatting();
    _getTime();

    if(Model.usuario.formatoAyuda == tipoInfo.TEXTO) {
      Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    }
  }
  Controller _con;

  void _getTime() {
    var dateTime = new DateTime.now();
    final String formattedDateTime = '${dia.format(dateTime)} ${diaSemana.format(dateTime)} de ${mes.format(dateTime)} ${hora.format(dateTime)}';
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(Model.personalizacion.homepageElementos > 0){
      opciones = [];
      totalPaginas = (Model.personalizacion.opcionesMenu.length / Model.personalizacion.homepageElementos).toInt();

      if(Model.personalizacion.opcionesMenu.length % Model.personalizacion.homepageElementos != 0){
        totalPaginas++;
        elemsUltPag = Model.personalizacion.opcionesMenu.length % Model.personalizacion.homepageElementos;
      }

      totalPaginas--;

      for (int i = 0; i < Model.personalizacion.homepageElementos && i+pagActual*Model.personalizacion.homepageElementos != Model.personalizacion.opcionesMenu.length; i++) {
        opciones.add(Model.personalizacion.opcionesMenu[i+pagActual*Model.personalizacion.homepageElementos]);
        elementosRecorridos++;
      }
    }
    else{
      for(int i = 0; i < Model.personalizacion.opcionesMenu.length; i++){
        opciones.add(Model.personalizacion.opcionesMenu[i]);
      }
    }
    /// TEXTO
      return WillPopScope(
          onWillPop: () async => false,
          child:  Scaffold(
            key: scaffoldKey,
            backgroundColor: FlutterFlowTheme.tertiaryColor,
            body: SafeArea(
              minimum: EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  // RELOJ
                  (Model.personalizacion.homepageReloj == 1) ?
                    Container(
                    height: Model.usuario.formatoAyuda == tipoInfo.PICTOGRAMAS ? ResponsiveValue(
                      context,
                      defaultValue: 155.0,
                      valueWhen: [
                        const Condition.smallerThan(
                          name: MOBILE,
                          value: 115.0,
                        ),
                        const Condition.largerThan(
                          name: MOBILE,
                          value: 140.0,
                        )
                      ],
                    ).value : 50.0,
                    decoration: const BoxDecoration(
                      color: FlutterFlowTheme.tertiaryColor,
                    ),
                    child: Model.usuario.formatoAyuda == tipoInfo.TEXTO ? Text(
                      _timeString,
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.title1,
                    ) :
                    Container(
                      height: ResponsiveValue(
                        context,
                        defaultValue: 138.0,
                        valueWhen: [
                          const Condition.smallerThan(
                            name: MOBILE,
                            value: 115.0,
                          ),
                          const Condition.largerThan(
                            name: MOBILE,
                            value: 140.0,
                          )
                        ],
                      ).value,
                      decoration: const BoxDecoration(
                        color: FlutterFlowTheme.tertiaryColor,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          _con.fechaPictograma(context),
                          Text(
                            '${dia.format(dateTime).toUpperCase()}',
                            style: FlutterFlowTheme.pictogramas.override(
                              fontFamily: 'Escolar',
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: false,
                            ),
                          )
                        ],
                      ),
                    ),
                  ) :
                  Container(
                    height: ResponsiveValue(
                      context,
                      defaultValue: 138.0,
                      valueWhen: [
                        const Condition.smallerThan(
                          name: MOBILE,
                          value: 115.0,
                        ),
                        const Condition.largerThan(
                          name: MOBILE,
                          value: 140.0,
                        )
                      ],
                    ).value,
                  ),
                  Model.usuario.formatoAyuda == tipoInfo.TEXTO ? HomePageGridText(opciones) : HomePageGridPicto(opciones),
                  Container(
                      height: ResponsiveValue(
                        context,
                        defaultValue: 115.0,
                        valueWhen: [
                          const Condition.smallerThan(
                            name: MOBILE,
                            value: 110.0,
                          ),
                          const Condition.largerThan(
                            name: MOBILE,
                            value: 140.0,
                          ),
                          const Condition.largerThan(
                            name: TABLET,
                            value: 250.0,
                          )
                        ],
                      ).value,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if(Model.personalizacion.homepageElementos > 0)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  // ontap of each card, set the defined int to the grid view index
                                  if(pagActual -1 >= 0)
                                    pagActual -= 1;
                                });
                              },
                              child: Semantics(
                                label: pagActual != 0 ? 'Anterior página' : '',
                                child: Container(
                                  height: ResponsiveValue(
                                    context,
                                    defaultValue: 300.0,
                                    valueWhen: [
                                      const Condition.smallerThan(
                                        name: MOBILE,
                                        value: 110.0,
                                      ),
                                      const Condition.largerThan(
                                        name: MOBILE,
                                        value: 140.0,
                                      ),
                                      const Condition.largerThan(
                                        name: TABLET,
                                        value: 250.0,
                                      )
                                    ],
                                  ).value,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.tertiaryColor,
                                    border: Border.all(
                                      color: pagActual != 0 ? Colors.black : Colors.transparent,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: pagActual != 0 ? Colors.black : Colors.transparent,
                                    size: 100,
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          ),
                          Container(
                            height: ResponsiveValue(
                              context,
                              defaultValue: 300.0,
                              valueWhen: [
                                const Condition.smallerThan(
                                  name: MOBILE,
                                  value: 110.0,
                                ),
                                const Condition.largerThan(
                                  name: MOBILE,
                                  value: 140.0,
                                ),
                                const Condition.largerThan(
                                  name: TABLET,
                                  value: 250.0,
                                )
                              ],
                            ).value,
                            decoration: BoxDecoration(
                              color: Color(0xFFEEEEEE),
                              borderRadius: BorderRadius.all(Radius.circular(100))
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () async {
                                await _con.cerrarSesion();
                                await Navigator.pushReplacement<void, void>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginAlumWidget(),
                                  ),
                                );
                              },
                              child: Image.network(
                                '${Model.usuario.profilePhoto}',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                          ),
                          if(Model.personalizacion.homepageElementos > 0 )
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // ontap of each card, set the defined int to the grid view index
                                    if(pagActual + 1 <= totalPaginas){
                                      pagActual += 1;
                                    }
                                  });
                                },
                                child: Semantics(
                                    label: pagActual != totalPaginas ? 'Siguiente página' : '',
                                    child: Container(
                                      height: ResponsiveValue(
                                        context,
                                        defaultValue: 300.0,
                                        valueWhen: [
                                          const Condition.smallerThan(
                                            name: MOBILE,
                                            value: 110.0,
                                          ),
                                          const Condition.largerThan(
                                            name: MOBILE,
                                            value: 140.0,
                                          ),
                                          const Condition.largerThan(
                                            name: TABLET,
                                            value: 250.0,
                                          )
                                        ],
                                      ).value,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.tertiaryColor,
                                        border: Border.all(
                                          color: pagActual != totalPaginas ? Colors.black : Colors.transparent,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.arrow_forward,
                                        color: pagActual != totalPaginas ? Colors.black : Colors.transparent,
                                        size: 100,
                                      ),
                                    )
                                ),
                            ),
                        ],
                      )
                  ),
                ],
              ),
            ),
          )
      );
    }
  }