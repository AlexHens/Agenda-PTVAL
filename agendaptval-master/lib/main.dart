
import 'package:agendaptval/vistas/homepage/alumnos/home_page_alu_widget.dart';
import 'package:agendaptval/vistas/homepage/profesores/home_page_prof_widget.dart';
import 'package:agendaptval/vistas/login_prof_widget.dart';
import 'package:agendaptval/modeloControlador/tipoUsuario.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'package:responsive_framework/utils/scroll_behavior.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'modeloControlador/controller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool resultado = await haIniciadoSesionAntes();

  runApp(MyApp(resultado));
}

/// Función que determina si el usuario había iniciado ya antes sesión en la aplicación,
/// cargando su modelo asociado.
/// @return variable que indica si se había iniciado sesión antes
/// @author victor
Future<bool> haIniciadoSesionAntes() async {
  bool resultado = false;
  SharedPreferences prefs = await SharedPreferences.getInstance();

  print('Ha iniciado sesión antes? ' + prefs.containsKey('UserAgendaPTVAL').toString());

  if(await prefs.containsKey('UserAgendaPTVAL')) {

    String username = prefs.getString('UserAgendaPTVAL');
    String password = prefs.getString('PassAgendaPTVAL');

    Controller con = new Controller();
    await con.iniciarSesion(username,password);

    resultado = true;
  }

  return resultado;
}

class MyApp extends StatelessWidget{
  bool expr;

  MyApp(this.expr);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MiAgendaPTVAL',
      builder: (context, widget) => ResponsiveWrapper.builder(
        ClampingScrollWrapper.builder(context, widget),
        breakpoints: const [
          ResponsiveBreakpoint.resize(350, name: MOBILE),
          ResponsiveBreakpoint.autoScale(600, name: TABLET),
          ResponsiveBreakpoint.resize(800, name: DESKTOP),
          ResponsiveBreakpoint.autoScale(1700, name: 'XL'),
        ],
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('es', 'ES')],
      theme: ThemeData(primarySwatch: Colors.blue),
      home: _decideMainPage(this.expr),
      debugShowCheckedModeBanner: false,
    );
  }

  /// Función que decide qué página debe mostrarse al comienzo de la aplicación.
  /// Lo usamos para mostrar según qué pantalla en función de un rol preasignado.
  /// @param expr variable condicional que nos indica si la persona se había identificado previamente
  /// @return el Widget que se va a mostrar
  /// @author victor
  _decideMainPage(bool expr) {
    if (expr) {
      if (Model.usuario.getRol() == tipoUsuario.ALUMNO) {
        return HomePageAluWidget();
      }
      else if(Model.usuario.getRol() == tipoUsuario.PROFESOR || Model.usuario.getRol() == tipoUsuario.ADMINISTRADOR) {
        return HomePageProfWidget();
      }
    } else {
      return LoginWidget();
    }
  }


}
