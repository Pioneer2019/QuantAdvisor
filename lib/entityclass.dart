

class ModelInfo{

  String ModelName;

  String ModelDesc;
  
  int NumStock;

  String WgtMethod;

  String IndustryList;

  String FacProcess;

  int CYBWeight;

  int DefaultInterval;

  String DefaultHedgeIndex;

  String StockRange;

}

class ModelInfoEx{

  String UserID;

  String ModelName;

  String ModelDesc;
  
  List<FactorInModel> FactorList;

  String IndustryList;

  String FacProcess;

  String WgtMethod;

  int NumStock;

  int CYBWeight;

  int DefaultInterval;

  String DefaultHedgeIndex;

  String StockRange;

  List<Cond> CondList;

  int SkipHead;
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
}

class Cond{

  String CondName;

  int CondMin;

  int CondMax;
}