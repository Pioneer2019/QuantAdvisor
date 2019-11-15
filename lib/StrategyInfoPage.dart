import 'package:flutter/material.dart';
import 'package:uitest2/entityclass.dart';
import 'package:uitest2/sharedata.dart';
import 'package:uitest2/webapihelper.dart';

import 'StrategyBasic.dart';
import 'FactorList.dart';
import 'FactorFilterList.dart';

import 'backTest.dart';
import 'showdialog.dart';


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

  void SaveModelInfoAction(ModelInfoEx4Save modelInfo4Save){
    //保存模型信息
    WebAPIHelper.instance.SaveModelInfo(modelInfo4Save);

    Navigator.pop(context,true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
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

                //返回到调用页面
                Navigator.pop(context,true);
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
                child: new BackTest(m_ModelInfo.ModelName),
              ),
              Container(
                color: Color(0xffffffff),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(8),
                child: new FactorFilterList(m_ModelInfo,false),
              ),

            ],
          );
  }
}

