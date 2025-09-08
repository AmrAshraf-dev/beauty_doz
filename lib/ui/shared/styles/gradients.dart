import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'colors.dart';

class Gradients {
  static const Gradient primaryGradient = LinearGradient(
      colors: [Color(0xff353b3f), Color(0xff191a1d)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter);
  static const secandaryGradient = LinearGradient(
      colors: [Color(0xffFBFBFC), Color(0xffD3DAE7)],
      stops: [0, 1],
      begin: Alignment(-1.00, 0.00),
      end: Alignment(1.00, -0.00));

  static const sideBlackGradient = LinearGradient(
      colors: [Color(0xff191a1d), Color(0xff353b3f)],
      stops: [0, 1],
      begin: Alignment(-1.00, 0.00),
      end: Alignment(1.00, -0.00));

  static const fireGradient = LinearGradient(
      colors: [Color(0xffe0530a), Color(0xffbd2310)],
      stops: [0, 1],
      begin: Alignment(-1.00, 0.00),
      end: Alignment(1.00, -0.00));
  static const accentGradient = LinearGradient(
      colors: [AppColors.accentText, AppColors.ternaryBackground],
      stops: [0, 1],
      begin: Alignment(-1.00, 0.00),
      end: Alignment(1.00, -0.00));
  static LinearGradient blueGradient = LinearGradient(colors: [
    Colors.lightBlue.withOpacity(.7),
    Colors.lightBlue.withOpacity(.9)
  ], stops: [
    0,
    1
  ], begin: Alignment(-1.00, 0.00), end: Alignment(1.00, -0.00));
  static const backGroundfireGradient = LinearGradient(
      colors: [Color(0xffbd2310), Color(0xffe0530a)],
      stops: [0, 1],
      begin: Alignment(-1.00, 0.00),
      end: Alignment(1.00, -0.00));
}
