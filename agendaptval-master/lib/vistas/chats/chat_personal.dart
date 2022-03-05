import 'package:agendaptval/flutter_flow/flutter_flow_theme.dart';
import 'package:agendaptval/modeloControlador/usuarios.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'conversaciones.dart';
import 'package:agendaptval/modeloControlador/controller.dart';

class ChatPersonal extends StatefulWidget {
  ChatPersonal({Key key, this.user}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ChatPersonal(user: this.user);

  Usuarios user;
}

class _ChatPersonal extends State<ChatPersonal> with TickerProviderStateMixin {
  Usuarios user;
  Usuarios emisor, receptor;
  _ChatPersonal({Key key, this.user});

  Controller _con = Controller.con;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _textController = TextEditingController();
  List<MensajeChat> _messages = [];
  final FocusNode _focusNode = FocusNode();
  bool _isComposing = false;
  bool mensajes_cargados = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar:  AppBar(
        backgroundColor: FlutterFlowTheme.laurelGreen,
        automaticallyImplyLeading: true,
        leading: addLeadingIcon(context),
        title: addTitle(user),
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: Color(0xFFF8F8F8),
      body: Column (
        children: [
          // FutureBuilder<List<MensajeChat>>(
          //   future: cargarMensajes(),
          //   builder: (BuildContext context, AsyncSnapshot<List<MensajeChat>> snapshot) {
          //     switch (snapshot.connectionState) {
          //       case ConnectionState.waiting:
          //         return Center(child: Container(
          //           child: SpinKitRotatingCircle(
          //             color: FlutterFlowTheme.laurelGreen,
          //             size: 50.0,
          //           ),
          //         ));
          //       default:
          //         if (snapshot.hasError) {
          //           return Text('Error: ${snapshot.error}');
          //         } else {
          //           return ListView.builder(
          //             itemCount: snapshot.data.length,
          //             itemBuilder: (context, index) {
          //               return Card(
          //                 child: ListTile(
          //                   leading: FaIcon(FontAwesomeIcons.user),
          //                   title: Text(
          //                     snapshot.data[index].name,
          //                     style: FlutterFlowTheme.title1
          //                   ),
          //                   subtitle: Text(
          //                     snapshot.data[index].text,
          //                     style: FlutterFlowTheme.bodyText1,
          //                   ),
          //                 ),
          //               );
          //             },
          //           );
          //         }
          //     }
          //   }
          // ),
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, index) => _messages[index],
              itemCount: _messages.length,
            ),
          ),
          const Divider(height: 1.0,),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
            ),
            child: buildTextComposer(context),
          ),
        ],
      )
    );
  }

  void dispose(){
    for(var message in _messages){
      message.animationController.dispose();
    }

    super.dispose();
  }

  Widget buildTextComposer(context){
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onChanged: (text) {
                  setState(() {
                    _isComposing = text.isNotEmpty;
                  });
                },
                onSubmitted: _isComposing ? _handleSubmitted : null,
                decoration: const InputDecoration.collapsed(hintText: 'Escribe aquí...'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _isComposing
                  ? () => _handleSubmitted(_textController.text)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<List<MensajeChat>> cargarMensajes() async{
    List<MensajeChat> _new_messages = await _con.getMensajesChat(Model.usuario.idUsuario, user.idUsuario);

    _messages.clear();

    for(int i = 0; i<_new_messages.length; i++){
      MensajeChat m = MensajeChat(
        text: _new_messages.elementAt(i).text,
        name: _new_messages.elementAt(i).name,
        animationController: AnimationController(
          duration: const Duration(milliseconds: 700),
          vsync: this,
        ),
      );

      _messages.insert(0, m);
    }

    return _messages;
  }

  void _handleSubmitted(String text){

    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    var message = MensajeChat(
        text: text,
        name: Model.usuario.nombre,
        animationController: AnimationController(
          duration: const Duration(milliseconds: 700),
          vsync: this,
        ),
    );
    setState(() {
      _messages.insert(0, message);
    });

    _focusNode.requestFocus();
    message.animationController.forward();
  }

  Widget addLeadingIcon(context){
    return new Container(
      width: 130,
      height: 40,
      padding: const EdgeInsets.only(left: 20.0),
      color: Color(0x0000000E),
      child: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
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

  Widget addTitle(Usuarios user){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(padding: EdgeInsets.only(left: 50.0)),
        ClipOval(
          child: CachedNetworkImage(
            imageUrl: _con.getEnlaceArchivoServidor(user.profilePhoto),
            fit: BoxFit.cover,
            width: 60,
            height: 60,
          ),
        ),
        Padding(padding: EdgeInsets.only(left: 10.0)),
        Text(
          user.nombre,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class MensajeChat extends StatelessWidget {
  const MensajeChat({
    this.text,
    this.name,
    this.animationController,
    Key key
  }) : super(key: key);

  final String text;
  final String name;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(parent: animationController, curve: Curves.easeOut),
      axisAlignment: 0.0,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(child: Text(name[0])),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.headline6,),
                  //const Divider(height: 1.0,),
                  Container(
                    margin: const EdgeInsets.only(top: 5.0),
                    child: Text(text, style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.black,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


