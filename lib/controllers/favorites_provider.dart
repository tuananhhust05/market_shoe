import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class FavoriteNotifier extends ChangeNotifier {
  final _favBox = Hive.box('fav_box');

  List<dynamic> _favorites = [];
  List<dynamic> get favorites => _favorites;  // to read private property for show data

  // update private property
  set favorites(List<dynamic>  Newfavorites){
    _favorites = Newfavorites;
    // default function in flutter for update ui
    notifyListeners();
  }


  //  List<dynamic> cart = [];
  List<dynamic> _ids = [];
  List<dynamic> get ids => _ids;  // to read private property for show data

  // update private property
  set cart(List<dynamic>  Newids){
    _ids = Newids;
    // default function in flutter for update ui
    notifyListeners();
  }


  getFavorites(){
    final favData = _favBox.keys.map((key){
      final item = _favBox.get(key);
      return {
        "key":key,
        "id":item['id']
      };
    }).toList();
    _favorites = favData.toList();
    _ids = _favorites.map((item)=> item['id']).toList();
  }

  Future<void> createFav(Map<String,dynamic> addFav) async {
    await _favBox.add(addFav);
  }

  List<dynamic> _fav = [];
  List<dynamic> get fav => _fav;  // to read private property for show data
  set fav(List<dynamic>  Newfav){
    _fav = Newfav;
    // default function in flutter for update ui
    notifyListeners();
  }

  getAllData(){
    final favData = _favBox.keys.map((key){
      final item = _favBox.get(key);
      return {
        "key":key,
        "id":item["id"],
        "name":item["name"],
        "category":item['category'],
        "price":item['price'],
        "imageUrl":item['imageUrl']
      };
    }).toList();
    _fav = favData.reversed.toList();
    notifyListeners();
  }

  deleteFav(int key) async{
    await _favBox.delete(key);
  }
}