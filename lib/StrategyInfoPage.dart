import 'package:flutter/material.dart';
import 'entityclass.dart';
import 'sharedata.dart';
import 'webapihelper.dart';

import 'StrategyBasic.dart';
import 'FactorList.dart';
import 'FactorFilterList.dart';

import 'backTest.dart';
import 'showdialog.dart';
import 'trade.dart';

class StrategyInfoPage extends StatefulWidget {
  
  String m_ModelName;
  ModelInfoEx m_CurrentModel = new ModelInfoEx();
  
  StrategyInfoPage(pModelName){
      m_ModelName = pModelName;

      //m_CurrentModel = WebAPIHelper.instance.GetModelInfoByName(pModelName);
  }

  @override
  _StrategyInfoPageState createState() => _StrategyInfoPageState();
  
  
}

class _StrategyInfoPageState extends State<StrategyInfoPage> with SingleTickerProviderStateMixin
{

  TabController m_tabController;

  _GetModelInfoExAsync() async {

    ModelInfoEx m = await WebAPIHelper.instance.GetModelInfoExByName(widget.m_ModelName);

    if (mounted){
      setState((){
        widget.m_CurrentModel = m;
      });
    }

  }

  @override
  void initState() {

    //清除缓存的回测数据
    SharedData.instance.ClearCachedBackTestData();

    SharedData.instance.ClearCachedTradeData();

    _GetModelInfoExAsync();

    //print('初始化 数据...');
    m_tabController = new TabController(
        vsync: this,//固定写法
        length: 5   //指定tab长度
    );
    //添加监听
    m_tabController.addListener((){
      var index = m_tabController.index;
      var previousIndex = m_tabController.previousIndex;
      print("index: $index");
      print('previousIndex: $previousIndex');
    });
    super.initState();
  }

  void SaveModelInfoAction(ModelInfoEx4Save modelInfo4Save){
    //保存模型信息
    WebAPIHelper.instance.SaveModelInfo(modelInfo4Save);

    Navigator.pop(context,true);
  }

  @override
  Widget build(BuildContext context) {

    //判断缓存的modelInfo 是否和当前的modelInfo 一致
    //https://stackoverflow.com/questions/55208620/flutter-textfield-focus-rebuilds-widget-if-keyboardtype-changes
    if (WebAPIHelper.instance.m_Cache_ModelInfoEx.ModelName != this.widget.m_CurrentModel.ModelName && 
        this.widget.m_ModelName == WebAPIHelper.instance.m_Cache_ModelInfoEx.ModelName){
      this.widget.m_CurrentModel = WebAPIHelper.instance.m_Cache_ModelInfoEx;
    }

    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('策略详情  '+widget.m_ModelName),
            bottom: TabBar(
              controller: m_tabController,
              isScrollable: true,
              labelStyle: TextStyle(fontSize: 14.0,),
              tabs: <Widget>[
                Tab(text: '基本',),
                Tab(text: '打分',),
                Tab(text: '筛选',),
                Tab(text: '回测',),
                Tab(text: '交易',),
              ],
            ),
          ),

        body: new TabBarView_StrategyInfo2(m_tabController,widget.m_CurrentModel),

        bottomNavigationBar: BottomNavigationBar( // 底部导航
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.save), title: Text('保存')),
              BottomNavigationBarItem(icon: Icon(Icons.content_copy), title: Text('另存为')),
              BottomNavigationBarItem(icon: Icon(Icons.hotel), title: Text('返回')),
            ],

            onTap:  (index) {

              if (index == 0){
                //保存当前编辑的模型
                ModelInfoEx4Save modelInfo4Save = SharedData.instance.ConvertModelInfoEx4Save(widget.m_CurrentModel);

                var br = Dialog4Save.instance.CheckInputValue4Save(
                      modelInfo4Save,context,true);
                if (br==false){
                  return;
                }

                //保存模型信息
                WebAPIHelper.instance.SaveModelInfo(modelInfo4Save);

                Dialog4Save.instance.ShowDialog_MsgBox(context, '模型保存成功!');

                ////返回到调用页面
                //Navigator.pop(context,true);
              }
              else if (index == 1){
                //另存为另一个模型，复制一个模型，然后弹出一个对话框，输入新的模型名称
                ModelInfoEx4Save modelInfo4Save = SharedData.instance.ConvertModelInfoEx4Save(widget.m_CurrentModel);

                Dialog4Save.instance.SaveAsModel(modelInfo4Save,context,SaveModelInfoAction);
                
              }
              else if (index == 2){
                //返回到调用页面
                Navigator.pop(context,false);
              }
              
            }

          ),
        ),
      );
  }
}

class TabBarView_StrategyInfo2 extends StatelessWidget
{
  TabController m_tabController;
  //String m_ModelName;
  ModelInfoEx m_ModelInfo = new ModelInfoEx();

  TabBarView_StrategyInfo2(TabController tabControl,ModelInfoEx modelInfo)
  {
    m_tabController = tabControl;
    m_ModelInfo = modelInfo;
  }

  @override
  Widget build(BuildContext context)
  {
    return new TabBarView(
            controller: m_tabController,
            children: <Widget>[
              Container(
                color: Color(0xffffffff),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(8),
                child: new StrategyBasic(m_ModelInfo,false),
              ),
              Container(
                color: Color(0xffffffff),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(8),
                child: new FactorList(m_ModelInfo,false),
              ),
              Container(
                color: Color(0xffffffff),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(8),
                child: new FactorFilterList(m_ModelInfo,false),
              ),
              
              Container(
                color: Color(0xffffffff),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(8),
                child: new BackTest(m_ModelInfo),
              ),
              Container(
                color: Color(0xffffffff),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(8),
                child: new TradePage(m_ModelInfo),
              ),

            ],
          );
  }
}

