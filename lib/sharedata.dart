import 'package:flutter/widgets.dart';

import 'FactorFilterList.dart';
import 'backTest.dart';
import 'entityclass.dart';
import 'entityclass.dart';
import 'entityclass.dart';
import 'entityclass.dart';
import 'main.dart';
import 'dropdownBtn_factor.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class SharedData {
  // 工厂模式
  factory SharedData() =>_getInstance();
  static SharedData get instance => _getInstance();
  static SharedData _instance;
  SharedData._internal() {
    // 初始化
  }
  static SharedData _getInstance() {
    if (_instance == null) {
      _instance = new SharedData._internal();
    }
    return _instance;
  }

  ///////////////////////////////////////////////////////////////////////////////////////
  ///保存新建的模型信息
  ModelInfoEx4Save m_ModelInfoEx4New = new ModelInfoEx4Save();

  ClearModelInfoEx4New(ModelInfoEx4Save modelInfoEx){
    modelInfoEx.ModelName='';
    modelInfoEx.ModelDesc='';
    modelInfoEx.NumStock=0;
    modelInfoEx.IndustryList = new List();
    modelInfoEx.DefaultInterval=0;
    modelInfoEx.StockRange='';
    modelInfoEx.FactorList = new List();
    modelInfoEx.CondList = new List();

    //设置 初始化值
    modelInfoEx.StockRange='全市场';
    modelInfoEx.IndustryList.add('全行业');
    modelInfoEx.NumStock=20;
    modelInfoEx.DefaultInterval=20;
  }

  /////////////////////////////////////////////////////////////////////////
  //新建模型新建因子的权重
  //List<FactorInModel> FactorList4NewModel = new List();
  //true: Save;  false: cancel
  bool SaveOrCancelAction = false;

  void ClearNewFactorData(){
    m_ModelInfoEx4New.FactorList.clear();
    SaveOrCancelAction = false;
  }

  void AddNewFactor4NewModel(){
    m_ModelInfoEx4New.FactorList.add(new FactorInModel());

    //增加缺省值
    SetDefaultValue4NewFactor(m_ModelInfoEx4New.FactorList[m_ModelInfoEx4New.FactorList.length-1]);
  }

  //设置新建因子的缺省值
  void SetDefaultValue4NewFactor(FactorInModel factor){
    factor.FactorFunc='Linear';
    factor.FactorWeight=1;
  }

  FactorInModel GetNewFactor4NewModel(){
    return m_ModelInfoEx4New.FactorList[m_ModelInfoEx4New.FactorList.length-1];
  }
  /////////////////////////////////////////////////////////////////////////
  
  
  /////////////////////////////////////////////////////////////////////////
  //新建模型新建因子筛选条件
 
  void ClearNewConditionData(){
    m_ModelInfoEx4New.CondList.clear();
  }

  void AddNewCondition4NewModel(){
    var cond = new Cond();
    SetDefaultValue4NewCond(cond);
    m_ModelInfoEx4New.CondList.add(cond);
  }

  void SetDefaultValue4NewCond(Cond cond){
    cond.CondMin=0;
    cond.CondMax=100;
  }

  Cond GetNewCondition4NewModel(){
    return m_ModelInfoEx4New.CondList[m_ModelInfoEx4New.CondList.length-1];
  }
  /////////////////////////////////////////////////////////////////////////

  //主页上的 StrategyListState 对象
  StrategyListState m_Mainform_StrategyList;

  //转换函数
  ModelInfoEx4Save ConvertModelInfoEx4Save(ModelInfoEx modelInfo){
    ModelInfoEx4Save modelInfo4Save = new ModelInfoEx4Save();

    modelInfo4Save.ModelName = modelInfo.ModelName;
    modelInfo4Save.ModelDesc = modelInfo.ModelDesc;

    modelInfo4Save.FactorList.addAll(modelInfo.FactorList);
    modelInfo4Save.IndustryList.addAll(modelInfo.IndustryList);

    modelInfo4Save.NumStock = modelInfo.NumStock;
    modelInfo4Save.DefaultInterval = modelInfo.DefaultInterval;
    
    modelInfo4Save.StockRange = modelInfo.StockRange;
    modelInfo4Save.CondList.addAll(modelInfo.CondList);
    
    return modelInfo4Save;
  }

  //当用户新建因子时，选择因子类别时，记录选择的因子类别
  String m_FactorType_NewFactor = '';

  //当用户新建因子选择条件时，选择因子类别时，记录选择的因子类别
  String m_FactorType_NewCond = '';

  //指向因子下拉列表框控件
  DropdownBtnFactorState m_dropdownFactorState;


  //缓存回测得到的数据，防止切换tab时丢失数据
  List<bool> isSelected4BackTest = [true, false, false, false, false];
  String summary4BackTest="";

  List<charts.Series<BacktestValue, DateTime>> seriesList4BackTest=[];

  List<TableRow> transRows4BackTest = [];

  double minValue4BackTest=0;
  double maxValue4BackTest=1;
  //清除 回测缓存数据
  ClearCachedBackTestData(){
    summary4BackTest='';

    minValue4BackTest=0;
    maxValue4BackTest=1;

    seriesList4BackTest=[];
    transRows4BackTest = [];
  }


  //模拟交易页面上缓存的数据，防止切换tab时丢失数据
  String m_action4Trade = '调仓';

  int m_amount4Trade=0;

  List m_posData4Trade;

  List m_orderData4Trade;

  //清除 回测缓存数据
  ClearCachedTradeData(){
    m_action4Trade='调仓';
    m_amount4Trade=100000;
    m_posData4Trade = new List();
    m_orderData4Trade = new List();
  }
}

enum FactorOrCondition{
  Factor,
  Condition,
}

enum FactorFilterWeight {
   min,
   max,
}
