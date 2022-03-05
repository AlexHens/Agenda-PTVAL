import 'package:agendaptval/modeloControlador/controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: avoid_classes_with_only_static_members
class FlutterFlowTheme {
  static const Color primaryColor = Color(0xFF3474E0);
  static const Color secondaryColor = Color(0xFFEE8B60);
  static const Color secondaryColorDarker = Color(0xFF87330e);
  static const Color tertiaryColor = Color(0xFFFFFFFF);

  static const Color cultured = Color(0xFFF8F8F8);
  static const Color teaGreen = Color(0xFFC5EBC3);
  static const Color laurelGreen = Color(0xFFB7C8B5);
  static const Color laurelGreenDarker = Color(0xFF546D51);
  static const Color lilac = Color(0xFFC2A5C0);
  static const Color malachite = Color(0xFF66E671);
  static const Color vividTangerine = Color(0xFFFFA18A);

  static const Color shyGrey = Color(0x5B9C9C9C);

  String primaryFontFamily = 'Roboto';

  static TextStyle get title1 => GoogleFonts.getFont(
        'Roboto',
        color: Color(0xFF000000),
        fontWeight: FontWeight.w600,
        fontSize: Model.personalizacion != null ? Model.personalizacion.tamTexto.toDouble() + 24 : 24,
      );

  static TextStyle get title2 => GoogleFonts.getFont(
        'Roboto',
        color: Color(0xFF000000),
        fontWeight: FontWeight.w500,
        fontSize: Model.personalizacion != null ? Model.personalizacion.tamTexto.toDouble() + 22 : 22,
      );
  static TextStyle get title3 => GoogleFonts.getFont(
        'Roboto',
        color: Color(0xFF000000),
        fontWeight: FontWeight.w500,
        fontSize: Model.personalizacion != null ? Model.personalizacion.tamTexto.toDouble() + 20 : 20,
      );
  static TextStyle get subtitle1 => GoogleFonts.getFont(
        'Roboto',
        color: Color(0xFF000000),
        fontWeight: FontWeight.w500,
        fontSize: Model.personalizacion != null ? Model.personalizacion.tamTexto.toDouble() + 18 : 18,
      );
  static TextStyle get subtitle2 => GoogleFonts.getFont(
        'Roboto',
        color: Color(0xFF000000),
        fontWeight: FontWeight.normal,
        fontSize: Model.personalizacion != null ? Model.personalizacion.tamTexto.toDouble() + 16 : 16,
      );
  static TextStyle get bodyText1 => GoogleFonts.getFont(
        'Roboto',
        color: Color(0xFF000000),
        fontWeight: FontWeight.normal,
        fontSize: Model.personalizacion != null ? Model.personalizacion.tamTexto.toDouble() + 22 : 22,
      );
  static TextStyle get bodyText2 => GoogleFonts.getFont(
        'Roboto',
        color: Color(0xFF000000),
        fontWeight: FontWeight.w500,
        fontSize: Model.personalizacion != null ? Model.personalizacion.tamTexto.toDouble() + 18 : 18,
      );

  static TextStyle get pictogramas => TextStyle(
    fontFamily: 'Escolar',
    color: Color(0xFF000000),
    fontWeight: FontWeight.w800,
    fontSize: Model.personalizacion != null ? Model.personalizacion.tamTexto.toDouble() + 24 : 24,
  );

  static TextStyle get pictogramasBody => TextStyle(
    fontFamily: 'Escolar',
    color: Color(0xFF000000),
    fontWeight: FontWeight.w800,
    fontSize: Model.personalizacion != null ? Model.personalizacion.tamTexto.toDouble() + 22 : 22,
  );

  static TextStyle get tareasPasosEscolar => TextStyle(
    fontFamily: 'Escolar',
    color: Color(0xFF000000),
    fontWeight: FontWeight.w800,
    fontSize: Model.personalizacion != null ? Model.personalizacion.tamTexto.toDouble() + 40 : 40,
  );
}

extension TextStyleHelper on TextStyle {
  TextStyle override({
    String fontFamily,
    Color color,
    double fontSize,
    FontWeight fontWeight,
    FontStyle fontStyle,
    bool useGoogleFonts = true,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily,
              color: color ?? this.color,
              fontSize: fontSize ?? this.fontSize,
              fontWeight: fontWeight ?? this.fontWeight,
              fontStyle: fontStyle ?? this.fontStyle,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
            );
}
