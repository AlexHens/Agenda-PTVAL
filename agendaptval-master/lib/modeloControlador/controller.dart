import 'dart:typed_data';
import 'dart:core';
import 'package:agendaptval/flutter_flow/flutter_image_add_drag_sort.dart';
import 'package:agendaptval/flutter_flow/random_number.dart';
import 'package:agendaptval/modeloControlador/opcionesHomepage.dart';
import 'package:agendaptval/modeloControlador/personalizacion.dart';
import 'package:agendaptval/modeloControlador/pictograma.dart';
import 'package:agendaptval/modeloControlador/platos.dart';
import 'package:agendaptval/modeloControlador/retroalimentacion.dart';
import 'package:agendaptval/modeloControlador/tipoInfo.dart';
import 'package:agendaptval/modeloControlador/tipoPlato.dart';
import 'package:agendaptval/modeloControlador/tipoTarea.dart';
import 'package:agendaptval/modeloControlador/tipoUsuario.dart';
import 'package:agendaptval/modeloControlador/usuarios.dart';
import 'package:agendaptval/modeloControlador/tarea.dart';
import 'package:agendaptval/vistas/chats/chat_personal.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';
import 'emoticono.dart';
import 'item.dart';
import 'menus.dart';

final IP = '192.168.1.142';

/// Clase del Modelo donde se guardará toda la información asociada al usuario que
/// inicia sesión en la aplicación
/// @author victor
class Model extends ModelMVC{
  /// SECCIÓN VARIABLES DEL MODELO

  static Usuarios usuario;
  static Personalizacion personalizacion;
  static bool inicializado = false;

  /// Función para asignar los datos a las variables del usuario en la aplicación
  /// @author victor
  static void _cargarModelo(Usuarios user){

    usuario = user;
  }

  static void _cargarPersonalizacion(Personalizacion pers){

    personalizacion = pers;

  }

  /// Función para limpiar los datos del usuario en la aplicación
  /// @param idUsuario el identificador único del usuario de la BD
  /// @param nombre el nombre del usuario
  /// @param apellido el apellido del usuario
  /// @param username el nombre de usuario del usuario
  /// @author victor
  static void _limpiarModelo(){
    String empty = '';
    usuario = new Usuarios(-1, empty, empty, empty, empty, empty, empty, empty, null, null);
    personalizacion = new Personalizacion(0, 0, 0, null, 0, 0, empty, empty, empty, empty);
  }

}

/// Clase controlador, que hace de intermediario con el Modelo
/// @author victor
class Controller extends ControllerMVC{

  /// Funciones para el correcto funcionamiento del MVC
  ///
  factory Controller(){
    if(_this == null) _this = Controller._();
    return _this;
  }
  static Controller _this;

  Controller._();

  static Controller get con => _this;
  ///
  ///
  /// Función para ejecutar una query en la BD
  /// Ejemplo: insert into pictogramas (idArasaac, nombre, url) values (?, ?, ?)', [valor1,valor2,valor3]
  /// Si la consulta devuelve algo se consulta de la siguiente forma:
  ///
  ///    resultado.elementAt(índice)['Columna'];
  ///
  /// @param query Cadena en la que se introduce la query a ejecutar en la BD. Por cada valor de una variable se introduce un '?'
  /// @param valores Lista en la que aparecen en el mismo orden que los '?' los valores a reemplazar por las '?'
  /// @return Si la query se ejecuta con éxito, una variable de tipo Results a la que se puede acceder al contenido mediante sus métodos
  ///         Si la query se ejecuta sin éxito, una variable de tipo String en la que se detalla el error de la query.
  /// @author victor
  Future<dynamic> queryBD(String query, List valores) async {

    Results resultado;

    var settings = ConnectionSettings(
        host: IP,
        port: 6033,
        user: 'admin',
        password: 'admin',
        db: 'agendaptval_db'
    );
    var conn = await MySqlConnection.connect(settings);

    try{
      resultado = await conn.query(query, valores);
    }
    catch(error){
      print(error.toString());
      return "ERROR QUERYBD\n" + error.toString();
    }

    return resultado;
  }


  /// Función para registrar la inclusión de una foto a un perfil
  /// @param archivo una variable de tipo file que contiene el archivo a subir
  /// @param idUsuario variable que identifica al usuario al que pertenece la foto
  /// @return si se ha completado el registro de la subida
  /// @author victor
  Future<String> subirFotoPerfil(File archivo, String idUsuario) async{
    var url = 'http://${IP}:3000';
    bool resultado = false;
    String link;

    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', archivo.path));
    request.send().then((response) async {
      if (response.statusCode == 200) {
        await archivo.delete();
        Map<String, dynamic> json = convert.jsonDecode(await response.stream.bytesToString());
        link = json['downloadLink'].toString().replaceAll('localhost', '');

        String query = "update Usuarios set foto = ? where id_usuario = ?";
        List<String> valores = [link, idUsuario];
        Results r = await queryBD(query, valores);
        Model.usuario.profilePhoto = getEnlaceArchivoServidor(link);
        if(r.isEmpty) resultado = true;
      }
    }
    );

    return link;
  }

  /// Función para registrar la inclusión de una foto a una tarea completada
  /// @param archivo una variable de tipo file que contiene el archivo a subir
  /// @param idTarea variable que identifica la tarea a la que pertenece la foto
  /// @return si se ha completado el registro de la subida
  /// @author victor
  Future<bool> subirFotoTarea(File archivo, String idTarea) async{
    var url = 'http://${IP}:3000';
    bool resultado = false;

    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', archivo.path));
    request.send().then((response) async {
      if (response.statusCode == 200) {
        await archivo.delete();
        Map<String, dynamic> json = convert.jsonDecode(await response.stream.bytesToString());
        String link = json['downloadLink'].toString().replaceAll('localhost', '${IP}');

        String query = "update Tareas set foto = ? where idTarea = ?";
        List<String> valores = [link, idTarea];
        if(await queryBD(query, valores)) resultado = true;
      }
    }
    );

    return resultado;
  }

  /// Función para registrar la inclusión de una foto a una conversación de chat
  /// @param archivo una variable de tipo file que contiene el archivo a subir
  /// @param idConversacion variable que identifica la conversación a la que pertenece la foto
  /// @param idUsuario variable que identifica al usuario que envía la foto
  /// @return si se ha completado el registro de la subida
  /// @author victor
  Future<bool> subirFotoChat(File archivo, String idConversacion, String idUsuario) async{
    var url = 'http://${IP}:3000';
    bool resultado = false;

    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', archivo.path));
    request.send().then((response) async {
      if (response.statusCode == 200) {
        await archivo.delete();
        Map<String, dynamic> json = convert.jsonDecode(await response.stream.bytesToString());
        String link = json['downloadLink'].toString().replaceAll('localhost', '${IP}');

        String query = "insert into Mensajes (idConversacion, idUsuario, url_imagen) values(?,?,?)";
        List<String> valores = [idConversacion, idUsuario,link];
        if(await queryBD(query, valores)) resultado = true;
      }
    }
    );

    return resultado;
  }

  /// Función para registrar la inclusión de un video a una conversación de chat
  /// @param archivo una variable de tipo file que contiene el archivo a subir
  /// @param idConversacion variable que identifica la conversación a la que pertenece el video
  /// @param idUsuario variable que identifica al usuario que envía el video
  /// @return si se ha completado el registro de la subida
  /// @author victor
  Future<bool> subirVideoChat(File archivo, String idConversacion, String idUsuario) async{
    var url = 'http://${IP}:3000';
    bool resultado = false;

    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', archivo.path));
    request.send().then((response) async {
      if (response.statusCode == 200) {
        await archivo.delete();
        Map<String, dynamic> json = convert.jsonDecode(await response.stream.bytesToString());
        String link = json['downloadLink'].toString().replaceAll('localhost', '${IP}');

        String query = "insert into Mensajes (idConversacion, idUsuario, url_video) values(?,?,?)";
        List<String> valores = [idConversacion, idUsuario,link];
        if(await queryBD(query, valores)) resultado = true;
      }
    }
    );

    return resultado;
  }

  /// Función para registrar la inclusión de un audio a una conversación de chat
  /// @param archivo una variable de tipo file que contiene el archivo a subir
  /// @param idConversacion variable que identifica la conversación a la que pertenece el audio
  /// @param idUsuario variable que identifica al usuario que envía el audio
  /// @return si se ha completado el registro de la subida
  /// @author victor
  Future<bool> subirAudioChat(File archivo, String idConversacion, String idUsuario) async{
    var url = 'http://${IP}:3000';
    bool resultado = false;

    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', archivo.path));
    request.send().then((response) async {
      if (response.statusCode == 200) {
        await archivo.delete();
        Map<String, dynamic> json = convert.jsonDecode(await response.stream.bytesToString());
        String link = json['downloadLink'].toString().replaceAll('localhost', '${IP}');

        String query = "insert into Mensajes (idConversacion, idUsuario, url_audio) values(?,?,?)";
        List<String> valores = [idConversacion, idUsuario,link];
        if(await queryBD(query, valores)) resultado = true;
      }
    }
    );

    return resultado;
  }

  String getEnlaceArchivoServidor(String ruta){
    return 'http://${IP}${ruta}';
  }

  /// Función para cargar los datos del usuario en la aplicación
  /// @param idUsuario el identificador único del usuario de la BD
  /// @param nombre el nombre del usuario
  /// @param apellido el apellido del usuario
  /// @param username el nombre de usuario del usuario
  /// @author victor
  Future<void> cargarModelo(Usuarios user) async {

    limpiarModelo();

    if(user.getRol() == tipoUsuario.ALUMNO) {
      await cargarPersonalizacion(user.idUsuario.toString());
    }

    Model._cargarModelo(user);

    Model.inicializado = true;

  }

  Future<void> cargarPersonalizacion(String idUsuario) async {

    String query = 'select * from Personalizacion where idUsuario=?';
    List<OpcionesHomepage> elementos_homepage_final = [];

    var res_query = await queryBD(query, [idUsuario]);

    if (!res_query.isEmpty) {

      if(!res_query.elementAt(0)['opciones_homepage'].toString().isEmpty){
        var elementos_homepage = res_query.elementAt(0)['opciones_homepage'].toString().split(',');

        for(int i = 0 ; i < elementos_homepage.length; i++){
          switch (elementos_homepage[i]){
            case ('tareas'):
              res_query.elementAt(0)['pictograma_tareas'].toString().isEmpty ?
              elementos_homepage_final.add(new OpcionesHomepage('${getEnlaceArchivoServidor(':3000/file?file=pictogramas/homepage/tareas.png')}', 'TAREAS')) :
              elementos_homepage_final.add(new OpcionesHomepage('${getEnlaceArchivoServidor(res_query.elementAt(0)['pictograma_tareas'])}', 'TAREAS'));
              break;
            case ('notificaciones'):
              res_query.elementAt(0)['pictograma_notificaciones'].toString().isEmpty ?
              elementos_homepage_final.add(new OpcionesHomepage('${getEnlaceArchivoServidor(':3000/file?file=pictogramas/homepage/notificaciones.png')}', 'NOTIFICACIONES')) :
              elementos_homepage_final.add(new OpcionesHomepage('${getEnlaceArchivoServidor(res_query.elementAt(0)['pictograma_notificaciones'])}', 'NOTIFICACIONES'));
              break;
            case ('chats'):
              res_query.elementAt(0)['pictograma_chats'].toString().isEmpty ?
              elementos_homepage_final.add(new OpcionesHomepage('${getEnlaceArchivoServidor(':3000/file?file=pictogramas/homepage/chats.png')}', 'CHATS')):
              elementos_homepage_final.add(new OpcionesHomepage('${getEnlaceArchivoServidor(res_query.elementAt(0)['pictograma_chats'])}', 'CHATS'));
              break;
            case ('historial'):
              res_query.elementAt(0)['pictograma_historial'].toString().isEmpty ?
              elementos_homepage_final.add(new OpcionesHomepage('${getEnlaceArchivoServidor(':3000/file?file=pictogramas/homepage/listo.png')}', 'HISTORIAL')) :
              elementos_homepage_final.add(new OpcionesHomepage('${getEnlaceArchivoServidor(res_query.elementAt(0)['pictograma_historial'])}', 'HISTORIAL'));
              break;
          }
        }
      }
      else{
        elementos_homepage_final.add(new OpcionesHomepage('${getEnlaceArchivoServidor(':3000/file?file=pictogramas/homepage/tareas.png')}', 'TAREAS'));
        elementos_homepage_final.add(new OpcionesHomepage('${getEnlaceArchivoServidor(':3000/file?file=pictogramas/homepage/notificaciones.png')}', 'NOTIFICACIONES'));
        elementos_homepage_final.add(new OpcionesHomepage('${getEnlaceArchivoServidor(':3000/file?file=pictogramas/homepage/chats.png')}', 'CHATS'));
        elementos_homepage_final.add(new OpcionesHomepage('${getEnlaceArchivoServidor(':3000/file?file=pictogramas/homepage/listo.png')}', 'HISTORIAL'));

      }


      //if (elementos_homepage.isEmpty)

      Model._cargarPersonalizacion(Personalizacion(
          res_query.elementAt(0)['homepage_reloj'],
          res_query.elementAt(0)['tam_texto'],
          res_query.elementAt(0)['texto_en_pictogramas'],
          elementos_homepage_final,
          res_query.elementAt(0)['homepage_elementos'],
          res_query.elementAt(0)['tareas_elementos_pp'],
          res_query.elementAt(0)['pictograma_tareas'].toString().isEmpty ? '' : getEnlaceArchivoServidor(res_query.elementAt(0)['pictograma_tareas']),
          res_query.elementAt(0)['pictograma_notificaciones'].toString().isEmpty ? '' :getEnlaceArchivoServidor(res_query.elementAt(0)['pictograma_notificaciones']),
          res_query.elementAt(0)['pictograma_chats'].toString().isEmpty ? '' : getEnlaceArchivoServidor(res_query.elementAt(0)['pictograma_chats']),
          res_query.elementAt(0)['pictograma_historial'].toString().isEmpty ? '' : getEnlaceArchivoServidor(res_query.elementAt(0)['pictograma_historial'])
      ));
    }

    print(Model.personalizacion.pictogramaTareas);
  }

