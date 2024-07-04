import 'package:app3/view/shared/appstyle.dart';
import 'package:flutter/material.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../controllers/favorites_provider.dart';
import '../../models/constants.dart';
import '../ui/favorites.dart';

class MyWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(CommunityMaterialIcons.alarm),
        onPressed: () {
          print('Pressed');
        }
    );
  }
}
class ProductCard extends StatefulWidget {
   const ProductCard({super.key, required this.price, required this.category, required this.id, required this.name, required this.image});

   final String price;
   final String category;
   final String id;
   final String name;
   final String image;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {

  @override
  Widget build(BuildContext context){
    // data in provider is global
    // when we change data in it
    // any object is created by provider after have data
    var favorNotifier_init = Provider.of<FavoriteNotifier>(context,listen:true);
    favorNotifier_init.getFavorites();

    bool selected = true;
    return Padding(
      padding:const EdgeInsets.fromLTRB(0,0,20,0),
      child:ClipRRect(
          borderRadius:const BorderRadius.all(Radius.circular(16)),
          child:Container(
            height:MediaQuery.of(context).size.height,
            width:MediaQuery.of(context).size.width*0.6,
            decoration:const BoxDecoration(
               boxShadow:[
                 BoxShadow(
                     color:Colors.white,
                     spreadRadius: 1,
                     blurRadius:0.6,
                     offset:Offset(1,1)
                 )
               ]
            ),
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // img and heart
                Stack(
                  children: [
                    // image
                    Container(
                       height: MediaQuery.of(context).size.height*0.23,
                      decoration: BoxDecoration(
                        image:DecorationImage(
                          image: NetworkImage(widget.image)
                        )
                      ),
                    ),

                    // add to favourite
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Consumer<FavoriteNotifier>(
                        builder:(context,favoriteNotifier,child){
                          return GestureDetector(
                            onTap: () async {
                              if(favoriteNotifier.ids.contains(widget.id)){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder:(context) => const Favorites()
                                    )
                                );
                              }
                              else{
                                favoriteNotifier.createFav({
                                  "id":widget.id,
                                  "name":widget.name,
                                  "category":widget.category,
                                  "price":widget.price,
                                  "imageUrl":widget.image
                                });
                                setState((){}); // update data in controller
                              }
                            },
                            child:favoriteNotifier.ids.contains(widget.id) ?
                            const Icon(CommunityMaterialIcons.heart)
                                : const Icon(CommunityMaterialIcons.heart_outline),
                          );
                        })
                    )
                  ],
                ),

                // information
                // name and category
                Padding(
                    padding: const EdgeInsets.only(left:8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.name,  // take data from parent widget
                          style: appstyleWithHt(25, Colors.black, FontWeight.bold,1.1),
                        ),
                        Text(widget.category,
                          style: appstyleWithHt(18, Colors.grey, FontWeight.bold,1.5),
                        )
                      ],
                    ),
                ),
                // price and color
                Padding(
                    padding: const EdgeInsets.only(left:8,right:0),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                           "\$${widget.price}" ,
                           style: appstyle(30, Colors.black, FontWeight.w600),
                        ),
                        Row(
                          children: [
                            Text("Colors",
                              style:appstyle(14, Colors.grey, FontWeight.w500)
                            ),
                            const SizedBox(width:5),
                            const CircleAvatar(
                                radius:15,
                                backgroundColor:Colors.black
                            ),
                            const SizedBox(width:5),
                            // box choose color
                            // SizedBox(
                            //   width: 5,
                            //   child: ChoiceChip(
                            //     label: Text(""),
                            //     selected: selected,
                            //     visualDensity: VisualDensity.compact,
                            //     selectedColor: Colors.black,
                            //   )
                            // )
                          ],
                        )
                      ],
                    )
                )
              ],
            )
          )
      )
    );
  }
}