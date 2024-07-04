import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../../controllers/favorites_provider.dart';
import '../../controllers/mainscreen_provider.dart';
import '../shared/appstyle.dart';

class Favorites extends StatefulWidget {
  const Favorites({ super.key });

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final _favBox = Hive.box('fav_box');

  _deleteFav(int key) async{
    await _favBox.delete(key);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenNotifier>(
        builder:(context,mainScreenNotifier,child){
          var favorNotifier_init = Provider.of<FavoriteNotifier>(context,listen:true);
          favorNotifier_init.getAllData();
          return Scaffold(
              body: SizedBox(
                  height:MediaQuery.of(context).size.height,
                  width:MediaQuery.of(context).size.width,
                  child: Stack(
                      children:[
                        Container(
                            padding:const EdgeInsets.fromLTRB(16,45,0,0),
                            height:MediaQuery.of(context).size.height*0.4,
                            width:MediaQuery.of(context).size.width,
                            decoration:const BoxDecoration(
                                image:DecorationImage(
                                    image:AssetImage("assets/images/top_image.png"),
                                    fit:BoxFit.fill
                                )
                            ),
                            child:Padding(
                                padding:const EdgeInsets.all(8),
                                child:Text("My Favorites",
                                    style:appstyle(36,Colors.white,FontWeight.bold)
                                )
                            )
                        ),
                        Padding(
                            padding:const EdgeInsets.all(8),
                            child:ListView.builder(
                              itemCount:favorNotifier_init.fav.length,
                              padding:const EdgeInsets.only(top:100),
                              itemBuilder: (BuildContext context, int index) {
                                final shoe = favorNotifier_init.fav[index];
                                return Padding(
                                    padding:const EdgeInsets.all(8),
                                    child:ClipRRect(
                                        borderRadius:const BorderRadius.all(Radius.circular(12)),
                                        child:Container(
                                            height:MediaQuery.of(context).size.height *0.11,
                                            width:MediaQuery.of(context).size.width,
                                            decoration:BoxDecoration(
                                                color:Colors.grey.shade100,
                                                boxShadow:[
                                                  BoxShadow(
                                                      color:Colors.grey.shade500,
                                                      spreadRadius:5,
                                                      blurRadius:0.3,
                                                      offset:const Offset(0,1)
                                                  )
                                                ]
                                            ),
                                            child: Row(
                                                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                children:[
                                                  Row(
                                                      children:[
                                                        Padding(
                                                          padding:const EdgeInsets.all(12),
                                                          child:CachedNetworkImage(
                                                              imageUrl:shoe['imageUrl'],
                                                              width:70,
                                                              height:70,
                                                              fit:BoxFit.fill
                                                          ),
                                                        ),

                                                        Padding(
                                                            padding:const EdgeInsets.only(
                                                                top:12,left:12
                                                            ),
                                                            child:Column(
                                                                crossAxisAlignment:CrossAxisAlignment.start,
                                                                children:[
                                                                  Text(shoe['name'],
                                                                      style:appstyle(16,Colors.black,FontWeight.bold)
                                                                  ),
                                                                  const SizedBox(
                                                                    height:5,
                                                                  ),
                                                                  Text(shoe['category'],
                                                                      style:appstyle(16,Colors.grey,FontWeight.w600)
                                                                  ),
                                                                  const SizedBox(
                                                                      height:5
                                                                  ),
                                                                  Row(
                                                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                                                      children:[
                                                                        Text("\$${shoe['price']}")
                                                                      ]
                                                                  )
                                                                ]
                                                            )
                                                        ),
                                                      ]
                                                  ),
                                                  Padding(
                                                      padding:const EdgeInsets.all(8),
                                                      child:GestureDetector(
                                                          onTap: () {
                                                            favorNotifier_init.deleteFav(shoe['key']);
                                                            favorNotifier_init.ids.removeWhere(
                                                                    (element) => element == shoe['id']
                                                            );
                                                            favorNotifier_init.getAllData();
                                                            // mainScreenNotifier.modeDeleteProductInCart = !mainScreenNotifier.modeDeleteProductInCart; // change mode to rerender
                                                          },
                                                          child:const Icon(Ionicons.heart_dislike_circle_outline)
                                                      )
                                                  )
                                                ]
                                            )
                                        )
                                    )
                                );
                              },
                            )
                        )
                      ]
                  )
              )
          );
        });
  }
}