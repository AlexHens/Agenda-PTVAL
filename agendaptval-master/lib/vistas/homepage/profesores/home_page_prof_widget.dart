import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:agendaptval/modeloControlador/tipoUsuario.dart';
import 'package:agendaptval/vistas/Comida/lista_menus_admin/lista_menus_admin_widget.dart';
import 'package:agendaptval/vistas/Menu_admin/seccion_menu.dart';
import 'package:agendaptval/vistas/chats/conversaciones.dart';
import 'package:agendaptval/vistas/creacionUsuarios/lista_usuarios_admin_widget.dart';
import 'package:agendaptval/vistas/creacionUsuarios/lista_usuarios_prof_widget.dart';
import 'package:agendaptval/vistas/homepage/profesores/perfil_prof_widget.dart';
import 'package:agendaptval/vistas/inventario/lista_materiales_admin.dart';
import 'package:agendaptval/vistas/login_prof_widget.dart';
import 'package:agendaptval/vistas/tareasAdmin/lista_tareas_admin.dart';
import 'package:agendaptval/vistas/tareasProf/lista_tareas_prof_widget.dart';
import 'package:agendaptval/vistas/tareasProf/lista_tareas_prof_pendientes_widget.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../../flutter_flow/flutter_flow_icon_button.dart';
import '../../../flutter_flow/flutter_flow_theme.dart';
import '../../../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../unimplemented_widget.dart';
import '../alumnos/home_page_alu_widget.dart';

class HomePageProfWidget extends StatefulWidget {
  HomePageProfWidget({Key key}) : super(key: key);

  @override
  _HomePageProfWidgetState createState() => _HomePageProfWidgetState();
}

class _HomePageProfWidgetState extends StateMVC {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final List<IconData> drawerIconos = [
    Icons.people_outlined,
    Icons.fact_check_outlined,
    Icons.chat_outlined,
    FontAwesomeIcons.utensilSpoon,
    FontAwesomeIcons.boxOpen,
    Icons.notifications,
    Icons.person,
  ];
  List<bool> estaSeleccionado = [true, false, false, false, false, false, false, false];
  int indiceSeleccionado;

  _HomePageProfWidgetState(): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> paginas = (Model.usuario.getRol() == tipoUsuario.PROFESOR) ?
    // [Unimplemented(),ListaTareasProfWidget(),Unimplemented(),Unimplemented(),Unimplemented(),Unimplemented(),PerfilProf()]
    [ListaUsuariosProfWidgetState(),ListaTareasProfWidget(),ListaConversacionesWidget(),SeccionMenuAdminWidget(),Unimplemented(),Unimplemented(),PerfilProf()]
        :
    [ListaUsuariosAdminWidgetState(),ListaTareasAdminWidget(),SeccionMenuAdminWidget(),ListaMaterialesAdminWidget(),PerfilProf()];
    final List<String> drawerNombres = (Model.usuario.getRol() == tipoUsuario.PROFESOR) ?
    ['Lista de Usuarios', 'Lista de Tareas', 'Chats', 'Menús', 'Inventario', 'Notificaciones', 'Perfil']
        : ['Gestionar Usuarios', 'Crear Tareas', 'Crear Menús', 'Inventario', 'Perfil'];

