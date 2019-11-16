import 'package:flutter/material.dart';
import 'multiselect/flutter_multiselect.dart';
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

  String title = '行业列表';

  //List<Widget> m_List = new List();
  ////列表是否选中值
  //List<bool> m_isChecks = new List();
  List<dynamic> m_data = new List();

  //作为数据源的List
  List<dynamic> m_DataSource = new List();

  //初始化m_data，作为控件的初始化显示数据
  void InitialCheckList(){

    m_data.clear();
    if (m_data.length == 0){
      //m_data = new List(WebAPIHelper.instance.m_Cache_IndustryList.length);

      /*
      for(int i=0;i<m_isChecks.length;i++){
        m_isChecks[i] = false;
      }
      */

    }

    if (widget.m_IsMakeNewModel){
      /*
      for(int i=0;i<m_isChecks.length;i++){
        var industryName = WebAPIHelper.instance.m_Cache_IndustryList[i];
        if (SharedData.instance.m_ModelInfoEx4New.IndustryList.contains(industryName) == true){
          m_isChecks[i]=true;
        }
        else{
          m_isChecks[i]=false;
        }
      }
      */
    }
    else{
      for(var idsName in widget.m_ModelInfo.IndustryList){
        
          m_data.add(idsName);
        
      }
    }
    
  }  

  //初始化行业列表
  void InitialDataSource() {

    InitialCheckList();

    m_DataSource.clear();

    for(int i=0;i < WebAPIHelper.instance.m_Cache_IndustryList.length;i++){

      var name = WebAPIHelper.instance.m_Cache_IndustryList[i];

      Map map = new Map();
      map['display']=name;
      map['value']=name;
      m_DataSource.add(map);
      
    }

  }

  //处理鼠标点选 项目的 checked 选择框
  void procSelectIndustry(var selectedvalue, List<String> industryList){
    industryList.clear();
    for(var item in selectedvalue){
      industryList.add(item.toString());
    }
  }

  //选择 保存后，触发 该事件
  void valueChanged(var selectedvalue) {
    if (widget.m_IsMakeNewModel){
      procSelectIndustry(selectedvalue, SharedData.instance.m_ModelInfoEx4New.IndustryList);
    }
    else{
      procSelectIndustry(selectedvalue, widget.m_ModelInfo.IndustryList);
    }
  }

  //final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    InitialDataSource();

    return new MultiSelect(
                  autovalidate: false,
                  titleText: title,
                  validator: (value) {
                    if (value == null) {
                      return 'Please select one or more option(s)';
                    }
                  },
                  errorText: 'Please select one or more option(s)',
                  dataSource: m_DataSource,
                  textField: 'display',
                  valueField: 'value',
                  filterable: true,
                  required: true,
                  initialValue: m_data,
                  value: null,
                  maxLength: 10,
                  change: valueChanged,
               
    );
  }
}



/*
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
      for(int i=0;i<m_isChecks.length;i++){
        var industryName = WebAPIHelper.instance.m_Cache_IndustryList[i];
        if (SharedData.instance.m_ModelInfoEx4New.IndustryList.contains(industryName) == true){
          m_isChecks[i]=true;
        }
        else{
          m_isChecks[i]=false;
        }
      }
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

*/
