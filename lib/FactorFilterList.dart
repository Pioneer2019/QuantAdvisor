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
                    flex:2,
                    child: new Text('分位数筛选',
                        textAlign: TextAlign.center),
                  ),

                  new Expanded(
                    flex:1,
                    child: Row(
                      children:<Widget>[

                        new Text('操作 ',
                          textAlign: TextAlign.left
                          ),

                        new GestureDetector(
                          onTap: () async {
                            if (widget.IsMakeNewModel){
                              SharedData.instance.AddNewCondition4NewModel();
                            }
                            else{
                              var cond = new Cond();
                              SharedData.instance.SetDefaultValue4NewCond(cond);
                              widget.m_ModeInfo.CondList.add(cond);
                            }

                            widget.IsCreateNewFactor = await Navigator.push(
                              context,
                              new MaterialPageRoute(builder: (context) => 
                                new NewFactorFilter4Model(widget.m_ModeInfo, widget.IsMakeNewModel))
                              );

                              if (widget.IsMakeNewModel){
                                setState((){
                                    
                                });
                              }
                          },
                          child: new Icon(Icons.add_box),
                        ),  

                      ]
                    )
                  ),
            ],
          ),
        new Divider(),

        new Flexible(
            child: new FactorFilterList1(widget.m_ModeInfo,widget.IsMakeNewModel, this),
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

  _FactorFilterListState m_parent;

  List<Widget> m_List = new List();

  FactorFilterList1(ModelInfoEx modelInfo, bool isMakeNewModel, _FactorFilterListState parent){
    this.m_ModelInfo = modelInfo;
    this.IsMakeNewModel = isMakeNewModel;
    m_parent = parent;
  }

  //生成 m_List 中的widget
  void MakeWidgetList(){

    if (this.IsMakeNewModel){

      subMakeWidgetList(SharedData.instance.m_ModelInfoEx4New.CondList);

    }
    else{
      //添加数据
      if (this.m_ModelInfo.CondList == null){
        this.m_ModelInfo.CondList = new List<Cond>();
      }

      subMakeWidgetList(this.m_ModelInfo.CondList);

      }
    }
    
    //生成 m_List<widget>控件数组的子函数
    void subMakeWidgetList(List<Cond> condList){

      for(var f in condList){

        var factorDesc = WebAPIHelper.instance.GetFactorInfoByName(f.CondName).FactorDesc;

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
                    flex:2,
                    child: Row(
                      children:<Widget>[
                        
                        new Expanded(
                          child: new Text('下限:'),
                        ),

                        new Expanded(
                          child: new Text(f.CondMin.toString(),
                            style: new TextStyle(fontSize: 16),
                            ),
                          ),

                        new Expanded(
                          child: new Text('上限:'),
                        ),

                        new Expanded(
                          child: new Text(f.CondMax.toString(),
                            style: new TextStyle(fontSize: 16),  //判断keyword是否为空
                              ), 
                          ),

                      ] 
                    ),
                  ),

                  new Expanded(
                    flex:1,
                    child:  new IconButton(
                            onPressed: () {
                              
                              var factorName = WebAPIHelper.instance.GetFactorInfoByDesc(factorDesc).FactorName;
                              //删除当前 cond
                              if (this.IsMakeNewModel){
                                SharedData.instance.m_ModelInfoEx4New.CondList.removeWhere((item) => item.CondName == factorName);
                              }
                              else{
                                this.m_ModelInfo.CondList.removeWhere((item) => item.CondName == factorName);
                              }

                              m_parent.RefreshUI();

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