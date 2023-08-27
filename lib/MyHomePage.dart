import 'package:flutter/material.dart';

import 'HomeScreen.dart';
import 'TablasTequios.dart';
import 'TablasPrediales.dart';
import 'RegisterScreen.dart';
import 'SettingScreen.dart';
import 'NoDataFoundScreen.dart';
import 'LoginScreen.dart';
import 'ChangePasswordScreen.dart';
import 'globals.dart' as globals;

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    Widget page;

    int exitValue = globals.enablefield ? 6 : 4;

    if (selectedIndex == 0) {
      page = HomeScreenMain();
    } else if (selectedIndex == 1) {
      page = HomeScreenMain();
    } else if (selectedIndex == 2) {
      page = TablasTequios();
    } else if (selectedIndex == 3) {
      page = TablasPrediales();
    } else if (selectedIndex == exitValue) {
      page = LoginScreen();
      Navigator.pop(context);
    } else if (selectedIndex == 4) {
      page = RegisterScreen();
    } else if (selectedIndex == 5) {
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
                    label: Text(globals.userLogged.username ?? ''),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.search),
                    label: Text('Buscar'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.card_membership),
                    label: Text('Tequios'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.card_membership),
                    label: Text('Prediales'),
                  ),
                  if (globals.enablefield)
                    NavigationRailDestination(
                      icon: Icon(Icons.verified_user),
                      label: Text('Crear usuario'),
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
