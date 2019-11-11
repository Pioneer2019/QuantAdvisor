import 'package:flutter/material.dart';
import 'dropdownBtn_factor.dart';

import 'entityclass.dart';

import 'webapihelper.dart';

class NewFactor4Model extends StatefulWidget{

   @override
  _NewFactor4ModelState createState() => _NewFactor4ModelState();
  
}

class _NewFactor4ModelState extends State<NewFactor4Model>{

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Row(
           
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           
           children: <Widget>[
             new Text('因子'),
             new DropdownBtnFactor(),
             new Text('函数'),
           ]
      ]
    )
  }
}