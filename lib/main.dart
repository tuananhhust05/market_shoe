import 'package:flutter/material.dart'; // thư viện mặc định
// code tự tạo ra
import 'controllers/cart_provider.dart';
import 'controllers/favorites_provider.dart';
import 'controllers/product_provider.dart';
import 'view/ui/mainscreen.dart';
import 'controllers/mainscreen_provider.dart';

// thư viện phải cài
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 2 package for hive
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  // Hive is a lightweight and blazing fast key-value database written in pure Dart
  // config local data base
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('cart_box');
  await Hive.openBox('fav_box');

  runApp(
      MultiProvider(
        providers:[
          ChangeNotifierProvider(
            create: (context) => MainScreenNotifier()
          ),
          ChangeNotifierProvider(
              create: (context) => ProductNotifier()
          ),
          ChangeNotifierProvider(
              create: (context) => FavoriteNotifier()
          ),
          ChangeNotifierProvider(
              create: (context) => CartProvider()
          ),
        ],
        child:const MyApp()
      )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // for responsive
    return ScreenUtilInit(
      designSize:const Size(375,812),
      minTextAdapt:true,
      splitScreenMode:true,
      builder:(context,child){
        return MaterialApp(
          debugShowCheckedModeBanner:false,
          title: 'dbestech',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const MainScreen(),
        );
      }
    );

  }
}