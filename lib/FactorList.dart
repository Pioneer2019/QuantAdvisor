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
      return new Column(
          children: <Widget>[
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
                      child: 
                        new Row(
                          children: <Widget>[
                            new Text('操作 ',
                            textAlign: TextAlign.left
                            ),

                            new GestureDetector(
                              onTap:() async{

                                //清空要保存的 FactorType
                                SharedData.instance.m_FactorType_NewFactor='';

                                //为了保存数据，先新建一个Factor
                                if (widget.IsMakeNewModel){
                                  SharedData.instance.AddNewFactor4NewModel();
                                }
                                else{
                                  widget.m_ModeInfo.FactorList.add(new FactorInModel());
                                  //设置缺省值
                                  SharedData.instance.SetDefaultValue4NewFactor(widget.m_ModeInfo.FactorList[widget.m_ModeInfo.FactorList.length-1]);
                                }

                                widget.IsCreateNewFactor = await Navigator.push(
                                  context,
                                  new MaterialPageRoute(builder: (context) => 
                                    new NewFactor4Model(widget.m_ModeInfo,widget.IsMakeNewModel))
                                  );

                                  if (widget.IsMakeNewModel){
                                    setState((){
                                        
                                    });
                                  }
                              },

                              child: new Icon(
                                Icons.add_box,
                              )
                            )
                          ],
                        )
                        
                    ),
              ],
            ),
        new Divider(),

        new Flexible(
            child: new FactorList1(widget.m_ModeInfo,widget.IsMakeNewModel,this),
            //child: new Text('data'),
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

      //新建模型情况：
      MakeWidgetList4New();  

    }
    else{
      //当前编辑的模型
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
      var direction = f.FactorWeight>=0? "越大越好":"越小越好";

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
                  child: new Text(direction,
                        textAlign: TextAlign.center),
                ),

                new Expanded(
                  flex:1,
                  child: new Text(f.FactorWeight.abs().toString(),
                        textAlign: TextAlign.center),

                ),

                new Expanded(
                  flex:1,
                  child:  new IconButton(
                          onPressed: () {
                          
                            //删除 factorDesc
                            DeleteFactor(factorDesc);
                            //(parent.() as _FactorListState).RefreshUI();
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

  void MakeWidgetList4New(){
    subMakeWidgetList(SharedData.instance.m_ModelInfoEx4New.FactorList);
  }

  void DeleteFactor(String factorDesc){
    if (this.IsMakeNewModel){
      SharedData.instance.m_ModelInfoEx4New.FactorList.removeWhere((item) => item.FactorDesc == factorDesc);
    }
    else{
      this.m_ModeInfo.FactorList.removeWhere((item) => item.FactorDesc == factorDesc);
    }
  }

}