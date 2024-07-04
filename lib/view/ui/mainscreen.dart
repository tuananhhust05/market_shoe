import 'package:app3/view/ui/product_by_cat.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:community_material_icon/community_material_icon.dart';
import 'package:provider/provider.dart';
import '../../controllers/mainscreen_provider.dart';
import '../shared/appstyle.dart';
import '../shared/bottom_nav.dart';
import '../shared/bottom_nav_widget.dart';
import 'cartpage.dart';
import 'favorites.dart';
import 'homepage.dart';
import 'profile.dart';
import 'searchpage.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});


  @override
  Widget build(BuildContext context){
    List<Widget> pageList = [
      const HomePage(),
      const SearchPage(),
      const Favorites(),
      CartPage(),
      const ProfilePage()
    ];
    int  pageIndex = 0;

    return Consumer<MainScreenNotifier>(
      builder:(context,mainScreenNotifier,child){
        return Scaffold(
          body:pageList[mainScreenNotifier.pageIndex],
          bottomNavigationBar: const BottomNavBar()
        );
      }
    );

  }
}