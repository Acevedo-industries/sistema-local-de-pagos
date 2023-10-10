import 'package:app/components/LoadMessage.dart';
import 'package:app/components/SuccessMessage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'PagoState.dart';
import 'components/ErrorMessage.dart';
import 'components/Offline.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PagoState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: SettingScreenView(),
      ),
    );
  }
}

class SettingScreenView extends StatefulWidget {
  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreenView> {
  bool buttonEnable = true;

  void _changedButtonEnable(bool value) {
    setState(() {
      buttonEnable = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<PagoState>();

    ((value) => {
          if (value != null) {_changedButtonEnable(true)}
        })(appState.backupProcess.mystate);

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffffffff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Configuracion",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            color: Color(0xff000000),
          ),
        ),
        leading: Icon(
          Icons.menu,
          color: Color(0xff212435),
          size: 24,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      MaterialButton(
                        onPressed: () {
                          _changedButtonEnable(false);
                          appState.createBackupData();
                        },
                        color: Color(0xffffffff),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(color: Color(0xff808080), width: 1),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        textColor: Color(0xff000000),
                        height: 40,
                        minWidth: 0,
                        child: Text(
                          buttonEnable
                              ? " Descargar copia de la Base de Datos "
                              : "Descargando ... ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      SizedBox(height: 25), // Espacio entre los botones
                      MaterialButton(
                        onPressed: () {
                          _changedButtonEnable(false);
                          appState.createDumpSql();
                        },
                        color: Color(0xffffffff),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(color: Color(0xff808080), width: 1),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        textColor: Color(0xff000000),
                        height: 40,
                        minWidth: 0,
                        child: Text(
                          buttonEnable
                              ? " Descargar Base de Datos en SQL "
                              : "Creando ... ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                      SizedBox(height: 25), // Espacio entre los botones
                      MaterialButton(
                        onPressed: () {
                          _changedButtonEnable(false);
                          appState.createDumpExcel();
                        },
                        color: Color(0xffffffff),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                          side: BorderSide(color: Color(0xff808080), width: 1),
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        textColor: Color(0xff000000),
                        height: 40,
                        minWidth: 0,
                        child: Text(
                          buttonEnable
                              ? "Descargar Base de Datos en Excel"
                              : "Creando ... ",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            if (buttonEnable == false && appState.backupProcess.mystate == null)
              LoadMessage("Descargando una copia de los datos ..."),
            if (appState.backupProcess.mystate == true)
              SuccessMessage(appState.backupProcess.message.toString()),
            if (appState.backupProcess.mystate == false)
              ErrorMessage(appState.backupProcess.message.toString()),
          ],
        ),
      ),
    );
  }
}
