import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/analytics_bloc/analytics_bloc.dart';

class AnalyticsRepo{

  int electronics=0;
  int fashion=0;
  int catTot=0;
  var keys;
  List<charts.Series<CategoryData, String>> catSeries = List<charts.Series<CategoryData, String>>();
  List<charts.Series<CategoryData, String>> fashSubcatSeries = List<charts.Series<CategoryData, String>>();
  List<charts.Series<CategoryData, String>> elecSubcatSeries = List<charts.Series<CategoryData, String>>();
  List<CategoryData> categoryData = List<CategoryData>();
  List fashList = ['Caps', 'Bottoms', 'Eye Wear', 'T-Shirts', 'Watches'];
  List elecList = ['Mobile Phones', 'Games', 'Laptops'];
  Map<dynamic, dynamic> myMap = Map<dynamic, dynamic>();

  getPieCount()async{
    catTot=0;
    fashion=0;
    electronics=0;
    catSeries=[];
    fashSubcatSeries=[];
    elecSubcatSeries=[];
    categoryData=[];
    await getViewData("Category", "Fashion");
    await getViewData("Category", "Electronics");
    categoryData=[];
    await getViewData("SubCategory", "Caps");
    await getViewData("SubCategory", "Bottoms");
    await getViewData("SubCategory", "Eye Wear");
    await getViewData("SubCategory", "T-Shirts");
    await getViewData("SubCategory", "Watches");
    categoryData=[];
    await getViewData("SubCategory", "Laptops");
    await getViewData("SubCategory", "Mobile Phones");
    await getViewData("SubCategory", "Games");
    analyticsBloc.categoryIn.add(catSeries);
    analyticsBloc.fashionIn.add(fashSubcatSeries);
    analyticsBloc.electronicsIn.add(elecSubcatSeries);
  }

  getViewData(String type, String value) async{
    int count=0;
    myMap={};
    keys=[];
    QuerySnapshot fs = await Firestore.instance.collection('products').where('$type', isEqualTo: '$value').getDocuments();
    fs.documents.forEach((f) {
      print(f.data['Map']);
      myMap=f.data['Map'];
      if(myMap!=null){
        myMap=f.data['Map'];
        keys = myMap.keys.toList()..sort();
        for(int i=0; i<keys.length ; i++)
          count+=myMap[keys[i]][0];
      }
    });
    categoryData.add(CategoryData(value, count));
    if(type=="SubCategory"){
      if(fashList.contains(value)){
        fashion+=count;
        fashSubcatSeries=returnList(value, fashion);
      }
      else{
        electronics+=count;
        elecSubcatSeries=returnList(value, electronics);  
    }
    }
    else{
      catTot+=count;
      catSeries=returnList(type, catTot);
    }
  }

  returnList(String id, int count){
    return [charts.Series(
        id: id,
        domainFn: (CategoryData cat, _) => cat.category,
        measureFn: (CategoryData val, _) => val.data,
        data: categoryData,
        labelAccessorFn: (CategoryData row, _) => '${row.category}: \n${((row.data/count)*100).toStringAsFixed(1)}%',
        outsideLabelStyleAccessorFn: (CategoryData val, _) => charts.TextStyleSpec(color: charts.MaterialPalette.white, fontSize: 13)
    )];
  }
}

class CategoryData{
  String category;
  int data;
  CategoryData(this.category, this.data);
}

final analyticsRepo = AnalyticsRepo();