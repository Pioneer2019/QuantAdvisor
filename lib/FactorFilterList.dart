import 'package:flutter/material.dart';
import 'entityclass.dart';
import 'newfactorfilter4model.dart';
import 'sharedata.dart';
import 'webapihelper.dart';

class FactorFilterList extends StatefulWidget
{
  ModelInfoEx m_ModeInfo = new ModelInfoEx();
  bool IsCreateNewFactor = false;

  //true: 新建模型; false: 修改模型
  bool IsMakeNewModel = true;

  FactorFilterList(ModelInfoEx modelInfo,bool isMakeNewModel){
    this.m_ModeInfo = modelInfo;
    IsMakeNewModel=isMakeNewModel;
  }

  @override
    State createState() => new _FactorFilterListState();
}

class _FactorFilterListState extends State<FactorFilterList>
{
  
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
                          onPressed: () async {
                            if (widget.IsMakeNewModel){
                                SharedData.instance.AddNewCondition4NewModel();
                              }

                            widget.IsCreateNewFactor = await Navigator.push(
                              context,
                              new MaterialPageRoute(builder: (context) => 
                                new NewFactorFilter4Model(widget.IsMakeNewModel))
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
            child: new FactorFilterList1(widget.m_ModeInfo,widget.IsMakeNewModel),
        )
        

      ],
      );
  }
}

class FactorFilterList1 extends StatelessWidget
{

  ModelInfoEx m_ModelInfo = new ModelInfoEx();

  //true: 新建模型; false: 修改模型
  bool IsMakeNewModel = true;

  List<Widget> m_List = new List();

  FactorFilterList1(ModelInfoEx modelInfo, bool isMakeNewModel){
    this.m_ModelInfo = modelInfo;
    this.IsMakeNewModel = isMakeNewModel;
  }

  //生成 m_List 中的widget
  void MakeWidgetList(){

    if (this.IsMakeNewModel){

      subMakeWidgetList(SharedData.instance.CondList4NewModel);

    }
    else{
      //添加数据
      if (this.m_ModelInfo.CondList == null){
        this.m_ModelInfo.CondList = new List<Cond>();
      }

      subMakeWidgetList(this.m_ModelInfo.CondList);

      }
    }
    

    void subMakeWidgetList(List<Cond> condList){

      for(var f in condList){

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