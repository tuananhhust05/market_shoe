import 'package:flutter/material.dart';

import '../models/sneaker_model.dart';
import '../services/helper.dart';

class ProductNotifier extends ChangeNotifier {
   int _activepage = 0;
   List<dynamic> _shoeSizes = [];
   List<String> _sizes = [];

   List<String> get sizes => _sizes;
   set sizes(List<String> newsizes){
     _sizes = newsizes;
     notifyListeners();
   }

   int get activepage => _activepage;
   set activepage(int newIndex){
     _activepage = newIndex;
     notifyListeners();
   }

   List<dynamic> get shoeSizes => _shoeSizes;
   set shoeSizes(List<dynamic> newSizes){
     _shoeSizes = newSizes;
     notifyListeners();
   }

   // change data in provider
   void toggleCheck(int index){
     for( int i =0; i < _shoeSizes.length; i++){
       if( i == index){
         _shoeSizes[i]['isSelected'] = !_shoeSizes[i]['isSelected'];
       }
       // else{
       //   _shoeSizes[i]['isSelected'] = false;
       // }
       notifyListeners(); // update statte
     }
   }

   void clearSelected(){
     for( int i =0; i < _shoeSizes.length; i++){
       _shoeSizes[i]['isSelected'] = false;
     };
     notifyListeners();
   }


   // home page
   late Future<List<Sneakers>> male;
   late Future<List<Sneakers>> female;
   late Future<List<Sneakers>> kids;

   void getMale(){
     male = Helper().getMaleSneakers();
   }

   void getFemale(){
     female = Helper().getFemaleSneakers();
   }

   void getKids(){
     kids = Helper().getKidsSneakers();
   }

   // product page
   late Future<Sneakers> sneaker;
   void getShoes(String category, dynamic id){
     if(category == "Men's Running"){
       sneaker = Helper().getMaleSneakersById(id);
     }
     else if(category == "Women's Running"){
       sneaker = Helper().getFemaleSneakersById(id);
     }
     else if(category == "Kids' Running"){
       sneaker = Helper().getKidsSneakersById(id);
     }
   }
}