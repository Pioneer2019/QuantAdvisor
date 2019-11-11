import 'package:flutter/material.dart';
import 'dropdownBtn_factor.dart';

import 'dropdownBtn_func.dart';
import 'weightslider.dart';
import 'sharedata.dart';

//import 'entityclass.dart';

//import 'webapihelper.dart';

class NewFactorFilter4Model extends StatefulWidget{

  final String title = "新建因子筛选";

  //true: 新建模型; false: 修改模型
  bool m_IsMakeNewModel = true;

  NewFactorFilter4Model(bool isMakeNewModel){
    m_IsMakeNewModel = isMakeNewModel;
  }

   @override
  _NewFactorFilter4ModelState createState() => _NewFactorFilter4ModelState();
  
}

class _NewFactorFilter4ModelState extends State<NewFactorFilter4Model>{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(widget.title),
      ),

      //模型列表
      body: new Padding(
          padding: const EdgeInsets.all(20.0),
          child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

                new Text('选择因子：',
                style: TextStyle(fontSize: 16),),

                new DropdownBtnFactor(FactorOrCondition.Condition),

                new WeightFactorFilterSlider(FactorFilterWeight.min),

                new WeightFactorFilterSlider(FactorFilterWeight.max),
            
          ]
        ),
      ),

      bottomNavigationBar: BottomNavigationBar( // 底部导航
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.save), 
                title: Text('保存'),
                ),
              BottomNavigationBarItem(icon: Icon(Icons.cancel), title: Text('返回')),
            ],
            onTap:  (index) {
              //保存因子
              Navigator.pop(context,true);
            },
          ),

    );
  }
}