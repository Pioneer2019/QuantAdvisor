import 'package:flutter/material.dart';
import 'package:uitest2/entityclass.dart';
import 'package:uitest2/sharedata.dart';

import 'newfactor4model.dart';
import 'newfactorfilter4model.dart';

class WeightSlider extends StatefulWidget {

  //int FactorWeight=0;
  ModelInfoEx m_ModelInfo = new ModelInfoEx();

  //true: 新建模型; false: 修改模型
  bool m_IsMakeNewModel=false;

  WeightSlider(ModelInfoEx modelInfo,bool isMakeNewModel){
    m_ModelInfo = modelInfo;
    m_IsMakeNewModel = isMakeNewModel;
  }

  @override
  State<StatefulWidget> createState() => _WeightSlider();
}

class _WeightSlider extends State<WeightSlider> {
  double _value = 0;


  @override
  Widget build(BuildContext context) {
    
    //Widget parent = context.ancestorWidgetOfExactType(NewFactor4Model);
    //this.IsMakeNewModel = (parent as NewFactor4Model).m_IsMakeNewModel;

    var weight = 0;
    if (widget.m_IsMakeNewModel){
      weight = SharedData.instance.GetNewFactor4NewModel().FactorWeight;
    }
    else{
      weight = widget.m_ModelInfo.FactorList[widget.m_ModelInfo.FactorList.length-1].FactorWeight;
    }
    
    return 
    Column(
      
      crossAxisAlignment: CrossAxisAlignment.start,

      children: <Widget>[
        new Text('选择权重：${weight}',
                style: TextStyle(fontSize: 16),),

        new Slider(
          value: _value,
          min: -20.0,
            max: 20.0,
          onChanged: (newValue) {
            print('onChanged:$newValue');
            setState(() {
              _value = newValue;

              if (widget.m_IsMakeNewModel){
                //记录数据
                SharedData.instance.GetNewFactor4NewModel().FactorWeight=newValue.toInt();  
              }
              else{
                widget.m_ModelInfo.FactorList[widget.m_ModelInfo.FactorList.length-1].FactorWeight = newValue.toInt();
              }
              
            });
          },
          onChangeStart: (startValue) {
            print('onChangeStart:$startValue');
          },
          onChangeEnd: (endValue) {
            print('onChangeEnd:$endValue');
          },
          label: '$_value ',
          divisions: 40,
          semanticFormatterCallback: (newValue) {
            return '${newValue.round()} ';
          },
        ),
      ]
    );
  }
}

///////////////////////////////////////////////////////////////////////////////////////////
///
///
///////////////////////////////////////////////////////////////////////////////////////////

class WeightFactorFilterSlider extends StatefulWidget {

  //int filter_weight = 0;
  ModelInfoEx m_ModelInfo = new ModelInfoEx();
  //true: 新建模型; false: 修改模型
  bool m_IsMakeNewModel=false;

  FactorFilterWeight m_type = FactorFilterWeight.min;

  WeightFactorFilterSlider(ModelInfoEx modelInfo,bool isMakeNewModel,FactorFilterWeight type){
    m_ModelInfo = modelInfo;
    m_IsMakeNewModel = isMakeNewModel;
    m_type = type;
  }

  String GetPromptText(){
    if (m_type == FactorFilterWeight.min){
      return "因子大于等于(%)";
    }
    else{
      return "因子小于等于(%)";
    }
  }

  @override
  State<StatefulWidget> createState() => _WeightFactorFilterSlider();
}

class _WeightFactorFilterSlider extends State<WeightFactorFilterSlider> {
  
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    
    //Widget parent = context.ancestorWidgetOfExactType(NewFactorFilter4Model);
    //this.IsMakeNewModel = (parent as NewFactorFilter4Model).m_IsMakeNewModel;

    var weight = 0;
    if (widget.m_IsMakeNewModel){
      if (widget.m_type == FactorFilterWeight.min){
        weight = SharedData.instance.GetNewCondition4NewModel().CondMin;
      }
      else{
        weight = SharedData.instance.GetNewCondition4NewModel().CondMax;
      }
    }
    else{
      if (widget.m_type == FactorFilterWeight.min){      
        weight = widget.m_ModelInfo.CondList[widget.m_ModelInfo.CondList.length-1].CondMin;
      }
      else{
        weight = widget.m_ModelInfo.CondList[widget.m_ModelInfo.CondList.length-1].CondMax;
      }
    }
    
    return new Column(
      
      crossAxisAlignment: CrossAxisAlignment.start,

      children: <Widget>[
        new Text(widget.GetPromptText()+': ${weight}',
                style: TextStyle(fontSize: 16),),

        new Slider(
          value: _value,
          min: 0,
            max: 100,
          onChanged: (newValue) {
            print('onChanged:$newValue');
            setState(() {
              _value = newValue;

              //记录数据
              if (widget.m_IsMakeNewModel){
                if (widget.m_type == FactorFilterWeight.min){
                  SharedData.instance.GetNewCondition4NewModel().CondMin=newValue.toInt();  
                }
                else{
                  SharedData.instance.GetNewCondition4NewModel().CondMax=newValue.toInt();  
                }
              }
              else{
                Cond cond = widget.m_ModelInfo.CondList[widget.m_ModelInfo.CondList.length-1];
                if (widget.m_type == FactorFilterWeight.min){
                  cond.CondMin=newValue.toInt();  
                }
                else{
                  cond.CondMax=newValue.toInt();  
                }
              }
              
            });
          },
          onChangeStart: (startValue) {
            print('onChangeStart:$startValue');
          },
          onChangeEnd: (endValue) {
            print('onChangeEnd:$endValue');
          },
          label: '$_value ',
          divisions: 100,
          semanticFormatterCallback: (newValue) {
            return '${newValue.round()} ';
          },
        ),
      ]
    );
  }
}
