import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'webapihelper.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class TradePage extends StatefulWidget
{
  String m_ModelName;

  TradePage(pModelName){
    m_ModelName = pModelName;
  }
  @override
  _TradePageState createState() => _TradePageState(m_ModelName);
}

class _TradePageState extends State<TradePage>
{
  List m_posData;
  List m_orderData;
  String m_action;
  int m_amount;
  void GetSimPos() async {
      String strPos = await WebAPIHelper.instance.GetSimPos(m_ModelName);
      print(strPos);
      if (strPos.length > 0) {
        setState(() {
          m_posData = jsonDecode(strPos) as List;
        });
      }
  }
  void GetOrders() async {
      String strOrders = await WebAPIHelper.instance.GetOrders(m_ModelName, m_amount);
      print(strOrders);
      if (strOrders.length > 0) {
        setState(() {
          m_orderData = jsonDecode(strOrders) as List;
        });
      }
  }

  void SubmitOrders() async {
      String strPos = await WebAPIHelper.instance.SubmitOrders(m_ModelName, m_orderData);
      print(strPos);
      if (strPos.length > 0) {
        setState(() {
          m_posData = jsonDecode(strPos) as List;
        });
      }
  }

  String m_ModelName;
  _TradePageState(this.m_ModelName) {
    m_amount = 100000;
    m_action = "调仓";
    m_posData = [];
    m_orderData = [];
    if (m_ModelName.length>0) {
      GetSimPos();
    }
  }
  @override
  Widget build(BuildContext context)
  {
    //Size deviceSize = MediaQuery.of(context).size;
    //String strPos = await WebAPIHelper.instance.GetSimPos(widget.m_ModelName);
    List<TableRow> rows = [];
    var controller = new MoneyMaskedTextController(decimalSeparator: '.', thousandSeparator: ',');
    if (m_action == '调仓') {
      rows.add(
          new TableRow(
            children: <Widget>[
              new TableCell(child:Text("代码")),
              new TableCell(child:Text("简称")),
              new TableCell(child:Text("持股")),
              new TableCell(child:Text("成本价")),
              new TableCell(child:Text("最新价")),
            ]
          )
      );
      for (int i=0; i<m_posData.length;i++) {
        rows.add(
            new TableRow(
              children: <Widget>[
                new TableCell(child:Text(NumberFormat("000000").format(m_posData[i]['Symbol']))),
                new TableCell(child:Text(m_posData[i]['Name'])),
                new TableCell(child:Text(m_posData[i]['Quantity'].toString())),
                new TableCell(child:Text(m_posData[i]['Price'].toString())),
                new TableCell(child:Text(m_posData[i]['LastPrice'].toString())),
              ]
            )
        );
      }
    } else if (m_action=='执行订单') {
      rows.add(
          new TableRow(
            children: <Widget>[
              new TableCell(child:Text("代码")),
              new TableCell(child:Text("简称")),
              new TableCell(child:Text("持股")),
              new TableCell(child:Text("调仓量")),
              new TableCell(child:Text("最新价")),
            ]
          )
      );
      for (int i=0; i<m_orderData.length;i++) {
        rows.add(
            new TableRow(
              children: <Widget>[
                new TableCell(child:Text(NumberFormat("000000").format(m_orderData[i]['Symbol']))),
                new TableCell(child:Text(m_orderData[i]['Name'])),
                new TableCell(child:Text(m_orderData[i]['Quantity'].toString())),
                new TableCell(child:Text(m_orderData[i]['Diff'].toString())),
                new TableCell(child:Text(m_orderData[i]['LastPrice'].toString())),
              ]
            )
        );
      }
    }
    return SingleChildScrollView(
      child: Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            //new TextField(controller: controller,),
            Visibility(visible: m_action=="执行订单",
              child:new Expanded(
                flex:1,
                child:new TextField(
                  keyboardType: TextInputType.number,//键盘类型，数字键盘
                  decoration: InputDecoration(),
                  onChanged: (text) {
                    m_amount = int.parse(text);
                  },
                  controller: TextEditingController.fromValue(TextEditingValue(text: '$m_amount',)),
                ),
              ),
            ),
            Visibility(visible: m_action=="执行订单",
              child:RaisedButton(
                padding: EdgeInsets.all(10),
                    onPressed: () async {
                      GetOrders();
                    },
                  child: new Text(
                    "生成",
                    style: TextStyle(fontSize: 13)
                  ),
              ),
            ),
            RaisedButton(
              padding: EdgeInsets.all(10),
                  onPressed: () async {
                    print(m_action);
                    if (m_action=="调仓") {
                      GetOrders();
                      setState(() {
                        m_action = "执行订单";
                      });
                    } else if (m_action == "执行订单") {
                      SubmitOrders();
                      setState(() {
                        m_action = "调仓";
                      });
                    }
                  },
                child: new Text(
                  m_action,
                  style: TextStyle(fontSize: 13)
                ),
            ),
            Visibility(visible: m_action=="执行订单",
              child:RaisedButton(
                padding: EdgeInsets.all(10),
                    onPressed: () async {
                      if (m_action=="执行订单") {
                        setState(() {
                          m_action = "调仓";
                        });
                      }
                    },
                  child: new Text(
                    "放弃调仓",
                    style: TextStyle(fontSize: 13)
                  ),
              ),
            )
          ],
        ),
        Text("当前持仓"),
        new Table(
            border: TableBorder.all(),
            children: rows,
          )
      ],
      )
    );
  }
}