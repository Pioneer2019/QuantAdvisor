import 'dart:convert';
import 'dart:io';

import 'entityclass.dart';

class WebAPIHelper {
  // 工厂模式
  factory WebAPIHelper() =>_getInstance();
  static WebAPIHelper get instance => _getInstance();
  static WebAPIHelper _instance;
  WebAPIHelper._internal() {
    // 初始化
  }
  static WebAPIHelper _getInstance() {
    if (_instance == null) {
      _instance = new WebAPIHelper._internal();
    }
    return _instance;
  }

  final _url_GetModelList = 'http://47.102.210.159:3939/ListModel';
  
  final _url_GetIndustryList = 'http://47.102.210.159:3939/ListIndustry';

  final _url_GetFactorList = 'http://47.102.210.159:3939/ListFactor';

  final _url_GetModelInfo = 'http://47.102.210.159:3939/GetModel?model_name=';


  //缓存的模型列表
  List<ModelInfo> m_Cache_ModelList = new List();
  
  //缓存的行业列表
  List<String> m_Cache_IndustryList = new List();

  //缓存的系统因子列表
  List<FactorInfo> m_Cache_FactorList = new List();

  //缓存的ModelInfoEx
  ModelInfoEx m_Cache_ModelInfoEx = new ModelInfoEx();

  //得到模型列表
  Future<List<ModelInfo>> GetModelList() async {
    
    var httpClient = new HttpClient();

    List<ModelInfo> list = new List<ModelInfo>();

    String result;

    try {
      var request = await httpClient.getUrl(Uri.parse(_url_GetModelList));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        //result = data['origin'];

        for (var item in data) {
          
            ModelInfo m = new ModelInfo();
            m.ModelName = item['ModelName'];
            m.ModelDesc = item['ModelDesc'];
            m.NumStock = item['NumStock'];
            m.WgtMethod = item['WgtMethod'];
            m.IndustryList = item['IndustryList'];
            m.FacProcess = item['FacProcess'];
            m.CYBWeight = item['CYBWeight'];
            m.DefaultInterval = item['DefaultInterval'];
            m.DefaultHedgeIndex = item['DefaultHedgeIndex'];
            m.StockRange = item['StockRange'];

            list.add(m);
        }

      } else {
        result =
            'Error getting IP address:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed getting IP address';
    }

    m_Cache_ModelList = list;
    return list;

  }

  //按照 ModelName找 ModelInfo
  ModelInfo GetModelInfoByName(String modelName){

    for (var model in m_Cache_ModelList) {
      if (model.ModelName == modelName){
        return model;
      }
    }
    
    return null;
  }

  //得到行业列表
  Future<List<String>> GetIndustryList() async {
    
    var httpClient = new HttpClient();

    List<String> list = new List();

    String result;

    try {
      var request = await httpClient.getUrl(Uri.parse(_url_GetIndustryList));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        //result = data['origin'];

        for (var item in data) {
          
            list.add(item);
        }

      } else {
        result =
            'Error getting IP address:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed getting IP address';
    }

    m_Cache_IndustryList = list;
    return list;

  }

  //得到因子列表
  Future<List<FactorInfo>> GetFactorList() async {
    
    var httpClient = new HttpClient();

    List<FactorInfo> list = new List();

    String result;

    try {
      var request = await httpClient.getUrl(Uri.parse(_url_GetFactorList));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        //result = data['origin'];

        for (var item in data) {
          var factor = new FactorInfo();
          factor.UserID = item['UserID'];
          factor.FactorName = item['FactorName'];
          factor.FactorDesc = item['FactorDesc'];

          list.add(factor);
        }

      } else {
        result =
            'Error getting IP address:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed getting IP address';
    }

    m_Cache_FactorList = list;
    return list;

  }


  //得到模型信息
  Future<ModelInfoEx> GetModelInfoExByName(String name) async {
    var httpClient = new HttpClient();

    ModelInfoEx m = new ModelInfoEx();

    String result;

    try {
      var request = await httpClient.getUrl(Uri.parse(this._url_GetModelInfo+name));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        var json = await response.transform(utf8.decoder).join();
        var data = jsonDecode(json);
        //result = data['origin'];

        m.UserID = data['UserID'][0];
        m.ModelName = data['ModelName'][0];
        m.ModelDesc = data['ModelDesc'][0];
        m.FactorList = new List();
        
        for(var f in [data['FactorList'][0]]){
             var fc = new FactorInModel();
             fc.FactorWeight = f["FactorWeight"];
             fc.FactorName = f["FactorName"];
             fc.FactorDesc = f["FactorDesc"];

             m.FactorList.add(fc);
        }

        m.IndustryList = data['IndustryList'][0];
        m.FacProcess = data['FacProcess'][0];
        m.WgtMethod = data['WgtMethod'][0];

        m.NumStock = data['NumStock'][0];
        m.CYBWeight = data['CYBWeight'][0];
        m.DefaultInterval = data['DefaultInterval'][0];
        m.DefaultHedgeIndex = data['DefaultHedgeIndex'][0];
        m.StockRange = data['StockRange'][0];
        
        m.CondList = new List();
        if (data['CondList'].length>0){
          for(var c in [data['CondList'][0]]){
              Cond cond = new Cond();
              cond.CondName = c['CondName'];
              cond.CondMin = c['CondMin'];
              cond.CondMax = c['CondMax'];

              m.CondList.add(cond);
          }

        }
        
        if (data['SkipHead'].length>0){
            m.SkipHead = data['SkipHead'][0];
        }
        

        m_Cache_ModelInfoEx = m;

      } else {
        result =
            'Error getting IP address:\nHttp status ${response.statusCode}';
      }
    } catch (exception) {
      result = 'Failed getting IP address';
    }

    return m;
  }
  
  //用 name 查找 因子 factor
  FactorInfo GetFactorInfoByName(String name){
    for(var f in m_Cache_FactorList){
      if (f.FactorName == name){
        return f;
      }
    }
    var fc = new FactorInfo();
    fc.FactorDesc="";
    return fc;
  }

  //返回函数列表
  List<String> GetFunctionList(){
    List<String> funcList = new List();
    funcList.add('Linear');
    funcList.add('Sigmoid');
    funcList.add('LinearInt');
    funcList.add('SigmoidInt');
    return funcList;
  }

}