import 'dart:convert';
import 'dart:math';
import 'package:QuantAdvisorApp/sharedata.dart';
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


class BacktestValue {
  final DateTime date;
  final double value;

  BacktestValue(this.date, this.value);
}

class _BackTestState extends State<BackTest>
{
  String m_ModelName;
  String m_startDate = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 183)));
  String m_endDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String m_Result = "";
  List<bool> isSelected = [true, false, false, false, false]; //半年，1年，3年，5年，10年
  
  //String summary="";
  set summary(String value){
    SharedData.instance.summary4BackTest = value;
  }
  String get summary{
    return SharedData.instance.summary4BackTest;
  }

  double model_annual_ret=0;
  double model_mdd=0;
  double model_sharpe=0;
  double avg_turnover=0;

  //List<charts.Series<BacktestValue, DateTime>> seriesList=[];
  set seriesList(List<charts.Series<BacktestValue, DateTime>> value){
    SharedData.instance.seriesList4BackTest = value;
  }
  List<charts.Series<BacktestValue, DateTime>> get seriesList{
    return SharedData.instance.seriesList4BackTest;
  }

  //List<TableRow> transRows=[];
  set transRows(List<TableRow> value){
    SharedData.instance.transRows4BackTest = value;
  }
  List<TableRow> get transRows{
    return SharedData.instance.transRows4BackTest;
  }

  //double minValue=0;
  set minValue(double value){
    SharedData.instance.minValue4BackTest = value;
  }
  double get minValue{
    return SharedData.instance.minValue4BackTest;
  }

  //double maxValue=1;
  set maxValue(double value){
    SharedData.instance.maxValue4BackTest = value;
  }
  double get maxValue{
    return SharedData.instance.maxValue4BackTest;
  }

  bool isTesting=false;

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
        //ftw git push test
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
              new Visibility( visible: isTesting,
                  child: new Container(width:20, height:20, margin: EdgeInsets.all(2),child:new Center(child:new CircularProgressIndicator(),))
              ),
              new Visibility( visible: !isTesting,
                  child: new Expanded(
                flex:1,
                child: new RaisedButton(
                  padding: EdgeInsets.all(10),
                      onPressed: () async {
                        if (isTesting) return;
                        setState(() {
                          isTesting = true;
                        });

                        //清除缓存的回测数据
                        SharedData.instance.ClearCachedBackTestData();

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
                          maxValue = -1/0;
                          minValue = 1/0;
                          for (var i=0; i< model_daily_rtn['Value'].length; i++) {
                            //print(DateTime.parse(model_daily_rtn['Date'][i].toString()));
                            maxValue = max(maxValue, max(model_daily_rtn['Value'][i].toDouble(),max(model_daily_rtn['HS300'][i].toDouble(),model_daily_rtn['ZZ500'][i].toDouble())));
                            minValue = min(minValue, min(model_daily_rtn['Value'][i].toDouble(),min(model_daily_rtn['HS300'][i].toDouble(),model_daily_rtn['ZZ500'][i].toDouble())));
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
                                    new TableCell(child:Text(NumberFormat("##.##%").format(ret[j]),style: TextStyle(fontSize: 11.0, color: ret[j]>0?Colors.red:Colors.green), textAlign: TextAlign.right)),
                                  ]
                                )
                              );
                            }
                          }
                        }
                        if (mounted) {
                          setState(() {
                            isTesting = false;
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
              )
           ]
          ),
          new SizedBox(height: 5.0,),
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
                primaryMeasureAxis: new charts.NumericAxisSpec(viewport: new charts.NumericExtents((minValue-0.1), (maxValue+0.1))),
              ),
            )
          ),
          new SizedBox(height: 5.0,),
          new Visibility( visible: seriesList.length>0,
            child: Text("交易记录"),
          ),
          new SizedBox(height: 5.0,),
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
