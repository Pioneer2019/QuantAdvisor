import 'package:flutter/material.dart';
import 'package:uitest2/entityclass.dart';
import 'dropdownBtn.dart';
import 'checkBoxList.dart';
import 'sharedata.dart';

//显示策略基本信息的部件
class StrategyBasic extends StatelessWidget
{
  ModelInfoEx m_ModelInfo=new ModelInfoEx();

  //true: 新建模型; false: 修改模型
  bool m_IsMakeNewModel = true;

  StrategyBasic(ModelInfoEx modeInfo,bool isMakeNewModel){
    m_ModelInfo = modeInfo;
    print(m_ModelInfo.ModelDesc);
    m_IsMakeNewModel = isMakeNewModel;
  }

  @override
  Widget build(BuildContext context)
  {
    return new Flex(
       direction: Axis.vertical,
       children: <Widget>[
         new Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
                new Expanded(
                  flex:1,
                  child: new Text('模型名称'),
                ),
                
                new Expanded(
                  flex:5,
                  child: new TextField(
                        
                        decoration: InputDecoration(),
                        onChanged: (text) {
                          //value = text;
                          if (m_IsMakeNewModel==true){
                            SharedData.instance.m_ModelInfoEx4New.ModelName = text;
                          }
                        },

                        controller: TextEditingController.fromValue(TextEditingValue
                            (
                              text: '${m_IsMakeNewModel==false ? m_ModelInfo.ModelName : SharedData.instance.m_ModelInfoEx4New.ModelName}',  //判断keyword是否为空
                          ), 
                          
                        ),
                  ),
                ),
            ]
         ),
         
         //new Divider(),

         new Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
                new Expanded(
                  flex:1,
                  child: new Text('策略说明'),
                ),
                
                new Expanded(
                  flex:5,
                  child: new TextField(
                        decoration: InputDecoration(),

                        onChanged: (text) {
                          //value = text;
                          if (m_IsMakeNewModel==true){
                            SharedData.instance.m_ModelInfoEx4New.ModelDesc = text;
                          }
                        },

                        controller: TextEditingController.fromValue(TextEditingValue
                            (
                              text: '${m_IsMakeNewModel==false ? m_ModelInfo.ModelDesc : SharedData.instance.m_ModelInfoEx4New.ModelDesc}',  //判断keyword是否为空
                          ), 
                        ),

                        ),

                        
                ),
           ]
         ),

        //new Divider(),

        new Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
                new Expanded(
                  flex:1,
                  child: new Text('选股范围'),
                ),
                
                new Expanded(
                  flex:5,
                  child: new LearnDropdownButton(m_ModelInfo.StockRange,this.m_IsMakeNewModel), 
                ),
           ]
         ),

         new Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
                new Expanded(
                  flex:1,
                  child: new Text('选股行业'),
                ),
                
                new Expanded(
                  flex:5,
                  child: new IndustryList(this.m_ModelInfo,this.m_IsMakeNewModel),
                ),
           ]
         ),

          new Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
                new Expanded(
                  flex:1,
                  child: new Text('选股个数'),
                ),
                
                new Expanded(
                  flex:5,
                  child: new TextField(

                        keyboardType: TextInputType.number,//键盘类型，数字键盘

                        decoration: InputDecoration(),
                        
                        controller: TextEditingController.fromValue(TextEditingValue
                            (
                              text: '${m_IsMakeNewModel==false ? m_ModelInfo.NumStock: SharedData.instance.m_ModelInfoEx4New.NumStock}',  //判断keyword是否为空
                          ), 
                        ),

                        ), 
                ),
           ]
         ),
          
          new Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
                new Expanded(
                  flex:1,
                  child: new Text('调仓天数'),
                ),
                
                new Expanded(
                  flex:5,
                  child: new TextField(
                        
                        keyboardType: TextInputType.number,//键盘类型，数字键盘
                        decoration: InputDecoration(),

                        controller: TextEditingController.fromValue(TextEditingValue
                            (
                              text: '${m_IsMakeNewModel==false ? m_ModelInfo.DefaultInterval : SharedData.instance.m_ModelInfoEx4New.DefaultInterval}',  //判断keyword是否为空
                          ), 
                        ),
                        ), 
                ),
           ]
         ),

       ], 
    );
  }
}

