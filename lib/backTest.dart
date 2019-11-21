import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'webapihelper.dart';

class BackTest extends StatefulWidget
{
  String m_ModelName;
  BackTest(this.m_ModelName);
  @override
  _BackTestState createState() => _BackTestState(m_ModelName);
}

class _BackTestState extends State<BackTest>
{
  String m_ModelName;
  String m_startDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 183)));
  String m_endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String m_Result = "";
  List<bool> isSelected = [true, false, false, false, false]; //半年，1年，3年，5年，10年
  String summary="";
  double model_annual_ret=0;
  double model_mdd=0;
  double model_sharpe=0;
  double avg_turnover=0;
  List<charts.Series<BacktestValue, DateTime>> seriesList=[];
  List<TableRow> transRows=[];

  _BackTestState(this.m_ModelName);

   @override
  Widget build(BuildContext context)
  {
    Size deviceSize = MediaQuery.of(context).size;
    //return Flex(
    return SingleChildScrollView(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        //mainAxisSize: MainAxisSize.max,
       //direction: Axis.vertical,
       children: <Widget>[
         new Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: <Widget>[
                new Expanded(
                  flex:3,
                  child: 
                    ToggleButtons(
                      children: <Widget>[
                        Text("半年"),
                        Text("1年"),
                        Text("3年"),
                        Text("5年"),
                        Text("10年"),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                            if (buttonIndex == index) {
                              isSelected[buttonIndex] = true;
                              if (index == 0)
                                m_startDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 183)));
                              else if (index == 1)
                                m_startDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 365)));
                              else if (index == 2)
                                m_startDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 365*3)));
                              else if (index == 3)
                                m_startDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 365*5)));
                              else if (index == 4)
                                m_startDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 365*10)));
                            } else {
                              isSelected[buttonIndex] = false;
                            }
                          }
                        });
                      },
                      isSelected: isSelected,
                    ),
                ),
                
                new Expanded(
                  flex:1,
                  child: new RaisedButton(
                    padding: EdgeInsets.all(10),
                        onPressed: () async {
                          print("Start back test");
                          String result = await WebAPIHelper.instance.TestModel(widget.m_ModelName, m_startDate.replaceAll("-", ""), m_endDate.replaceAll("-", ""));
                          //print(json);
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
                            List<BacktestValue> modelValue = [];
                            List<BacktestValue> hs300Value = [];
                            List<BacktestValue> zz500Value = [];
                            for (var i=0; i< model_daily_rtn['Value'].length; i++) {
                              //print(DateTime.parse(model_daily_rtn['Date'][i].toString()));
                              modelValue.add(new BacktestValue(DateTime.parse(model_daily_rtn['Date'][i].toString()), model_daily_rtn['Value'][i].toDouble()));
                              hs300Value.add(new BacktestValue(DateTime.parse(model_daily_rtn['Date'][i].toString()), model_daily_rtn['HS300'][i].toDouble()));
                              zz500Value.add(new BacktestValue(DateTime.parse(model_daily_rtn['Date'][i].toString()), model_daily_rtn['ZZ500'][i].toDouble()));
                            }
                            seriesList = [
                              new charts.Series<BacktestValue, DateTime>(
                                id: '沪深300',
                                colorFn: (_, __) => charts.MaterialPalette.lime.shadeDefault,
                                domainFn: (BacktestValue value, _) => value.date,
                                measureFn: (BacktestValue value, _) => value.value,
                                data: hs300Value,
                              ),
                              new charts.Series<BacktestValue, DateTime>(
                                id: '中证500',
                                colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
                                domainFn: (BacktestValue value, _) => value.date,
                                measureFn: (BacktestValue value, _) => value.value,
                                data: zz500Value,
                              ),
                              new charts.Series<BacktestValue, DateTime>(
                                id: '策略净值',
                                colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
                                domainFn: (BacktestValue value, _) => value.date,
                                measureFn: (BacktestValue value, _) => value.value,
                                data: modelValue,
                              ),
                            ];
                            transRows = [];
                            transRows.add(
                              new TableRow(
                                children: <Widget>[
                                  new TableCell(child:Text("调仓日")),
                                  new TableCell(child:Text("代码")),
                                  new TableCell(child:Text("简称")),
                                  new TableCell(child:Text("行业")),
                                  new TableCell(child:Text("权重")),
                                  new TableCell(child:Text("收益")),
                                ]
                              )
                            );

                            var sch_stock_data_list = data['sch_stock_data_list'];
                            for (var i=sch_stock_data_list.length-1; i>=0;i--) {
                              var tradeDate = sch_stock_data_list[i]['Date'];
                              var symbol = sch_stock_data_list[i]['Symbol'];
                              var name = sch_stock_data_list[i]['Name'];
                              var industry = sch_stock_data_list[i]['Industry'];
                              var weight = sch_stock_data_list[i]['Weight'];
                              var ret = sch_stock_data_list[i]['Return'];
                              transRows.add(new TableRow(
                                children: <Widget>[
                                  new TableCell(child:Text(tradeDate[1].toString(),style: TextStyle(fontSize: 11.0))),
                                  new TableCell(child:Text("")),
                                  new TableCell(child:Text("")),
                                  new TableCell(child:Text("")),
                                  new TableCell(child:Text("")),
                                  new TableCell(child:Text("")),
                                ]));
                              for (var j=0; j<symbol.length; j++) {
                                transRows.add(
                                  new TableRow(
                                    children: <Widget>[
                                      new TableCell(child:Text(tradeDate[j].toString(),style: TextStyle(fontSize: 11.0))),
                                      new TableCell(child:Text(NumberFormat("000000").format(symbol[j]),style: TextStyle(fontSize: 11.0))),
                                      new TableCell(child:Text(name[j],style: TextStyle(fontSize: 11.0))),
                                      new TableCell(child:Text(industry[j]!=null?industry[j]:"",style: TextStyle(fontSize: 11.0))),
                                      new TableCell(child:Text(NumberFormat("##.##%").format(weight[j]),style: TextStyle(fontSize: 11.0), textAlign: TextAlign.right,)),
                                      new TableCell(child:Text(NumberFormat("##.##%").format(ret[j]),style: TextStyle(fontSize: 11.0), textAlign: TextAlign.right)),
                                    ]
                                  )
                                );
                              }
                            }
                          }
                          if (mounted) {
                            setState(() {
                              m_Result = result;
                              seriesList;
                              transRows;
                            });
                          }
                        },
                      child: const Text(
                        '回测',
                        style: TextStyle(fontSize: 13)
                      ),
                        ), 
                ),
                
           ]
          ),
          new Text(summary),
          new Visibility( visible: seriesList.length>0,
            child: new SizedBox(
              width: deviceSize.width*0.88,
              height: deviceSize.height*0.4,
              child:new charts.TimeSeriesChart(
                seriesList,
                behaviors: [
                  new charts.SlidingViewport(),
                  new charts.PanAndZoomBehavior(),
                  new charts.SeriesLegend()
                ],
              ),
            )
          ),
          new Table(
            border: TableBorder.all(),
            children: transRows,
          ),
        //new BackTestTabControl(m_Result),
       ]
      )
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
  final DateTime date;
  final double value;

  BacktestValue(this.date, this.value);
}