  /// Función para iniciar sesión en la aplicación
  /// @param username nombre de usuario del campo de texto de la pantalla login
  /// @param password contraseña del campo de texto de la pantalla login
  /// @return si el usuario y contraseña coinciden se devuelve true y se cargan
  ///         los datos del usuario en el modelo, si no se devuelve false.
  /// @author victor
  Future<bool> iniciarSesion(String username, [String password]) async{

    bool resultado  = false;
    bool noMeter = false;
    bool noPrevio = false;
    int numAlum = -1;
    Usuarios user = null;
    List<String> passwords;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey('UserAlumAgendaPTVAL')) {
      List<String> usuarios = await prefs.getStringList('UserAlumAgendaPTVAL');

      for(int i = 0; i < usuarios.length; i++){
        if(usuarios[i] == username){
          numAlum = i;
        }
      }

      if(numAlum != -1) {
        noMeter = true;
        passwords = await prefs.getStringList('PassAlumAgendaPTVAL');
        password = passwords[numAlum];
      }
    }


    String query = 'select * from Usuarios where username=? and password=?';

    var resultado_query = await queryBD(query,[username,password]);

    //  Si el resultado de la consulta está vacío es que el usuario y contraseña no existe
    if(!resultado_query.isEmpty) {

      resultado = true;
      await cargarModelo(Usuarios(
          resultado_query.elementAt(0)['id_usuario'],
          resultado_query.elementAt(0)['nombre'],
          resultado_query.elementAt(0)['apellidos'],
          username,
          password,
          getEnlaceArchivoServidor(resultado_query.elementAt(0)['foto']),
          resultado_query.elementAt(0)['tipoInfo'],
          resultado_query.elementAt(0)['rol'],
          null,
          //  TO-DO: Notificaciones (?)
          null)); //  TO-DO: Conversaciones);


      if (resultado_query.elementAt(0)['rol'] == 'alumno' && !noMeter) {
        if (prefs.containsKey('UserAlumAgendaPTVAL')) {
          List<String> usuarios = await prefs.getStringList('UserAlumAgendaPTVAL');
          List<String> pass = await prefs.getStringList('PassAlumAgendaPTVAL');

          for (int i = 0; i < usuarios.length; i++) {
            if (usuarios[i] == username) {
              noMeter = true;
            }
          }

          if (!noMeter) {
            usuarios.add(username);
            pass.add(password);
            await prefs.setStringList('UserAlumAgendaPTVAL', usuarios);
            await prefs.setStringList('PassAlumAgendaPTVAL', pass);
          }
        }
        else {
          List<String> usuarios = [];
          List<String> pass = [];

          usuarios.add(username);
          pass.add(password);

          await prefs.setStringList('UserAlumAgendaPTVAL', usuarios);
          await prefs.setStringList('PassAlumAgendaPTVAL', pass);
        }
      }

      await prefs.setString('UserAgendaPTVAL', '${username}');
      await prefs.setString('PassAgendaPTVAL', '${password}');

    }

