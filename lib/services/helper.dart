import 'package:flutter/services.dart' as the_bundle; // lirary default
import '../models/sneaker_model.dart';
import 'package:http/http.dart' as client;
import 'config.dart';

class Helper {

  // Male
  Future<List<Sneakers>> getMaleSneakers() async {
     var url = Uri.http(Config.apiUrl,Config.sneakers);
     print("Đường dẫn .............................");
     print(url);
     var response = await client.get(url);
     if(response.statusCode == 200){
       print(response.body);
       final maleList = sneakersFromJson(response.body);
       print(maleList);
       var male = maleList.where((element) => element.category == "Men's Running");
       return male.toList();
     }
     else{
       return [];
     }
  }

  // Female
  Future<List<Sneakers>> getFemaleSneakers() async {
    final data = await the_bundle.rootBundle.loadString("assets/json/women_shoes.json");
    final femaleList = sneakersFromJson(data);
    return femaleList;
  }
  // Kids
  Future<List<Sneakers>> getKidsSneakers() async {
    final data = await the_bundle.rootBundle.loadString("assets/json/kids_shoes.json");
    final kidsList = sneakersFromJson(data);
    return kidsList;
  }

  // Single  Male
  Future<Sneakers> getMaleSneakersById(String id) async {
    final data = await the_bundle.rootBundle.loadString("assets/json/men_shoes.json");
    final maleList = sneakersFromJson(data);
    final sneaker = maleList.firstWhere((sneaker) => sneaker.id == id );
    return sneaker;
  }

  // Single Female
  Future<Sneakers> getFemaleSneakersById(String id) async {
    final data = await the_bundle.rootBundle.loadString("assets/json/women_shoes.json");
    final femaleList = sneakersFromJson(data);
    final sneaker = femaleList.firstWhere((sneaker) => sneaker.id == id );
    return sneaker;
  }

  // Single Kids
  Future<Sneakers> getKidsSneakersById(String id) async {
    final data = await the_bundle.rootBundle.loadString("assets/json/kids_shoes.json");
    final kidsList = sneakersFromJson(data);
    final sneaker = kidsList.firstWhere((sneaker) => sneaker.id == id );
    return sneaker;
  }

}