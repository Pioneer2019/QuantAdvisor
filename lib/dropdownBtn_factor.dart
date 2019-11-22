import 'package:flutter/material.dart';
import 'sharedata.dart';
import 'webapihelper.dart';

import 'entityclass.dart';

import 'webapihelper.dart';

class DropdownBtnFactor extends StatefulWidget{

  ModelInfoEx m_ModeInfo = new ModelInfoEx();

  //true: 新建模型; false: 修改模型
  bool m_IsMakeNewModel=false;

  FactorOrCondition m_type = FactorOrCondition.Factor;

  DropdownBtnFactor(ModelInfoEx modelInfo, bool isMakeNewModel, FactorOrCondition type){
    m_ModeInfo = modelInfo;
    m_IsMakeNewModel = isMakeNewModel;
    m_type = type;
  }

  @override
  State<StatefulWidget> createState() {
    return DropdownBtnFactorState();
  }
}


class DropdownBtnFactorState extends State<DropdownBtnFactor>{

  //重新刷新界面
  RefreshUI(){
    setState(() {
      
    });
  }

  //得到系统因子列表，放在下拉列表框中
  List<DropdownMenuItem> getListData(){

    List<DropdownMenuItem> items=new List();

    String factorDesc = '';
    String factorName = '';

    DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
        child:new Text(factorDesc),
        value: factorName,
      );
    items.add(dropdownMenuItem1);

    var selFactorType = '';
    if (widget.m_type == FactorOrCondition.Factor){
      selFactorType = SharedData.instance.m_FactorType_NewFactor;
    }
    else{
      selFactorType = SharedData.instance.m_FactorType_NewCond;
    }

    if (selFactorType != ''){
      for(var factor in WebAPIHelper.instance.m_Cache_FactorTypeMapList[selFactorType])
      {
        factorDesc = factor.FactorDesc + "("+factor.FactorName+")";
        factorName = factor.FactorName;
        DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
          child:new Text(factorDesc),
          value: factorName,
        );
        items.add(dropdownMenuItem1);
      }
    }
    
    return items;
  }

  var m_value = '';

/*  _LearnDropdownButton(){
    value=getListData()[0].value;
  }*/

  //处理用户选择 因子 项目
  void procSelectFactorItem(){

    if (widget.m_IsMakeNewModel){
      if (widget.m_type == FactorOrCondition.Factor){
        SharedData.instance.GetNewFactor4NewModel().FactorName = m_value;
        SharedData.instance.GetNewFactor4NewModel().FactorDesc = 
          WebAPIHelper.instance.GetFactorInfoByName(m_value).FactorDesc;  
      }
      else{
        SharedData.instance.GetNewCondition4NewModel().CondName = m_value;
      }
    }
    else
    {
      if (widget.m_type == FactorOrCondition.Factor){
        FactorInModel factor = widget.m_ModeInfo.FactorList[widget.m_ModeInfo.FactorList.length-1];
        factor.FactorName = m_value;
        factor.FactorDesc = WebAPIHelper.instance.GetFactorInfoByName(m_value).FactorDesc;  
      }
      else{
        Cond cond = widget.m_ModeInfo.CondList[widget.m_ModeInfo.CondList.length-1];
        cond.CondName = m_value;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    
    /*
    这段代码可以作为 使用 context.ancestorWidgetOfExactType的参考
    Widget parent = null;
    if (widget.m_type == FactorOrCondition.Factor){
      parent = context.ancestorWidgetOfExactType(NewFactor4Model);
      widget.m_IsMakeNewModel = (parent as NewFactor4Model).m_IsMakeNewModel; 
    }
    else{
      parent = context.ancestorWidgetOfExactType(NewFactorFilter4Model);
      widget.IsMakeNewModel = (parent as NewFactorFilter4Model).m_IsMakeNewModel; 
    }
    */

    SharedData.instance.m_dropdownFactorState = this;

    return new DropdownButton(
              items: getListData(),
              hint:new Text('因子'),//当没有默认值的时候可以设置的提示
              value: m_value,//下拉菜单选择完之后显示给用户的值
              onChanged: (T){//下拉菜单item点击之后的回调
                setState(() {
                  m_value=T;

                  procSelectFactorItem();

                });
              },
              elevation: 24,//设置阴影的高度
              style: new TextStyle(//设置文本框里面文字的样式
                color: Colors.black,
                fontSize: 14.0,
              ),
              
//              isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
              iconSize: 50.0,//设置三角标icon的大小
              isExpanded: true,
    );
  }
}


//////////////////////////////////////////////////////////////////////////////////
///
///
///
class DropdownBtnFactorType extends StatefulWidget{

  ModelInfoEx m_ModeInfo = new ModelInfoEx();

  //true: 新建模型; false: 修改模型
  bool m_IsMakeNewModel=false;

  FactorOrCondition m_type = FactorOrCondition.Factor;

  DropdownBtnFactorType(ModelInfoEx modelInfo, bool isMakeNewModel, FactorOrCondition type){
    m_ModeInfo = modelInfo;
    m_IsMakeNewModel = isMakeNewModel;
    m_type = type;
  }

  @override
  State<StatefulWidget> createState() {
    return _DropdownBtnFactorType();
  }
}

class _DropdownBtnFactorType extends State<DropdownBtnFactorType>{

  //得到系统因子类别列表，放在下拉列表框中
  List<DropdownMenuItem> getListData(){

    List<DropdownMenuItem> items=new List();

    String factorType = '';

    DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
        child:new Text(factorType),
        value: factorType,
      );
    items.add(dropdownMenuItem1);

    for(var factorType in WebAPIHelper.instance.m_Cache_FactorTypeMapList.keys)
    {
      DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
        child:new Text(factorType),
        value: factorType,
      );
      items.add(dropdownMenuItem1);
    }
    
    return items;
  }

  var m_value = '';

/*  _LearnDropdownButton(){
    value=getListData()[0].value;
  }*/

  //处理用户选择 因子类别 项目
  void procSelectFactorItem(){

    if (widget.m_type == FactorOrCondition.Factor){
      SharedData.instance.m_FactorType_NewFactor = m_value;
    }
    else{
      SharedData.instance.m_FactorType_NewCond = m_value;
    }

    SharedData.instance.m_dropdownFactorState.m_value = '';
    SharedData.instance.m_dropdownFactorState.RefreshUI();

  }

  @override
  Widget build(BuildContext context) {
    
    return new DropdownButton(
              items: getListData(),
              hint:new Text('因子类别'),//当没有默认值的时候可以设置的提示
              value: m_value,//下拉菜单选择完之后显示给用户的值
              onChanged: (T){//下拉菜单item点击之后的回调
                setState(() {
                  m_value=T;

                  procSelectFactorItem();

                });
              },
              elevation: 24,//设置阴影的高度
              style: new TextStyle(//设置文本框里面文字的样式
                color: Colors.black,
                fontSize: 14.0,
              ),
              
//              isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
              iconSize: 50.0,//设置三角标icon的大小
              isExpanded: true,
    );
  }
}