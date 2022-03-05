import 'package:agendaptval/flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

import 'lista_tareas_prof_completadas_widget.dart';
import 'lista_tareas_prof_pendientes_widget.dart';
import 'lista_tareas_prof_revision_widget.dart';

class ListaTareasProfWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
      length: 3,
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
                  new Tab(text: 'En progreso',icon: new Icon(Icons.loop, color: Colors.black,), ),
                  new Tab(text: 'Revisar',icon: new Icon(Icons.assignment_turned_in, color: Colors.black,), ),
                  new Tab(text: 'Completadas',icon: new Icon(Icons.done_all, color: Colors.black,), ),
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ListaTareasProfPendientesWidget(),
            ListaTareasProfRevisionWidget(),
            ListaTareasProfCompletadasWidget(),
          ],
        ),
      ),
    ),
    );
  }
}