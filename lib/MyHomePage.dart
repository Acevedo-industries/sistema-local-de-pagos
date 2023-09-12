import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'HomeScreen.dart';
import 'TablasTequios.dart';
import 'TablasPrediales.dart';
import 'RegisterScreen.dart';
import 'SettingScreen.dart';
import 'NoDataFoundScreen.dart';
import 'LoginScreen.dart';
import 'PasswordChangeScreen.dart';
import 'globals.dart' as globals;
import 'CreateTequio.dart';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    Widget page;

    int exitValue = globals.enablefield ? 9 : 4;
    int predialesVale = globals.enablefield ? 4 : 3;

    if (selectedIndex == 0) {
      page = HomeScreenMain();
    } else if (selectedIndex == 1) {
      page = HomeScreenMain();
    } else if (selectedIndex == 2) {
      page = TablasTequios();
    } else if (selectedIndex == 3) {
      page = CreateTequioScreen();
    } else if (selectedIndex == predialesVale) {
      page = TablasPrediales();
    } else if (selectedIndex == exitValue) {
      page = LoginScreen();
      if (Platform.isAndroid) {
        SystemNavigator.pop();
      } else {
        exit(0);
      }
      //Navigator.pop(context);
    } else if (selectedIndex == 6) {
      page = RegisterScreen();
    } else if (selectedIndex == 7) {
      page = PasswordChangeScreen();
    } else if (selectedIndex == 8) {
      page = SettingScreen();
    } else {
      page = NoDataFoundScreen();
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.account_circle),
                    label: Text(globals.userLogged?.username ?? 'Desconocido'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.search),
                    label: Text('Buscar'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.card_membership),
                    label: Text('Tequios'),
                  ),
                  if (globals.enablefield)
                    NavigationRailDestination(
                      icon: Icon(Icons.add_box_rounded),
                      label: Text('Registrar nuevo Tequio'),
                    ),
                  NavigationRailDestination(
                    icon: Icon(Icons.card_membership),
                    label: Text('Prediales'),
                  ),
                  if (globals.enablefield)
                    NavigationRailDestination(
                      icon: Icon(Icons.add_box_rounded),
                      label: Text('Registrar nuevo Predial'),
                    ),
                  if (globals.enablefield)
                    NavigationRailDestination(
                      icon: Icon(Icons.supervised_user_circle_rounded),
                      label: Text('Crear usuario'),
                    ),
                  if (globals.enablefield)
                    NavigationRailDestination(
                      icon: Icon(Icons.verified_user),
                      label: Text('Cambiar contraseña'),
                    ),
                  if (globals.enablefield)
                    NavigationRailDestination(
                      icon: Icon(Icons.construction_sharp),
                      label: Text('Configuracion'),
                    ),
                  NavigationRailDestination(
                    icon: Icon(Icons.exit_to_app),
                    label: Text('Salir'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}
