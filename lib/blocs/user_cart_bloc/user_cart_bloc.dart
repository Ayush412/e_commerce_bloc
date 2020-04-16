import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce_bloc/blocs/bloc.dart';
import 'package:e_commerce_bloc/repositories/user_cart_repo.dart';
import 'package:rxdart/rxdart.dart';

class UserCartBloc implements BaseBloc{

  QuerySnapshot qs;
  int cartTotal;
  int discount = 0;
  int shipping = 10;
  int finalAmount = 0;

  //CONTROLLERS
  BehaviorSubject<QuerySnapshot> _cartController = BehaviorSubject();
  BehaviorSubject<int> _totalController = BehaviorSubject();
  BehaviorSubject<DocumentSnapshot> _codeController = BehaviorSubject();
  BehaviorSubject<int> _finalAmountController = BehaviorSubject();

  //SINKS
  Sink<QuerySnapshot> get cartIn => _cartController.sink;
  Sink<int> get totalIn => _totalController.sink;
  Sink<DocumentSnapshot> get codeIn => _codeController.sink;
  Sink<int> get finalAmountIn => _finalAmountController.sink;

  //STREAMS
  Stream<QuerySnapshot> get cartOut => _cartController.stream;
  Stream<int> get totalOut => _totalController.stream;
  Stream<DocumentSnapshot> get codeOut => _codeController.stream;
  Stream<int> get finalAmountOut => _finalAmountController.stream;

  confirmPurchase() async{
    bloc.loadingStatusIn.add(true);
    Map<String, Map> map = Map<String, Map>();
    qs.documents.forEach((element){map[element.documentID] = element.data;});
    await userCartRepo.confirmPurchase(map, finalAmount);
    bloc.loadingStatusIn.add(false);
  }

  resetCode(){
    discount = 0;
    shipping = 10;
    finalAmount = 0;
    codeIn.add(null);
    calculateTotal();
  }

  getPromoCode(String code) async{
    bloc.loadingStatusIn.add(true);
    codeIn.add( await userCartRepo.getPromoCode(code));
    bloc.loadingStatusIn.add(false);
  }
  
  getDiscount(DocumentSnapshot event){
     if(event.data['Percentage']!=null){
        discount = ((cartTotal*event.data['Percentage']/100)).round();
        print(discount);
      }
      else{
        discount = event.data['Amount'];
      }
      shipping = 10;
      calculateTotal();
  }

  getShipping(int event){
    discount = 0;
    shipping = 10 - event;
    calculateTotal();
  }

  calculateTotal(){
    finalAmount = cartTotal-discount+shipping;
    finalAmountIn.add(finalAmount);
  }

  getCart() async{
    List data = await userCartRepo.getCart();
    totalIn.add(data[0]);
    cartIn.add(data[1]);
    cartTotal = data[0];
    qs = data[1];
    calculateTotal();
  }

  addVal(String doc) async{
    bloc.loadingStatusIn.add(true);
    await userCartRepo.addVal(doc);
    await getCart();
    calculateTotal();
    bloc.loadingStatusIn.add(false);
  }

  remVal(String doc) async{
    bloc.loadingStatusIn.add(true);
    await userCartRepo.remVal(doc);
    await getCart();
    calculateTotal();
    bloc.loadingStatusIn.add(false);
  }

  delProd(String doc) async{
    bloc.loadingStatusIn.add(true);
    await userCartRepo.delProd(doc);
    await getCart();
    calculateTotal();
    bloc.loadingStatusIn.add(false);
  }

  @override
  void dispose() {
    _cartController.close();
    _totalController.close();
    _codeController.close();
    _finalAmountController.close();
  }

}

final userCartBloc = UserCartBloc();