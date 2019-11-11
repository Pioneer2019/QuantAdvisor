import 'package:flutter/material.dart';
import 'package:uitest2/entityclass.dart';
import 'package:uitest2/webapihelper.dart';

import 'StrategyBasic.dart';
import 'FactorList.dart';
import 'FactorFilterList.dart';

import 'backTest.dart';


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

      setState((){
        widget.m_CurrentModel = m;
      });

  }

  @override
  void initState() {

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
          appBar: AppBar(
            title: Text('策略详情'),
            bottom: TabBar(
              controller: m_tabController,
              isScrollable: true,
              labelStyle: TextStyle(fontSize: 14.0,),
              tabs: <Widget>[
                Tab(text: '基本设置',),
                Tab(text: '打分设置',),
                Tab(text: '筛选设置',),
                Tab(text: '回测',),
                Tab(text: '选股交易',),
              ],
            ),
          ),

        body: new TabBarView_StrategyInfo2(m_tabController,widget.m_CurrentModel),

        bottomNavigationBar: BottomNavigationBar( // 底部导航
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(icon: Icon(Icons.save), title: Text('保存')),
              BottomNavigationBarItem(icon: Icon(Icons.hotel), title: Text('返回')),
            ],
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
                child: new StrategyBasic(m_ModelInfo),
              ),
              Container(
                color: Color(0xffffffff),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(8),
                child: new FactorList(m_ModelInfo),
              ),
              Container(
                color: Color(0xffffffff),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(8),
                child: new FactorFilterList(m_ModelInfo),
              ),
              
              Container(
                color: Color(0xffffffff),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(8),
                child: new BackTest(),
              ),
              Container(
                color: Color(0xffffffff),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(8),
                child: new FactorFilterList(m_ModelInfo),
              ),

            ],
          );
  }
}

