import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uitest2/entityclass.dart';
import 'package:uitest2/sharedata.dart';
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

  //刷新界面
  RefreshUI(){
    setState(() {
      
    });
  }

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
            onTap:  (index) async {
              if (index == 0)
              {
                bool br = await Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new newStrategyPage())
                  );
                if (br==null) { br = false;}
                if (br){
                  SharedData.instance.m_Mainform_StrategyList.GetModelListAsync();
                }
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
    //List<Widget> _list = new List();

    //初始化得到系统数据
    GetSystemDataAsync() async {
      await WebAPIHelper.instance.GetIndustryList();    
      await WebAPIHelper.instance.GetFactorList();  
    }

    //根据模型列表生成ListTile数组
    List<Widget> GetModelList(){

      List<Widget> list = new List();

      for (int i = 0; i < _listData.length; i++) {
              var modelName = _listData[i].ModelName;
              list.add(new Center(
                child: ListTile(
                  leading: new Icon(Icons.launch),
                  title: new Text(modelName),
                  trailing: 
                  new SizedBox(width: 100, height: 50,
                  child: new Row(          

                      mainAxisSize: MainAxisSize.min,

                      children: <Widget>[
                      
                      new IconButton(
                        
                        //删除当前模型
                        onPressed:() {
                         this._deleteCurrentModel(modelName);
                        },

                        icon: new Icon(Icons.delete_forever),
                        tooltip: '删除',
                          ),

                      new IconButton(
                        onPressed:(){
                          Navigator.push(
                            context,
                            new MaterialPageRoute(builder: (context) => new StrategyInfoPage(modelName))
                            );
                        },

                        icon: new Icon(Icons.keyboard_arrow_right),
                        tooltip: "模型信息",
                      ),

                      
                    ]),
                
                ),
                onTap: (){
                  Navigator.push(
                            context,
                            new MaterialPageRoute(builder: (context) => new StrategyInfoPage(modelName))
                            );
                },
                ),
              ));
            }
        return list;
    }

    //延迟得到模型列表后赋值给_list,再刷新界面
    GetModelListAsync() async {

      _listData = await WebAPIHelper.instance.GetModelList();    

      setState((){
            
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
      SharedData.instance.m_Mainform_StrategyList = this;

      return new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: GetModelList(),
      );
        
  }

  //删除当前模型
  _deleteCurrentModel(String modelName) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('您是否确认删除当前模型？'),
          actions: <Widget>[
            FlatButton(
              child: Text('否',
              style: new TextStyle(fontSize: 18),),
              onPressed: () {
                Navigator.of(context).pop(context);
              },
            ),

            FlatButton(
              child: Text('是',
              style: new TextStyle(fontSize: 18),),
              onPressed: () async {
                Navigator.of(context).pop(context);
                
                bool br = await WebAPIHelper.instance.RemoveModelInfo(modelName);

                if (br){
                  GetModelListAsync();
                }
                
              },
            ),
          ],
        );
      },
    );
  }

}