    for(int i = 0; i < estaSeleccionado.length; i++){
      if(estaSeleccionado[i]) {
        indiceSeleccionado = i;
      }
    }
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.laurelGreen,
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        leading: FlutterFlowIconButton(
          borderColor: Colors.transparent,
          borderRadius: 30,
          borderWidth: 1,
          buttonSize: 60,
          icon: Icon(
            Icons.menu,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () async {
            scaffoldKey.currentState.openDrawer();
          },
        ),
        title: Text(
          '${drawerNombres[indiceSeleccionado]}',
          style: FlutterFlowTheme.title1,
        ),
        actions: [],
        centerTitle: true,
        elevation: indiceSeleccionado == 1 && Model.usuario.getRol() == tipoUsuario.PROFESOR ? 0 : indiceSeleccionado == 2 && Model.usuario.getRol() == tipoUsuario.ADMINISTRADOR ? 0 : 4,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      drawer: Model.usuario.getRol() == tipoUsuario.PROFESOR ? Drawer(
        elevation: 16,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.laurelGreen,
              ),
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, 1),
                      child: FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 30,
                        borderWidth: 1,
                        buttonSize: 70,
                        icon: Icon(
                          Icons.arrow_back,
                          color: Color(0xA3FFFFFF),
                          size: 50,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, 1),
                      child: Text(
                        'Menú',
                        style: FlutterFlowTheme.title1.override(
                          fontFamily: 'Roboto',
                          color: Color(0xA3FFFFFF),
                          fontSize: 70,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.people_outlined),
              selected: estaSeleccionado[0],
              title: Text(
                'Usuarios',
                style: FlutterFlowTheme.title1.override(
                  fontFamily: 'Roboto',
                  fontSize: 22,
                  color: estaSeleccionado[0] ? Color(0xFF3474E0) : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
                for(int i = 0; i < estaSeleccionado.length; i++){
                  setState(() {
                    if (0 == i) {
                      estaSeleccionado[0] = true;
                    } else {                               //the condition to change the highlighted item
                      estaSeleccionado[i] = false;
                    }
                  });
                }
              },
            ),
            ListTile(
              trailing: Icon(Icons.fact_check_outlined),
              selected: estaSeleccionado[1],
              title: Text(
                'Tareas',
                style: FlutterFlowTheme.title1.override(
                  fontFamily: 'Roboto',
                  fontSize: 22,
                  color: estaSeleccionado[1] ? Color(0xFF3474E0) : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
                for(int i = 0; i < estaSeleccionado.length; i++){
                  setState(() {
                    if (1 == i) {
                      estaSeleccionado[1] = true;
                    } else {                               //the condition to change the highlighted item
                      estaSeleccionado[i] = false;
                    }
                  });
                }
              },
            ),
            ListTile(
              trailing: Icon(Icons.chat_outlined),
              selected: estaSeleccionado[2],
              title: Text(
                'Chats',
                style: FlutterFlowTheme.title1.override(
                  fontFamily: 'Roboto',
                  fontSize: 22,
                  color: estaSeleccionado[2] ? Color(0xFF3474E0) : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
                for(int i = 0; i < estaSeleccionado.length; i++){
                  setState(() {
                    if (2 == i) {
                      estaSeleccionado[2] = true;
                    } else {                               //the condition to change the highlighted item
                      estaSeleccionado[i] = false;
                    }
                  });
                }
              },
            ),
             ListTile(
               trailing: Icon(FontAwesomeIcons.utensilSpoon),
               selected: estaSeleccionado[3],
               title: Text(
                 'Menús',
                 style: FlutterFlowTheme.title1.override(
                   fontFamily: 'Roboto',
                   color: estaSeleccionado[3] ? Color(0xFF3474E0) : Colors.black,
                   fontSize: 22,
                   fontWeight: FontWeight.w500,
                 ),
               ),
               onTap: () {
                 // Update the state of the app.
                 // ...
                 Navigator.pop(context);
                 for(int i = 0; i < estaSeleccionado.length; i++){
                   setState(() {
                     if (3 == i) {
                       estaSeleccionado[3] = true;
                     } else {                               //the condition to change the highlighted item
                       estaSeleccionado[i] = false;
                     }
                   });
                 }
               },
             ),
            // ListTile(
            //   trailing: Icon(FontAwesomeIcons.boxOpen),
            //   selected: estaSeleccionado[4],
            //   title: Text(
            //     'Inventario',
            //     style: FlutterFlowTheme.title1.override(
            //       fontFamily: 'Roboto',
            //       color: estaSeleccionado[4] ? Color(0xFF3474E0) : Colors.black,
            //       fontSize: 22,
            //       fontWeight: FontWeight.w500,
            //     ),
            //   ),
            //   onTap: () {
            //     // Update the state of the app.
            //     // ...
            //     Navigator.pop(context);
            //     for(int i = 0; i < estaSeleccionado.length; i++){
            //       setState(() {
            //         if (4 == i) {
            //           estaSeleccionado[4] = true;
            //         } else {                               //the condition to change the highlighted item
            //           estaSeleccionado[i] = false;
            //         }
            //       });
            //     }
            //   },
            // ),
            // ListTile(
            //   trailing: Icon(Icons.notifications),
            //   selected: estaSeleccionado[5],
            //   title: Text(
            //     'Notificaciones',
            //     style: FlutterFlowTheme.title1.override(
            //       fontFamily: 'Roboto',
            //       fontSize: 22,
            //       color: estaSeleccionado[5] ? Color(0xFF3474E0) : Colors.black,
            //       fontWeight: FontWeight.w500,
            //     ),
            //   ),
            //   onTap: () {
            //     // Update the state of the app.
            //     // ...
            //     Navigator.pop(context);
            //     for(int i = 0; i < estaSeleccionado.length; i++){
            //       setState(() {
            //         if (5 == i) {
            //           estaSeleccionado[5] = true;
            //         } else {                               //the condition to change the highlighted item
            //           estaSeleccionado[i] = false;
            //         }
            //       });
            //     }
            //   },
            // ),
            ListTile(
              trailing: Icon(Icons.person),
              selected: estaSeleccionado[6],
              title: Text(
                'Perfil',
                style: FlutterFlowTheme.title1.override(
                  fontFamily: 'Roboto',
                  color: estaSeleccionado[6] ? Color(0xFF3474E0) : Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
                for(int i = 0; i < estaSeleccionado.length; i++){
                  setState(() {
                    if (6 == i) {
                      estaSeleccionado[6] = true;
                    } else {                               //the condition to change the highlighted item
                      estaSeleccionado[i] = false;
                    }
                  });
                }
              },
            ),
            ListTile(
              trailing: Icon(Icons.logout, color: FlutterFlowTheme.secondaryColorDarker,),
              title: Text(
                'Cerrar Sesión',
                style: FlutterFlowTheme.title1.override(
                  fontFamily: 'Roboto',
                  color: FlutterFlowTheme.secondaryColorDarker,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                // Update the state of the app.
                // ...
                await _con.cerrarSesion();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginWidget(),
                  ),
                );
              },
            ),
          ],
        ),
      ) : Drawer(
        elevation: 16,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.laurelGreen,
              ),
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Align(
                      alignment: AlignmentDirectional(0, 1),
                      child: FlutterFlowIconButton(
                        borderColor: Colors.transparent,
                        borderRadius: 30,
                        borderWidth: 1,
                        buttonSize: 70,
                        icon: Icon(
                          Icons.arrow_back,
                          color: Color(0xA3FFFFFF),
                          size: 50,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0, 1),
                      child: Text(
                        'Menú',
                        style: FlutterFlowTheme.title1.override(
                          fontFamily: 'Roboto',
                          color: Color(0xA3FFFFFF),
                          fontSize: 70,
                          fontWeight: FontWeight.w200,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            ListTile(
              trailing: Icon(Icons.people_outlined),
              selected: estaSeleccionado[0],
              title: Text(
                'Gestionar Usuarios',
                style: FlutterFlowTheme.title1.override(
                  fontFamily: 'Roboto',
                  fontSize: 22,
                  color: estaSeleccionado[0] ? Color(0xFF3474E0) : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
                for(int i = 0; i < estaSeleccionado.length; i++){
                  setState(() {
                    if (0 == i) {
                      estaSeleccionado[0] = true;
                    } else {                               //the condition to change the highlighted item
                      estaSeleccionado[i] = false;
                    }
                  });
                }
              },
            ),
            ListTile(
              trailing: Icon(Icons.fact_check_outlined),
              selected: estaSeleccionado[1],
              title: Text(
                'Crear Tareas',
                style: FlutterFlowTheme.title1.override(
                  fontFamily: 'Roboto',
                  fontSize: 22,
                  color: estaSeleccionado[1] ? Color(0xFF3474E0) : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
                for(int i = 0; i < estaSeleccionado.length; i++){
                  setState(() {
                    if (1 == i) {
                      estaSeleccionado[1] = true;
                    } else {                               //the condition to change the highlighted item
                      estaSeleccionado[i] = false;
                    }
                  });
                }
              },
            ),
            ListTile(
              trailing: Icon(FontAwesomeIcons.utensilSpoon),
              selected: estaSeleccionado[2],
              title: Text(
                'Crear Menús',
                style: FlutterFlowTheme.title1.override(
                  fontFamily: 'Roboto',
                  fontSize: 22,
                  color: estaSeleccionado[2] ? Color(0xFF3474E0) : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
                for(int i = 0; i < estaSeleccionado.length; i++){
                  setState(() {
                    if (2 == i) {
                      estaSeleccionado[2] = true;
                    } else {                               //the condition to change the highlighted item
                      estaSeleccionado[i] = false;
                    }
                  });
                }
              },
            ),
            ListTile(
              trailing: Icon(FontAwesomeIcons.box),
              selected: estaSeleccionado[3],
              title: Text(
                'Inventario',
                style: FlutterFlowTheme.title1.override(
                  fontFamily: 'Roboto',
                  fontSize: 22,
                  color: estaSeleccionado[3] ? Color(0xFF3474E0) : Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
                for(int i = 0; i < estaSeleccionado.length; i++){
                  setState(() {
                    if (3 == i) {
                      estaSeleccionado[3] = true;
                    } else {                               //the condition to change the highlighted item
                      estaSeleccionado[i] = false;
                    }
                  });
                }
              },
            ),
            ListTile(
              trailing: Icon(Icons.person),
              selected: estaSeleccionado[4],
              title: Text(
                'Perfil',
                style: FlutterFlowTheme.title1.override(
                  fontFamily: 'Roboto',
                  color: estaSeleccionado[4] ? Color(0xFF3474E0) : Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
                Navigator.pop(context);
                for(int i = 0; i < estaSeleccionado.length; i++){
                  setState(() {
                    if (4 == i) {
                      estaSeleccionado[4] = true;
                    } else {                               //the condition to change the highlighted item
                      estaSeleccionado[i] = false;
                    }
                  });
                }
              },
            ),
            ListTile(
              trailing: Icon(Icons.logout, color: FlutterFlowTheme.secondaryColorDarker,),
              title: Text(
                'Cerrar Sesión',
                style: FlutterFlowTheme.title1.override(
                  fontFamily: 'Roboto',
                  color: FlutterFlowTheme.secondaryColorDarker,
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTap: () async {
                // Update the state of the app.
                // ...
                await _con.cerrarSesion();
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginWidget(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: paginas[indiceSeleccionado],
    )
  );
  }
}
