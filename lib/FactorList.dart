import 'package:flutter/material.dart';
import 'package:uitest2/entityclass.dart';
import 'package:uitest2/webapihelper.dart';

class FactorList extends StatelessWidget
{
  ModelInfoEx m_ModeInfo = new ModelInfoEx();

  FactorList(ModelInfoEx modelInfo){
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
                    flex:1,
                    child: new Text('方向',
                        textAlign: TextAlign.center),
                  ),

                  new Expanded(
                    flex:1,
                    child: new Text('权重',
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
            child: new FactorList1(this.m_ModeInfo),
        )
        

      ],
      );
  }
}

class FactorList1 extends StatelessWidget
{
  ModelInfoEx m_ModeInfo = new ModelInfoEx();

  List<Widget> m_List = new List();

  FactorList1(ModelInfoEx modelInfo){
    this.m_ModeInfo = modelInfo;
  }

  //生成 m_List 中的widget
  void MakeWidgetList(){
    //添加数据
    if (this.m_ModeInfo.FactorList == null){
      this.m_ModeInfo.FactorList = new List<FactorInModel>();
    }

    for(var f in this.m_ModeInfo.FactorList){

      m_List.add(
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
              new Expanded(
                  flex:2,
                  child: new Text(WebAPIHelper.instance.GetFactorInfoByName(f.FactorName).FactorDesc,
                        textAlign: TextAlign.center),
                ),
                
                new Expanded(
                  flex:1,
                  child: new Text('越大越好',
                        textAlign: TextAlign.center),
                ),

                new Expanded(
                  flex:1,
                  child: new Text(f.FactorWeight.toString(),
                        textAlign: TextAlign.center),

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