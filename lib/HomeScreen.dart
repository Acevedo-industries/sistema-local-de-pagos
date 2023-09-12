import 'package:app/components/ErrorMessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'PagoState.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:app/DataCard.dart';

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
        home: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final myController = TextEditingController(text: "Albertha Navarro Flores");

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<PagoState>();

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
        leading: Icon(
          Icons.menu,
          color: Color(0xff212435),
          size: 24,
        ),
        actions: [
          Icon(Icons.search, color: Color(0xff212435), size: 24),
        ],
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
                    appState.queryByName(myController.text);
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
                    "Buscar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
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
