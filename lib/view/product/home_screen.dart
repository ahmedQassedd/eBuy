import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ebuy/model/products_model.dart';
import 'package:ebuy/shared/cache_helper.dart';
import 'package:ebuy/shared/const.dart';
import 'package:ebuy/shared/void_componants.dart';
import 'package:ebuy/view/auth_view/login_screen.dart';
import 'package:ebuy/view/cart_and_favorite/cart_screen.dart';
import 'package:ebuy/view/cart_and_favorite/favorite_screen.dart';
import 'package:ebuy/view/profile/edit_profile_screen.dart';
import 'package:ebuy/view/profile/orders_screen.dart';
import 'package:ebuy/view/profile/profile_screen.dart';
import 'package:ebuy/view_model/cubit/app_cubit.dart';
import 'package:ebuy/view_model/cubit/app_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'product_details.dart';

class HomeScreen extends StatelessWidget {
  final _advancedDrawerController = AdvancedDrawerController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return AdvancedDrawer(
          backdropColor: primaryColor,
          controller: _advancedDrawerController,
          animationCurve: Curves.fastOutSlowIn,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          rtlOpening: false,
          disabledGestures: false,
          childDecoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              leading: IconButton(
                color: Colors.black54,
                onPressed: _handleMenuButtonPressed,
                icon: ValueListenableBuilder<AdvancedDrawerValue>(
                  valueListenable: _advancedDrawerController,
                  builder: (_, value, __) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 250),
                      child: Icon(
                        value.visible
                            ? Icons.arrow_back_ios_rounded
                            : Icons.person_outline,
                        key: ValueKey<bool>(value.visible),
                      ),
                    );
                  },
                ),
              ),
              actions: [
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    IconButton(
                        padding: const EdgeInsetsDirectional.only(end: 10.0),
                        onPressed: () {
                          cubit.getProductFromFavorite();

                          navigateTo(
                              context: context, widget: const FavoriteScreen());
                        },
                        icon: Icon(
                          Icons.favorite_outline_outlined,
                          size: 30.0,
                          color: Colors.grey[600],
                        )),
                    if (cubit.favoritesList.isNotEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 10.0, end: 10.0, top: 6.0, bottom: 10.0),
                        child: CircleAvatar(
                          radius: 7.0,
                          backgroundColor: primaryColor,
                          child: Text(
                            '${cubit.favoritesList.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Stack(
                  alignment: AlignmentDirectional.topEnd,
                  children: [
                    IconButton(
                        padding: const EdgeInsetsDirectional.only(end: 10.0),
                        onPressed: () {
                          cubit.getProductFromCart();
                          navigateTo(
                              context: context, widget: const CartScreen());
                        },
                        icon: Icon(
                          Icons.shopping_cart_outlined,
                          size: 30,
                          color: Colors.grey[600],
                        )),
                    if (cubit.cartProducts.isNotEmpty)
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 10.0, end: 10.0, top: 6.0, bottom: 10.0),
                        child: CircleAvatar(
                          radius: 7.0,
                          backgroundColor: primaryColor,
                          child: Text(
                            '${cubit.cartProducts.length}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 20.0, end: 20.0, bottom: 10.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    Center(
                      child: SizedBox(
                          height: 50.0,
                          width: 520.0,
                          child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => catalogItem(
                                  text: cubit.catalogList[index],
                                  context: context,
                                  index: index),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    width: 40.0,
                                  ),
                              itemCount: cubit.catalogList.length)),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    ConditionalBuilder(
                      condition: state is! LoadingGetProductsDataState &&
                          cubit.productsModelList.isNotEmpty,
                      builder: (context) => GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: cubit.currentIndex == 0
                            ? cubit.productsModelList.length
                            : cubit.tshirtModelList.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.73,
                          mainAxisSpacing: 20.0,
                          crossAxisSpacing: 20.0,
                        ),
                        itemBuilder: (context, index) => productItem(
                            index: index,
                            press: () {
                              navigateTo(
                                  context: context,
                                  widget: ProductDetails(index));
                            },
                            context: context,
                            bagsModel: cubit.currentIndex == 0
                                ? cubit.productsModelList[index]
                                : cubit.tshirtModelList[index]),
                      ),
                      fallback: (context) => const Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.white,
                          color: primaryColor,
                          strokeWidth: 2.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          drawer: SafeArea(
            child: ListTileTheme(
              textColor: Colors.white,
              iconColor: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: const EdgeInsets.only(
                      top: 35.0,
                      bottom: 64.0,
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xff2E4C6D),
                          radius: 60,
                          backgroundImage: NetworkImage('${cubit.user?.pic}'),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      cubit.getUserData();
                      navigateTo(
                          context: context, widget: const ProfileScreen());
                    },
                    leading: const Icon(Icons.account_circle_rounded),
                    title: const Text('Profile'),
                  ),
                  ListTile(
                    onTap: () {
                      cubit.getUserData();
                      navigateTo(context: context, widget: EditProfileScreen());
                    },
                    leading: cubit.user?.address == ''
                        ? const Icon(
                            Icons.error,
                            color: Colors.amber,
                          )
                        : const Icon(
                            Icons.check_circle,
                            color: Color(0xff2E4C6D),
                          ),
                    title: const Text('Your address'),
                  ),
                  ListTile(
                    onTap: () {
                      cubit.getOrder();
                      navigateTo(context: context, widget: const OrderScreen());
                    },
                    leading: const Icon(Icons.production_quantity_limits),
                    title: const Text('Orders'),
                  ),
                  ListTile(
                    onTap: () {
                      CacheHelper.removeData(key: 'uid')!.then((value) {
                        navigateAndFinish(
                            context: context, widget: const LoginScreen());
                      });
                    },
                    leading: const Icon(Icons.exit_to_app_rounded),
                    title: const Text('Log out'),
                  ),
                  const Spacer(),
                  DefaultTextStyle(
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                        vertical: 16.0,
                      ),
                      child: const Text('Terms of Service | Privacy Policy'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget catalogItem(
          {required String text,
          required BuildContext context,
          required int index}) =>
      GestureDetector(
        onTap: () {
          AppCubit.get(context).getProducts();
          AppCubit.get(context).currentIndexMethod(index: index);
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(text,
                style: Theme.of(context).textTheme.subtitle2!.copyWith(
                    color: AppCubit.get(context).currentIndex == index
                        ? Colors.black
                        : Colors.grey,
                    fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 5.0,
            ),
            AnimatedContainer(
                curve: Curves.bounceOut,
                duration: const Duration(milliseconds: 800),
                height: AppCubit.get(context).currentIndex == index ? 2.0 : 0.0,
                width: AppCubit.get(context).currentIndex == index ? 25.0 : 0.0,
                color: Colors.black)
          ],
        ),
      );

  Widget productItem({
    required int index,
    required BuildContext context,
    required Function press,
    required ProductsModel bagsModel,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: InkWell(
            onTap: () {
              AppCubit.get(context).getSingleFavorite(
                  AppCubit.get(context).currentIndex == 0
                      ? AppCubit.get(context).bagId[index]
                      : AppCubit.get(context).tshirtId[index]);

              AppCubit.get(context).getSingleCart(
                  AppCubit.get(context).currentIndex == 0
                      ? AppCubit.get(context).bagId[index]
                      : AppCubit.get(context).tshirtId[index]);

              press();
              AppCubit.get(context).numLOfProduct = 1;
            },
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Color(bagsModel.color),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Hero(
                tag: "${bagsModel.image}",
                child: Image.network(
                  '${bagsModel.image}',
                ),
              ),
            ),
          )),
          const SizedBox(
            height: 2.0,
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(
              top: 3.0,
            ),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${bagsModel.name}',
                    style: Theme.of(context)
                        .textTheme
                        .caption!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    '${bagsModel.price}\$',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
        ],
      );

  void _handleMenuButtonPressed() {
    _advancedDrawerController.showDrawer();
  }
}
