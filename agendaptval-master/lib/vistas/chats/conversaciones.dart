
import 'package:agendaptval/flutter_flow/flutter_flow_theme.dart';
import 'package:agendaptval/modeloControlador/usuarios.dart';
import 'package:agendaptval/vistas/homepage/profesores/home_page_prof_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as Path;
import 'package:agendaptval/modeloControlador/controller.dart';

import 'chat_personal.dart';

class ListaConversacionesWidget extends StatefulWidget {
  ListaConversacionesWidget({Key key}) : super(key: key);

  @override
  _ListaConversacionesWidgetState createState() =>
      _ListaConversacionesWidgetState();

}

Widget addLeadingIcon(context){
  return new Container(
    width: 130,
    height: 40,
    padding: const EdgeInsets.only(left: 20.0),
    color: Color(0x0000000E),
    child: FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomePageProfWidget()),
        );
      },
      child: FaIcon(
        FontAwesomeIcons.arrowLeft,
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
    ),
  );
}

Widget addActionIcon(){
  return new Container(
    width: 100,
    height: 40,
    padding: const EdgeInsets.only(right: 20.0),
    color: Color(0x0000000E),
    child: FloatingActionButton(
      onPressed: () {
        print('Button pressed ...');
      },
      child: FaIcon(
        FontAwesomeIcons.home,
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
    ),
  );
}

Widget buildItem(Usuarios user, context){
  return new ListTile(
    title: new Text(
      user.nombre,
      style: TextStyle(
        fontFamily: 'Poppins',
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
    ),
    leading: CircleAvatar(
      radius: 20,
      backgroundColor: Colors.transparent,
      backgroundImage: AssetImage(''),
    ),
    onTap: (){
      Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ChatPersonal(user: user))
      );
    },
  );
}

class _ListaConversacionesWidgetState extends State<ListaConversacionesWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<Usuarios> usuarios = [];

  Controller _con = Controller.con;
  Usuarios user;

  Future<List<Usuarios>> cargarUsuarios() async {
    usuarios = await _con.getPosiblesChats(Model.usuario.idUsuario);
    print("Usuarios cargados");

    return usuarios;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: FutureBuilder<List<Usuarios>>(
          future: cargarUsuarios(),
          builder: (BuildContext context, AsyncSnapshot<List<Usuarios>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: Container(
                  child: SpinKitRotatingCircle(
                    color: FlutterFlowTheme.laurelGreen,
                    size: 50.0,
                  ),
                ));
              default:
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChatPersonal(user: snapshot.data[index]))
                            );
                          },
                          child: Card(
                            child: ListTile(
                              leading: ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: _con.getEnlaceArchivoServidor(snapshot.data[index].profilePhoto),
                                  fit: BoxFit.cover,
                                  width: 60,
                                  height: 60,
                                ),
                              ),
                              title: Text(
                                snapshot.data[index].nombre,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                  );
                }
            }}
      ),


    );
  }
}
