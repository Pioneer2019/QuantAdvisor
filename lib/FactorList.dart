import 'package:flutter/material.dart';
import 'package:uitest2/entityclass.dart';
import 'package:uitest2/newfactor4model.dart';
import 'package:uitest2/sharedata.dart';
import 'package:uitest2/webapihelper.dart';

class FactorList extends StatefulWidget{

  ModelInfoEx m_ModeInfo = new ModelInfoEx();
  bool IsCreateNewFactor = false;

  //true: 新建模型; false: 修改模型
  bool IsMakeNewModel = true;

  FactorList(ModelInfoEx modelInfo,bool isMakeNewModel){
    this.m_ModeInfo = modelInfo;
    IsMakeNewModel=isMakeNewModel;
  }

  @override
    State createState() => new _FactorListState();
}
class _FactorListState extends State<FactorList>
{
  //刷新界面
  RefreshUI(){
    setState(() {
      
    });
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
                          onPressed: () async {

                              if (widget.IsMakeNewModel){
                                SharedData.instance.AddNewFactor4NewModel();
                              }

                            widget.IsCreateNewFactor = await Navigator.push(
                              context,
                              new MaterialPageRoute(builder: (context) => 
                                new NewFactor4Model(widget.IsMakeNewModel))
                              );

                              if (widget.IsMakeNewModel){
                                setState((){
                                    
                                });
                              }
                          },
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
            child: new FactorList1(widget.m_ModeInfo,widget.IsMakeNewModel,this),
        )
        

      ],
      );
  }
}

class FactorList1 extends StatelessWidget{

  ModelInfoEx m_ModeInfo = new ModelInfoEx();

  //true: 新建模型; false: 修改模型
  bool IsMakeNewModel = true;

  FactorList1(ModelInfoEx modelInfo,bool isMakeNewModel, 
  _FactorListState parent){
    this.m_ModeInfo = modelInfo;
    this.IsMakeNewModel = isMakeNewModel;
    m_parent = parent;
  }

  List<Widget> m_List = new List();

  _FactorListState m_parent;

  @override
  Widget build(BuildContext context)
  {
    if (this.IsMakeNewModel==true){
      /*
      Widget parent = context.ancestorWidgetOfExactType(FactorList);
      if ((parent as FactorList).IsCreateNewFactor){
        MakeWidgetList4New();  
      }
      */
      
      MakeWidgetList4New();  

    }
    else{
      MakeWidgetList();  
    }
    
    return new ListView(
        //itemExtent: 25.0, 
        
        children: m_List,
    );
  }

  //用this.m_ModeInfo.FactorList的数据 生成 m_List 中的widget
  void MakeWidgetList(){
    //添加数据
    if (this.m_ModeInfo.FactorList == null){
      this.m_ModeInfo.FactorList = new List<FactorInModel>();
    }
    subMakeWidgetList(this.m_ModeInfo.FactorList);
  }  

  void subMakeWidgetList(List<FactorInModel> factorList){
    
    m_List.clear();

    for(var f in factorList){

      var factorDesc = WebAPIHelper.instance.GetFactorInfoByName(f.FactorName).FactorDesc;

      m_List.add(
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
              new Expanded(
                  flex:2,
                  child: new Text(factorDesc,
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
                          onPressed: () {
                            //print('$factorDesc');
                            if (this.IsMakeNewModel){
                              //删除 factorDesc
                              DeleteFactor(factorDesc);
                              //(parent.() as _FactorListState).RefreshUI();
                              m_parent.RefreshUI();
                            }
                          },
                          icon: new Icon(Icons.delete),
                          tooltip: '删除',
                        ),
                ),
          ],
        ),
      );
    }
  }  

  void MakeWidgetList4New(){
    subMakeWidgetList(SharedData.instance.FactorList4NewModel);
  }

  void DeleteFactor(String factorDesc){
    if (this.IsMakeNewModel){
      SharedData.instance.FactorList4NewModel.removeWhere((item) => item.FactorDesc == factorDesc);
    }
  }

}