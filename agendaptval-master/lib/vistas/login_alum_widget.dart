import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/usuarios.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:responsive_framework/responsive_value.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:agendaptval/modeloControlador/tipoUsuario.dart';

import 'homepage/alumnos/home_page_alu_widget.dart';
import 'homepage/profesores/home_page_prof_widget.dart';
import 'login_prof_widget.dart';

class LoginAlumWidget extends StatefulWidget {
  LoginAlumWidget({Key key}) : super(key: key);

  @override
  _LoginAlumWidgetState createState() => _LoginAlumWidgetState();
}

class _LoginAlumWidgetState extends StateMVC {
  bool _loadingButton1 = false;
  bool _loadingButton2 = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  var _borderRadius = BorderRadius.circular(20.toDouble());
  List<Usuarios> alumnos;
  var alumnoSeleccionado;
  int _numPagsTotales = 0;
  int _pagActual = 0;
  int _elemsPagFinal = 0;

  bool primeraVez = true;

  _LoginAlumWidgetState(): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  int elementos(){

    return _pagActual != _numPagsTotales ? 4 : _elemsPagFinal;

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.tertiaryColor,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          scrollDirection: Axis.vertical,
          children: [
            Align(
              alignment: const AlignmentDirectional(0, 0),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                child: Text(
                  'Agenda PTVAL San Rafael',
                  style: FlutterFlowTheme.title1,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(25, 30, 25, 0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.44,
                decoration: const BoxDecoration(
                  color: FlutterFlowTheme.tertiaryColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: FutureBuilder(
                          future: _con.getAlumnosLogueados(),
                          builder: (BuildContext context2, AsyncSnapshot<List<Usuarios>> snapshot){
                            if(snapshot.hasData && !(snapshot.data.isEmpty)) {
                              if(primeraVez) {
                                alumnos = snapshot.data;
                                alumnoSeleccionado = List<bool>.filled(snapshot.data.length, false);
                                primeraVez = false;
                                print('Length alumnos ${alumnos.length}');
                                _numPagsTotales = alumnos.length ~/ 4;
                                _elemsPagFinal = alumnos.length % 4;

                                if(alumnos.length % 4 == 0 && alumnos.length > 0){
                                  _numPagsTotales--;
                                  _elemsPagFinal = 4;
                                }

                              }
                              return GridView.builder(
                                  padding: EdgeInsets.fromLTRB(ResponsiveValue(
                                    context,
                                    defaultValue: 0.0,
                                    valueWhen: [
                                      const Condition.largerThan(
                                        name: MOBILE,
                                        value: 155.0,
                                      ),
                                    ],
                                  ).value, 0, ResponsiveValue(
                                    context,
                                    defaultValue: 0.0,
                                    valueWhen: [
                                      const Condition.largerThan(
                                        name: MOBILE,
                                        value: 155.0,
                                      ),
                                    ],
                                  ).value, 0),
                                  shrinkWrap: false,
                                  scrollDirection: Axis.vertical,
                                  itemCount: elementos(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 10,
                                    mainAxisSpacing: 10,
                                    childAspectRatio: 1,
                                  ),
                                  itemBuilder: (BuildContext context, int index) {
                                    return CachedNetworkImage(
                                        imageUrl: alumnos[index+(_pagActual*4)].profilePhoto,
                                        imageBuilder: (context3, imageProvider) => Stack(
                                            children: [
                                              AnimatedContainer(
                                                width: MediaQuery.of(context).size.width,
                                                height: MediaQuery.of(context).size.height * 1,
                                                duration: const Duration(milliseconds: 10),
                                                curve: Curves.fastOutSlowIn,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFFEEEEEE),
                                                    borderRadius: alumnoSeleccionado[index+(_pagActual*4)] ? _borderRadius : null,
                                                    border: Border.all(color: alumnoSeleccionado[index+(_pagActual*4)] ? Colors.greenAccent : Colors.transparent, width: 8),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    )
                                                ),
                                              ),
                                              AnimatedContainer(
                                                width: MediaQuery.of(context).size.width,
                                                height: MediaQuery.of(context).size.height * 0.06,
                                                duration: const Duration(milliseconds: 10),
                                                decoration: BoxDecoration(
                                                  color: Color(0x9F000000),
                                                  borderRadius: alumnoSeleccionado[index+(_pagActual*4)] ? const BorderRadius.only(
                                                    bottomLeft: Radius.circular(0),
                                                    bottomRight: Radius.circular(0),
                                                    topLeft: Radius.circular(20),
                                                    topRight: Radius.circular(20),
                                                  ) : null,
                                                ),
                                               ),
                                              Container(
                                                width: MediaQuery.of(context).size.width,
                                                height: MediaQuery.of(context).size.height * 1,
                                                child: CheckboxListTile(
                                                  value: alumnoSeleccionado[index+(_pagActual*4)],
                                                  activeColor: Colors.cyan,
                                                  onChanged: (bool val) {
                                                    setState(() {
                                                      for (var i = 0; i < alumnoSeleccionado.length; i++){
                                                        if(alumnoSeleccionado[i]){
                                                          alumnoSeleccionado[i] = false;
                                                        }
                                                      }
                                                      alumnoSeleccionado[index+(_pagActual*4)] = val;
                                                    });
                                                  },
                                                  title: Text("${alumnos[index+(_pagActual*4)].nombre}", style: TextStyle(color: Colors.white,fontSize: 17)),
                                                ),
                                              )
                                            ])
                                    );
                                  });
                            }
                            else if(snapshot.hasError){
                              return new Text('Error ${snapshot.error}');
                            }
                            else if(snapshot.hasData && snapshot.data.isEmpty){
                              return const Center(
                                child: Text('Una vez se inicie sesión como alumno, aparecerán aquí sus cuentas', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22), textAlign: TextAlign.center,),
                              );
                            }
                            else{
                              return const SpinKitRotatingCircle(
                                color: Colors.greenAccent,
                                size: 50.0,
                              );
                            }
                          },
                        )
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          // ontap of each card, set the defined int to the grid view index
                            if(_pagActual -1 >= 0)
                              _pagActual -= 1;
                        });
                      },
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(2, 0, 2, 0),
                        child: Semantics(
                          label: 'Anterior página',
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
                          setState(() {
                            // ontap of each card, set the defined int to the grid view index
                            if(_pagActual + 1 <= _numPagsTotales){
                              _pagActual += 1;
                              if(_pagActual == _numPagsTotales){
                                _elemsPagFinal = alumnos.length % 4;
                              }
                            }
                          });
                        },
                        child: Semantics(
                          label: 'Siguiente página',
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
            Row(
              children: [
                Semantics(
                  button: true,
                  enabled: true,
                  label: 'Entrar con el usuario seleccionado',
                  child:GestureDetector(
                  onTap: () async {
                    bool login = false;
                    int posicion = -1;

                    for(int i = 0; i < alumnoSeleccionado.length; i++){
                      if(alumnoSeleccionado[i]) {
                      posicion = i;
                      }
                    }

                    try {
                      if(posicion != -1)
                        login = await _con.iniciarSesion(alumnos[posicion].nombreUsuario);

                    } finally {
                      if(login && Model.inicializado && posicion != -1){
                        if (Model.usuario.getRol() == tipoUsuario.ALUMNO) {
                          Navigator.pushReplacement<void, void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (BuildContext context) => HomePageAluWidget(),
                            ),
                          ).then((_) async {
                            setState(() { });
                          });
                        }
                      }
                    }
                  },
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(2, 2, 0, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.49,
                      height: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                      // Change button text when light changes state.
                      child: Image.asset('assets/pictogramas/misc/entrar.png'),
                    ),
                  ),
                  )
                ),
                Semantics(
                  button: true,
                  enabled: true,
                  label: 'Acceder con claves',
                  child: GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginWidget(),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(2, 2, 0, 0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.49,
                      height: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                      // Change button text when light changes state.
                      child: Image.asset('assets/pictogramas/misc/contrasena.png'),
                    ),
                  ),
                )
                ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
