import 'package:ebuy/shared/const.dart';
import 'package:ebuy/shared/void_componants.dart';
import 'package:ebuy/view/product/home_screen.dart';
import 'package:ebuy/view_model/cubit/app_cubit.dart';
import 'package:ebuy/view_model/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true, min: 0.8, max: 1);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (AppCubit.get(context).productsModelList.isNotEmpty &&
            AppCubit.get(context).tshirtModelList.isNotEmpty &&
            AppCubit.get(context).user!.pic!.isNotEmpty) {
          navigateAndFinish(context: context, widget: HomeScreen());
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _animation,
                  child: Column(
                    children: [
                      const Image(
                        image: AssetImage('assets/images/logo.png'),
                        height: 200,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Success Login',
                        style: Theme.of(context).textTheme.headline4!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
