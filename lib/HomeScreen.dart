import 'package:app/components/ErrorMessage.dart';
import 'package:app/components/NoResult.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'PagoState.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app/DataCard.dart';

import 'components/LoadMessage.dart';

class HomeScreenMain extends StatelessWidget {
  const HomeScreenMain({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => PagoState(),
      child: MaterialApp(
        title: 'Namer App',
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          Locale('mex', ''), //code
          Locale('es', ''),
        ],
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: HomeScreenView(),
      ),
    );
  }
}

class HomeScreenView extends StatefulWidget {
  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreenView> {
  final myController = TextEditingController(text: "");

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
        })(appState.searchProcess.mystate);

    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0x00ffffff),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        title: Text(
          "Buscar",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 20,
            color: Color(0xff000000),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              margin: EdgeInsets.all(0),
              padding: EdgeInsets.all(0),
              width: 400,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0x1fffffff),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.zero,
                border: Border.all(color: Color(0x4d9e9e9e), width: 1),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: Text(
                          "Nombre: ",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: TextField(
                          autofocus: true,
                          onSubmitted: (value) {
                            if (myController.text.trim().isNotEmpty) {
                              _changedButtonEnable(false);
                              appState.queryByName(myController.text);
                            }
                          },
                          textInputAction: TextInputAction.search,
                          controller:
                              myController, //.text= "Albertha Navarro Flores",
                          obscureText: false,
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                          decoration: InputDecoration(
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                  color: Color(0x00000000), width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                  color: Color(0x00000000), width: 1),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide(
                                  color: Color(0x00000000), width: 1),
                            ),
                            filled: true,
                            fillColor: Color(0xfff2f2f3),
                            isDense: false,
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 10),
              child: Align(
                alignment: Alignment(0.7, 0.0),
                child: MaterialButton(
                  onPressed: () {
                    if (myController.text.trim().isNotEmpty) {
                      _changedButtonEnable(false);
                      appState.queryByName(myController.text);
                    }
                  },
                  color: Color(0xffff5630),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  padding: EdgeInsets.all(16),
                  textColor: Color(0xffffffff),
                  height: 40,
                  minWidth: 140,
                  child: Text(
                    buttonEnable ? "Buscar" : "Buscando ... ",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ),
            ),
            if (appState.readFromServer == false)
              Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "* Está leyendo los datos de la copia que obtuvo de la base de datos, esta información puede NO estar actualizada",
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontStyle: FontStyle.normal,
                      fontSize: 14,
                      color: Color(0xff7a0606),
                    ),
                  ),
                ),
              ),
            ListView(
              scrollDirection: Axis.vertical,
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.zero,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Align(alignment: Alignment.center),
                          if (!buttonEnable)
                            LoadMessage(
                                "Buscando ${myController.text} en la base de datos ...")
                          else if (appState.searchProcess.message ==
                                  "noEncontrado" &&
                              appState.searchProcess.mystate == false)
                            NoResult(
                                "No se encontro ningun registro en la base de datos \n que coincida con alguna de las variaciones del texto buscado: \n\n '${myController.text}' ")
                          else if (appState.searchProcess.message == "error" &&
                              appState.searchProcess.mystate == false)
                            ErrorMessage(
                                "Hubo un error al realizar la busqueda, por favor verifique los datos o intente mas tarde.")
                          else
                            for (var pago in appState.pagoList)
                              pago.tipo != null
                                  ? DataCard(pago: pago)
                                  : ErrorMessage(pago.nombre.toString())
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
