import 'package:flutter/material.dart';
import 'package:uitest2/sharedata.dart';
import 'dropdownBtn_factor.dart';

import 'dropdownBtn_func.dart';
import 'entityclass.dart';
import 'weightslider.dart';
import 'sharedata.dart';

//import 'entityclass.dart';

//import 'webapihelper.dart';

class NewFactor4Model extends StatefulWidget{

  final String title = "新建因子";

  ModelInfoEx m_ModeInfo = new ModelInfoEx();

  //true: 新建模型; false: 修改模型
  bool m_IsMakeNewModel = true;

  NewFactor4Model(ModelInfoEx modelInfo, bool isMakeNewModel){
    m_IsMakeNewModel = isMakeNewModel;
    m_ModeInfo = modelInfo;
  }

   @override
  _NewFactor4ModelState createState() => _NewFactor4ModelState();
  
}

class _NewFactor4ModelState extends State<NewFactor4Model>{

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

                new DropdownBtnFactor(widget.m_ModeInfo,widget.m_IsMakeNewModel, FactorOrCondition.Factor),

                new Text('选择函数：',
                style: TextStyle(fontSize: 16),),
                new DropdownBtnFunc(widget.m_ModeInfo,widget.m_IsMakeNewModel),
                
                new WeightSlider(widget.m_ModeInfo,widget.m_IsMakeNewModel),
            
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