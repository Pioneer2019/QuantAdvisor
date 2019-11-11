import 'package:flutter/material.dart';
import 'webapihelper.dart';
import 'entityclass.dart';

class IndustryList extends StatefulWidget {
  
  ModelInfoEx m_ModelInfo = new ModelInfoEx();

  IndustryList(ModelInfoEx modeInfo){
    m_ModelInfo = modeInfo;
    print(m_ModelInfo.IndustryList);
  }

  @override
  State<StatefulWidget> createState() => IndustryListState();
}

class IndustryListState extends State<IndustryList> {
  bool _value = false;

  List<Widget> m_List = new List();
  //列表是否选中值
  List<bool> m_isChecks = new List();

  //初始化行业列表
  void InitialList(){

    bool isCheck = false;

    m_isChecks = new List(WebAPIHelper.instance.m_Cache_IndustryList.length);

    for(int i=0;i<m_isChecks.length;i++){

      var industryName = WebAPIHelper.instance.m_Cache_IndustryList[i];
      if (widget.m_ModelInfo.IndustryList == null){
        widget.m_ModelInfo.IndustryList ="";
      }
      if (widget.m_ModelInfo.IndustryList.indexOf(industryName)>=0){
          m_isChecks[i]=true;
      }
      else{
        m_isChecks[i]=false;
      }
    }

    m_List.clear();

    for(int i=0;i < WebAPIHelper.instance.m_Cache_IndustryList.length;i++){

      var name = WebAPIHelper.instance.m_Cache_IndustryList[i];
      m_List.add(
        new CheckboxListTile(
          value: m_isChecks[i],
          onChanged: (bool){
            setState(() {
              m_isChecks[i] = bool;
            });
          },
          title: Text(name),
          controlAffinity: ListTileControlAffinity.platform,
          activeColor: _value ? Colors.red : Colors.green,
          dense: true,
        ),
      );
    }

  }

  //全选/全不选切换
  void _valueChanged(bool value) {
    for (var i = 0; i < m_isChecks.length; i++) {
      m_isChecks[i] = value;
    }
    setState(() {
      _value = value;
    });
  }

  @override
  Widget build(BuildContext context) {

    InitialList();

    return new SizedBox(
      height: 238,  
      child : new SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: new Column(
            children: m_List,
        ),
      ),
    );
  }
}


