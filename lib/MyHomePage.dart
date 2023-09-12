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
import 'CreatePredial.dart';
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

    if (globals.intRol == 3) {
      if (selectedIndex == 0) {
        page = HomeScreenMain();
      } else if (selectedIndex == 1) {
        page = HomeScreenMain();
      } else if (selectedIndex == 2) {
        page = TablasTequios();
      } else if (selectedIndex == 3) {
        page = TablasPrediales();
      } else if (selectedIndex == 4) {
        page = SettingScreen();
      } else if (selectedIndex == 5) {
        page = LoginScreen();
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else {
          exit(0);
        }
        //Navigator.pop(context);
      } else {
        page = NoDataFoundScreen();
      }
    } else if (globals.intRol == 2) {
      if (selectedIndex == 0) {
        page = HomeScreenMain();
      } else if (selectedIndex == 1) {
        page = HomeScreenMain();
      } else if (selectedIndex == 2) {
        page = TablasTequios();
      } else if (selectedIndex == 3) {
        page = CreateTequioScreen();
      } else if (selectedIndex == 4) {
        page = TablasPrediales();
      } else if (selectedIndex == 5) {
        page = CreatePredialScreen();
      } else if (selectedIndex == 6) {
        page = SettingScreen();
      } else if (selectedIndex == 7) {
        page = LoginScreen();
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else {
          exit(0);
        }
        //Navigator.pop(context);
      } else {
        page = NoDataFoundScreen();
      }
    } else {
      if (selectedIndex == 0) {
        page = HomeScreenMain();
      } else if (selectedIndex == 1) {
        page = HomeScreenMain();
      } else if (selectedIndex == 2) {
        page = TablasTequios();
      } else if (selectedIndex == 3) {
        page = CreateTequioScreen();
      } else if (selectedIndex == 4) {
        page = TablasPrediales();
      } else if (selectedIndex == 5) {
        page = CreatePredialScreen();
      } else if (selectedIndex == 6) {
        page = RegisterScreen();
      } else if (selectedIndex == 7) {
        page = PasswordChangeScreen();
      } else if (selectedIndex == 8) {
        page = SettingScreen();
      } else if (selectedIndex == 9) {
        page = LoginScreen();
        if (Platform.isAndroid) {
          SystemNavigator.pop();
        } else {
          exit(0);
        }
        //Navigator.pop(context);
      } else {
        page = NoDataFoundScreen();
      }
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
                  if (globals.intRol <= 3)
                    NavigationRailDestination(
                      icon: Icon(Icons.search),
                      label: Text('Buscar'),
                    ),
                  if (globals.intRol <= 3)
                    NavigationRailDestination(
                      icon: Icon(Icons.card_membership),
                      label: Text('Tequios'),
                    ),
                  if (globals.intRol <= 2)
                    NavigationRailDestination(
                      icon: Icon(Icons.add_box_rounded),
                      label: Text('Registrar nuevo Tequio'),
                    ),
                  if (globals.intRol <= 3)
                    NavigationRailDestination(
                      icon: Icon(Icons.card_membership),
                      label: Text('Prediales'),
                    ),
                  if (globals.intRol <= 2)
                    NavigationRailDestination(
                      icon: Icon(Icons.add_box_rounded),
                      label: Text('Registrar nuevo Predial'),
                    ),
                  if (globals.intRol <= 1)
                    NavigationRailDestination(
                      icon: Icon(Icons.supervised_user_circle_rounded),
                      label: Text('Crear usuario'),
                    ),
                  if (globals.intRol <= 1)
                    NavigationRailDestination(
                      icon: Icon(Icons.verified_user),
                      label: Text('Cambiar contraseña'),
                    ),
                  if (globals.intRol <= 3)
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
