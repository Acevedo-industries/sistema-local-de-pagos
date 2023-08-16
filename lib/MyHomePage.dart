import 'package:flutter/material.dart';

import 'HomeScreen.dart';
import 'TablasTequios.dart';
import 'TablasPrediales.dart';
import 'RegisterScreen.dart';
import 'SettingScreen.dart';
import 'NoDataFoundScreen.dart';
import 'LoginScreen.dart';
import 'ChangePasswordScreen.dart';

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;

    if (selectedIndex == 0) {
      page = HomeScreenMain();
    } else if (selectedIndex == 1) {
      page = TablasTequios();
    } else if (selectedIndex == 2) {
      page = TablasPrediales();
    } else if (selectedIndex == 3) {
      page = RegisterScreen();
    } else if (selectedIndex == 4) {
      page = SettingScreen();
    } else if (selectedIndex == 5) {
      page = LoginScreen();
      Navigator.pop(context);
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
                  NavigationRailDestination(
                    icon: Icon(Icons.verified_user),
                    label: Text('Crear usuario'),
                  ),
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
