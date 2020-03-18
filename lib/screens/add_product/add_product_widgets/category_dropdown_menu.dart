import 'package:e_commerce_bloc/blocs/add_product_bloc/add_product_bloc.dart';
import 'package:flutter/material.dart';

class CategoryMenu{

  List<String> categories=['Fashion', 'Electronics'];
  List<String> fashion=['Caps', 'Bottoms', 'Eye Wear', 'T-Shirts', 'Watches'];
  List<String> electronics=['Laptops', 'Mobile Phones', 'Games'];
  String defaultCategory='Select Category';
  String defaultSubCategory='Select Subcategory';
  String _category;
  String _subCategory;

  dropDownMenuCat()
  {
    _category=defaultCategory;
    addProductBloc.prodCategoryIn.add(_category);
    return StreamBuilder(
      stream: addProductBloc.prodCategoryOut,
      builder: (context, snapshot) {
        if(snapshot.hasData)
          _category = snapshot.data;
        return Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Container(
            width:300,
            height: 60,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), border: Border.all(color: Colors.grey)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint:  Row(children:[
                  Padding(
                    padding: const EdgeInsets.only(left:8),
                    child: Icon(Icons.category),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:8),
                    child: Text(_category, style: TextStyle(color: _category==defaultCategory? Colors.grey : Colors.black),),
                  )
                ]),
                items: categories.map((String val){
                    return DropdownMenuItem<String>(
                      value: val,
                      child: new Text(val),
                    );
                  }).toList(),
                  onChanged:(String val){
                    if(_category!=val){
                    _category = val;
                    addProductBloc.prodCategoryIn.add(_category);
                    }
                  })
            )
          )
        );
      }
    );
  }

  dropDownMenuSub()
  {
    addProductBloc.subcategory=defaultSubCategory;
    List<String> display = List<String>();
    if(_category=='Fashion')
      display=fashion;
    if(_category=='Electronics')
      display=electronics;
    return StreamBuilder<Object>(
      stream: addProductBloc.prodCategoryOut,
      builder: (context, snapshot) {
        if(snapshot.data==defaultCategory)
          return Container();
        else{
          _subCategory=defaultSubCategory;
          addProductBloc.prodSubcategoryIn.add(_subCategory);
          if(_category=='Fashion')
            display=fashion;
          if(_category=='Electronics')
            display=electronics;
        return Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Container(
            width:300,
            height: 60,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(32), border: Border.all(color: Colors.grey)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint:  Row(children:[
                  Padding(
                    padding: const EdgeInsets.only(left:8),
                    child: Icon(Icons.sort),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left:8),
                    child: StreamBuilder(
                      stream: addProductBloc.prodSubcategoryOut,
                      builder: (context, snap) {
                        if(snap.hasData)
                          _subCategory=snap.data;
                        return Text(_subCategory, style: TextStyle(color: _subCategory==defaultSubCategory? Colors.grey : Colors.black),);
                      }
                    ),
                  )
                ]),
                items: display.map((String val){
                    return DropdownMenuItem<String>(
                      value: val,
                      child: new Text(val),
                    );
                  }).toList(),
                  onChanged:(String val){
                    _subCategory = val;
                    addProductBloc.prodSubcategoryIn.add(_subCategory);
                  }
              )
            )
          )
        );
        }
      }
    );
  }
}

final categoryMenu = CategoryMenu();