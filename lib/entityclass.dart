

class ModelInfo{

  String ModelName;

  String ModelDesc;
  
  int NumStock;

  String WgtMethod;

  List<String> IndustryList = new List();

  String FacProcess;

  int CYBWeight;

  int DefaultInterval;

  String DefaultHedgeIndex;

  String StockRange;

}

class ModelInfoEx{

  String UserID = "";

  String ModelName = "";

  String ModelDesc = "";
  
  List<FactorInModel> FactorList;

  List<String> IndustryList = new List();

  String FacProcess = "";

  String WgtMethod = "";

  int NumStock;

  int CYBWeight;

  int DefaultInterval;

  String DefaultHedgeIndex = "";

  String StockRange = "";

  List<Cond> CondList = new List();

  int SkipHead;
}

class ModelInfoEx4New{

  String ModelName = "";

  String ModelDesc = "";
  
  List<FactorInModel> FactorList = new List();

  List<String> IndustryList = new List();

  int NumStock;

  int DefaultInterval;

  String StockRange = "";

  List<Cond> CondList = new List();

}

class ModelInfoEx4NewJson{

  List<String> ModelName = new List();

  List<String> ModelDesc = new List();
  
  List<FactorInModel> FactorList = new List();

  List<String> IndustryList = new List();

  List<int> NumStock = new List();

  List<int> DefaultInterval = new List();

  List<String> StockRange = new List();

  List<Cond> CondList = new List();

  ModelInfoEx4NewJson(ModelInfoEx4New modelInfo){
    
    ModelName.add(modelInfo.ModelName);
    ModelDesc.add(modelInfo.ModelDesc);
    NumStock.add(modelInfo.NumStock);
    
    for(var i in modelInfo.IndustryList){
      IndustryList.add(i);
    }

    DefaultInterval.add(modelInfo.DefaultInterval);
    StockRange.add(modelInfo.StockRange);

    for(var f in modelInfo.FactorList){
      FactorList.add(f);
    }
    
    for(var c in modelInfo.CondList){
      CondList.add(c);
    }

  }

  Map<String,dynamic> toJson() =>
  {
    'ModelName' : ModelName,
    'ModelDesc' : ModelDesc,
    'NumStock' : NumStock,
    'IndustryList' : IndustryList,
    'DefaultInterval' : DefaultInterval,
    'StockRange' : StockRange,
    'FactorList' : FactorList,
    'CondList' : CondList,
  };


}

class FactorInfo{

  String UserID;

  String FactorName;

  String FactorDesc;
}


class FactorInModel{

  int   FactorWeight;                                                                                                                                                     

  String FactorName;

  String FactorDesc;

  //模型新建因子时用到
  String FactorFunc;

  Map<String,dynamic> toJson() =>
  {
    'FactorName' : FactorName,
    'FactorWeight' : FactorWeight,
    'FactorFunc' : FactorFunc,
  };

}

class Cond{

  String CondName;

  int CondMin;

  int CondMax;

  Map<String,dynamic> toJson() =>
  {
    'CondName' : CondName,
    'CondMin' : CondMin,
    'CondMax' : CondMax,
  };

}