import 'package:bloc/bloc.dart';
import 'package:ebuy/shared/bloc_observer/bloc_observer.dart';
import 'package:ebuy/shared/const.dart';
import 'package:ebuy/shared/widget_componants.dart';
import 'package:ebuy/view/auth_view/login_screen.dart';
import 'package:ebuy/view_model/cubit/app_cubit.dart';
import 'package:ebuy/view_model/cubit/app_states.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'shared/cache_helper.dart';
import 'view/auth_view/onboard_page.dart';
import 'view/product/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();

  uid = CacheHelper.getData(key: 'uid');
  bool? boarding = CacheHelper.getData(key: 'opened');

  Widget firstPage;

  if (boarding == true) {
    if (uid != null) {
      firstPage = HomeScreen();
    } else {
      firstPage = const LoginScreen();
    }
  } else {
    firstPage = OnBoardPage();
  }

  runApp(MyApp(firstPage));
}

class MyApp extends StatelessWidget {
  Widget firstPage;
  MyApp(this.firstPage);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getProducts()
        ..getUserData()
        ..getProductFromCart()
        ..getOrder()
        ..getProductFromFavorite(),
      child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightThemeCom(),
              home: firstPage,
            );
          }),
    );
  }
}
