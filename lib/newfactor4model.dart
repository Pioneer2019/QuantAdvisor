import 'package:flutter/material.dart';
import 'sharedata.dart';
import 'showdialog.dart';
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

  //判断因子是否重复了
  bool checkDuplicateFactor(){
    List<FactorInModel> factorList = null;
    String newFactorName = '';
    if (this.widget.m_IsMakeNewModel){
      newFactorName = SharedData.instance.m_ModelInfoEx4New.FactorList[SharedData.instance.m_ModelInfoEx4New.FactorList.length-1].FactorName;
      factorList = SharedData.instance.m_ModelInfoEx4New.FactorList;
    }
    else{
      newFactorName = this.widget.m_ModeInfo.FactorList[this.widget.m_ModeInfo.FactorList.length-1].FactorName;
      factorList = this.widget.m_ModeInfo.FactorList;
    }

    for(int i=0;i < factorList.length-1;i++){
      if (factorList[i].FactorName == newFactorName){
        return false;
      }
    }
    return true;
  }

  //判断是否没有选择因子
  bool checkFactorNameIsEmpty(){
    String newFactorName = '';
    if (this.widget.m_IsMakeNewModel){
      newFactorName = SharedData.instance.m_ModelInfoEx4New.FactorList[SharedData.instance.m_ModelInfoEx4New.FactorList.length-1].FactorName;
    }
    else{
      newFactorName = this.widget.m_ModeInfo.FactorList[this.widget.m_ModeInfo.FactorList.length-1].FactorName;
    }

    if (newFactorName.isEmpty){
      return false;
    }
    return true;
  }

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

                new Text('选择因子类别：',
                style: TextStyle(fontSize: 16),),
                new DropdownBtnFactorType(widget.m_ModeInfo,widget.m_IsMakeNewModel, FactorOrCondition.Factor),

                new Text('选择因子：',
                style: TextStyle(fontSize: 16),),

                //new DropdownBtnFactor(widget.m_ModeInfo,widget.m_IsMakeNewModel, FactorOrCondition.Factor),
                new DropdownBtnFactor(widget.m_ModeInfo,widget.m_IsMakeNewModel, FactorOrCondition.Factor),

                new Text('函数：',
                style: TextStyle(fontSize: 16),),
                //new DropdownBtnFunc(widget.m_ModeInfo,widget.m_IsMakeNewModel),
                new Text(''),
                new Text('Linear'),
                new Divider(),
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
              if (index == 0){
                //先判断 是否已经存在了相同的因子
                bool br = checkFactorNameIsEmpty();
                if (br==false){
                  Dialog4Save.instance.ShowDialog_FieldIsEmpty(context,'因子');
                  return;
                }

                br = this.checkDuplicateFactor();
                if (br==false){
                  Dialog4Save.instance.ShowDialog_DuplicateFactor(context,'因子');
                  return;
                }
                //保存因子
                Navigator.pop(context,true);
              }
              else{
                //删除新加的因子
                if (widget.m_IsMakeNewModel){
                  var fc = SharedData.instance.m_ModelInfoEx4New.FactorList[SharedData.instance.m_ModelInfoEx4New.FactorList.length-1];
                  SharedData.instance.m_ModelInfoEx4New.FactorList.remove(fc);
                }
                else{
                  var fc = widget.m_ModeInfo.FactorList[widget.m_ModeInfo.FactorList.length-1];
                  widget.m_ModeInfo.FactorList.remove(fc);
                }
                //保存因子
                Navigator.pop(context,true);
              }
            },
          ),

    );
  }
}