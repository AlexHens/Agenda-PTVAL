import 'dart:io';
import 'dart:typed_data';

import 'package:agendaptval/flutter_flow/flutter_flow_theme.dart';
import 'package:agendaptval/flutter_flow/random_number.dart';
import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mvc_pattern/mvc_pattern.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';


const List<Color> colors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
];

class ArasaacWidget extends StatefulWidget {
  ArasaacWidget({Key key}) : super(key: key);

  @override
  _ArasaacWidgetState createState() => _ArasaacWidgetState();

}

class _ArasaacWidgetState extends StateMVC {
  TextEditingController textController;
  TextEditingController _textFieldController = TextEditingController();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);
  Color pickerColor = Color(0xff443a49);
  ValueChanged<Color> onColorChanged;
  List<Color> pickerColors = [];
  ValueChanged<List<Color>> onColorsChanged;
  List<Color> colorHistory = [];
  int _portraitCrossAxisCount = 4;
  double _borderRadius = 30;
  double _blurRadius = 5;
  double _iconSize = 24;
  Color colorSeleccionado = Colors.white;
  String codeDialog;
  String valueText;

  _ArasaacWidgetState(): super(Controller()){
    _con = Controller.con;
  }
  Controller _con;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  // ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  String obtainHexFromColor(Color color){
    return color.toString().split('x')[1].substring(2,8);
  }

  Widget pickerLayoutBuilder(BuildContext context, List<Color> colors, PickerItem child) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return SizedBox(
      width: 300,
      height: orientation == Orientation.portrait ? 360 : 240,
      child: GridView.count(
        crossAxisCount: _portraitCrossAxisCount,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: [for (Color color in colors) child(color)],
      ),
    );
  }

  Widget pickerItemBuilder(Color color, bool isCurrentColor, void Function() changeColor) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_borderRadius),
        color: color,
        boxShadow: [BoxShadow(color: color.withOpacity(0.8), offset: const Offset(1, 2), blurRadius: _blurRadius)],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: (){
            colorSeleccionado = color;
            Navigator.pop(context);
            setState(() {

            });
          },
          borderRadius: BorderRadius.circular(_borderRadius),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isCurrentColor ? 1 : 0,
            child: Icon(
              Icons.done,
              size: _iconSize,
              color: useWhiteForeground(color) ? Colors.white : Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        openCloseDial: isDialOpen,
        backgroundColor: Colors.redAccent,
        overlayColor: Colors.grey,
        overlayOpacity: 0.5,
        spacing: 15,
        spaceBetweenChildren: 15,
        closeManually: true,
        children: [
          SpeedDialChild(
              child: Icon(Icons.palette),
              label: 'Color de fondo',
              //backgroundColor: Colors.blue,
              onTap: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Selecciona un color de fondo'),
                      content: SingleChildScrollView(
                        child: BlockPicker(
                          pickerColor: pickerColor,
                          onColorChanged: onColorChanged,
                          availableColors: colors,
                          layoutBuilder: pickerLayoutBuilder,
                          itemBuilder: pickerItemBuilder,
                        ),
                      ),
                    );
                  },
                );
                isDialOpen.value = false;
                print('Share Tapped');
              }
          ),
          SpeedDialChild(
              child: Icon(Icons.text_fields),
              label: 'Texto en Pictograma',
              onTap: (){
                isDialOpen.value = false;
                print('Mail Tapped');
              }
          ),
        ],
      ),
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.laurelGreen,
        automaticallyImplyLeading: true,
        title: Text(
          'Selección de Pictograma',
          style: FlutterFlowTheme.title1
        ),
        iconTheme: new IconThemeData(color: Colors.black),
        actions: [],
        centerTitle: true,
        elevation: 4,
      ),
      backgroundColor: FlutterFlowTheme.tertiaryColor,
      body: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Color(0xFFEEEEEE),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding:
                              EdgeInsetsDirectional.fromSTEB(4, 0, 4, 0),
                              child: Icon(
                                Icons.search_rounded,
                                color: Color(0xFF95A1AC),
                                size: 24,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                                child: TextField(
                                  controller: textController,
                                  obscureText: false,
                                  onSubmitted: (value) {
                                    print("search: ${value}");
                                    setState(() {

                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Búsqueda en Arasaac',
                                    labelStyle:
                                    FlutterFlowTheme.bodyText1.override(
                                      fontFamily: 'Lexend Deca',
                                      color: Color(0xFF95A1AC),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    enabledBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                    ),
                                  ),
                                  style: FlutterFlowTheme.bodyText1.override(
                                    fontFamily: 'Lexend Deca',
                                    color: Color(0xFF95A1AC),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              textController.text.isNotEmpty ?
              Expanded(
                child: FutureBuilder<List>(
                  future: _con.obtenerPictogramasBusqueda(textController.text),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);

                    return snapshot.hasData
                        ?
                    GridView.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        itemCount: snapshot.data.length,
                        itemBuilder: (BuildContext ctx, index) {
                          return GestureDetector(
                              onTap: () async {

                                await showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Nombre del pictograma'),
                                        content: TextField(
                                          onChanged: (value) {
                                            setState(() {
                                              valueText = value;
                                            });
                                          },
                                          controller: _textFieldController,
                                          decoration: InputDecoration(),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            child: Text('Cancelar'),
                                            onPressed: () {
                                              setState(() {
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),
                                          TextButton(
                                            child: Text('OK'),
                                            onPressed: () {
                                              setState(() {
                                                codeDialog = valueText;
                                                Navigator.pop(context);
                                              });
                                            },
                                          ),

                                        ],
                                      );
                                    });

                                Uint8List imageInUnit8List = snapshot.data[index];// store unit8List image here ;
                                final tempDir = await getTemporaryDirectory();
                                File file = await File('${tempDir.path}/${randomNumber.generate()}.png').create();
                                file.writeAsBytesSync(imageInUnit8List);
                                Navigator.pop(context, file);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Image.memory(snapshot.data[index]),
                                decoration: BoxDecoration(
                                    color: colorSeleccionado,
                                    borderRadius: BorderRadius.circular(15)),
                              )
                          );
                        }
                    )
                        : new Center(child: Container(
                    child: SpinKitRotatingCircle(
                    color: FlutterFlowTheme.laurelGreen,
                      size: 50.0,
                    ),
                    ));
                  },
                ),
              ) :
              Expanded(child: Center(child: Container(
                child: Text('Busca un término para seleccionar un pictograma', style: FlutterFlowTheme.subtitle1),
              ),))
            ],
          )
        ],
      ),
    );
  }
}
