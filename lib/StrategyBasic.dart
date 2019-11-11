import 'package:flutter/material.dart';
import 'package:uitest2/entityclass.dart';
import 'dropdownBtn.dart';
import 'checkBoxList.dart';

//显示策略基本信息的部件
class StrategyBasic extends StatelessWidget
{
  ModelInfoEx m_ModelInfo=new ModelInfoEx();

  StrategyBasic(ModelInfoEx modeInfo){
    m_ModelInfo = modeInfo;
    print(m_ModelInfo.ModelDesc);
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

                        controller: TextEditingController.fromValue(TextEditingValue
                            (
                              text: '${m_ModelInfo.ModelName == null ? "": m_ModelInfo.ModelName}',  //判断keyword是否为空
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

                        controller: TextEditingController.fromValue(TextEditingValue
                            (
                              text: '${m_ModelInfo.ModelDesc == null ? "": m_ModelInfo.ModelDesc}',  //判断keyword是否为空
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
                  child: new LearnDropdownButton(m_ModelInfo.StockRange), 
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
                  child: new IndustryList(this.m_ModelInfo),
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
                              text: '${m_ModelInfo.NumStock == null ? "": m_ModelInfo.NumStock}',  //判断keyword是否为空
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
                              text: '${m_ModelInfo.DefaultInterval == null ? "": m_ModelInfo.DefaultInterval}',  //判断keyword是否为空
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

