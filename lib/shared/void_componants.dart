import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void navigateTo({required BuildContext context, required Widget widget}) =>
    Navigator.push(context, MaterialPageRoute(builder: (context) => widget));

void navigateAndFinish(
    {required BuildContext context, required Widget widget}) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => widget), (route) => false);
}