class TabBarView_BackTest extends StatelessWidget{
  Size deviceSize;
  TabController m_tabController;
  String summary;
  double model_annual_ret;
  double model_mdd;
  double model_sharpe;
  double avg_turnover;
  List<charts.Series<BacktestValue, DateTime>> seriesList;
  List<TableRow> transRows;

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
      List<BacktestValue> modelValue = [];
      List<BacktestValue> hs300Value = [];
      List<BacktestValue> zz500Value = [];
      for (var i=0; i< model_daily_rtn['Value'].length; i++) {
        //print(DateTime.parse(model_daily_rtn['Date'][i].toString()));
        modelValue.add(new BacktestValue(DateTime.parse(model_daily_rtn['Date'][i].toString()), model_daily_rtn['Value'][i].toDouble()));
        hs300Value.add(new BacktestValue(DateTime.parse(model_daily_rtn['Date'][i].toString()), model_daily_rtn['HS300'][i].toDouble()));
        zz500Value.add(new BacktestValue(DateTime.parse(model_daily_rtn['Date'][i].toString()), model_daily_rtn['ZZ500'][i].toDouble()));
      }
      seriesList = [
        new charts.Series<BacktestValue, DateTime>(
          id: '沪深300',
          colorFn: (_, __) => charts.MaterialPalette.lime.shadeDefault,
          domainFn: (BacktestValue value, _) => value.date,
          measureFn: (BacktestValue value, _) => value.value,
          data: hs300Value,
        ),
        new charts.Series<BacktestValue, DateTime>(
          id: '中证500',
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (BacktestValue value, _) => value.date,
          measureFn: (BacktestValue value, _) => value.value,
          data: zz500Value,
        ),
        new charts.Series<BacktestValue, DateTime>(
          id: '策略净值',
          colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
          domainFn: (BacktestValue value, _) => value.date,
          measureFn: (BacktestValue value, _) => value.value,
          data: modelValue,
        ),
      ];
      transRows = [];
      transRows.add(
        new TableRow(
          children: <Widget>[
            new TableCell(child:Text("调仓日")),
            new TableCell(child:Text("代码")),
            new TableCell(child:Text("简称")),
            new TableCell(child:Text("行业")),
            new TableCell(child:Text("权重")),
            new TableCell(child:Text("收益")),
          ]
        )
      );

