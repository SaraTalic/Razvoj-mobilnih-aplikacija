import 'package:flutter/material.dart';
import 'package:recipe/consent/colors.dart';

PreferredSizeWidget appbar() {
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Container(
          width: 36, 
          height: 36, 
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage('images/ikona.png'), 
              //fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ],
    backgroundColor: maincolor,
  );
}
