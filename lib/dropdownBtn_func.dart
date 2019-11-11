import 'package:flutter/material.dart';
import 'package:uitest2/newfactor4model.dart';
import 'package:uitest2/webapihelper.dart';

import 'sharedata.dart';

class DropdownBtnFunc extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _DropdownBtnFunc();
  }
}
class _DropdownBtnFunc extends State<DropdownBtnFunc>{

  //true: 新建模型; false: 修改模型
  bool IsMakeNewModel=false;

  //系统函数列表，放到下拉列表框中
  List<DropdownMenuItem> getListData(){

    List<DropdownMenuItem> items=new List();

    DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
        child:new Text(''),
        value: '',
      );
    items.add(dropdownMenuItem1);

    for(var func in WebAPIHelper.instance.GetFunctionList())
    {
      DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
        child:new Text(func),
        value: func,
      );
      items.add(dropdownMenuItem1);
    }
    
    return items;
  }

  var m_value = '';

/*  _LearnDropdownButton(){
    value=getListData()[0].value;
  }*/

  @override
  Widget build(BuildContext context) {

    Widget parent = context.ancestorWidgetOfExactType(NewFactor4Model);
    this.IsMakeNewModel = (parent as NewFactor4Model).m_IsMakeNewModel;
    
    return new DropdownButton(
              items: getListData(),
              hint:new Text('函数'),//当没有默认值的时候可以设置的提示
              value: m_value,//下拉菜单选择完之后显示给用户的值
              onChanged: (T){//下拉菜单item点击之后的回调
                setState(() {
                  m_value=T;

                  if (this.IsMakeNewModel){
                    SharedData.instance.GetNewFactor4NewModel().FuncName = m_value;
                  }


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