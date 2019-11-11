import 'package:flutter/material.dart';

class LearnDropdownButton extends StatefulWidget{

  String m_CurrentStockRange = "";
  LearnDropdownButton(String stockRange){
      m_CurrentStockRange = stockRange;
      if (m_CurrentStockRange == null){
        m_CurrentStockRange = "";
      }
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
    DropdownMenuItem dropdownMenuItem5=new DropdownMenuItem(
      child:new Text('0725'),
      value: '0725',
    );
    items.add(dropdownMenuItem5);
    DropdownMenuItem dropdownMenuItem6=new DropdownMenuItem(
      child:new Text('0811'),
      value: '0811',
    );
    items.add(dropdownMenuItem6);
    DropdownMenuItem dropdownMenuItem7=new DropdownMenuItem(
      child:new Text('pool-0610'),
      value: 'pool-0610',
    );
    items.add(dropdownMenuItem7);
    DropdownMenuItem dropdownMenuItem8=new DropdownMenuItem(
      child:new Text('pool-0910'),
      value: 'pool-0910',
    );
    items.add(dropdownMenuItem8);
    DropdownMenuItem dropdownMenuItem9=new DropdownMenuItem(
      child:new Text('pool-20180513'),
      value: 'pool-20180513',
    );
    items.add(dropdownMenuItem9);
    DropdownMenuItem dropdownMenuItem10=new DropdownMenuItem(
      child:new Text('中小市值'),
      value: '中小市值',
    );
    items.add(dropdownMenuItem10);
    return items;
  }

  var m_value = '';

/*  _LearnDropdownButton(){
    value=getListData()[0].value;
  }*/

  @override
  Widget build(BuildContext context) {
    
    print(widget.m_CurrentStockRange);
    if (m_value == ''){
      m_value = widget.m_CurrentStockRange;  
    }

    return new DropdownButton(
              items: getListData(),
              hint:new Text('选股范围'),//当没有默认值的时候可以设置的提示
              value: m_value,//下拉菜单选择完之后显示给用户的值
              onChanged: (T){//下拉菜单item点击之后的回调
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
    );
  }
}