    return resultado;
  }

  /// Obtener lista de alumnos que han iniciado sesión ya en el dispositivo
  /// @author victor
  Future<List<Usuarios>> getAlumnosLogueados() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Usuarios> alumnosLogueados = [];

    String query = "select * from Usuarios where username=? and password=?";

    if(prefs.containsKey('UserAlumAgendaPTVAL')){
      List<String> usuarios = await prefs.getStringList('UserAlumAgendaPTVAL');
      List<String> pass = await prefs.getStringList('PassAlumAgendaPTVAL');

      for(int i = 0; i < usuarios.length; i++) {
        var resultado_query = await queryBD(query,[usuarios[i],pass[i]]);

        if(!(resultado_query.isEmpty)) {
          alumnosLogueados.add(Usuarios(
              resultado_query.elementAt(0)['id_usuario'],
              resultado_query.elementAt(0)['nombre'],
              resultado_query.elementAt(0)['apellidos'],
              resultado_query.elementAt(0)['username'],
              resultado_query.elementAt(0)['password'],
              getEnlaceArchivoServidor(resultado_query.elementAt(0)['foto']),
              resultado_query.elementAt(0)['tipoInfo'],
              resultado_query.elementAt(0)['rol'],
              null,//  TO-DO: Notificaciones (?)
              null));//  TO-DO: Conversaciones (?)
        }
      }

    }

    return alumnosLogueados;

  }

  /// Función para obtener un tipoInfo de un String
  /// @author victor
  tipoInfo transformarTipoInfo(String tipo){
    tipoInfo nuevo;
    switch (tipo){
      case ('texto'):
        nuevo = tipoInfo.TEXTO;
        break;
      case ('pictogramas'):
        nuevo = tipoInfo.PICTOGRAMAS;
        break;
    }
    return nuevo;
  }

  /// Función para limpiar los datos del usuario en la aplicación
  /// @param idUsuario el identificador único del usuario de la BD
  /// @param nombre el nombre del usuario
  /// @param apellido el apellido del usuario
  /// @param username el nombre de usuario del usuario
  /// @author victor
  void limpiarModelo(){

    Model._limpiarModelo();

  }

  /// Función para cerrar sesión en la aplicación.
  /// Limpia el modelo antes de cerrar la sesión.
  /// Ejemplo para establecer un botón de cierre de sesión:
  ///                       onPressed: () async {
  //                         print('Cerrando Sesión ...');
  //                         _con.cerrarSesion();
  //                         await Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) => LoginWidget(),
  //                           ),
  //                         );
  //                       },
  /// @author victor
  Future<void> cerrarSesion() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('UserAgendaPTVAL');
    await prefs.remove('PassAgendaPTVAL');

    limpiarModelo();

  }

  Future<Results> cambiarPassword(String newPassword, String idUsuario) async{

    String query = 'update Usuarios set password = ? where id_usuario = ?';

    List<String> valores = [newPassword, idUsuario];
    Results r = await queryBD(query, valores);

    return r;
  }

  Image fechaPictograma(BuildContext context){

    DateTime fecha = DateTime.now();
    DateFormat formato = DateFormat('EEEE');
    String fechaFinal = formato.format(fecha);

    switch(fechaFinal){
      case ('Monday'):
        return Image.asset(
          'assets/pictogramas/semana/l.png',
          fit: BoxFit.cover,
        );
      case ('Tuesday'):
        return Image.asset(
          'assets/pictogramas/semana/m.png',
          fit: BoxFit.cover,
        );
      case ('Wednesday'):
        return Image.asset(
          'assets/pictogramas/semana/x.png',
          fit: BoxFit.cover,
        );
      case ('Thursday'):
        return Image.asset(
          'assets/pictogramas/semana/j.png',
          fit: BoxFit.cover,
        );
      case ('Friday'):
        return Image.asset(
          'assets/pictogramas/semana/v.png',
          fit: BoxFit.cover,
        );
    }
  }

  /// Función para crear una tarea del administrador
  /// @param idTarea id de la Tarea
  /// @param nombre el nombre de la tarea
  /// @param descripcion la descripcion de la tareao
  /// @param duracion la duracion de la tarea
  /// @param imagenes imagenes añadidas a la tarea
  /// @param pictogramas pictogramas añadidos a la tarea
  /// @author amanda
  Future<bool> addTarea(String nombre, String descripcion, var duracion, String imagenes, String pictogramas) async{


    var url = '${IP}:3000';
    bool resultado = false;

    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.send().then((response) async {
      if (response.statusCode == 200) {
        Map<String, dynamic> json = convert.jsonDecode(await response.stream.bytesToString());
        String link = json['downloadLink'].toString().replaceAll('localhost', '${IP}');

        String query = "insert into Tarea (nombre, descripcion, fecha) values(?,?,?)";
        List<String> valores = [nombre,descripcion,duracion,"", "", "", duracion, pictogramas, imagenes];
        if(await queryBD(query, valores)) resultado = true;
      }
    }
    );

    return resultado;

  }

  Future<void> subirPictoaBD(String idArasaac, String nombre, String enlace) async {

    queryBD('insert into pictogramas (idArasaac, nombre, url) values (?, ?, ?)', [idArasaac, nombre, enlace]);
  }

  /// Función para registrar la inclusión de un pictograma al repositorio
  /// @param archivo una variable de tipo file que contiene el archivo a subir
  /// @param nombrePictograma nombre descriptivo que le asigna el usuario a este pictograma
  /// @return si se ha completado el registro de la subida
  /// @author victor
  Future<String> subirPictograma(File image) async{
    var url = 'http://${IP}:3000';
    var bytes = image.readAsBytesSync();
    String resultado = "";

    var request = new http.MultipartRequest("POST", Uri.parse(url));
    await request.files.add(await http.MultipartFile.fromPath('file', '${image.absolute.path}'));
    await request.send().then((response) async {
      if (response.statusCode == 200) print("Uploaded!");
      final respStr = await response.stream.bytesToString();
      //print(respStr);
      resultado = respStr;
    });

    return resultado;
  }


  /// Función para subir una tarea a la base de datos
  /// @param idTarea id de la Tarea
  /// @param nombre el nombre de la tarea
  /// @param descripcion la descripcion de la tareao
  /// @param duracion la duracion de la tarea
  /// @param imagenes imagenes añadidas a la tarea
  /// @param pictogramas pictogramas añadidos a la tarea
  /// @author amanda
  Future<Results> postTarea(String nombre, String descripcion, var duracion, List<ImageDataItem> imagen, List<ImageDataItem> pictograma, List<ImageDataItem> video, List<ImageDataItem> audio, String tipo) async{

    //  Insertamos las imagenes de la tarea si las tuviese
    String url_imagenes = '';
    String url_pictograma = '';
    String url_video = '';
    String url_audio = '';

    if(imagen.length > 0){
      for(int i = 0; i < imagen.length; i++){
        if(url_imagenes.length == 0){
          url_imagenes = url_imagenes + (await subirPictograma(File(imagen[i].url))).split('\"localhost')[1].split('\",')[0];
        }
        else {
          url_imagenes = url_imagenes + ',' + (await subirPictograma(File(imagen[i].url))).split('\"localhost')[1].split('\",')[0];
        }
      }
    }

    if(pictograma.length > 0){
      for(int i = 0; i < pictograma.length; i++){
        if(url_pictograma.length == 0){
          url_pictograma = url_pictograma + (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0];
        }
        else {
          url_pictograma = url_pictograma + ',' + (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0];
        }
      }
    }

    if(video.length > 0){
      for(int i = 0; i < video.length; i++){
        if(url_video.length == 0){
          url_video = url_video + (await subirPictograma(File(video[i].url))).split('\"localhost')[1].split('\",')[0];
        }
        else {
          url_video = url_video + ',' + (await subirPictograma(File(video[i].url))).split('\"localhost')[1].split('\",')[0];
        }
      }
    }

    if(audio.length > 0){
      for(int i = 0; i < audio.length; i++){
        if(url_audio.length == 0){
          url_audio = url_audio + (await subirPictograma(File(audio[i].url))).split('\"localhost')[1].split('\",')[0];
        }
        else{
          url_audio = url_audio + ',' + (await subirPictograma(File(audio[i].url))).split('\"localhost')[1].split('\",')[0];
        }
      }
    }

    String query = "";

    String query2 = "insert into Tareas (nombre, descripcion, enlace_autorizacion, duracion, enlace_video, enlace_audio, enlace_pictograma, enlace_imagen, tipo) values(?,?,?,?,?,?,?,?,?)";
    List<String> valores = [nombre,descripcion,"", duracion,url_video, url_audio, url_pictograma, url_imagenes, tipo];
    Results r = await queryBD(query2, valores);

    return r;
  }

  /// Función para subir una tarea a la base de datos
  /// @param idTarea id de la Tarea
  /// @param nombre el nombre de la tarea
  /// @param descripcion la descripcion de la tareao
  /// @param duracion la duracion de la tarea
  /// @param imagenes imagenes añadidas a la tarea
  /// @param pictogramas pictogramas añadidos a la tarea
  /// @author amanda
  Future<Results> postTareaProfesor(String nombre, int idUsuario, String descripcion, DateTime fecha_ini, DateTime fecha_fin, List<ImageDataItem> imagen, List<ImageDataItem> pictograma, List<ImageDataItem> video, List<ImageDataItem> audio, String tipo) async{

    //  Insertamos las imagenes de la tarea si las tuviese
    String url_imagenes = '';
    String url_pictograma = '';
    String url_video = '';
    String url_audio = '';

    if(imagen.length > 0){
      for(int i = 0; i < imagen.length; i++){
        if(url_imagenes.length == 0){
          url_imagenes = url_imagenes + (await subirPictograma(File(imagen[i].url))).split('\"localhost')[1].split('\",')[0];
        }
        else {
          url_imagenes = url_imagenes + ',' + (await subirPictograma(File(imagen[i].url))).split('\"localhost')[1].split('\",')[0];
        }
      }
    }

    if(pictograma.length > 0){
      for(int i = 0; i < pictograma.length; i++){
        if(url_pictograma.length == 0){
          url_pictograma = url_pictograma + (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0];
        }
        else {
          url_pictograma = url_pictograma + ',' + (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0];
        }
      }
    }

    if(video.length > 0){
      for(int i = 0; i < video.length; i++){
        if(url_video.length == 0){
          url_video = url_video + (await subirPictograma(File(video[i].url))).split('\"localhost')[1].split('\",')[0];
        }
        else {
          url_video = url_video + ',' + (await subirPictograma(File(video[i].url))).split('\"localhost')[1].split('\",')[0];
        }
      }
    }

    if(audio.length > 0){
      for(int i = 0; i < audio.length; i++){
        if(url_audio.length == 0){
          url_audio = url_audio + (await subirPictograma(File(audio[i].url))).split('\"localhost')[1].split('\",')[0];
        }
        else{
          url_audio = url_audio + ',' + (await subirPictograma(File(audio[i].url))).split('\"localhost')[1].split('\",')[0];
        }
      }
    }


    String query = "insert into Tareas (nombre,descripcion,enlace_autorizacion,duracion,enlace_video,enlace_audio,enlace_pictograma,enlace_imagen,tipo) values(?,?,?,?,?,?,?,?,?)";
    List<String> valores = [nombre,descripcion,"", fecha_fin != null ? fecha_fin.difference(fecha_ini).inDays.toString() : '1',url_video, url_audio, url_pictograma, url_imagenes, tipo];

    Results r = await queryBD(query, valores);

    String query3 = 'select id_tarea from Tareas where nombre = ?';
    Results r3 = await queryBD(query3,[nombre]);

    String query2 = "insert into Alumno_realiza_tarea (id_tarea,id_usuario, fecha_inicio, fecha_fin, completada, nombreTarea, descripcion, enlace_autorizacion, enlace_video, enlace_audio, enlace_pictograma, enlace_imagen, tipo) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    List<String> valores2 = [r3.elementAt(0)['id_tarea'].toString(), idUsuario.toString(), fecha_ini.toString(), fecha_fin.toString(), '0', nombre, descripcion, '', url_video, url_audio, url_pictograma, url_imagenes, tipo];
    Results r2 = await queryBD(query2, valores2);
    return r2;
  }


  /// Función para obtener tarea
  /// @param idTarea id de la Tarea
  /// @author amanda
  Future<Tarea> getTarea(int idTarea) async{
    Tarea tarea;
    List<String> enlaces_imagenes = [];
    List<String> enlaces_imagenes_aux;
    List<String> enlaces_videos_aux;
    List<String> enlaces_audios_aux;
    List<String> enlaces_pictos = [];
    List<String> enlaces_videos = [];
    List<String> enlaces_audios = [];
    List<String> enlaces_pictos_aux;

    String query = "select * from Tareas where id_tarea = ?";

    var resultado_query = await queryBD(query,[idTarea]);

    enlaces_imagenes_aux = resultado_query.elementAt(0)['enlace_imagen'].split(',');
    enlaces_pictos_aux = resultado_query.elementAt(0)['enlace_pictograma'].split(',');
    enlaces_videos_aux = resultado_query.elementAt(0)['enlace_video'].split(',');
    enlaces_audios_aux = resultado_query.elementAt(0)['enlace_audio'].split(',');

    for(int i = 0 ; i  < enlaces_imagenes_aux.length ; i++){
      if(enlaces_imagenes_aux[i].isNotEmpty){
        enlaces_imagenes.add(getEnlaceArchivoServidor(enlaces_imagenes_aux[i]));
      }
    }

    for(int i = 0 ; i  < enlaces_pictos_aux.length ; i++){
      if(enlaces_pictos_aux[i].isNotEmpty) {
        enlaces_pictos.add(getEnlaceArchivoServidor(enlaces_pictos_aux[i]));
      }
    }
    for(int i = 0 ; i  < enlaces_videos_aux.length ; i++){
      if(enlaces_videos_aux[i].isNotEmpty) {
        enlaces_videos.add(getEnlaceArchivoServidor(enlaces_videos_aux[i]));
      }
    }
    for(int i = 0 ; i  < enlaces_audios_aux.length ; i++){
      if(enlaces_audios_aux[i].isNotEmpty) {
        enlaces_audios.add(getEnlaceArchivoServidor(enlaces_audios_aux[i]));
      }
    }

    tarea = Tarea(
        idTarea,
        resultado_query.elementAt(0)['nombre'],
        0,
        resultado_query.elementAt(0)['descripcion'],
        resultado_query.elementAt(0)['duracion'],
        null,
        null,
        enlaces_videos,
        enlaces_imagenes,
        enlaces_audios,
        null,
        enlaces_pictos,
        stringToTipoTarea(resultado_query.elementAt(0)['tipo']),
        null,
        null,
      null
    );

    return tarea;

  }

  Future<Retroalimentacion> getRetroalimentacionAlumno(int idRetroalimentacion) async{

    Retroalimentacion retro;
    String enlace_picto;
    String enlace_picto_aux;

    String query = "select * from Retroalimentacion where id_retroalimentacion = ?";
    var resultado_query = await queryBD(query,[idRetroalimentacion]);

    enlace_picto_aux = resultado_query.elementAt(0)['pictograma'];

    if(enlace_picto_aux.isNotEmpty)
      enlace_picto = getEnlaceArchivoServidor(enlace_picto_aux);

    return Retroalimentacion(
      resultado_query.elementAt(0)['id_retroalimentacion'],
      resultado_query.elementAt(0)['descripcion'],
      resultado_query.elementAt(0)['calificacion'],
      enlace_picto,
      await getEmoticono(resultado_query.elementAt(0)['calificacion']),
      resultado_query.elementAt(0)['mostrar_calificacion'],
    );


  }

  /// Función para obtener tarea
  /// @param idTarea id de la Tarea
  /// @author amanda
  Future<Tarea> getTareaAsignada(int idTarea, int idUsuario) async{
    Tarea tarea;
    List<String> enlaces_imagenes = [];
    List<String> enlaces_imagenes_aux;
    List<String> enlaces_videos_aux;
    List<String> enlaces_audios_aux;
    List<String> enlaces_pictos = [];
    List<String> enlaces_videos = [];
    List<String> enlaces_audios = [];
    List<String> enlaces_pictos_aux;
    String enlace_foto_resultado = null;
    String enlace_foto_resultado_aux = null;

    String query = "select * from Alumno_realiza_tarea where id_tarea = ? and id_usuario = ?";

    var resultado_query = await queryBD(query,[idTarea,idUsuario]);

    enlaces_imagenes_aux = resultado_query.elementAt(0)['enlace_imagen'].split(',');
    enlaces_pictos_aux = resultado_query.elementAt(0)['enlace_pictograma'].split(',');
    enlaces_videos_aux = resultado_query.elementAt(0)['enlace_video'].split(',');
    enlaces_audios_aux = resultado_query.elementAt(0)['enlace_audio'].split(',');
    enlace_foto_resultado_aux = resultado_query.elementAt(0)['foto_resultado'];

    if(enlace_foto_resultado_aux != null){
      enlace_foto_resultado = getEnlaceArchivoServidor(enlace_foto_resultado_aux);
    }

    for(int i = 0 ; i  < enlaces_imagenes_aux.length ; i++){
      if(enlaces_imagenes_aux[i].isNotEmpty){
        enlaces_imagenes.add(getEnlaceArchivoServidor(enlaces_imagenes_aux[i]));
      }
    }

    for(int i = 0 ; i  < enlaces_pictos_aux.length ; i++){
      if(enlaces_pictos_aux[i].isNotEmpty) {
        enlaces_pictos.add(getEnlaceArchivoServidor(enlaces_pictos_aux[i]));
      }
    }
    for(int i = 0 ; i  < enlaces_videos_aux.length ; i++){
      if(enlaces_videos_aux[i].isNotEmpty) {
        enlaces_videos.add(getEnlaceArchivoServidor(enlaces_videos_aux[i]));
      }
    }
    for(int i = 0 ; i  < enlaces_audios_aux.length ; i++){
      if(enlaces_audios_aux[i].isNotEmpty) {
        enlaces_audios.add(getEnlaceArchivoServidor(enlaces_audios_aux[i]));
      }
    }

    DateTime f_inicio = resultado_query.elementAt(0)['fecha_inicio'];
    DateTime f_fin = resultado_query.elementAt(0)['fecha_fin'];
    int duracion = f_fin.difference(f_inicio).inDays;

    tarea = Tarea(
        idTarea,
        resultado_query.elementAt(0)['nombreTarea'],
        resultado_query.elementAt(0)['completada'],
        resultado_query.elementAt(0)['descripcion'],
        duracion,
        f_inicio,
        f_fin,
        enlaces_videos,
        enlaces_imagenes,
        enlaces_audios,
        null,
        enlaces_pictos,
        stringToTipoTarea(resultado_query.elementAt(0)['tipo']),
        resultado_query.elementAt(0)['id_retroalimentacion'] != 0 ? await getRetroalimentacionAlumno(resultado_query.elementAt(0)['id_retroalimentacion']) : null,
        resultado_query.elementAt(0)['id_usuario'],
        enlace_foto_resultado
    );

    return tarea;

  }

  tipoTarea stringToTipoTarea(String tipo){
    switch(tipo){
      case ('fija'):
        return tipoTarea.FIJA;
        break;
      case ('comanda_comedor'):
        return tipoTarea.COMANDA_MENU;
        break;
      case ('comanda_fotocopiadora'):
        return tipoTarea.COMANDA_FOTOCOPIADORA;
        break;
      case ('comanda_inventario'):
        return tipoTarea.COMANDA_INVENTARIO;
        break;
    }
  }


  /// Función para obtener todas las tareas
  /// @author amanda
  Future<List<Tarea>> getAllTareas() async{

    List<Tarea> tareas = [];

    List<String> enlaces_imagenes = [];
    List<String> enlaces_imagenes_aux;
    List<String> enlaces_videos_aux;
    List<String> enlaces_audios_aux;
    List<String> enlaces_pictos = [];
    List<String> enlaces_videos = [];
    List<String> enlaces_audios = [];
    List<String> enlaces_pictos_aux;


    String query = "select * from Tareas";

    var resultado_query = await queryBD(query, []);

    for(int i = 0; i < resultado_query.length; i++){

      enlaces_imagenes = [];
      enlaces_pictos = [];
      enlaces_videos = [];
      enlaces_audios = [];

      enlaces_imagenes_aux = resultado_query.elementAt(i)['enlace_imagen'].split(',');
      enlaces_pictos_aux = resultado_query.elementAt(i)['enlace_pictograma'].split(',');
      enlaces_videos_aux = resultado_query.elementAt(i)['enlace_video'].split(',');
      enlaces_audios_aux = resultado_query.elementAt(i)['enlace_audio'].split(',');

      for(int i = 0 ; i  < enlaces_imagenes_aux.length ; i++){
        if(enlaces_imagenes_aux[i].isNotEmpty){
          enlaces_imagenes.add(getEnlaceArchivoServidor(enlaces_imagenes_aux[i]));
        }
      }

      for(int i = 0 ; i  < enlaces_pictos_aux.length ; i++){
        if(enlaces_pictos_aux[i].isNotEmpty) {
          enlaces_pictos.add(getEnlaceArchivoServidor(enlaces_pictos_aux[i]));
        }
      }
      for(int i = 0 ; i  < enlaces_videos_aux.length ; i++){
        if(enlaces_videos_aux[i].isNotEmpty) {
          enlaces_videos.add(getEnlaceArchivoServidor(enlaces_videos_aux[i]));
        }
      }
      for(int i = 0 ; i  < enlaces_audios_aux.length ; i++){
        if(enlaces_audios_aux[i].isNotEmpty) {
          enlaces_audios.add(getEnlaceArchivoServidor(enlaces_audios_aux[i]));
        }
      }

      tareas.add(
          Tarea(
              resultado_query.elementAt(i)['id_tarea'],
              resultado_query.elementAt(i)['nombre'],
              0,
              resultado_query.elementAt(i)['descripcion'],
              resultado_query.elementAt(i)['duracion'],
              null,
              null,
              enlaces_videos,
              enlaces_imagenes,
              enlaces_audios,
              null,
              enlaces_pictos,
              stringToTipoTarea(resultado_query.elementAt(i)['tipo']),
              null,
              null,
            null
          )
      );
    }

    return tareas;

  }


  /// Función para eliminar una tarea
  /// @param idTarea id de la Tarea
  /// @author amanda
  Future<Results> eliminarTarea(int idTarea) async{

    String query = 'delete from Tareas where id_tarea = ?';

    List valores = [idTarea];
    Results r = await queryBD(query, valores);

    return r;


  }

  /// Función para eliminar una asignación
  /// @param idTarea id de la Tarea
  /// @author amanda
  Future<Results> eliminarAsignacion(int idTarea, int idUsuario) async{

    String query = 'delete from Alumno_realiza_tarea where id_tarea = ? and id_usuario = ?';

    List valores = [idTarea, idUsuario];
    Results r = await queryBD(query, valores);

    return r;
  }

  /// Función para editar el nombre de una tarea
  /// @param newNombre nuevo nombre de la tarea
  /// @param idTarea id de la Tarea
  /// @author amanda
  Future<Results> editarNombreTarea(String newNombre, int idTarea) async{

    String query = 'update Tareas set nombre = ? where id_tarea = ?';

    List valores = [newNombre, idTarea];
    Results r = await queryBD(query, valores);

    return r;

  }

  /// Función para editar la descripción de una tarea
  /// @param newDesc nueva descripción de la tarea
  /// @param idTarea id de la Tarea
  /// @author amanda
  Future<Results> editarDescripcionTarea(String newDesc, int idTarea) async{

    String query = 'update Tareas set descripcion = ? where id_tarea = ?';

    List valores = [newDesc, idTarea];
    Results r = await queryBD(query, valores);

    return r;

  }

  /// Función para editar la duración de una tarea
  /// @param newDur nueva descripción de la tarea
  /// @param idTarea id de la Tarea
  /// @author amanda
  Future<Results> editarDuracionTarea(String newDur, int idTarea) async{

    String query = 'update Tareas set duracion = ? where id_tarea = ?';

    List valores = [newDur, idTarea];
    Results r = await queryBD(query, valores);

    return r;

  }

  /// Función para editar el tipo de una tarea
  /// @param newDur nueva descripción de la tarea
  /// @param idTarea id de la Tarea
  /// @author amanda
  Future<Results> editarTipoTarea(String newTipo, int idTarea) async{

    String query = 'update Tareas set tipo = ? where id_tarea = ?';

    List valores = [newTipo, idTarea];
    Results r = await queryBD(query, valores);

    return r;

  }

  /// Función para editar una tarea
  /// @param idTarea id de la Tarea
  /// @param nombre el nombre de la tarea
  /// @param descripcion la descripcion de la tareao
  /// @param duracion la duración de la tarea
  /// @param imagenes imagenes añadidas a la tarea
  /// @param pictogramas pictogramas añadidos a la tarea
  /// @author amanda
  Future<Results> editarTarea(int idTarea, String nombre, String descripcion, var duracion, List<ImageDataItem> imagen, List<ImageDataItem> pictograma, List<ImageDataItem> video, List<ImageDataItem> audio, String tipo) async{

    Tarea tarea = await getTarea(idTarea);
    Results r;

    //  Insertamos las imagenes de la tarea si las tuviese
    String url_imagenes = '';
    String url_pictograma = '';
    String url_video = '';
    String url_audio = '';

    if(tarea.nombre != nombre)
      await editarNombreTarea(nombre, idTarea);

    if(tarea.descripcion != descripcion)
      await editarDescripcionTarea(descripcion, idTarea);

    if(tarea.duracion != duracion)
      await editarDuracionTarea(duracion, idTarea);

    if(tarea.tipo != stringToTipoTarea(tipo))
      await editarTipoTarea(tipo, idTarea);

    /// IMÁGENES

    if(imagen.length > 0){
      for(int i = 0; i < imagen.length; i++){
        if(url_imagenes.length == 0 ){
          url_imagenes = url_imagenes + (!imagen[i].url.contains('http') ? (await subirPictograma(File(imagen[i].url))).split('\"localhost')[1].split('\",')[0] : imagen[i].url.substring(imagen[i].url.indexOf(':3000')));
        }
        else {
          url_imagenes = url_imagenes + ',' + (!imagen[i].url.contains('http') ? (await subirPictograma(File(imagen[i].url))).split('\"localhost')[1].split('\",')[0] : imagen[i].url.substring(imagen[i].url.indexOf(':3000')));
        }
      }
    }

    if(pictograma.length > 0){
      for(int i = 0; i < pictograma.length; i++){
        if(url_pictograma.length == 0){
          url_pictograma = url_pictograma + (!pictograma[i].url.contains('http') ? (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0] : pictograma[i].url.substring(pictograma[i].url.indexOf(':3000')));
        }
        else {
          url_pictograma = url_pictograma + ',' + (!pictograma[i].url.contains('http') ? (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0] : pictograma[i].url.substring(pictograma[i].url.indexOf(':3000')));
        }
      }
    }

    if(video.length > 0){
      for(int i = 0; i < video.length; i++){
        if(url_video.length == 0){
          url_video = url_video + (!video[i].url.contains('http') ? (await subirPictograma(File(video[i].url))).split('\"localhost')[1].split('\",')[0] : video[i].url.substring(video[i].url.indexOf(':3000')));
        }
        else {
          url_video = url_video + ',' + (!video[i].url.contains('http') ? (await subirPictograma(File(video[i].url))).split('\"localhost')[1].split('\",')[0] : video[i].url.substring(video[i].url.indexOf(':3000')));
        }
      }
    }

    if(audio.length > 0){
      for(int i = 0; i < audio.length; i++){
        if(url_audio.length == 0){
          url_audio = url_audio + (!audio[i].url.contains('http') ? (await subirPictograma(File(audio[i].url))).split('\"localhost')[1].split('\",')[0] : audio[i].url.substring(audio[i].url.indexOf(':3000')));
        }
        else{
          url_audio = url_audio + ',' + (!audio[i].url.contains('http') ? (await subirPictograma(File(audio[i].url))).split('\"localhost')[1].split('\",')[0] : audio[i].url.substring(audio[i].url.indexOf(':3000')));
        }
      }
    }

    print(url_video);

    String query2 = "update Tareas set enlace_video = ?, enlace_audio = ?, enlace_pictograma = ?, enlace_imagen = ? where id_tarea = ?";
    List<String> valores = [url_video, url_audio, url_pictograma, url_imagenes, idTarea.toString()];
    Results r2 = await queryBD(query2, valores);

    return r;

  }

  /// Función para editar una tarea asignada
  /// @param idTarea id de la Tarea
  /// @param nombre el nombre de la tarea
  /// @param descripcion la descripcion de la tareao
  /// @param duracion la duración de la tarea
  /// @param imagenes imagenes añadidas a la tarea
  /// @param pictogramas pictogramas añadidos a la tarea
  /// @author amanda
  Future<Results> editarTareaAsignada(int idTarea, int idUsuario ,String nombre, String descripcion, DateTime fecha_ini, DateTime fecha_fin, int completada, List<ImageDataItem> imagen, List<ImageDataItem> pictograma, List<ImageDataItem> video, List<ImageDataItem> audio, String tipo) async{

    Tarea tarea = await getTareaAsignada(idTarea, idUsuario);
    Results r;

    //  Insertamos las imagenes de la tarea si las tuviese
    String url_imagenes = '';
    String url_pictograma = '';
    String url_video = '';
    String url_audio = '';

    if(tarea.nombre != nombre){
      String query = 'update Alumno_realiza_tarea set nombreTarea = ? where id_tarea = ?';
      List valores = [nombre, idTarea];
      Results r = await queryBD(query, valores);
    }

    if(tarea.idUsuarioRealiza != idUsuario){
      String query = 'update Alumno_realiza_tarea set id_usuario = ? where id_tarea = ?';
      List valores = [idUsuario, idTarea];
      Results r = await queryBD(query, valores);
    }

    if(tarea.descripcion != descripcion){
      String query = 'update Alumno_realiza_tarea set descripcion = ? where id_tarea = ?';
      List valores = [descripcion, idTarea];
      Results r = await queryBD(query, valores);

    }

    if(tarea.fecha_inicio != fecha_ini){
      String query = 'update Alumno_realiza_tarea set fecha_inicio = ? where id_tarea = ?';
      List valores = [fecha_ini, idTarea];
      Results r = await queryBD(query, valores);
    }

    if(tarea.fecha_fin != fecha_fin){
      String query = 'update Alumno_realiza_tarea set fecha_fin = ? where id_tarea = ?';
      List valores = [fecha_fin, idTarea];
      Results r = await queryBD(query, valores);
    }

    if(tarea.completada != (completada == 0 ? false : true)){
      String query = 'update Alumno_realiza_tarea set completada = ? where id_tarea = ?';
      List valores = [completada, idTarea];
      Results r = await queryBD(query, valores);
    }

    if(tarea.tipo != stringToTipoTarea(tipo)){
      String query = 'update Alumno_realiza_tarea set tipo = ? where id_tarea = ?';
      List valores = [tipo, idTarea];
      Results r = await queryBD(query, valores);

    }


    /// IMÁGENES

    if(imagen.length > 0){
      for(int i = 0; i < imagen.length; i++){
        if(url_imagenes.length == 0 ){
          url_imagenes = url_imagenes + (!imagen[i].url.contains('http') ? (await subirPictograma(File(imagen[i].url))).split('\"localhost')[1].split('\",')[0] : imagen[i].url.substring(imagen[i].url.indexOf(':3000')));
        }
        else {
          url_imagenes = url_imagenes + ',' + (!imagen[i].url.contains('http') ? (await subirPictograma(File(imagen[i].url))).split('\"localhost')[1].split('\",')[0] : imagen[i].url.substring(imagen[i].url.indexOf(':3000')));
        }
      }
    }

    if(pictograma.length > 0){
      for(int i = 0; i < pictograma.length; i++){
        if(url_pictograma.length == 0){
          url_pictograma = url_pictograma + (!pictograma[i].url.contains('http') ? (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0] : pictograma[i].url.substring(pictograma[i].url.indexOf(':3000')));
        }
        else {
          url_pictograma = url_pictograma + ',' + (!pictograma[i].url.contains('http') ? (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0] : pictograma[i].url.substring(pictograma[i].url.indexOf(':3000')));
        }
      }
    }

    if(video.length > 0){
      for(int i = 0; i < video.length; i++){
        if(url_video.length == 0){
          url_video = url_video + (!video[i].url.contains('http') ? (await subirPictograma(File(video[i].url))).split('\"localhost')[1].split('\",')[0] : video[i].url.substring(video[i].url.indexOf(':3000')));
        }
        else {
          url_video = url_video + ',' + (!video[i].url.contains('http') ? (await subirPictograma(File(video[i].url))).split('\"localhost')[1].split('\",')[0] : video[i].url.substring(video[i].url.indexOf(':3000')));
        }
      }
    }

    if(audio.length > 0){
      for(int i = 0; i < audio.length; i++){
        if(url_audio.length == 0){
          url_audio = url_audio + (!audio[i].url.contains('http') ? (await subirPictograma(File(audio[i].url))).split('\"localhost')[1].split('\",')[0] : audio[i].url.substring(audio[i].url.indexOf(':3000')));
        }
        else{
          url_audio = url_audio + ',' + (!audio[i].url.contains('http') ? (await subirPictograma(File(audio[i].url))).split('\"localhost')[1].split('\",')[0] : audio[i].url.substring(audio[i].url.indexOf(':3000')));
        }
      }
    }

    print(url_video);

    String query2 = "update Alumno_realiza_tarea set enlace_video = ?, enlace_audio = ?, enlace_pictograma = ?, enlace_imagen = ? where id_tarea = ? and id_usuario = ?";
    List<String> valores = [url_video, url_audio, url_pictograma, url_imagenes, idTarea.toString(), idUsuario.toString()];
    Results r2 = await queryBD(query2, valores);

    return r;

  }


  /// Función para asignar una tarea a un alumno
  /// @param idTarea id de la Tarea
  /// @param idAlumno id del alumno
  /// @author amanda
  Future<Results> asignarTarea(int idTarea, int idAlumno, DateTime fecha_ini, DateTime fecha_fin) async{

    //DateTime fecha = DateTime.now();

    Tarea tarea;

    String query = "select * from Tareas where id_tarea = ?";

    var resultado_query = await queryBD(query,[idTarea]);


    query = "insert into Alumno_realiza_tarea (id_tarea, id_usuario, fecha_inicio, fecha_fin, completada, nombreTarea, descripcion, enlace_autorizacion, enlace_video, enlace_audio, enlace_pictograma, enlace_imagen, tipo) values(?,?,?,?,?,?,?,?,?,?,?,?,?)";
    List valores = [idTarea.toString(),idAlumno.toString(),fecha_ini, fecha_fin,'0',resultado_query.elementAt(0)['nombre'],resultado_query.elementAt(0)['descripcion'],' ',resultado_query.elementAt(0)['enlace_video'],resultado_query.elementAt(0)['enlace_audio'],resultado_query.elementAt(0)['enlace_pictograma'],resultado_query.elementAt(0)['enlace_imagen'],resultado_query.elementAt(0)['tipo']];
    Results r = await queryBD(query, valores);
    return r;

  }

  /// Función para obtener todas los alumnos
  /// @author amanda
  Future<List<Usuarios>> getAllAlumnos() async{

    List<Usuarios> alumnos = [];
    String query = "select * from Usuarios where rol = 'alumno'";

    var resultado_query = await queryBD(query,[]);


    for(int i = 0; i < resultado_query.length; i++){

      alumnos.add(
          Usuarios(
              resultado_query.elementAt(i)['id_usuario'],
              resultado_query.elementAt(i)['nombre'],
              resultado_query.elementAt(i)['apellidos'],
              resultado_query.elementAt(i)['username'],
              resultado_query.elementAt(i)['password'],
              resultado_query.elementAt(i)['foto'],
              resultado_query.elementAt(i)['tipoInfo'],
              resultado_query.elementAt(i)['rol'],
              null,
              null
          )
      );

    }

    return alumnos;

  }


  /// Función para obtener un alumno
  /// @param idAlumno id del alumno
  /// @author amanda
  Future<Usuarios> getAlumno(int idAlumno) async{

    Usuarios alumno;

    String query = "select * from Usuarios where id_usuario = ? and rol = alumno";

    var resultado_query = await queryBD(query,[idAlumno]);


    alumno = Usuarios(
        resultado_query.elementAt(0)['id_usuario'],
        resultado_query.elementAt(0)['nombre'],
        resultado_query.elementAt(0)['apellidos'],
        resultado_query.elementAt(0)['username'],
        resultado_query.elementAt(0)['password'],
        resultado_query.elementAt(0)['foto'],
        resultado_query.elementAt(0)['tipoInfo'],
        resultado_query.elementAt(0)['rol'],
        null,
        null
    );

  }

  /// Función para obtener un alumno asignado a una tarea
  /// @param idTarea id de la tarea
  /// @author amanda
  Future<Usuarios> getAlumnoAsignado(int idTarea) async{

    Usuarios alumno;

    String query = "select * from Alumno_realiza_tarea where id_tarea = ? ";

    var resultado_query = await queryBD(query,[idTarea]);


    alumno = Usuarios(
        resultado_query.elementAt(0)['id_usuario'],
        resultado_query.elementAt(0)['nombre'],
        resultado_query.elementAt(0)['apellidos'],
        resultado_query.elementAt(0)['username'],
        resultado_query.elementAt(0)['password'],
        resultado_query.elementAt(0)['foto'],
        resultado_query.elementAt(0)['tipoInfo'],
        resultado_query.elementAt(0)['rol'],
        null,
        null
    );

  }

  /// Función para obtener todas las tareas que no han sido asignadas a un alumno
  /// @author amanda
  Future<List<Tarea>> getAllTareasNoAsig(int idAlumno) async{

    List<Tarea> tareas = await getAllTareas();
    List<Tarea> tareasnoAsig = [];
    Usuarios alumno = await getAlumno(idAlumno);

    String query = "select * from Alumno_realiza_tarea where idAlumno = ?";

    var resultado_query_asignadas = await queryBD(query,[idAlumno]);

    for(int i = 0; i < tareas.length; i++) {
      for (int j = 0; j < resultado_query_asignadas.length; j++) {

        if(tareas.elementAt(i).idTarea != resultado_query_asignadas.elementAt(j)['idTarea'])
          tareasnoAsig.add(tareas.elementAt(i));
      }
    }

    return tareasnoAsig;

  }

  /// Función para obtener todas las tareas en progreso que puede ver un profesor
  /// @author victor
  Future<List<Tarea>> getTareasDeTuteladosEnProgresoProfesor() async{

    List<Tarea> tareas = await getTareasDeTutelados();
    List<Tarea> tareasEnProgreso = [];

    for(int i = 0; i < tareas.length; i++) {
      if(tareas[i].completada == 0){
        tareasEnProgreso.add(tareas[i]);
      }
    }

    return tareasEnProgreso;
  }

  /// Función para obtener todas las tareas en revisión que puede ver un profesor
  /// @author victor
  Future<List<Tarea>> getTareasDeTuteladosRevisionProfesor() async{

    List<Tarea> tareas = await getTareasDeTutelados();
    List<Tarea> tareasRevision = [];

    for(int i = 0; i < tareas.length; i++) {
      if(tareas[i].completada == 1){
        tareasRevision.add(tareas[i]);
      }
    }

    return tareasRevision;
  }

  /// Función para obtener todas las tareas en revisión que puede ver un profesor
  /// @author victor
  Future<List<Tarea>> getTareasDeTuteladosCompletadasProfesor() async{

    List<Tarea> tareas = await getTareasDeTutelados();
    List<Tarea> tareasCompletadas = [];

    for(int i = 0; i < tareas.length; i++) {
      if(tareas[i].completada == 2){
        tareasCompletadas.add(tareas[i]);
      }
    }

    return tareasCompletadas;
  }


  Future<List> obtenerMultimedia(List<Pictograma> pictogramas) async{
    var api_url = 'https://api.arasaac.org/api/pictograms/';
    var imagenes = [];

    for (int i = 0 ; i < pictogramas.length; i++){
      final response = await http.get(Uri.parse(api_url + pictogramas[i].idPictograma.toString()));
      //await File('assets/temp/busq/pictograma/${pictogramas[i].idPictograma}.png').writeAsBytes(response.bodyBytes);
      imagenes.add(Uint8List.fromList(response.bodyBytes));
      //Image.memory(Uint8List.fromList(response.bodyBytes));
      //subirPictograma(new File('assets/temp/${pictogramas[i].idPictograma}.png'));
    }

    return imagenes;
  }

  Future<List> obtenerPictogramasBusqueda(String busqueda) async{

    var api_url = 'https://api.arasaac.org/api/pictograms/es/search/';
    List<Pictograma> pictogramasbusqueda = [];
    Pictograma aux;

    final response = await http.get(Uri.parse(api_url + removeDiacritics(busqueda)));

    //  El numero de items del JSON
    int longitud = convert.jsonDecode(response.body).length;

    for(int i = 0; i < longitud; i++){
      print(convert.jsonDecode(response.body)[i]['_id']);
      int idPictograma = convert.jsonDecode(response.body)[i]['_id'];
      aux = new Pictograma(idPictograma);
      pictogramasbusqueda.add(aux);
    }

    //  Obtener contenido multimedia para cada uno de los ids

    return await obtenerMultimedia(pictogramasbusqueda);
  }

  /// Función para obtener el usuario que realiza una tarea
  /// @param idAlumno id del alumno
  /// @author victor
  Future<Usuarios> getUsuarioDeTarea(int idTarea) async{

    Usuarios user;

    String query = "select * from Alumno_realiza_tarea where id_tarea = ?";
    var resultado_query = await queryBD(query,[idTarea]);
    for(int j = 0 ; j < resultado_query.length; j++) {
      String query2 = "select * from Usuarios where id_usuario = ?";
      var resultado_query2 = await queryBD(
          query2, [resultado_query.elementAt(j)['id_usuario']]);
      for (int k = 0; k < resultado_query2.length; k++) {
        user = Usuarios(
            resultado_query2.elementAt(k)['id_usuario'],
            resultado_query2.elementAt(k)['nombre'],
            resultado_query2.elementAt(k)['apellidos'],
            resultado_query2.elementAt(k)['username'],
            resultado_query2.elementAt(k)['password'],
            getEnlaceArchivoServidor(resultado_query.elementAt(k)['foto']),
            resultado_query2.elementAt(k)['tipoInfo'],
            resultado_query2.elementAt(k)['rol'],
            null,
            //  TO-DO: Notificaciones (?)
            null);
      }
    }

    return user;
  }

  /// Función para obtener los alumnos tutelados por un profesor
  /// @author victor
  Future<List<Usuarios>> getAlumnosTutelados() async{

    List<Usuarios> alumnos = [];
    String query = "select * from Usuarios where tutelado_por = ?";

    var resultado_query = await queryBD(query,[Model.usuario.idUsuario]);

    for(int i = 0; i < resultado_query.length; i++){
      alumnos.add(Usuarios(
          resultado_query.elementAt(i)['id_usuario'],
          resultado_query.elementAt(i)['nombre'],
          resultado_query.elementAt(i)['apellidos'],
          resultado_query.elementAt(i)['username'],
          resultado_query.elementAt(i)['password'],
          getEnlaceArchivoServidor(resultado_query.elementAt(i)['foto']),
          resultado_query.elementAt(i)['tipoInfo'],
          resultado_query.elementAt(i)['rol'],
          null,
          //  TO-DO: Notificaciones (?)
          null));
    }


    return alumnos;
  }

  /// Función para obtener los profesores
  /// @author victor
  Future<List<Usuarios>> getProfesores() async{

    List<Usuarios> profesores = [];
    String query = "select * from Usuarios where rol = 'profesor'";

    var resultado_query = await queryBD(query,[]);

    for(int i = 0; i < resultado_query.length; i++){
      profesores.add(Usuarios(
          resultado_query.elementAt(i)['id_usuario'],
          resultado_query.elementAt(i)['nombre'],
          resultado_query.elementAt(i)['apellidos'],
          resultado_query.elementAt(i)['username'],
          resultado_query.elementAt(i)['password'],
          getEnlaceArchivoServidor(resultado_query.elementAt(i)['foto']),
          resultado_query.elementAt(i)['tipoInfo'],
          resultado_query.elementAt(i)['rol'],
          null,
          //  TO-DO: Notificaciones (?)
          null));
    }


    return profesores;
  }

  /// Función para obtener las tareas de los alumnos tutelados por un profesor
  /// @param idAlumno id del alumno
  /// @author victor
  Future<List<Tarea>> getTareasDeTutelados() async{

    List<int> alumnos = [];
    List<Tarea> tareas = [];
    List<String> enlaces_imagenes = [];
    List<String> enlaces_imagenes_aux;
    List<String> enlaces_videos_aux;
    List<String> enlaces_audios_aux;
    List<String> enlaces_pictos = [];
    List<String> enlaces_videos = [];
    List<String> enlaces_audios = [];
    List<String> enlaces_pictos_aux;
    String enlace_foto_resultado;
    String enlace_foto_resultado_aux = null;

    String query = "select * from Usuarios where tutelado_por = ? and rol = 'alumno'";

    var resultado_query = await queryBD(query,[Model.usuario.idUsuario]);

    for(int i = 0; i < resultado_query.length; i++){
      alumnos.add(resultado_query.elementAt(i)['id_usuario']);

      String query2 = "select * from Alumno_realiza_tarea where id_usuario = ?";
      var resultado_query2 = await queryBD(query2,[resultado_query.elementAt(i)['id_usuario']]);
      for(int j = 0 ; j < resultado_query2.length; j++){

        enlaces_imagenes = [];
        enlaces_pictos = [];
        enlaces_videos = [];
        enlaces_audios = [];

        enlaces_imagenes_aux = resultado_query2.elementAt(j)['enlace_imagen'].split(',');
        enlaces_pictos_aux = resultado_query2.elementAt(j)['enlace_pictograma'].split(',');
        enlaces_videos_aux = resultado_query2.elementAt(j)['enlace_video'].split(',');
        enlaces_audios_aux = resultado_query2.elementAt(j)['enlace_audio'].split(',');
        enlace_foto_resultado_aux = resultado_query2.elementAt(j)['foto_resultado'];

        if(enlace_foto_resultado_aux != null){
          enlace_foto_resultado = getEnlaceArchivoServidor(enlace_foto_resultado_aux);
        }

        for(int l = 0 ; l  < enlaces_imagenes_aux.length ; l++){
          if(enlaces_imagenes_aux[l].isNotEmpty){
            enlaces_imagenes.add(getEnlaceArchivoServidor(enlaces_imagenes_aux[l]));
          }
        }

        for(int l = 0 ; l < enlaces_pictos_aux.length ; l++){
          if(enlaces_pictos_aux[l].isNotEmpty) {
            enlaces_pictos.add(getEnlaceArchivoServidor(enlaces_pictos_aux[l]));
          }
        }
        for(int l = 0 ; l  < enlaces_videos_aux.length ; l++){
          if(enlaces_videos_aux[l].isNotEmpty) {
            enlaces_videos.add(getEnlaceArchivoServidor(enlaces_videos_aux[l]));
          }
        }
        for(int l = 0 ; l  < enlaces_audios_aux.length ; l++){
          if(enlaces_audios_aux[l].isNotEmpty) {
            enlaces_audios.add(getEnlaceArchivoServidor(enlaces_audios_aux[l]));
          }
        }

        DateTime f_ini = resultado_query2.elementAt(j)['fecha_inicio'];
        DateTime f_fin = resultado_query2.elementAt(j)['fecha_fin'];
        int duracion = f_fin.difference(f_ini).inDays;;

        tareas.add(new Tarea(
          resultado_query2.elementAt(j)['id_tarea'],
          resultado_query2.elementAt(j)['nombreTarea'],
          resultado_query2.elementAt(j)['completada'],
          resultado_query2.elementAt(j)['descripcion'],
          duracion,
          f_ini,
          f_fin,
          enlaces_videos,
          enlaces_imagenes,
          enlaces_audios,
          null,
          enlaces_pictos,
          stringToTipoTarea(resultado_query2.elementAt(j)['tipo']),
          null,
          resultado_query2.elementAt(j)['id_usuario'],
          enlace_foto_resultado,)
        );

      }
    }

    return tareas;
  }


  String removeDiacritics(String str) {
    var withDia = 'ÀÁÂÃÄÅàáâãäåÒÓÔÕÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿýŽž';
    var withoutDia = 'AAAAAAaaaaaaOOOOOOOooooooEEEEeeeeeCcDIIIIiiiiUUUUuuuuNnSsYyyZz';

    for (int i = 0; i < withDia.length; i++) {
      str = str.replaceAll(withDia[i], withoutDia[i]);
    }

    return str;
  }

  Future<Results> postRetroalimentacion(int idTarea, int idUsuario, String descripcionRetroalimentacion, int completada, int calificacion, List<ImageDataItem> pictograma, int mostrarCalificacion) async{
    String url_pictograma = '';

    if(pictograma.length != 0){

        if(url_pictograma.length == 0){
          url_pictograma = url_pictograma + (await subirPictograma(File(pictograma[0].url))).split('\"localhost')[1].split('\",')[0];
        }
        else {
          url_pictograma = url_pictograma + ',' + (await subirPictograma(File(pictograma[0].url))).split('\"localhost')[1].split('\",')[0];
        }

    }

    String query2 = 'insert into Retroalimentacion (descripcion, calificacion, pictograma, mostrar_calificacion) values(?,?,?,?)';

    Results r2 = await queryBD(query2, [descripcionRetroalimentacion, calificacion.toString(), url_pictograma, mostrarCalificacion.toString() ]);

    Results r3 = await queryBD(' SELECT MAX( id_retroalimentacion ) FROM Retroalimentacion;', []);

    print(r3.elementAt(0)['MAX( id_retroalimentacion )']);

    String query = "update Alumno_realiza_tarea set id_retroalimentacion = ? where id_usuario = ? and id_tarea = ?";

    Results r = await queryBD(query, [r3.elementAt(0)['MAX( id_retroalimentacion )'],idUsuario,idTarea]);

    String query3 = "update Alumno_realiza_tarea set completada = ? where id_usuario = ? and id_tarea = ?";

    Results r4 = await queryBD(query3, [completada == 1 && descripcionRetroalimentacion.isNotEmpty ? 2 : completada,idUsuario,idTarea]);

    return r4;
  }


  Future<String> subirFotoResultado(int idTarea, int idUsuario, File foto)  async{
    var url = 'http://${IP}:3000';
    bool resultado = false;
    String link;

    var request = new http.MultipartRequest("POST", Uri.parse(url));
    request.files.add(await http.MultipartFile.fromPath('file', foto.path));
    request.send().then((response) async {
      if (response.statusCode == 200) {
        await foto.delete();
        Map<String, dynamic> json = convert.jsonDecode(await response.stream.bytesToString());
        link = json['downloadLink'].toString().replaceAll('localhost', '');

        String query = 'update Alumno_realiza_tarea set foto_resultado = ? where id_usuario = ? and id_tarea = ?';
        List<String> valores = [link, idUsuario.toString(), idTarea.toString()];
        Results r = await queryBD(query, valores);
        if(r.isEmpty) resultado = true;
      }
    }
    );

    return link;
  }

  Future<Results> marcarTareaCompletada(int idTarea, int idUsuario, int completada) async{

    String query = 'update Alumno_realiza_tarea set completada = ? where id_usuario = ? and id_tarea = ?';

    Results r = await queryBD(query, [completada,idUsuario,idTarea]);

    return r;
  }

  Future<List<Tarea>> getTareasAlumnoCompletadas({int idUsuario}) async{

    List<Tarea> tareas = [];
    List<String> enlaces_imagenes = [];
    List<String> enlaces_imagenes_aux;
    List<String> enlaces_videos_aux;
    List<String> enlaces_audios_aux;
    List<String> enlaces_pictos = [];
    List<String> enlaces_videos = [];
    List<String> enlaces_audios = [];
    List<String> enlaces_pictos_aux;

    String query = "select * from Alumno_realiza_tarea where id_usuario = ? and completada = 2";
    var resultado_query = await queryBD(query,[Model.usuario.idUsuario]);
    for(int j = 0 ; j < resultado_query.length; j++){

      enlaces_imagenes = [];
      enlaces_pictos = [];
      enlaces_videos = [];
      enlaces_audios = [];

      enlaces_imagenes_aux = resultado_query.elementAt(j)['enlace_imagen'].split(',');
      enlaces_pictos_aux = resultado_query.elementAt(j)['enlace_pictograma'].split(',');
      enlaces_videos_aux = resultado_query.elementAt(j)['enlace_video'].split(',');
      enlaces_audios_aux = resultado_query.elementAt(j)['enlace_audio'].split(',');

      for(int l = 0 ; l  < enlaces_imagenes_aux.length ; l++){
        if(enlaces_imagenes_aux[l].isNotEmpty){
          enlaces_imagenes.add(getEnlaceArchivoServidor(enlaces_imagenes_aux[l]));
        }
      }

      for(int l = 0 ; l < enlaces_pictos_aux.length ; l++){
        if(enlaces_pictos_aux[l].isNotEmpty) {
          enlaces_pictos.add(getEnlaceArchivoServidor(enlaces_pictos_aux[l]));
        }
      }
      for(int l = 0 ; l  < enlaces_videos_aux.length ; l++){
        if(enlaces_videos_aux[l].isNotEmpty) {
          enlaces_videos.add(getEnlaceArchivoServidor(enlaces_videos_aux[l]));
        }
      }
      for(int l = 0 ; l  < enlaces_audios_aux.length ; l++){
        if(enlaces_audios_aux[l].isNotEmpty) {
          enlaces_audios.add(getEnlaceArchivoServidor(enlaces_audios_aux[l]));
        }
      }

      DateTime f_ini = resultado_query.elementAt(j)['fecha_inicio'];
      DateTime f_fin = resultado_query.elementAt(j)['fecha_fin'];
      int duracion = f_fin.difference(f_ini).inDays;;

      tareas.add(Tarea(
        resultado_query.elementAt(j)['id_tarea'],
        resultado_query.elementAt(j)['nombreTarea'],
        resultado_query.elementAt(j)['completada'],
        resultado_query.elementAt(j)['descripcion'],
        duracion,
        f_ini,
        f_fin,
        enlaces_videos,
        enlaces_imagenes,
        enlaces_audios,
        null,
        enlaces_pictos,
        stringToTipoTarea(resultado_query.elementAt(j)['tipo']),
        await getRetroalimentacionAlumno(resultado_query.elementAt(j)['id_retroalimentacion']),
        resultado_query.elementAt(j)['id_usuario'],
      null
      ));
    }

    tareas.sort(compararFechaFinal);
    return tareas;
  }

  int compararFechaInicio(Tarea a, Tarea b) {
    final propertyA = a.fecha_inicio;
    final propertyB = b.fecha_inicio;
    if (propertyA.isBefore(propertyB) ) {
      return -1;
    } else if (propertyA.isAfter(propertyB) ) {
      return 1;
    } else {
      return 0;
    }
  }

  int compararFechaFinal(Tarea a, Tarea b) {
    final propertyA = a.fecha_fin;
    final propertyB = b.fecha_fin;
    if (propertyA.isAfter(propertyB) ) {
      return -1;
    } else if (propertyA.isBefore(propertyB) ) {
      return 1;
    } else {
      return 0;
    }
  }

  Future<List<Tarea>> getTareasAlumno({int idUsuario}) async{

    List<Tarea> tareas = [];
    List<String> enlaces_imagenes = [];
    List<String> enlaces_imagenes_aux;
    List<String> enlaces_videos_aux;
    List<String> enlaces_audios_aux;
    List<String> enlaces_pictos = [];
    List<String> enlaces_videos = [];
    List<String> enlaces_audios = [];
    List<String> enlaces_pictos_aux;
    String enlace_resultado = null;
    String enlace_resultado_aux = null;

    String query = "select * from Alumno_realiza_tarea where id_usuario = ? and completada <> 2";
    var resultado_query = await queryBD(query,[Model.usuario.idUsuario]);
    for(int j = 0 ; j < resultado_query.length; j++){

      enlaces_imagenes = [];
      enlaces_pictos = [];
      enlaces_videos = [];
      enlaces_audios = [];

      enlaces_imagenes_aux = resultado_query.elementAt(j)['enlace_imagen'].split(',');
      enlaces_pictos_aux = resultado_query.elementAt(j)['enlace_pictograma'].split(',');
      enlaces_videos_aux = resultado_query.elementAt(j)['enlace_video'].split(',');
      enlaces_audios_aux = resultado_query.elementAt(j)['enlace_audio'].split(',');
      enlace_resultado_aux = resultado_query.elementAt(j)['foto_resultado'];

      if(enlace_resultado_aux != null){
        enlace_resultado = getEnlaceArchivoServidor(enlace_resultado_aux);
      }

      for(int l = 0 ; l  < enlaces_imagenes_aux.length ; l++){
        if(enlaces_imagenes_aux[l].isNotEmpty){
          enlaces_imagenes.add(getEnlaceArchivoServidor(enlaces_imagenes_aux[l]));
        }
      }

      for(int l = 0 ; l < enlaces_pictos_aux.length ; l++){
        if(enlaces_pictos_aux[l].isNotEmpty) {
          enlaces_pictos.add(getEnlaceArchivoServidor(enlaces_pictos_aux[l]));
        }
      }
      for(int l = 0 ; l  < enlaces_videos_aux.length ; l++){
        if(enlaces_videos_aux[l].isNotEmpty) {
          enlaces_videos.add(getEnlaceArchivoServidor(enlaces_videos_aux[l]));
        }
      }
      for(int l = 0 ; l  < enlaces_audios_aux.length ; l++){
        if(enlaces_audios_aux[l].isNotEmpty) {
          enlaces_audios.add(getEnlaceArchivoServidor(enlaces_audios_aux[l]));
        }
      }

      DateTime f_ini = resultado_query.elementAt(j)['fecha_inicio'];
      DateTime f_fin = resultado_query.elementAt(j)['fecha_fin'];
      int duracion = f_fin.difference(f_ini).inDays;;

      tareas.add(Tarea(
          resultado_query.elementAt(j)['id_tarea'],
          resultado_query.elementAt(j)['nombreTarea'],
          resultado_query.elementAt(j)['completada'],
          resultado_query.elementAt(j)['descripcion'],
          duracion,
          f_ini,
          f_fin,
          enlaces_videos,
          enlaces_imagenes,
          enlaces_audios,
          null,
          enlaces_pictos,
          stringToTipoTarea(resultado_query.elementAt(j)['tipo']),
          null,
          resultado_query.elementAt(j)['id_usuario'],
          enlace_resultado));
    }

    tareas.sort(compararFechaInicio);
    return tareas;
  }

  Future<Tarea> getTareaAlumno(int idTarea) async{


    List<String> enlaces_imagenes = [];
    List<String> enlaces_imagenes_aux;
    List<String> enlaces_videos_aux;
    List<String> enlaces_audios_aux;
    List<String> enlaces_pictos = [];
    List<String> enlaces_videos = [];
    List<String> enlaces_audios = [];
    List<String> enlaces_pictos_aux;
    String enlace_resultado = null;
    String enlace_resultado_aux = null;

    String query = "select * from Alumno_realiza_tarea where id_usuario = ? and id_tarea = ?";
    var resultado_query = await queryBD(query,[Model.usuario.idUsuario, idTarea]);


      enlaces_imagenes = [];
      enlaces_pictos = [];
      enlaces_videos = [];
      enlaces_audios = [];

      enlaces_imagenes_aux = resultado_query.elementAt(0)['enlace_imagen'].split(',');
      enlaces_pictos_aux = resultado_query.elementAt(0)['enlace_pictograma'].split(',');
      enlaces_videos_aux = resultado_query.elementAt(0)['enlace_video'].split(',');
      enlaces_audios_aux = resultado_query.elementAt(0)['enlace_audio'].split(',');
      enlace_resultado_aux = resultado_query.elementAt(0)['foto_resultado'];

      if(enlace_resultado_aux != null){
        enlace_resultado = getEnlaceArchivoServidor(enlace_resultado_aux);
      }

      for(int l = 0 ; l  < enlaces_imagenes_aux.length ; l++){
        if(enlaces_imagenes_aux[l].isNotEmpty){
          enlaces_imagenes.add(getEnlaceArchivoServidor(enlaces_imagenes_aux[l]));
        }
      }

      for(int l = 0 ; l < enlaces_pictos_aux.length ; l++){
        if(enlaces_pictos_aux[l].isNotEmpty) {
          enlaces_pictos.add(getEnlaceArchivoServidor(enlaces_pictos_aux[l]));
        }
      }
      for(int l = 0 ; l  < enlaces_videos_aux.length ; l++){
        if(enlaces_videos_aux[l].isNotEmpty) {
          enlaces_videos.add(getEnlaceArchivoServidor(enlaces_videos_aux[l]));
        }
      }
      for(int l = 0 ; l  < enlaces_audios_aux.length ; l++){
        if(enlaces_audios_aux[l].isNotEmpty) {
          enlaces_audios.add(getEnlaceArchivoServidor(enlaces_audios_aux[l]));
        }
      }

      DateTime f_ini = resultado_query.elementAt(0)['fecha_inicio'];
      DateTime f_fin = resultado_query.elementAt(0)['fecha_fin'];
      int duracion = f_fin.difference(f_ini).inDays;;

      Tarea tarea  = Tarea(
          resultado_query.elementAt(0)['id_tarea'],
          resultado_query.elementAt(0)['nombreTarea'],
          resultado_query.elementAt(0)['completada'],
          resultado_query.elementAt(0)['descripcion'],
          duracion,
          f_ini,
          f_fin,
          enlaces_videos,
          enlaces_imagenes,
          enlaces_audios,
          null,
          enlaces_pictos,
          stringToTipoTarea(resultado_query.elementAt(0)['tipo']),
          null,
          resultado_query.elementAt(0)['id_usuario'],
          enlace_resultado);

    return tarea;
  }

  Future<Emoticono> getEmoticono(int idEmoticono) async{

    Retroalimentacion retro;

    String query = "select * from Emoticono where id_emoticono = ?";
    var resultado_query = await queryBD(query,[idEmoticono]);

    String enlace_imagen;
    String enlace_imagen_aux = null;
    enlace_imagen_aux = resultado_query.elementAt(0)['enlace_imagen'];

    if(enlace_imagen_aux != null){
      enlace_imagen = getEnlaceArchivoServidor(enlace_imagen_aux);
    }

    return Emoticono(
      resultado_query.elementAt(0)['id_emoticono'],
      enlace_imagen,

    );


  }


  /// Función para eliminar un item
  /// @param idItem id del item
  /// @author amanda
  Future<Results> eliminarMaterial(int idItem) async{

    String query = 'delete from Item where id_item = ?';

    List valores = [idItem];
    Results r = await queryBD(query, valores);

    return r;


  }

  /// Función para obtener todas los items del inventario
  /// @author amanda
  Future<List<Item>> getAllItems() async{

    List<Item> items = [];

    String picto = null;
    String picto_aux = null;

    String query = "select * from Item";

    var resultado_query = await queryBD(query, []);





    for(int i = 0; i < resultado_query.length; i++){

      picto_aux = resultado_query.elementAt(i)['pictograma'];

      if(picto_aux != null){
        picto = getEnlaceArchivoServidor(picto_aux);
      }

      items.add(
          Item(
              resultado_query.elementAt(i)['id_item'],
              resultado_query.elementAt(i)['nombre'],
              resultado_query.elementAt(i)['cantidad'],
              picto
          )
      );
    }

    return items;

  }

  /// Función para obtener todas los items del inventario
  /// @author amanda
  Future<Item> getItem(int idItem) async{

    String picto = null;
    String picto_aux = null;

    String query = "select * from Item where id_item = ?";

    var resultado_query = await queryBD(query, [idItem]);

    picto_aux = resultado_query.elementAt(0)['pictograma'];

    if(picto_aux != null){
      picto = getEnlaceArchivoServidor(picto_aux);
    }



      Item item =
          Item(
              resultado_query.elementAt(0)['id_item'],
              resultado_query.elementAt(0)['nombre'],
              resultado_query.elementAt(0)['cantidad'],
              picto
          );


    return item;

  }

  /// Función para editar el nombre de una tarea
  /// @param newNombre nuevo nombre de la tarea
  /// @param idTarea id de la Tarea
  /// @author amanda
  Future<Results> editarNombreItem(String newNombre, int idItem) async{

    String query = 'update Item set nombre = ? where id_item = ?';

    List valores = [newNombre, idItem];
    Results r = await queryBD(query, valores);

    return r;

  }

  /// Función para editar el nombre de una tarea
  /// @param newNombre nuevo nombre de la tarea
  /// @param idTarea id de la Tarea
  /// @author amanda
  Future<Results> editarCantidadItem(int cantidad, int idItem) async{

    String query = 'update Item set cantidad = ? where id_item = ?';

    List valores = [cantidad, idItem];
    Results r = await queryBD(query, valores);

    return r;

  }

  /// Función para editar un item
  /// @param idItem id del item
  /// @param nombre el nombre de item
  /// @param cantidad del item
  /// @author amanda
  Future<Results> editarMaterial(int idItem, String nombre, int cantidad, List<ImageDataItem> pictograma) async{

    Item item = await getItem(idItem);
    Results r;

    String url_pictograma = '';



    if(item.nombre != nombre)
      await editarNombreItem(nombre, idItem);

    if(item.cantidad != cantidad)
      await editarCantidadItem(cantidad, idItem);

    if(pictograma.length > 0){
      for(int i = 0; i < pictograma.length; i++){
        if(url_pictograma.length == 0){
          url_pictograma = url_pictograma + (!pictograma[i].url.contains('http') ? (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0] : pictograma[i].url.substring(pictograma[i].url.indexOf(':3000')));
        }
        else {
          url_pictograma = url_pictograma + ',' + (!pictograma[i].url.contains('http') ? (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0] : pictograma[i].url.substring(pictograma[i].url.indexOf(':3000')));
        }
      }
    }

    String query2 = "update Item set pictograma = ? where id_item = ?";
    List<String> valores = [url_pictograma, idItem.toString()];
    Results r2 = await queryBD(query2, valores);

    return r;

  }



  /// Función para subir una tarea a la base de datos
  /// @param idTarea id de la Tarea
  /// @param nombre el nombre de la tarea
  /// @param descripcion la descripcion de la tareao
  /// @param duracion la duracion de la tarea
  /// @param imagenes imagenes añadidas a la tarea
  /// @param pictogramas pictogramas añadidos a la tarea
  /// @author amanda
  Future<Results> postItem(String nombre, int cantidad,  List<ImageDataItem> pictograma) async{


    String url_pictograma = '';

    if(url_pictograma.length == 0){
      for(int i = 0; i < pictograma.length; i++){
        if(url_pictograma.length == 0){
          url_pictograma = url_pictograma + (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0];
        }
        else {
          url_pictograma = url_pictograma + ',' + (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0];
        }
      }
    }

    String query = "";

    String query2 = "insert into Item (nombre, cantidad, pictograma) values(?,?,?)";
    List<String> valores = [nombre,cantidad.toString(),url_pictograma];
    Results r = await queryBD(query2, valores);

    return r;
  }

  /// Función para obtener todos los posibles chats en función del identificador del usuario.
  /// @author alejandro hens
  /// @params idUsuario id del usuario
  Future<List<Usuarios>> getPosiblesChats(int idUsuario) async {
    List<Usuarios> posibles_chats = [];

    String query = "select * from Usuarios where id_usuario = ?";

    var resultado_query_rol_usuario = await queryBD(query, [idUsuario]);

    String rol = resultado_query_rol_usuario.elementAt(0)['rol'];

    if(rol == "alumno"){
      // Consulta a la BD para obtener los profesores que le imparten clase al alumno

      String query2 = "select * from Profesor_imparte_clases_alumnos where id_alumno = ?";

      var resultado_query_profesores = await queryBD(query2, [idUsuario]);

      for(int i = 0; i<resultado_query_profesores.length; i++){
        int id_profesor = resultado_query_profesores.elementAt(i)['id_profesor'];
        String query3 = "select * from Usuarios where id_usuario = ?";

        var resultado_query_consulta_profesor = await queryBD(query3, [id_profesor]);

        Usuarios contacto_chat = Usuarios(
            resultado_query_consulta_profesor.elementAt(0)['id_usuario'],
            resultado_query_consulta_profesor.elementAt(0)['nombre'],
            resultado_query_consulta_profesor.elementAt(0)['apellidos'],
            resultado_query_consulta_profesor.elementAt(0)['username'],
            resultado_query_consulta_profesor.elementAt(0)['password'],
            resultado_query_consulta_profesor.elementAt(0)['foto'],
            resultado_query_consulta_profesor.elementAt(0)['tipoInfo'],
            resultado_query_consulta_profesor.elementAt(0)['rol'],
            null,
            null
        );

        posibles_chats.add(contacto_chat);
      }

    }

    else{
      // Consulta a la BD para obtener a todos los profesores y a los alumnos a los que el profesor imparete clases

      // Comenzamos con los alumnos a los que imparte clases
      String query4 = "select * from Profesor_imparte_clases_alumnos where id_profesor = ?";

      var resultado_query_alumnos = await queryBD(query4, [idUsuario]);

      print(resultado_query_alumnos.toString());

      for(int i = 0; i<resultado_query_alumnos.length; i++){
        int id_alumno = resultado_query_alumnos.elementAt(i)['id_alumno'];
        String query5 = "select * from Usuarios where id_usuario = ?";

        var resultado_query_consulta_alumno = await queryBD(query5, [id_alumno]);


        Usuarios contacto_chat = Usuarios(
            resultado_query_consulta_alumno.elementAt(0)['id_usuario'],
            resultado_query_consulta_alumno.elementAt(0)['nombre'],
            resultado_query_consulta_alumno.elementAt(0)['apellidos'],
            resultado_query_consulta_alumno.elementAt(0)['username'],
            resultado_query_consulta_alumno.elementAt(0)['password'],
            resultado_query_consulta_alumno.elementAt(0)['foto'],
            resultado_query_consulta_alumno.elementAt(0)['tipoInfo'],
            resultado_query_consulta_alumno.elementAt(0)['rol'],
            null,
            null
        );

        posibles_chats.add(contacto_chat);
      }

      // Continuamos con el resto de profesores
      String query6 = "select * from Usuarios where id_usuario != ? and rol = 'profesor'";

      var resultado_query_alumnos_aux = await queryBD(query6, [idUsuario]);

      print(resultado_query_alumnos_aux.toString());

      for(int i = 0; i<resultado_query_alumnos_aux.length; i++){

        Usuarios contacto_chat = Usuarios(
            resultado_query_alumnos_aux.elementAt(i)['id_usuario'],
            resultado_query_alumnos_aux.elementAt(i)['nombre'],
            resultado_query_alumnos_aux.elementAt(i)['apellidos'],
            resultado_query_alumnos_aux.elementAt(i)['username'],
            resultado_query_alumnos_aux.elementAt(i)['password'],
            resultado_query_alumnos_aux.elementAt(i)['foto'],
            resultado_query_alumnos_aux.elementAt(i)['tipoInfo'],
            resultado_query_alumnos_aux.elementAt(i)['rol'],
            null,
            null
        );

        print(contacto_chat.nombre);

        posibles_chats.add(contacto_chat);
      }
    }

    return posibles_chats;
  }

  Future<String> getPhotoName(String name) async {
    String query = "select * from Usuarios where nombre = ?";

    var resultados_query_photo = await queryBD(query, [name]);

    String res = resultados_query_photo.elementAt(0)['foto'];

    return res;
  }

  ///Función para obtener todos los mensajes de un chat determinado
  /// @author alejandro hens
  /// @params idEmisor e idReceptor, identificadores del emisor y receptor del mensaje
  Future<List<MensajeChat>> getMensajesChat(int idEmisor, int idReceptor) async {
    List<MensajeChat> mensajes = [];

    String query = "select * from Usuario_envia_mensaje_usuario where id_emisor = ? and id_receptor = ?";

    var resultado_query_mensajes = await queryBD(query, [idEmisor, idReceptor]);

    String query3 = "select * from Usuarios where id_usuario = ?";
    var resultado_query_emisor = await queryBD(query3, [idEmisor]);

    for(int i = 0; i<resultado_query_mensajes.length; i++){
      int id_mensaje = resultado_query_mensajes.elementAt(i)['id_mensaje'];

      String query2 = "select * from Mensajes where id_mensaje = ?";
      var resultado_query_consulta_mensaje = await queryBD(query2, [id_mensaje]);

      MensajeChat nuevo_mensaje = MensajeChat(
        text: resultado_query_consulta_mensaje.elementAt(0)['contenido_mensaje'],
        name: resultado_query_emisor.elementAt(0)['nombre'],
        animationController: null,
      );

      mensajes.insert(0, nuevo_mensaje);
    }

    return mensajes;
  }

  /// Función para obtener la personalizacion de un alumno
  /// @author angel
  void crearUsuario(String nombre, String apellidos, String username, ImageDataItem imagen, String password, String dni, String rol, String tipoInfo, String profesorTutelado) async{

    String url_imagenes = '';

    url_imagenes = (await subirPictograma(File(imagen.url))).split('\"localhost')[1].split('\",')[0];

    String query = "insert into Usuarios (nombre, apellidos, foto, username, password, dni, rol, tipoInfo, tutelado_por) values (?,?,?,?,?,?,?,?,?)";
    List<String> valores = [nombre, apellidos, url_imagenes, username, password, dni, rol, tipoInfo, profesorTutelado ];
    await queryBD(query, valores);

    if(rol == 'alumno') {
      String query2 = "select id_usuario from Usuarios where nombre = ? and apellidos = ?";
      List<String> valores2 = [nombre, apellidos];
      Results r = await queryBD(query2, valores2);

      String query3 = "INSERT INTO Alumnos (id_alumno) VALUES (?)";
      List<String> valores3 = [r.elementAt(0)['id_usuario'].toString(),];
      await queryBD(query3, valores3);

      String query4 = "INSERT INTO Personalizacion (idUsuario, homepage_reloj, tam_texto, texto_en_pictogramas, opciones_homepage, homepage_elementos, tareas_elementos_pp, pictograma_tareas, pictograma_notificaciones, pictograma_chats, pictograma_historial) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
      List<String> valores4 = [r.elementAt(0)['id_usuario'].toString(),'1','0','1','tareas,chats,notificaciones,historial,','4','0','','','',''];
      await queryBD(query4, valores4);
    }

  }

  /// Función para obtener la personalizacion de un alumno
  /// @author angel
  Future<Personalizacion> getPersonalizacion(int idAlumno) async{

    Results p;
    List<OpcionesHomepage> listaOpciones = [];
    String query = "select * from Personalizacion where idUsuario = ?";

    p = await queryBD(query,[idAlumno]);

    for (int i = 0; i < p.elementAt(0)["opciones_homepage"].split(',').length - 1; i++){
      listaOpciones.add(new OpcionesHomepage("", p.elementAt(0)["opciones_homepage"].split(',')[i]));
    }


    Personalizacion devolver = new Personalizacion(
        p.elementAt(0)["homepage_reloj"],
        p.elementAt(0)["tam_texto"],
        p.elementAt(0)["texto_en_pictogramas"],
        listaOpciones,
        p.elementAt(0)["homepage_elementos"],
        p.elementAt(0)["tareas_elementos_pp"],
        p.elementAt(0)["pictograma_tareas"],
        p.elementAt(0)["pictograma_notificaciones"],
        p.elementAt(0)["pictograma_chats"],
        p.elementAt(0)["pictograma_historial"]
    );

    return devolver;
  }

  /// Función para obtener la lista de usuarios para el admin
  /// @author angel
  Future<List<Usuarios>> getUsuarios() async{

    List<Usuarios> usuarios = [];
    String query = "select * from Usuarios where id_usuario <> 7";

    var resultado_query = await queryBD(query,[]);


    for(int i = 0; i < resultado_query.length; i++){
      usuarios.add(Usuarios(
          resultado_query.elementAt(i)['id_usuario'],
          resultado_query.elementAt(i)['nombre'],
          resultado_query.elementAt(i)['apellidos'],
          resultado_query.elementAt(i)['username'],
          resultado_query.elementAt(i)['password'],
          getEnlaceArchivoServidor(resultado_query.elementAt(i)['foto']),
          resultado_query.elementAt(i)['tipoInfo'],
          resultado_query.elementAt(i)['rol'],
          null,
          //  TO-DO: Notificaciones (?)
          null));
    }
    return usuarios;
  }


  /// Función para actualizar la personalización de un alumno
  /// @author angel
  void setPersonalizacion(int id_usuario, int homepage_reloj, int tam_texto, String opciones_homepage, int texto_en_pictogramas, int homepage_elementos ) async{

    String query = 'update Personalizacion set homepage_reloj = ?, tam_texto = ?, opciones_homepage = ?, texto_en_pictogramas = ?, homepage_elementos = ? where idUsuario = ?';

    List<String> valores = [homepage_reloj.toString(), tam_texto.toString(), opciones_homepage, texto_en_pictogramas.toString(), homepage_elementos.toString(), id_usuario.toString()];
    Results r = await queryBD(query, valores);
  }

  /// Función para actualizar los datos de un usuario
  /// @author angel
  void setUsuario(int id_usuario, String nombre, String apellidos, String username, String rol, String tipoInfo, String profeTutelado) async{

    String query = 'update Usuarios set nombre = ?, apellidos = ?, username = ?, rol = ?, tipoInfo = ?, tutelado_por = ? where id_usuario = ?';

    List<String> valores = [nombre,apellidos ,username,rol,tipoInfo,id_usuario.toString(), profeTutelado];
    Results r = await queryBD(query, valores);


  }

  /// Función para eliminar un usuario
  /// @author victor
  Future<Results> eliminarUsuario(Usuarios user) async{

    if(user.getRol() == tipoUsuario.ALUMNO) {
      String query = 'delete from Alumnos where id_alumno = ?';

      List valores = [user.idUsuario];
      Results r = await queryBD(query, valores);

      String query2 = 'delete from Personalizacion where idUsuario = ?';

      List valores2 = [user.idUsuario];
      Results r2 = await queryBD(query2, valores2);

      String query3 = 'delete from Usuarios where id_usuario = ?';

      List valores3 = [user.idUsuario];
      Results r3 = await queryBD(query3, valores3);
      return r3;
    }
    else{
      String query4 = 'delete from Usuarios where id_usuario = ?';

      List valores4 = [user.idUsuario];
      Results r4 = await queryBD(query4, valores4);
      return r4;
    }
  }

  tipoPlato stringToTipoPlato(String tipo){
    switch(tipo){
      case ('primero'):
        return tipoPlato.PRIMERO;
        break;
      case ('segundo'):
        return tipoPlato.SEGUNDO;
        break;
      case ('postre'):
        return tipoPlato.POSTRE;
        break;

    }
  }

  /// Función para eliminar un item
  /// @param idItem id del item
  /// @author amanda
  Future<Results> eliminarPlato(int idPlato) async{

    String query = 'delete from Platos where id_plato = ?';

    List valores = [idPlato];
    Results r = await queryBD(query, valores);

    return r;


  }

  /// Función para eliminar un item
  /// @param idItem id del item
  /// @author amanda
  Future<Results> eliminarMenu(int idMenu) async{

    String query = 'delete from Menu where id_menu = ?';

    List valores = [idMenu];
    Results r = await queryBD(query, valores);

    return r;


  }

  /// Función para subir una tarea a la base de datos
  /// @param idTarea id de la Tarea
  /// @param nombre el nombre de la tarea
  /// @param descripcion la descripcion de la tareao
  /// @param duracion la duracion de la tarea
  /// @param imagenes imagenes añadidas a la tarea
  /// @param pictogramas pictogramas añadidos a la tarea
  /// @author amanda
  Future<Results> postPlato(String nombre, String tipo, List<ImageDataItem> pictograma) async{


    String url_pictograma = '';

    if(url_pictograma.length == 0){
      for(int i = 0; i < pictograma.length; i++){
        if(url_pictograma.length == 0){
          url_pictograma = url_pictograma + (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0];
        }
        else {
          url_pictograma = url_pictograma + ',' + (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0];
        }
      }
    }

    String query = "";

    String query2 = "insert into Platos (nombre, tipo, pictograma) values(?,?,?)";
    List<String> valores = [nombre,tipo,url_pictograma];
    Results r = await queryBD(query2, valores);

    return r;
  }


  /// Función para subir una tarea a la base de datos
  /// @param idTarea id de la Tarea
  /// @param nombre el nombre de la tarea
  /// @param descripcion la descripcion de la tareao
  /// @param duracion la duracion de la tarea
  /// @param imagenes imagenes añadidas a la tarea
  /// @param pictogramas pictogramas añadidos a la tarea
  /// @author amanda
  Future<Results> postMenu(String nombre, int idPlato1, int idPlato2, int idPostre, int cantidad) async{


    String query = "";

    String query2 = "insert into Menu (nombre, id_plato_primero, id_plato_segundo, id_plato_postre, cantidad) values(?,?,?,?,?)";
    List<String> valores = [nombre,idPlato1.toString(),idPlato2.toString(),idPostre.toString(),cantidad.toString()];
    Results r = await queryBD(query2, valores);

    return r;
  }


  /// Función para editar un item
  /// @param idItem id del item
  /// @param nombre el nombre de item
  /// @param cantidad del item
  /// @author amanda
  Future<Results> editarPlato(int idPlato, String nombre, String tipo, List<ImageDataItem> pictograma) async{

    Results r;

    String url_pictograma = '';


    if(pictograma.length > 0){
      for(int i = 0; i < pictograma.length; i++){
        if(url_pictograma.length == 0){
          url_pictograma = url_pictograma + (!pictograma[i].url.contains('http') ? (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0] : pictograma[i].url.substring(pictograma[i].url.indexOf(':3000')));
        }
        else {
          url_pictograma = url_pictograma + ',' + (!pictograma[i].url.contains('http') ? (await subirPictograma(File(pictograma[i].url))).split('\"localhost')[1].split('\",')[0] : pictograma[i].url.substring(pictograma[i].url.indexOf(':3000')));
        }
      }
    }

    String query2 = "update Platos set pictograma = ?, nombre = ?, tipo = ? where id_plato = ?";
    List<String> valores = [url_pictograma, nombre, tipo, idPlato.toString()];
    r = await queryBD(query2, valores);

    return r;

  }

  /// Función para editar un item
  /// @param idItem id del item
  /// @param nombre el nombre de item
  /// @param cantidad del item
  /// @author amanda
  Future<Results> editarMenu(int idMenu, String nombre, int idPlato1, int idPlato2, int idPostre, int cantidad) async{

    Results r;


    String query2 = "update Menu set nombre = ?, id_plato_primero = ?, id_plato_segundo = ?, id_plato_postre = ?, cantidad = ? where id_menu = ?";
    List<String> valores = [nombre, idPlato1.toString(), idPlato2.toString(), idPostre.toString(), cantidad.toString(), idMenu.toString()];
    r = await queryBD(query2, valores);

    return r;

  }

  /// Función para editar un item
  /// @param idItem id del item
  /// @param nombre el nombre de item
  /// @param cantidad del item
  /// @author amanda
  Future<Results> editarCantidadMenu(int idMenu, int cantidad) async{

    Results r;


    String query2 = "update Menu cantidad = ? where id_plato = ?";
    List<String> valores = [cantidad.toString(), idMenu.toString()];
    r = await queryBD(query2, valores);

    return r;

  }

  /// Función para obtener todas los items del inventario
  /// @author amanda
  Future<Platos> getPlato(int idPlato) async{

    String picto = null;
    String picto_aux = null;

    String query = "select * from Platos where id_plato = ?";

    var resultado_query = await queryBD(query, [idPlato]);

    picto_aux = resultado_query.elementAt(0)['pictograma'];

    if(picto_aux != null){
      picto = getEnlaceArchivoServidor(picto_aux);
    }



    Platos plato =
    Platos(
        resultado_query.elementAt(0)['id_plato'],
        resultado_query.elementAt(0)['nombre'],
        stringToTipoPlato(resultado_query.elementAt(0)['tipo']),
        picto
    );


    return plato;

  }


  /// Función para obtener todas los items del inventario
  /// @author amanda
  Future<Menus> getMenu(int idMenu) async{



    String query = "select * from Menu where id_menu = ?";

    var resultado_query = await queryBD(query, [idMenu]);



    Menus menu =
    Menus(
        resultado_query.elementAt(0)['id_menu'],
        resultado_query.elementAt(0)['nombre'],
        resultado_query.elementAt(0)['cantidad'],
        [resultado_query.elementAt(0)['id_plato_primero'],resultado_query.elementAt(0)['id_plato_segundo'],resultado_query.elementAt(0)['id_plato_postre']]
    );


    return menu;

  }

  /// Función para obtener todas los items del inventario
  /// @author amanda
  Future<List<Platos>> getAllPlatosTipo(String tipo) async{

    List<Platos> platos = [];

    String picto = null;
    String picto_aux = null;

    String query = "select * from Platos";

    var resultado_query = await queryBD(query, []);


    for(int i = 0; i < resultado_query.length; i++){

      picto_aux = resultado_query.elementAt(i)['pictograma'];

      if(picto_aux != null){
        picto = getEnlaceArchivoServidor(picto_aux);
      }

      if(resultado_query.elementAt(i)['tipo'] == tipo) {
        platos.add(Platos(
            resultado_query.elementAt(i)['id_plato'],
            resultado_query.elementAt(i)['nombre'],
            stringToTipoPlato(resultado_query.elementAt(i)['tipo']),
            picto));
      }
    }

    return platos;

  }

  /// Función para obtener todas los items del inventario
  /// @author amanda
  Future<List<Platos>> getAllPlatos() async{

    List<Platos> platos = [];

    String picto = null;
    String picto_aux = null;

    String query = "select * from Platos";

    var resultado_query = await queryBD(query, []);


    for(int i = 0; i < resultado_query.length; i++){

      picto_aux = resultado_query.elementAt(i)['pictograma'];

      if(picto_aux != null){
        picto = getEnlaceArchivoServidor(picto_aux);
      }

      platos.add(
          Platos(
              resultado_query.elementAt(i)['id_plato'],
              resultado_query.elementAt(i)['nombre'],
              stringToTipoPlato(resultado_query.elementAt(i)['tipo']),
              picto
          )
      );
    }

    return platos;

  }

  /// Función para obtener todas los items del inventario
  /// @author amanda
  Future<List<Menus>> getAllMenus() async{

    List<Menus> menus = [];



    String query = "select * from Menu";

    var resultado_query = await queryBD(query, []);


    for(int i = 0; i < resultado_query.length; i++){
      Platos plato1 = await getPlato(resultado_query.elementAt(i)['id_plato_primero']);
      Platos plato2 = await getPlato(resultado_query.elementAt(i)['id_plato_segundo']);
      Platos plato3 = await getPlato(resultado_query.elementAt(i)['id_plato_postre']);

      menus.add(
          Menus(
              resultado_query.elementAt(i)['id_menu'],
              resultado_query.elementAt(i)['nombre'],
              resultado_query.elementAt(i)['cantidad'],
              [plato1,plato2,plato3]
          )
      );
    }

    return menus;

  }


}