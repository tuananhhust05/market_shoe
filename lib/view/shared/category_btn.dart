import 'package:flutter/material.dart';

import 'appstyle.dart';
class CategoryBtn extends StatelessWidget {

  const CategoryBtn({ super.key, required this.buttonClr, required this.label, this.onPress });
  final Color buttonClr;
  final String label;
  final void Function()? onPress;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPress,
      child:Container(
        padding:const EdgeInsets.all(5),
        height:55,
        width:MediaQuery.of(context).size.width * 0.23,
        decoration:BoxDecoration(
          border:Border.all(
            width:1,
            color:buttonClr,
            style:BorderStyle.solid,
          ),
          borderRadius:const BorderRadius.all(Radius.circular(9))
        ),
        child: Center(
          child: Text(
            label,
            style:appstyle(16,buttonClr,FontWeight.w600)
          ),
        )
      )
    );
  }
}