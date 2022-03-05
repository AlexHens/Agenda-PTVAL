import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/vistas/homepage/alumnos/home_page_alu_widget.dart';

import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'homepage/profesores/home_page_prof_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:agendaptval/modeloControlador/tipoUsuario.dart';

import 'login_alum_widget.dart';

class LoginWidget extends StatefulWidget {
  LoginWidget({Key key}) : super(key: key);

  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends StateMVC {
  TextEditingController textController1;
  TextEditingController textController2;
  bool passwordVisibility;
  bool _loadingButton = false;
  bool _loadingButton2 = false;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool loginIncorrecto = false;

  _LoginWidgetState(): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;


  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    passwordVisibility = false;
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
              alignment: AlignmentDirectional(0, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 100, 0, 0),
                child: Text(
                  'Agenda PTVAL San Rafael',
                  style: FlutterFlowTheme.title1,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                child: Text(
                  'Acceso Restringido',
                  style: FlutterFlowTheme.subtitle1,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(25, 100, 25, 0),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.tertiaryColor,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Text(
                        'Usuario',
                        style: FlutterFlowTheme.title3,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: TextFormField(
                        controller: textController1,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Introduzca Aquí Su Nombre de Usuario',
                          hintStyle: FlutterFlowTheme.bodyText2,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          contentPadding:
                          EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
                        ),
                        style: FlutterFlowTheme.bodyText2,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(-1, 0),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                        child: Text(
                          'Contraseña',
                          style: FlutterFlowTheme.title3,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                      child: TextFormField(
                        controller: textController2,
                        obscureText: !passwordVisibility,
                        decoration: InputDecoration(
                          hintText: 'Introduzca Aquí Su Contraseña',
                          hintStyle: FlutterFlowTheme.bodyText2,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          contentPadding:
                          EdgeInsetsDirectional.fromSTEB(18, 0, 0, 0),
                          suffixIcon: InkWell(
                            onTap: () => setState(
                                  () => passwordVisibility = !passwordVisibility,
                            ),
                            child: Icon(
                              passwordVisibility
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: Color(0xFF757575),
                              size: 22,
                            ),
                          ),
                        ),
                        style: FlutterFlowTheme.bodyText2,
                        textAlign: TextAlign.start,
                      ),
                    )
                  ],
                ),
              ),
            ),
            if(loginIncorrecto)
              Text(
                'Su nombre de usuario y contraseña\n no son correctos',
                textAlign: TextAlign.center,
                style: FlutterFlowTheme.bodyText1.override(
                  fontFamily: 'Roboto',
                  color: FlutterFlowTheme.secondaryColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(50, 50, 50, 0),
              child: FFButtonWidget(
                onPressed: () async {
                  setState(() => _loadingButton = true);
                  try {
                    bool login = await _con.iniciarSesion(textController1.text, textController2.text);
                    if(login){
                      if (Model.usuario.getRol() == tipoUsuario.ALUMNO) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePageAluWidget(),
                          ),
                        );
                      }
                      else if(Model.usuario.getRol() == tipoUsuario.PROFESOR || Model.usuario.getRol() == tipoUsuario.ADMINISTRADOR) {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePageProfWidget(),
                          ),
                        );
                      }
                    }
                    else{
                      loginIncorrecto = true;
                    }
                  } finally {
                    setState(() => _loadingButton = false);
                  }
                },
                text: 'Entrar',
                options: FFButtonOptions(
                  width: 250,
                  height: 60,
                  color: Color(0xFF3D3A3A),
                  textStyle: FlutterFlowTheme.title3.override(
                    fontFamily: 'Roboto',
                    color: FlutterFlowTheme.tertiaryColor,
                  ),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: 12,
                ),
                loading: _loadingButton,
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(50, 25, 50, 0),
              child: FFButtonWidget(
                onPressed: () async {
                  setState(() => _loadingButton2 = true);
                  try {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginAlumWidget(),
                      ),
                    );
                  } finally {
                    setState(() => _loadingButton2 = false);
                  }
                },
                text: 'Ya he iniciado sesión',
                icon: Icon(
                  Icons.face,
                  size: 15,
                ),
                options: FFButtonOptions(
                  width: 150,
                  height: 40,
                  color: Color(0xFF3D3A3A),
                  textStyle: FlutterFlowTheme.title3.override(
                    fontFamily: 'Roboto',
                    color: FlutterFlowTheme.tertiaryColor,
                  ),
                  borderSide: BorderSide(
                    color: Colors.transparent,
                    width: 1,
                  ),
                  borderRadius: 12,
                ),
                loading: _loadingButton2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}