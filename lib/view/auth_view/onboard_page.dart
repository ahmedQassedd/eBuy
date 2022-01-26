import 'package:ebuy/shared/const.dart';
import 'package:ebuy/view_model/cubit/app_cubit.dart';
import 'package:ebuy/view_model/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  String image;
  String subTitle;
  String title;

  BoardingModel(
      {required this.image, required this.subTitle, required this.title});
}

class OnBoardPage extends StatelessWidget {
  var pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          AppCubit cubit = AppCubit.get(context);

          return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.0,
                actions: [
                  TextButton(
                      onPressed: () {
                        cubit.skipOnBoard(context);
                      },
                      child: const Text(
                        'SKIP',
                        style: TextStyle(color: primaryColor),
                      ))
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Expanded(
                      child: PageView.builder(
                        controller: pageController,
                        onPageChanged: (int index) {
                          if (index == cubit.pages.length - 1) {
                            cubit.changeLastPage();
                          } else {
                            cubit.lastPage;
                          }
                        },
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) =>
                            boardItem(cubit.pages[index], context),
                        itemCount: cubit.pages.length,
                      ),
                    ),
                    Row(
                      children: [
                        SmoothPageIndicator(
                          controller: pageController,
                          count: cubit.pages.length,
                          effect: const ExpandingDotsEffect(
                            dotColor: Colors.grey,
                            dotHeight: 10.0,
                            dotWidth: 10.0,
                            spacing: 5.0,
                            activeDotColor: primaryColor,
                            expansionFactor: 5,
                          ),
                        ),
                        const Spacer(),
                        FloatingActionButton(
                          backgroundColor: primaryColor,
                          onPressed: () {
                            if (cubit.lastPage) {
                              cubit.skipOnBoard(context);
                            } else {
                              pageController.nextPage(
                                  duration: const Duration(milliseconds: 1000),
                                  curve: Curves.fastOutSlowIn);
                            }
                          },
                          child: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ));
        });
  }
}

Widget boardItem(BoardingModel model, context) => Column(
      children: [
        TweenAnimationBuilder(
          onEnd: () {
            AppCubit.get(context).changeOpacity();
          },
          curve: Curves.bounceOut,
          tween: Tween<double>(begin: 0, end: 300),
          duration: const Duration(seconds: 2),
          builder: (BuildContext context, double value, Widget? child) {
            return Image(
              image: AssetImage(model.image),
              height: value,
              width: value,
            );
          },
        ),
        const SizedBox(
          height: 40.0,
        ),
        AnimatedOpacity(
          duration: const Duration(seconds: 1),
          opacity: AppCubit.get(context).customOpacity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Center(
                child: Column(
              children: [
                Text(model.title,
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                        color: primaryColor, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 20.0,
                ),
                Text(model.subTitle,
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: Colors.black54, fontWeight: FontWeight.bold)),
              ],
            )),
          ),
        ),
      ],
    );
