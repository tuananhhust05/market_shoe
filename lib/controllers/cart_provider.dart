import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CartProvider with ChangeNotifier {
  int _counter = 0;
  int get counter => _counter;
  final _cartBox = Hive.box('cart_box');

  void increament(){
    _counter++;
    notifyListeners();
  }

  void decreament(){
    if(_counter >= 1 ){
      _counter--;
      notifyListeners();
    }
  }

  //  List<dynamic> cart = [];
  List<dynamic> _cart = [];
  List<dynamic> get cart => _cart;  // to read private property for show data

  // update private property
  set cart(List<dynamic>  Newcart){
    _cart = Newcart;
    // default function in flutter for update ui
    notifyListeners();
  }

  getCart(){
    final cartData = _cartBox.keys.map((key){
      final item = _cartBox.get(key);
      return {
        "key":key,
        "id":item['id'],
        "category":item['category'],
        "name":item['name'],
        "sizes":item['sizes'],
        "imageUrl":item['imageUrl'],
        "price":item['price'],
        "qty":item['qty']
      };
    }).toList();

    _cart = cartData.reversed.toList();
  }


  deleteCart(dynamic key) async {
    await _cartBox.delete(key);
    notifyListeners();
  }

}