import 'package:flutter/services.dart';

import 'Pago.dart';
import 'package:date_format/date_format.dart';
import 'globals.dart' as globals;
import 'package:flutter/material.dart';

class DataCard extends StatelessWidget {
  DataCard({
    super.key,
    required this.pago,
  });

  final Pago pago;
  final dateController = TextEditingController();

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
    dateController.text = fechaString(pago.fecha);
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
                                      readOnly: true,
                                      controller: dateController,
                                      enabled: enablefield,
                                      decoration: const InputDecoration(
                                        disabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0x80000000),
                                              width: 1),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0x80000000),
                                              width: 1),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0x80000000),
                                              width: 1),
                                        ),
                                        filled: true,
                                        hintText: "",
                                        fillColor: Color(0xfff2f2f3),
                                        isDense: false,
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 12),
                                      ),
                                      onTap: () async {
                                        var date = await showDatePicker(
                                            locale: const Locale("es", "MEX"),
                                            context: context,
                                            initialDate:
                                                pago.fecha ?? DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2100));
                                        if (date != null) {
                                          dateController.text = formatDate(
                                              date, [dd, '-', mm, '-', yyyy]);
                                        } else {
                                          dateController.text =
                                              fechaString(pago.fecha);
                                        }
                                      },
                                    )),
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
                    onPressed: () {
                      // appState.updatePago(dateController.text);
                    },
                    color: Color(0xffffffff),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    padding: EdgeInsets.all(16),
                    textColor: Color(0xff000000),
                    height: 40,
                    minWidth: 140,
                    child: Text(
                      "Actualizar",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
