import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class NoResult extends StatelessWidget {
  NoResult(this.messageError);
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
            if (messageError.isNotEmpty)
              Lottie.asset(
                'assets/animation_lms0jjiw.json',
                width: 120,
                height: 120,
                fit: BoxFit.fill,
              ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  messageError,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.clip,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.normal,
                    fontSize: 14,
                    color: Color.fromARGB(255, 59, 33, 33),
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
