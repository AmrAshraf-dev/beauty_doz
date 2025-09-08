import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    // THIS IS DEAFUIL //
    default:
      return MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Text('No path for ${settings.name}'),
          ),
        ),
      );
  }
}

Future<dynamic> push(BuildContext context, Widget page,
    {bool replace = false, int delay}) async {
  if (delay != null) await Future.delayed(Duration(milliseconds: delay), () {});
  final route = MaterialPageRoute(builder: (c) => page);

  return replace
      ? await Navigator.pushReplacement(context, route)
      : await Navigator.push(context, route);
}

Future<dynamic> pushReplaceAll(BuildContext context, Widget page,
    {int delay}) async {
  if (delay != null) await Future.delayed(Duration(milliseconds: delay), () {});
  return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => page),
      (Route<dynamic> route) => false);
}
