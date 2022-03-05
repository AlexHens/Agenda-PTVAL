import 'package:agendaptval/flutter_flow/flutter_flow_theme.dart';
import 'package:agendaptval/vistas/Menu_admin/lista_menus.dart';
import 'package:agendaptval/vistas/Menu_admin/lista_platos.dart';
import 'package:flutter/material.dart';


class SeccionMenuAdminWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            toolbarHeight: 75,
            backgroundColor: FlutterFlowTheme.laurelGreen,
            shadowColor: FlutterFlowTheme.laurelGreen,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  indicatorColor: FlutterFlowTheme.laurelGreenDarker,
                  labelColor: Colors.black,
                  tabs: [
                    new Tab(text: 'Menús',icon: new Icon(Icons.fastfood_sharp, color: Colors.black,), ),
                    new Tab(text: 'Platos',icon: new Icon(Icons.restaurant, color: Colors.black,), )
                  ],
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              ListaMenusWidget(),
              ListaPlatosWidget(),
            ],
          ),
        ),
      ),
    );
  }
}