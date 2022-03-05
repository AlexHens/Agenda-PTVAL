import 'package:agendaptval/flutter_flow/flutter_flow_theme.dart';
import 'package:agendaptval/flutter_flow/flutter_flow_widgets.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:io';

import '../../login_prof_widget.dart';

class PerfilProf extends StatefulWidget {
  PerfilProf({Key key}) : super(key: key);

  @override
  _PerfilProfState createState() => _PerfilProfState();

}

class _PerfilProfState extends StateMVC{

  bool _loadingButton1 = false;
  final TextEditingController textController1 = TextEditingController();
  final TextEditingController textController2 = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile fotoPerfil;


  _PerfilProfState(): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {
    super.initState();
  }

  Future<String> _imgFromCamera() async {
    XFile image = await _picker.pickImage(
        source: ImageSource.camera, imageQuality: 100
    );
    setState(() {
      if(image != null) {
        _con.subirFotoPerfil(File(image.path), Model.usuario.idUsuario.toString());
      }
      fotoPerfil = image;
    });
  }

  Future<void> _imgFromGallery() async {
    XFile image = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 100
    );
    setState(() {
      if (image != null) {
        _con.subirFotoPerfil(
            File(image.path), Model.usuario.idUsuario.toString());
      }
      fotoPerfil = image;
    });
  }

  void _showPicker(context) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Galería de Fotos'),
                      onTap: () async {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Cámara'),
                    onTap: () async {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      scrollDirection: Axis.vertical,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                  border: Border.all(width: 2),
                ),
                child:
                fotoPerfil == null ? CachedNetworkImage(
                  imageUrl: "${Model.usuario.profilePhoto}",
                  fit: BoxFit.cover,
                  width: 100,
                  height: 100,
                  placeholder: (context, url) => SpinKitRotatingCircle(
                    color: FlutterFlowTheme.laurelGreen,
                    size: 50.0,
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ) : Image.file(
                    File(fotoPerfil.path),
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 80),
              child: Container(
                width: 150,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFEEEEEE),
                ),
                child: FFButtonWidget(
                  onPressed: () async {
                    _showPicker(context);
                  },
                  text: 'Cambiar Foto',
                  options: FFButtonOptions(
                    width: 130,
                    height: 40,
                    color: FlutterFlowTheme.tertiaryColor,
                    textStyle: FlutterFlowTheme.subtitle2.override(
                      fontFamily: 'Roboto',
                      color: Colors.black,
                    ),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1,
                    ),
                    borderRadius: 12,
                  ),
                ),
              ),
            )
          ],
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 20, 0, 0),
          child: Text(
            'Nombre completo',
            style: FlutterFlowTheme.title1,
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
          child: Text(
            '${Model.usuario.nombre} ${Model.usuario.apellidos}',
            style: FlutterFlowTheme.bodyText1,
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 10, 0, 0),
          child: Text(
            'Usuario',
            style: FlutterFlowTheme.title1,
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
          child: Text(
            Model.usuario.nombreUsuario,
            style: FlutterFlowTheme.bodyText1,
          ),
        ),

        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(15, 25, 15, 15),
          child: Container(
            width: 20,
            height: 375,
            decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                      child: Text(
                        'Cambiar Contraseña',
                        style: FlutterFlowTheme.title1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 20, 0, 0),
                    child: Text(
                      'Contraseña Actual',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.title2,
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Container(
                      width: 350,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFEEEEEE),
                      ),
                      child: TextFormField(
                        controller: textController1,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Introduzca su contraseña actual',
                          hintStyle: FlutterFlowTheme.bodyText2,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        style: FlutterFlowTheme.bodyText2,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(15, 20, 0, 0),
                    child: Text(
                      'Contraseña Nueva',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.title2,
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Container(
                      width: 350,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Color(0xFFEEEEEE),
                      ),
                      child: TextFormField(
                        controller: textController2,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Introduzca su nueva contraseña',
                          hintStyle: FlutterFlowTheme.bodyText2,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        style: FlutterFlowTheme.bodyText2,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                    ),
                  ),
                  Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                      child: Container(
                        width: 200,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Color(0xFFEEEEEE),
                        ),
                        child: FFButtonWidget(
                          onPressed: () async {
                            var snackBar;
                            bool puedeCambiarla = textController1.text == Model.usuario.password;
                            Results res;
                            setState(() => _loadingButton1 = true);
                            try{
                              //await Future.delayed(const Duration(seconds: 1));
                              if(puedeCambiarla){
                                res = await _con.cambiarPassword(textController2.text, Model.usuario.idUsuario.toString());
                                if(res.isEmpty){
                                  Model.usuario.password = textController2.text;
                                }
                              }
                            }
                            finally{
                              setState(() => _loadingButton1 = false);
                              snackBar = SnackBar(
                                //backgroundColor: Colors.red,
                                content: Row(
                                    children: <Widget>[
                                      Icon(
                                        puedeCambiarla ? res.isEmpty ? Icons.check_circle_outlined : Icons.error_outline_outlined : Icons.error_outline_outlined,
                                        color: puedeCambiarla ? res.isEmpty ? Color(0xFF67AB3D) : Colors.redAccent : Colors.redAccent,
                                        size: 25,
                                      ),
                                      Padding(padding: EdgeInsets.fromLTRB(0, 0, 15, 0),),
                                      puedeCambiarla ? res.isEmpty ? Text('Contraseña cambiada',style: TextStyle(fontSize: 18),) : Text('Error: ${res.toString()}',style: TextStyle(fontSize: 18),) : Text('Contraseña anterior errónea',style: TextStyle(fontSize: 18),)
                                    ]
                                ),
                                duration: Duration(milliseconds: 2000),
                              );
                            }
                            textController1.clear();
                            textController2.clear();
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          },
                          text: 'Guardar',
                          options: FFButtonOptions(
                            width: 130,
                            height: 40,
                            color: FlutterFlowTheme.tertiaryColor,
                            textStyle: FlutterFlowTheme.subtitle2.override(
                              fontFamily: 'Roboto',
                              color: Colors.black,
                            ),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                            borderRadius: 12,
                          ),
                          loading: _loadingButton1,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }



}