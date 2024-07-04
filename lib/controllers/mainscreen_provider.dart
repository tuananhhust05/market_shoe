import 'package:flutter/material.dart';


// extend từ class cập nhật thông báo của flutter
class MainScreenNotifier extends ChangeNotifier {
    int _pageIndex = 0;
    int get pageIndex => _pageIndex;  // to read private property for show data

    // update private property
    set pageIndex(int newIndex){
      _pageIndex = newIndex;
      // default function in flutter for update ui
      notifyListeners();
    }

    bool _modeDeleteProductInCart = true;
    bool get modeDeleteProductInCart => _modeDeleteProductInCart;  // to read private property for show data

    // update private property
    set modeDeleteProductInCart(bool NewmodeDeleteProductInCart){
      _modeDeleteProductInCart = NewmodeDeleteProductInCart;
      // default function in flutter for update ui
      notifyListeners();
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
}