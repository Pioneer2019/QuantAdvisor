import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'webapihelper.dart';

class BackTest extends StatefulWidget
{
  String m_ModelName;
  BackTest(pModelName){
      m_ModelName = pModelName;

      //m_CurrentModel = WebAPIHelper.instance.GetModelInfoByName(pModelName);
  }
  @override
  _BackTestState createState() => _BackTestState();
}

class _BackTestState extends State<BackTest>
{
  String m_startDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 183)));
  String m_endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String m_Result = "";

   @override
  Widget build(BuildContext context)
  {
    Size deviceSize = MediaQuery.of(context).size;
    //return Flex(
      return Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisSize: MainAxisSize.max,
       //direction: Axis.vertical,
       children: <Widget>[
         new Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
                new Expanded(
                  flex:2,
                  child: 
                  new GestureDetector(
                         child: Text(
                            '开始日期:$m_startDate',
                            style: TextStyle(fontSize: 13),),
                    
                    onTap: () {
                        // 调用函数打开
                        showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(m_startDate),
                            firstDate: new DateTime(2009,1,1),
                            lastDate: new DateTime.now(),
                        ).then((DateTime val) {
                            print(val);   // 2018-07-12 00:00:00.000

                            if (val!=null) {
                              setState(() {
                               m_startDate = DateFormat('yyyy-MM-dd').format(val);
                              });
                            }
                            
                        }).catchError((err) {
                            print(err);
                        });
                    },
                  ),
                ),
                
              new Expanded(
                  flex:2,
                  child: 
                  new GestureDetector(
                    child: new Text(
                          '结束日期:$m_endDate'
                        ),
                    onTap: () {
                        // 调用函数打开
                        showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(m_endDate),
                            firstDate: new DateTime(2009,1,1),
                            lastDate: new DateTime.now(),
                        ).then((DateTime val) {
                            print(val);   // 2018-07-12 00:00:00.000

                            if (val!=null) {
                              setState(() {
                                m_endDate = DateFormat('yyyy-MM-dd').format(val);
                              });
                            }
                            
                        }).catchError((err) {
                            print(err);
                        });
                    },
                  ),
                ),
                
                new Expanded(
                  flex:1,
                  child: new RaisedButton(
                    padding: EdgeInsets.all(10),
                        onPressed: () async {
                          print("Start back test");
                          String json = await WebAPIHelper.instance.TestModel(widget.m_ModelName, m_startDate.replaceAll("-", ""), m_endDate.replaceAll("-", ""));
                          //print(json);
                          setState(() {
                            m_Result = json;
                          });
                        },
                      child: const Text(
                        '开始回测',
                        style: TextStyle(fontSize: 13)
                      ),
                        ), 
                ),
                
           ]
         ),

        new BackTestTabControl(m_Result),

       ]
);
  }
}

class BackTestTabControl extends StatefulWidget {
  String m_Result;
  BackTestTabControl(this.m_Result);
  
  @override
  _BackTestTabControlState createState() => _BackTestTabControlState();
}

class _BackTestTabControlState extends State<BackTestTabControl> with SingleTickerProviderStateMixin{

  TabController m_tabController;

  @override
  void initState() {
    print('_BackTestTabControlState initState');
    m_tabController = new TabController(
        vsync: this,//固定写法
        length: 2,   //指定tab长度
        
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
    print('_BackTestTabControlState build');
    return new Column(
      
      children: <Widget>[
        
          new TabBar(
                  controller: m_tabController,
                  isScrollable: true,
                  labelStyle: TextStyle(fontSize: 12.0,),
                  labelColor: Colors.black,
                  tabs: <Widget>[
                    Tab(text: '策略绩效',),
                    Tab(text: '交易明细',),
                  ],
                ),

            new TabBarView_BackTest(m_tabController,widget.m_Result),

      ]
    );
  }
}

class BacktestValue {
  final int seq;
  final double value;

  BacktestValue(this.seq, this.value);
}

class TabBarView_BackTest extends StatelessWidget{
  Size deviceSize;
  TabController m_tabController;
  String summary;
  double model_annual_ret;
  double model_mdd;
  double model_sharpe;
  double avg_turnover;
  List<charts.Series<BacktestValue, int>> seriesList;

  TabBarView_BackTest(TabController tabControl, String result)
  {
    m_tabController = tabControl;
    if (result.length > 0) {
      var data = jsonDecode(result);
      print(data['ModelName']);
      model_annual_ret = data['model_annual_ret']*100;
      model_mdd = data['model_mdd']*100;
      model_sharpe = data['model_sharpe'];
      avg_turnover = data['avg_turnover']*100;
      var formatter = new NumberFormat("#,###.##");
      summary = "年化收益率=${formatter.format(model_annual_ret)}%,最大回撤=${formatter.format(model_mdd)}%\n夏普比=${formatter.format(model_sharpe)},平均调仓换手率=${formatter.format(avg_turnover)}%";
      var model_daily_rtn = data['model_daily_rtn'];
      print(model_daily_rtn['Value'].length);
      List<BacktestValue> seriesData = [];
      for (var i=0; i< model_daily_rtn['Value'].length; i++) {
        seriesData.add(new BacktestValue(i, model_daily_rtn['Value'][i]));
      }
      seriesList = [
        new charts.Series<BacktestValue, int>(
        id: 'Value',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BacktestValue value, _) => value.seq,
        measureFn: (BacktestValue value, _) => value.value,
        data: seriesData,
      )
      ];
    } else {
      summary = "";
      seriesList = [];
    }
  }

  @override
  Widget build(BuildContext context){
    deviceSize = MediaQuery.of(context).size;
    print('TabBarView_BackTest build');
    print(deviceSize);
    return new SizedBox(
      
      
      width: deviceSize.width*0.9,
      height: deviceSize.height*0.5,

      child: new TabBarView(
          
          controller: m_tabController,
                  
        
        children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(summary),
                    new SizedBox(
                      width: deviceSize.width*0.85,
                      height: 200,
                      child:new charts.LineChart(seriesList),
                    )
                  ],
                )
              ),

             Container(
                color: Color(0xffffffff),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(0),
                child: new Text(""),
              ),

      ],)
    );

  }
}