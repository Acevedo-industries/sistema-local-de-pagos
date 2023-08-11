import 'package:flutter/material.dart';

import 'HomeScreen.dart';
import 'Tablas.dart';
import 'RegisterScreen.dart';
import 'SettingScreen.dart';
import 'NoDataFoundScreen.dart';
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
      page = Tablas();
    } else if (selectedIndex == 2) {
      page = RegisterScreen();
    } else if (selectedIndex == 3) {
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
                    icon: Icon(Icons.home),
                    label: Text('Buscar'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Tablas'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Crear usuario'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Configuracion'),
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
