import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class ErrorMessage extends StatelessWidget {
  ErrorMessage(this.messageError);
  String messageError = '';
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.fromLTRB(0, 30, 0, 30),
        padding: EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Color(0x1fffffff),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.zero,
          border: Border.all(color: Color(0x4dffffff), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            if (messageError.length > 0)
              Lottie.asset(
                'assets/animation_llsykp0p.json',
                width: 75,
                height: 75,
                fit: BoxFit.fill,
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  messageError,
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
          ],
        ),
      ),
    );
  }
}
