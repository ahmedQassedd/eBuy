import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'const.dart';

Widget customButton({
  double height = 50.0,
  double width = double.infinity,
  required String text,
  required Function onPressed,
}) =>
    Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: primaryColor,
      ),
      child: MaterialButton(
          onPressed: () {
            onPressed();
          },
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17.0,
            ),
          )),
    );

Widget customTextFormField({
  Function? onSubmitted,
  required TextEditingController controller,
  required TextInputType inputType,
  required String? Function(String?)? validator,
  String? label,
  String? hint,
  Function? tap,
  required IconData prefix,
  IconData? suffix,
  Function? suffixPressed,
  Function? change,
  bool secure = false,
  InputDecoration? border,
}) =>
    TextFormField(
      // onTap: () {
      //   tap!();
      // },
      // onChanged: (value) {
      //   change!(value);
      // },
      onFieldSubmitted: (value) {
        onSubmitted!(value);
      },
      cursorColor: primaryColor,
      controller: controller,
      keyboardType: inputType,
      validator: validator,
      obscureText: secure,
      decoration: InputDecoration(
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(
            onPressed: () {
              suffixPressed!();
            },
            icon: Icon(suffix)),
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[300]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );

ThemeData lightThemeCom() => ThemeData(
      fontFamily: 'myBestFont',
      primarySwatch: Colors.lightBlue,
      appBarTheme: const AppBarTheme(
        actionsIconTheme: IconThemeData(color: Colors.white),
        backwardsCompatibility: false,
        systemOverlayStyle:
            SystemUiOverlayStyle(statusBarIconBrightness: Brightness.light),
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20.0),
        elevation: 0.0,
      ),
    );
