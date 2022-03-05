import '../flutter_flow/flutter_flow_theme.dart';
import 'package:flutter/material.dart';

class Unimplemented extends StatefulWidget {
  const Unimplemented({Key key}) : super(key: key);

  @override
  _UnimplementedState createState() => _UnimplementedState();
}

class _UnimplementedState extends State<Unimplemented> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Align(
                alignment: AlignmentDirectional(0.05, 1),
                child: Icon(
                  Icons.warning,
                  color: Color(0xFFAB9F3D),
                  size: 200,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: AlignmentDirectional(0.05, -1),
                child: Text(
                  'No Implementado',
                  style: FlutterFlowTheme.title1,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [],
            )
          ],
        ),
      ),
    );
  }
}
