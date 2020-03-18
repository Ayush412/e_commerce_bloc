import 'package:e_commerce_bloc/blocs/products_home_bloc/products_home_bloc.dart';
import 'package:e_commerce_bloc/widgets/show_snack.dart';
import 'package:flutter/material.dart';

class BottomNavigation{

  String catVal;
  String subcatVal;
  String catVal2;
  String subcatVal2;

  bottomNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key){
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BottomNavigationBar(
        backgroundColor: Color(0x2FFAFAFA),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sort, color: Colors.white,),
            title: Text('Sort', style: TextStyle(color: Colors.white),)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu, color: Colors.white,),
            title: Text('Category', style: TextStyle(color: Colors.white),)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.filter_list, color: Colors.white,),
            title: Text('Sub Category', style: TextStyle(color: Colors.white),)
          ),
        ],
        currentIndex: 0,
        onTap: (int index) async{
          if(index == 0){
            List sortVal = await showMenu<List>(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              color: Colors.black,
              context: context,
              elevation: 0,
              position: RelativeRect.fromLTRB(20, 475.0, 60.0, 0.0),
              items: <PopupMenuItem<List>>[
                new PopupMenuItem<List>(
                          height: 40,
                          child: const Text('Price: Low to High', style: TextStyle(color: Colors.white, fontSize: 15),), value: ["ProdCost", false]),
                new PopupMenuItem<List>(
                          height: 40,
                          child: const Text('Price: High to Low', style: TextStyle(color: Colors.white, fontSize: 15),), value: ["ProdCost", true]),
                new PopupMenuItem<List>(
                          height: 40,
                          child: const Text('List: A to Z', style: TextStyle(color: Colors.white, fontSize: 15),), value: ["ProdName", false]),
                new PopupMenuItem<List>(
                          height: 40,
                          child: const Text('List: Z to A', style: TextStyle(color: Colors.white, fontSize: 15),), value: ["ProdName", true]),
              ],
            );
            productsHomeBloc.sortIn.add([sortVal,catVal2, subcatVal2]);
          }
          else if(index == 1){
              catVal = await showMenu<String>(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              color: Colors.black,
              context: context,
              position: RelativeRect.fromLTRB(30.0, 515.0, 30.0, 0.0),
              items: <PopupMenuItem<String>>[
                new PopupMenuItem<String>(
                          height: 40,
                          child: const Text('All', style: TextStyle(color: Colors.white, fontSize: 15),), value: 'All'),
                
                new PopupMenuItem<String>(
                          height: 40,
                          child: const Text('Fashion', style: TextStyle(color: Colors.white, fontSize: 15),), value: 'Fashion'),
                new PopupMenuItem<String>(
                          height: 40,
                          child: const Text('Electronics', style: TextStyle(color: Colors.white, fontSize: 15),), value: 'Electronics'),
                ],
              elevation: 0,
            );
            if(catVal=="All"){
              catVal=null;
              catVal2=null;
              subcatVal=null;
              subcatVal2=null;
              productsHomeBloc.sortIn.add([null,catVal2, subcatVal2]);
            }
            else if(catVal!=null){
              catVal2=catVal;
              subcatVal=null;
              subcatVal2=null;
              productsHomeBloc.sortIn.add([null,catVal2, subcatVal2]);
              subCatMenu(catVal);
            }
          }
          else if(index == 2){
              if (catVal2==null)
              {
                key.currentState.showSnackBar(ShowSnack('Select a category', Colors.white, Colors.orange));
              }
              subcatVal = await showMenu<String>(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              color: Colors.black,
              context: context,
              position: catVal2=="Fashion" ? RelativeRect.fromLTRB(38.0, 435.0, 20.0, 0.0) : RelativeRect.fromLTRB(38.0, 515.0, 20.0, 0.0),
              items: subCatMenu(catVal2),
              elevation: 0
            );
            if(subcatVal!=null){
              subcatVal2=subcatVal;
              productsHomeBloc.sortIn.add([null,catVal2, subcatVal2]);
              // setState(() {
              //   data=subCategorySort(subcatVal2);
              // });
            }
          }
        }, 
      ),
    );
  }

  subCatMenu(String category){
    if (category=='Fashion')
    {
        return <PopupMenuItem<String>>[
                      new PopupMenuItem<String>(
                                height: 40,
                                child: const Text('Caps', style: TextStyle(color: Colors.white, fontSize: 15),), value: 'Caps'),
                      new PopupMenuItem<String>(
                                height: 40,
                                child: const Text('Bottoms', style: TextStyle(color: Colors.white, fontSize: 15),), value: 'Bottoms'),
                      new PopupMenuItem<String>(
                                height: 40,
                                child: const Text('Eye Wear', style: TextStyle(color: Colors.white, fontSize: 15),), value: 'Eye Wear'),
                      new PopupMenuItem<String>(
                                height: 40,
                                child: const Text('T-Shirts', style: TextStyle(color: Colors.white, fontSize: 15),), value: 'T-Shirts'),
                      new PopupMenuItem<String>(
                                height: 40,
                                child: const Text('Watches', style: TextStyle(color: Colors.white, fontSize: 15),), value: 'Watches'),
                    
      ];
    }
    else if (category=='Electronics')
    {
        return <PopupMenuItem<String>>[
                      new PopupMenuItem<String>(
                                height: 40,
                                child: const Text('Laptops', style: TextStyle(color: Colors.white, fontSize: 15),), value: 'Laptops'),
                      new PopupMenuItem<String>(
                                height: 40,
                                child: const Text('Mobile Phones', style: TextStyle(color: Colors.white, fontSize: 15),), value: 'Mobile Phones'),
                      new PopupMenuItem<String>(
                                height: 40,
                                child: const Text('Games', style: TextStyle(color: Colors.white, fontSize: 15),), value: 'Games'),
        
        ];
    }
  }

  reset(){
    catVal=null;
    catVal2=null;
    subcatVal=null;
    subcatVal2=null;
  }

}

final bottomNavigation = BottomNavigation();

