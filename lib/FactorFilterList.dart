import 'package:flutter/material.dart';
import 'entityclass.dart';
import 'webapihelper.dart';

class FactorFilterList extends StatelessWidget
{

  ModelInfoEx m_ModeInfo = new ModelInfoEx();

  FactorFilterList(ModelInfoEx modelInfo){
    this.m_ModeInfo = modelInfo;
  }

  
  @override
  Widget build(BuildContext context)
  {
      return Column(children: <Widget>[
        new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                new Expanded(
                    flex:2,
                    child: new Text('因子',
                        textAlign: TextAlign.center),
                  ),
                  
                  new Expanded(
                    flex:2,
                    child: new Text('分位数筛选',
                        textAlign: TextAlign.center),
                  ),

                  new Expanded(
                    flex:1,
                    child: Row(
                      children:<Widget>[

                        new Text('操作',
                          textAlign: TextAlign.left
                          ),

                        new IconButton(
                          onPressed: () {},
                          icon: new Icon(Icons.add_box),
                          tooltip: '添加',
                        ),  

                      ]
                    )
                  ),
            ],
          ),
        //new Divider(),

        new Flexible(
            child: new FactorFilterList1(this.m_ModeInfo),
        )
        

      ],
      );
  }
}

class FactorFilterList1 extends StatelessWidget
{

  ModelInfoEx m_ModelInfo = new ModelInfoEx();

  List<Widget> m_List = new List();

  FactorFilterList1(ModelInfoEx modelInfo){
    this.m_ModelInfo = modelInfo;
  }

  //生成 m_List 中的widget
  void MakeWidgetList(){
    //添加数据
    if (this.m_ModelInfo.CondList == null){
      this.m_ModelInfo.CondList = new List<Cond>();
    }

    for(var f in this.m_ModelInfo.CondList){

      m_List.add(
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
              new Expanded(
                  flex:2,
                  child: new Text(WebAPIHelper.instance.GetFactorInfoByName(f.CondName).FactorDesc,
                        textAlign: TextAlign.center),
                ),
                
                new Expanded(
                  flex:2,
                  child: Row(
                    children:<Widget>[
                      
                      new Expanded(
                        child: new Text('大于等于'),
                      ),

                      new Expanded(
                        child: new TextField(
                          decoration: InputDecoration(),

                          controller: TextEditingController.fromValue(TextEditingValue
                              (
                                text: '${f.CondMin}',  //判断keyword是否为空
                            ), 
                          ),

                        ),
                      ),

                      new Expanded(
                        child: new Text('小于等于'),
                      ),

                      new Expanded(
                        child: new TextField(
                          decoration: InputDecoration(),

                          controller: TextEditingController.fromValue(TextEditingValue
                              (
                                text: '${f.CondMax}',  //判断keyword是否为空
                            ), 
                          ),
                        ),
                      ),

                    ] 
                  ),
                ),

                new Expanded(
                  flex:1,
                  child:  new IconButton(
                          onPressed: () {},
                          icon: new Icon(Icons.delete),
                          tooltip: '删除',
                        ),
                ),
          ],
        ),
      );

    }

  }

  @override
  Widget build(BuildContext context)
  {
    MakeWidgetList();

    return new ListView(
        //itemExtent: 25.0, 
        
        children: m_List,
        
    );
  }
}