import 'package:flutter/material.dart';
import 'package:uitest2/entityclass.dart';

import 'sharedata.dart';

class LearnDropdownButton extends StatefulWidget{

  //当前编辑的模型信息
  ModelInfoEx m_ModelInfo = new ModelInfoEx();

  //true: 新建模型; false: 修改模型
  bool m_IsMakeNewModel = true;

  LearnDropdownButton(ModelInfoEx modelInfo,bool isMakeNewModel){
      m_ModelInfo = modelInfo;
      m_IsMakeNewModel = isMakeNewModel;

  }

  @override
  State<StatefulWidget> createState() {
    return _LearnDropdownButton();
  }
}
class _LearnDropdownButton extends State<LearnDropdownButton>{

  List<DropdownMenuItem> getListData(){
    List<DropdownMenuItem> items=new List();

    DropdownMenuItem dropdownMenuItem1=new DropdownMenuItem(
      child:new Text(''),
      value: '',
    );
    items.add(dropdownMenuItem1);
    
    dropdownMenuItem1=new DropdownMenuItem(
      child:new Text('全市场'),
      value: '全市场',
    );
    items.add(dropdownMenuItem1);

    DropdownMenuItem dropdownMenuItem2=new DropdownMenuItem(
      child:new Text('沪深300'),
      value: '沪深300',
    );
    items.add(dropdownMenuItem2);
    DropdownMenuItem dropdownMenuItem3=new DropdownMenuItem(
      child:new Text('中证500'),
      value: '中证500',
    );
    items.add(dropdownMenuItem3);
    DropdownMenuItem dropdownMenuItem4=new DropdownMenuItem(
      child:new Text('中证800'),
      value: '中证800',
    );
    items.add(dropdownMenuItem4);
    
    return items;
  }

  var m_value = '';

/*  _LearnDropdownButton(){
    value=getListData()[0].value;
  }*/

  @override
  Widget build(BuildContext context) {
    
    print(widget.m_ModelInfo.StockRange);
    if (widget.m_IsMakeNewModel){
      m_value = SharedData.instance.m_ModelInfoEx4New.StockRange;
    }
    else{
      m_value = widget.m_ModelInfo.StockRange;  
    }

    return new DropdownButton(
              items: getListData(),
              hint:new Text('选股范围'),//当没有默认值的时候可以设置的提示
              value: m_value,//下拉菜单选择完之后显示给用户的值
              onChanged: (T){//下拉菜单item点击之后的回调

                if (widget.m_IsMakeNewModel){
                  SharedData.instance.m_ModelInfoEx4New.StockRange = T;
                }
                else{
                  widget.m_ModelInfo.StockRange = T;
                }

                setState(() {
                  m_value=T;
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