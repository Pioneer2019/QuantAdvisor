import 'package:flutter/material.dart';
import 'sharedata.dart';
import 'webapihelper.dart';
import 'entityclass.dart';

class IndustryList extends StatefulWidget {
  
  ModelInfoEx m_ModelInfo = new ModelInfoEx();

  //true: 新建模型; false: 修改模型
  bool m_IsMakeNewModel = true;

  IndustryList(ModelInfoEx modeInfo, bool isMakeNewModel){
    m_ModelInfo = modeInfo;
    print(m_ModelInfo.IndustryList);
    this.m_IsMakeNewModel = isMakeNewModel;
  }

  @override
  State<StatefulWidget> createState() => IndustryListState();
}

class IndustryListState extends State<IndustryList> {
  bool _value = false;

  List<Widget> m_List = new List();
  //列表是否选中值
  List<bool> m_isChecks = new List();

  //初始化m_isChecks
  void InitialCheckList(){

    if (m_isChecks.length == 0){
      m_isChecks = new List(WebAPIHelper.instance.m_Cache_IndustryList.length);
      for(int i=0;i<m_isChecks.length;i++){
        m_isChecks[i] = false;
      }
    }

    if (widget.m_IsMakeNewModel){
      
    }
    else{
      for(int i=0;i<m_isChecks.length;i++){
        var industryName = WebAPIHelper.instance.m_Cache_IndustryList[i];
        if (widget.m_ModelInfo.IndustryList.contains(industryName) == true){
          m_isChecks[i]=true;
        }
        else{
          m_isChecks[i]=false;
        }
      }
    }
    
  }  

  //初始化行业列表
  void InitialList() {

    bool isCheck = false;

    InitialCheckList();

    m_List.clear();

    for(int i=0;i < WebAPIHelper.instance.m_Cache_IndustryList.length;i++){

      var name = WebAPIHelper.instance.m_Cache_IndustryList[i];
      m_List.add(
        new CheckboxListTile(
          value: m_isChecks[i],
          onChanged: (bool){
            setState(() {
              m_isChecks[i] = bool;

              //更新 数据
              UpdateDataSource(bool,name);

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

  //更新数据
  void UpdateDataSource(bool checked,String itemName){
    
    if (widget.m_IsMakeNewModel){
      procSelectIndustry(checked, itemName, SharedData.instance.m_ModelInfoEx4New.IndustryList);
    }
    else{
      procSelectIndustry(checked, itemName, widget.m_ModelInfo.IndustryList);
    }
  }

  //处理鼠标点选 项目的 checked 选择框
  void procSelectIndustry(bool checked, String itemName, List<String> industryList){
    if (checked){
        if (industryList.contains(itemName)==false){
          industryList.add(itemName);
        }
      }
      else{
        if (industryList.contains(itemName)==true){
          industryList.remove(itemName);
        }
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
      height: 218,  
      child : new SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: new Column(
            children: m_List,
        ),
      ),
    );
  }
}


