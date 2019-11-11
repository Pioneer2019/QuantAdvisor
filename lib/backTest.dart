import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BackTest extends StatefulWidget
{
  @override
  _BackTestState createState() => _BackTestState();
}

class _BackTestState extends State<BackTest>
{
  var m_startDate = "-";
  var m_endDate = "-";

   @override
  Widget build(BuildContext context)
  {
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
                            initialDate: new DateTime.now(),
                            firstDate: new DateTime.now().subtract(new Duration(days: 6000)), // 减 30 天
                            lastDate: new DateTime.now().add(new Duration(days: 30)),       // 加 30 天
                        ).then((DateTime val) {
                            print(val);   // 2018-07-12 00:00:00.000

                            setState(() {

                              m_startDate = new DateFormat("yyyy-MM-dd").format(val);
                            });
                            
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
                            initialDate: new DateTime.now(),
                            firstDate: new DateTime.now().subtract(new Duration(days: 6000)), // 减 30 天
                            lastDate: new DateTime.now().add(new Duration(days: 30)),       // 加 30 天
                        ).then((DateTime val) {
                            print(val);   // 2018-07-12 00:00:00.000

                            setState(() {

                              m_endDate = new DateFormat("yyyy-MM-dd").format(val);
                            });
                            
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
                        onPressed: () {},
                      child: const Text(
                        '开始回测',
                        style: TextStyle(fontSize: 13)
                      ),
                        ), 
                ),
                
           ]
         ),

        new BackTestTabControl(),

       ]
    );
  }
}

class BackTestTabControl extends StatefulWidget {
  @override
  _BackTestTabControlState createState() => _BackTestTabControlState();
}

class _BackTestTabControlState extends State<BackTestTabControl> with SingleTickerProviderStateMixin{

  TabController m_tabController;

  @override
  void initState() {
    //print('初始化 数据...');
    m_tabController = new TabController(
        vsync: this,//固定写法
        length: 2   //指定tab长度
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

            new TabBarView_BackTest(m_tabController),
            

      ]
    );
  }
}


class TabBarView_BackTest extends StatelessWidget{
  TabController m_tabController;

  TabBarView_BackTest(TabController tabControl)
  {
    m_tabController = tabControl;
  }

  @override
  Widget build(BuildContext context){
    
    return new SizedBox(
      
      
      width: 380.0,
      height: 380.0,

      child: new TabBarView(
          
          controller: m_tabController,
                  
        
        children: <Widget>[
              Container(
                color: Color(0xffffffff),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(0),
                height: 1100,
                child: Column
                (
                    children: <Widget>[
                      new Text("股票多头,几何年化收益=25.8%,最大回撤=16.2%"),
                    ],
                  )
                
                
                    
              ),

             Container(
                color: Color(0xffffffff),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(0),
                child: new Text("夏普比=0.582,平均调仓换手率=62.4%"),
              ),

      ],)
    );

  }
}