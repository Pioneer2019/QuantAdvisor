import 'package:flutter/material.dart';
import 'package:uitest2/entityclass.dart';

import 'sharedata.dart';
import 'webapihelper.dart';

class Dialog4Save {
  // 工厂模式
  factory Dialog4Save() =>_getInstance();
  static Dialog4Save get instance => _getInstance();
  static Dialog4Save _instance;
  Dialog4Save._internal() {
    // 初始化
  }
  static Dialog4Save _getInstance() {
    if (_instance == null) {
      _instance = new Dialog4Save._internal();
    }
    return _instance;
  }

  //新建模型时，必须输入 的 条件 ，模型名 ，选股范围，行业，选股个数，调仓天数，打分设置 都必须要有输入
  bool CheckInputValue4Save(ModelInfoEx4Save modelInfo,BuildContext context, bool isNew){
    if (modelInfo.ModelName.trim().isEmpty == true){
      ShowDialog_necessaryInfo('模型名称',context,isNew);
      return false;
    }
    if (modelInfo.StockRange.trim().isEmpty == true){
      ShowDialog_necessaryInfo('选股范围',context,isNew);
      return false;
    }
    if (modelInfo.IndustryList.length == 0){
      ShowDialog_necessaryInfo('选股行业',context,isNew);
      return false;
    }
    if (modelInfo.NumStock == 0){
      ShowDialog_necessaryInfo('选股个数',context,isNew);
      return false;
    }
    if (modelInfo.DefaultInterval == 0){
      ShowDialog_necessaryInfo('调仓天数',context,isNew);
      return false;
    }
    if (modelInfo.FactorList.length == 0){
      ShowDialog_necessaryInfo('打分设置中的因子',context,isNew);
      return false;
    }
    return true;
  }

  //弹出对话框，告诉用户需要输入哪些字段值
  ShowDialog_necessaryInfo(String fieldName,BuildContext context, bool isNew) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        String prompt = (isNew?'新建':'')+'模型信息必须输入:'+fieldName;
        return AlertDialog(
          title: Text('提示'),
          
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(prompt),
              ],
            ),
          ),
        
          actions: <Widget>[
            FlatButton(
              child: Text('OK',
              style: new TextStyle(fontSize: 18),),
              onPressed: () async {
                Navigator.of(context).pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  //模型另存为XXX
  bool SaveAsModel(ModelInfoEx4Save modelInfo,BuildContext context,Function saveAction){
    DialogResult dr = new DialogResult();

    modelInfo.ModelName += '_Copy';

    ShowDialog_InputNewModelName(context, modelInfo, dr,saveAction);

    if (dr.ok){
      return true;
    }
    else{
      return false;
    }
    
  }

  //打开对话框，输入新的模型名
  ShowDialog_InputNewModelName(BuildContext context, ModelInfoEx4Save modelInfo,DialogResult dr,Function saveAction) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        String prompt = '模型名称:';
        return AlertDialog(
          title: Text('模型另存为'),
          
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(prompt),

                new TextField(
                        
                        decoration: InputDecoration(),
                        onChanged: (text) {
                          //value = text;
                          
                          modelInfo.ModelName = text.trim();
                          
                        },

                        controller: TextEditingController.fromValue(TextEditingValue
                          (
                            text: '${modelInfo.ModelName}',  //判断keyword是否为空
                          ), 
                          
                        ),
                  ),

              ],
            ),
          ),
        
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel',
              style: new TextStyle(fontSize: 18),),
              onPressed: () async {
                dr.cancel = true;
                Navigator.of(context).pop(context);
              },
            ),

            FlatButton(
              child: Text('OK',
              style: new TextStyle(fontSize: 18),),
              onPressed: () async {
                dr.ok = true;
                Navigator.of(context).pop(context);
                saveAction(modelInfo);
              },
            ),
          ],
        );
      },
    );
  }

  //弹出对话框，说明因子重复
  ShowDialog_DuplicateFactor(BuildContext context,String fieldName) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('该$fieldName已经存在，请换为其它$fieldName'),
          actions: <Widget>[

            FlatButton(
              child: Text('确定',
              style: new TextStyle(fontSize: 18),),
              onPressed: () async {
                Navigator.of(context).pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  //弹出对话框，说明没有输入因子
  ShowDialog_FieldIsEmpty(BuildContext context,String fieldName) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$fieldName为空，请选择$fieldName'),
          actions: <Widget>[

            FlatButton(
              child: Text('确定',
              style: new TextStyle(fontSize: 18),),
              onPressed: () async {
                Navigator.of(context).pop(context);
              },
            ),
          ],
        );
      },
    );
  }

}