      var sch_stock_data_list = data['sch_stock_data_list'];
      for (var i=sch_stock_data_list.length-1; i>=0;i--) {
        var tradeDate = sch_stock_data_list[i]['Date'];
        var symbol = sch_stock_data_list[i]['Symbol'];
        var name = sch_stock_data_list[i]['Name'];
        var industry = sch_stock_data_list[i]['Industry'];
        var weight = sch_stock_data_list[i]['Weight'];
        var ret = sch_stock_data_list[i]['Return'];
        transRows.add(new TableRow(
          children: <Widget>[
            new TableCell(child:Text(tradeDate[1].toString(),style: TextStyle(fontSize: 11.0))),
            new TableCell(child:Text("")),
            new TableCell(child:Text("")),
            new TableCell(child:Text("")),
            new TableCell(child:Text("")),
            new TableCell(child:Text("")),
          ]));
        for (var j=0; j<symbol.length; j++) {
          transRows.add(
            new TableRow(
              children: <Widget>[
                new TableCell(child:Text(tradeDate[j].toString(),style: TextStyle(fontSize: 11.0))),
                new TableCell(child:Text(NumberFormat("000000").format(symbol[j]),style: TextStyle(fontSize: 11.0))),
                new TableCell(child:Text(name[j],style: TextStyle(fontSize: 11.0))),
                new TableCell(child:Text(industry[j],style: TextStyle(fontSize: 11.0))),
                new TableCell(child:Text(NumberFormat("##.##%").format(weight[j]),style: TextStyle(fontSize: 11.0), textAlign: TextAlign.right,)),
                new TableCell(child:Text(NumberFormat("##.##%").format(ret[j]),style: TextStyle(fontSize: 11.0), textAlign: TextAlign.right)),
              ]
            )
          );
        }
      }
    } else {
      summary = "";
      seriesList = [];
      transRows = [];
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Text(summary),
                    new SizedBox(
                      width: deviceSize.width*0.88,
                      height: deviceSize.height*0.4,
                      child:new charts.TimeSeriesChart(
                        seriesList,
                        behaviors: [
                          new charts.SlidingViewport(),
                          new charts.PanAndZoomBehavior(),
                          new charts.SeriesLegend()
                        ],
                      ),
                    )
                  ],
                )
              ),

             SingleChildScrollView(
               padding: EdgeInsets.all(5),
                child: new Table(
                  border: TableBorder.all(),
                  children: transRows,
                ),
              ),

      ],)
    );

  }
}