import 'FactorFilterList.dart';
import 'entityclass.dart';
import 'entityclass.dart';
import 'entityclass.dart';
import 'entityclass.dart';
import 'main.dart';

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
    m_ModelInfoEx4New.ModelName='';
    m_ModelInfoEx4New.ModelDesc='';
    m_ModelInfoEx4New.NumStock=0;
    m_ModelInfoEx4New.IndustryList = new List();
    m_ModelInfoEx4New.DefaultInterval=0;
    m_ModelInfoEx4New.StockRange='';
    m_ModelInfoEx4New.FactorList = new List();
    m_ModelInfoEx4New.CondList = new List();
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
    m_ModelInfoEx4New.CondList.add(new Cond());
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
}

enum FactorOrCondition{
  Factor,
  Condition,
}

enum FactorFilterWeight {
   min,
   max,
}
