import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'PagoState.dart';
import 'Pago.dart';
import 'package:date_format/date_format.dart';
import 'globals.dart' as globals;

class HomeScreenMain extends StatelessWidget {
  const HomeScreenMain({super.key});

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
                  child: Text(
                    "Buscar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  textColor: Color(0xffffffff),
                  height: 40,
                  minWidth: 140,
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
                            DataCard(pago: pago)
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

class DataCard extends StatelessWidget {
  DataCard({
    super.key,
    required this.pago,
  });

  final Pago pago;

  Map<String, Color> datacolor = {
    'predial': Color(0xffaddb65),
    'tequio': Color(0xff6580db),
    'nada': Color(0xff6580db),
  };

  bool enablefield = globals.enablefield;

  String fechaString(DateTime? value) {
    print("value,,,,,,,,,,,,,,,,  $value");
    if (value != null) {
      return formatDate(value, [yyyy, '-', mm, '-', dd]);
    } else {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4),
      color: datacolor[pago.tipo ?? 'nada'],
      shadowColor: Color(0xff000000),
      elevation: 40,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              Align(
                alignment: Alignment(-0.0, 0.0),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 2, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          pago.tipo ?? '',
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      "Nombre:  ",
                                      textAlign: TextAlign.start,
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontStyle: FontStyle.normal,
                                        fontSize: 14,
                                        color: Color(0xff000000),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: TextField(
                                        enabled: enablefield,
                                        controller: TextEditingController(),
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
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide(
                                                color: Color(0x80000000),
                                                width: 1),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide(
                                                color: Color(0x80000000),
                                                width: 1),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            borderSide: BorderSide(
                                                color: Color(0x80000000),
                                                width: 1),
                                          ),
                                          filled: true,
                                          labelText: pago.nombre ?? '',
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
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  "Fecha:     ",
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.clip,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14,
                                    color: Color(0xff000000),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r"[0-9-]"))
                                    ],
                                    enabled: enablefield,
                                    controller: TextEditingController(),
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
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                            color: Color(0x80000000), width: 1),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                            color: Color(0x80000000), width: 1),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        borderSide: BorderSide(
                                            color: Color(0x80000000), width: 1),
                                      ),
                                      filled: true,
                                      labelText: fechaString(pago.fecha),
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
                        ],
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Folio:        ",
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.clip,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                                fontSize: 14,
                                color: Color(0xff000000),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                enabled: enablefield,
                                controller: TextEditingController(),
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
                                        color: Color(0x80000000), width: 1),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                        color: Color(0x80000000), width: 1),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: BorderSide(
                                        color: Color(0x80000000), width: 1),
                                  ),
                                  filled: true,
                                  labelText: (pago.folio ?? '').toString(),
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
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Cantidad: ",
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.clip,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: Color(0xff000000),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"[0-9.]"))
                            ],
                            enabled: enablefield,
                            controller: TextEditingController(),
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
                                    color: Color(0x80000000), width: 1),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                    color: Color(0x80000000), width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: BorderSide(
                                    color: Color(0x80000000), width: 1),
                              ),
                              filled: true,
                              labelText: pago.cantidad.toString(),
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
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Periodo:   ",
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                        fontSize: 14,
                        color: Color(0xff000000),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: TextField(
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9-]"))
                        ],
                        enabled: enablefield,
                        controller: TextEditingController(),
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
                            borderSide:
                                BorderSide(color: Color(0x80000000), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide:
                                BorderSide(color: Color(0x80000000), width: 1),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide:
                                BorderSide(color: Color(0x80000000), width: 1),
                          ),
                          filled: true,
                          labelText: pago.periodo ?? '',
                          fillColor: Color(0xfff2f2f3),
                          isDense: false,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (enablefield)
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                  child: MaterialButton(
                    onPressed: () {},
                    color: Color(0xffffffff),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "Actualizar",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    textColor: Color(0xff000000),
                    height: 40,
                    minWidth: 140,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
