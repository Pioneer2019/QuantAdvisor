import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uitest2/entityclass.dart';
import 'newStrategy.dart';
import 'StrategyInfoPage.dart';

import 'webapihelper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: '我的模型'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Widget> _list = new List();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      //模型列表
      body: new StrategyList(),

      bottomNavigationBar: BottomNavigationBar( // 底部导航
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.add_to_home_screen), 
                title: Text('新建模型'),
                ),
              BottomNavigationBarItem(icon: Icon(Icons.exit_to_app), title: Text('退出')),
            ],
            onTap:  (index) {
              if (index == 0)
              {
                Navigator.push(
                  context,
                  //new MaterialPageRoute(builder: (context) => new TabControllerPage()),
                  new MaterialPageRoute(builder: (context) => new TabControllerPage())
                  );
              }
            },
          ),

    );
  }
}

class StrategyList extends StatefulWidget {
    @override
    State createState() => new StrategyListState();
}

class StrategyListState extends State<StrategyList>
{

    List<ModelInfo> _listData = new List();
    List<Widget> _list = new List();

    //初始化得到系统数据
    GetSystemDataAsync() async {
      await WebAPIHelper.instance.GetIndustryList();    
      await WebAPIHelper.instance.GetFactorList();  
    }

    //延迟得到模型列表后赋值给_list,再刷新界面
    GetModelListAsync() async {
      _listData = await WebAPIHelper.instance.GetModelList();    

      setState((){
            for (int i = 0; i < _listData.length; i++) {
              var modelName = _listData[i].ModelName;
              _list.add(new Center(
                child: ListTile(
                  leading: new Icon(Icons.launch),
                  title: new Text(modelName),
                  trailing: new Icon(Icons.keyboard_arrow_right),

                  onTap: ()
                  {
                    //print('$modelName');

                    //显示当前策略信息
                      Navigator.push(
                      context,
                      new MaterialPageRoute(builder: (context) => new StrategyInfoPage(modelName))
                      );
                  },


                ),
              ));
            }
          });
      
    }

    @override
    void initState() {
        
        GetSystemDataAsync();
        
        GetModelListAsync();
        
    }


  @override
  Widget build(BuildContext context)
  {

          return new Column(
              mainAxisAlignment: MainAxisAlignment.start,
            children: _list,
          );
        
  }
}



class StrategyListold extends StatelessWidget
{
  @override
  Widget build(BuildContext context)
  {
    
          return new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new ListTile(
              leading: Icon(Icons.launch),
              title: Text('高分红'),
              trailing: Icon(Icons.keyboard_arrow_right),
              onTap: ()
              {
                 //显示当前策略信息
                  Navigator.push(
                  context,
                  //new MaterialPageRoute(builder: (context) => new TabControllerPage()),
                  new MaterialPageRoute(builder: (context) => new StrategyInfoPage('aaas'))
                  );
              },
            ),
            new Divider(),
            new ListTile(
              leading: Icon(Icons.launch),
              title: Text('低估值'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            new Divider(),
            new ListTile(
              leading: Icon(Icons.launch),
              title: Text('黄金底'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            new Divider(),
            new ListTile(
              leading: Icon(Icons.launch),
              title: Text('大消费'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            new Divider(),
            new ListTile(
              leading: Icon(Icons.launch),
              title: Text('大基建'),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
            new Divider(),

          ],
        );
        
  }
}

