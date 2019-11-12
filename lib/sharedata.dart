import 'FactorFilterList.dart';
import 'entityclass.dart';
import 'entityclass.dart';
import 'entityclass.dart';
import 'entityclass.dart';

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

  /////////////////////////////////////////////////////////////////////////
  //新建因子的权重
  List<FactorInModel> FactorList4NewModel = new List();
  //true: Save;  false: cancel
  bool SaveOrCancelAction = false;

  void ClearNewFactorData(){
    FactorList4NewModel.clear();
    SaveOrCancelAction = false;
  }

  void AddNewFactor4NewModel(){
    FactorList4NewModel.add(new FactorInModel());
  }

  FactorInModel GetNewFactor4NewModel(){
    return FactorList4NewModel[FactorList4NewModel.length-1];
  }
  /////////////////////////////////////////////////////////////////////////
  
  
  /////////////////////////////////////////////////////////////////////////
  //新建因子筛选条件
  List<Cond> CondList4NewModel = new List();
  
  void ClearNewConditionData(){
    CondList4NewModel.clear();
  }

  void AddNewCondition4NewModel(){
    CondList4NewModel.add(new Cond());
  }

  Cond GetNewCondition4NewModel(){
    return CondList4NewModel[CondList4NewModel.length-1];
  }
  /////////////////////////////////////////////////////////////////////////


  ///////////////////////////////////////////////////////////////////////////////////////
  ///保存模型信息
  ModelInfoEx4New m_ModelInfoEx4New = new ModelInfoEx4New();

  ClearModelInfoEx4New(ModelInfoEx4New modelInfoEx){
    m_ModelInfoEx4New.ModelName='';
    m_ModelInfoEx4New.ModelDesc='';
    m_ModelInfoEx4New.NumStock=0;
    m_ModelInfoEx4New.IndustryList = '';
    m_ModelInfoEx4New.DefaultInterval=0;
    m_ModelInfoEx4New.StockRange='';
    m_ModelInfoEx4New.FactorList = new List();
    m_ModelInfoEx4New.CondList = new List();
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
