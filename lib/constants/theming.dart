import 'package:flutter/material.dart';

const kBackgroundColor =  Color.fromRGBO(255, 255, 255, 1.0);
const kPrimaryColor = Color.fromRGBO(26, 67, 78, 1);
const ksecondaryHeaderColor = Color.fromRGBO(245, 239, 230, 1);
const kPrimaryLightColor = Color.fromRGBO(79, 137, 159, 1.0);
String uri= 'http://192.168.1.109:8585'; //10.42.0.107

const appBarGradient = LinearGradient(
  colors: [

    Color.fromRGBO(26, 67, 78, 1),
    Color.fromRGBO(26, 67, 78, 0.5745098039215686),

  ],
  stops: [0.5 ,1.0],
);


List<Color> backgroundColors = [
  const Color(0xFFCCE5FF), // light blue
  const Color(0xFFD7F9E9), // pale green
  const Color(0xFFFFF8E1), // pale yellow
  const Color(0xFFF5E6CC), // beige
  const Color(0xFFFFD6D6), // light pink
  const Color(0xFFE5E5E5), // light grey
  const Color(0xFFFFF0F0), // pale pink
  const Color(0xFFE6F9FF), // pale blue
  const Color(0xFFD4EDDA), // mint green
  const Color(0xFFFFF3CD), // pale orange
];