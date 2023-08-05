import 'package:flutter/material.dart';
import 'package:firebase/style/color.dart' as color;

Widget defaultButton({
  required context,
  required function,
  required String text,
  double width = double.infinity,
  bool isMin = false,
  double widthMin = 90.0,
  double height = 50.0,
  double textSize = 20.0,
}) =>
    Container(
      width: isMin ? widthMin : MediaQuery.of(context).size.width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.buttonColor,
          shape: const StadiumBorder(),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color.textButtonColor,
            fontSize: textSize,
          ),
        ),
        onPressed: () {
          function();
        },
      ),
    );
