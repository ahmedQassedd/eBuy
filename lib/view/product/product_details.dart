import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ebuy/shared/void_componants.dart';
import 'package:ebuy/view/cart_and_favorite/cart_screen.dart';
import 'package:ebuy/view/cart_and_favorite/favorite_screen.dart';
import 'package:ebuy/view/checkout/checkout_screen.dart';
import 'package:ebuy/view_model/cubit/app_cubit.dart';
import 'package:ebuy/view_model/cubit/app_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductDetails extends StatelessWidget {
  late int index;
  ProductDetails(this.index);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            actions: [
              IconButton(
                  padding: const EdgeInsetsDirectional.only(end: 10.0),
                  onPressed: () {
                    cubit.getProductFromFavorite();

                    navigateTo(
                        context: context, widget: const FavoriteScreen());
                  },
                  icon: const Icon(
                    Icons.favorite_outline_outlined,
                    size: 30.0,
                    color: Colors.white,
                  )),
              IconButton(
                  padding: const EdgeInsetsDirectional.only(end: 10.0),
                  onPressed: () {
                    cubit.getProductFromCart();
                    navigateTo(context: context, widget: const CartScreen());
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 30,
                    color: Colors.white,
                  )),
            ],
            leading: IconButton(
              padding: const EdgeInsetsDirectional.only(start: 5.0),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
            backgroundColor: Color(cubit.currentIndex == 0
                ? cubit.productsModelList[index].color
                : cubit.tshirtModelList[index].color),
            elevation: 0.0,
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    width: size.width,
                    decoration: BoxDecoration(
                      color: Color(cubit.currentIndex == 0
                          ? cubit.productsModelList[index].color
                          : cubit.tshirtModelList[index].color),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 6.0,
                          offset: const Offset(0.0, 10.0),
                        ),
                      ],
                      borderRadius: const BorderRadiusDirectional.only(
                        bottomEnd: Radius.circular(70.0),
                        bottomStart: Radius.circular(70.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(top: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Product Name :',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                        color: Colors.white,
                                      ),
                                ),
                                Text(
                                  cubit.currentIndex == 0
                                      ? '${cubit.productsModelList[index].name}'
                                      : '${cubit.tshirtModelList[index].name}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline4!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 70.0,
                          ),
                          SizedBox(
                            height: 180,
                            width: size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Price :',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                    Text(
                                      '\$ ${cubit.currentIndex == 0 ? '${cubit.productsModelList[index].price}' : '${cubit.tshirtModelList[index].price}'}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline4!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsetsDirectional.only(
                                      bottom: 10, end: 10),
                                  child: Hero(
                                    tag: cubit.currentIndex == 0
                                        ? '${cubit.productsModelList[index].image}'
                                        : '${cubit.tshirtModelList[index].image}',
                                    child: Image.network(
                                      '${cubit.currentIndex == 0 ? cubit.productsModelList[index].image : cubit.tshirtModelList[index].image}',
                                      fit: BoxFit.fill,
                                      height: 180,
                                      width: 170,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(
                        start: 20.0, end: 20.0, bottom: 0.0),
                    child: Container(
                      width: size.width,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(0.0),
                          topEnd: Radius.circular(0.0),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Size :',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  Text(
                                    '12 cm',
                                    style: Theme.of(context)
                                        .textTheme
                                        .subtitle1!
                                        .copyWith(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Description :',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  Text(
                                    '${cubit.currentIndex == 0 ? cubit.productsModelList[index].description : cubit.tshirtModelList[index].description}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption!
                                        .copyWith(
                                            height: 1.5,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 70.0,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: 25,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(cubit.currentIndex == 0
                                                ? cubit.productsModelList[index]
                                                    .color
                                                : cubit.tshirtModelList[index]
                                                    .color),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            cubit.minusProduct();
                                          },
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text(
                                            '${cubit.numLOfProduct}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headline6!
                                                .copyWith(color: Colors.black),
                                          )),
                                      Container(
                                        height: 25,
                                        width: 35,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Color(cubit.currentIndex == 0
                                                ? cubit.productsModelList[index]
                                                    .color
                                                : cubit.tshirtModelList[index]
                                                    .color),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: IconButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () {
                                            cubit.plusProduct();
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  CircleAvatar(
                                    radius: 20.0,
                                    backgroundColor: Color(cubit.currentIndex ==
                                            0
                                        ? cubit.productsModelList[index].color
                                        : cubit.tshirtModelList[index].color),
                                    child: ConditionalBuilder(
                                      condition:
                                          (cubit.singleFavorite?.favorite ==
                                              true),
                                      builder: (context) => IconButton(
                                        onPressed: () {
                                          cubit.deleteFromFavorite(
                                            id: cubit.currentIndex == 0
                                                ? cubit.bagId[index]
                                                : cubit.tshirtId[index],
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.favorite,
                                          color: Colors.white,
                                        ),
                                      ),
                                      fallback: (context) => IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          cubit.putProductInFavorite(
                                            quantity: 1,
                                            productId: cubit.currentIndex == 0
                                                ? cubit.bagId[index]
                                                : cubit.tshirtId[index],
                                            image: cubit.currentIndex == 0
                                                ? cubit.productsModelList[index]
                                                    .image
                                                : cubit.tshirtModelList[index]
                                                    .image,
                                            price: cubit.currentIndex == 0
                                                ? cubit.productsModelList[index]
                                                    .price
                                                : cubit.tshirtModelList[index]
                                                    .price,
                                            name: cubit.currentIndex == 0
                                                ? cubit.productsModelList[index]
                                                    .name
                                                : cubit.tshirtModelList[index]
                                                    .name,
                                            description: cubit.currentIndex == 0
                                                ? cubit.productsModelList[index]
                                                    .description
                                                : cubit.tshirtModelList[index]
                                                    .description,
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.favorite_outline_outlined,
                                          color: Colors.white,
                                          size: 17.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 50.0,
                              ),
                              Row(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 60,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Color(cubit.currentIndex == 0
                                            ? cubit
                                                .productsModelList[index].color
                                            : cubit
                                                .tshirtModelList[index].color),
                                      ),
                                      borderRadius: BorderRadius.circular(17),
                                    ),
                                    child: ConditionalBuilder(
                                      condition:
                                          (cubit.singleCart?.cart == true),
                                      builder: (context) => IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          cubit.deleteFromCart(
                                            id: cubit.currentIndex == 0
                                                ? cubit.bagId[index]
                                                : cubit.tshirtId[index],
                                          );
                                        },
                                        icon: Icon(
                                          Icons.check,
                                          size: 30.0,
                                          color: Color(cubit.currentIndex == 0
                                              ? cubit.productsModelList[index]
                                                  .color
                                              : cubit.tshirtModelList[index]
                                                  .color),
                                        ),
                                      ),
                                      fallback: (context) => IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: () {
                                          cubit.putProductInCart(
                                              productId: cubit.currentIndex == 0
                                                  ? cubit.bagId[index]
                                                  : cubit.tshirtId[index],
                                              image: cubit.currentIndex == 0
                                                  ? cubit
                                                      .productsModelList[index]
                                                      .image
                                                  : cubit.tshirtModelList[index]
                                                      .image,
                                              price: cubit.currentIndex == 0
                                                  ? cubit
                                                      .productsModelList[index]
                                                      .price
                                                  : cubit.tshirtModelList[index]
                                                      .price,
                                              description: cubit.currentIndex ==
                                                      0
                                                  ? cubit
                                                      .productsModelList[index]
                                                      .description
                                                  : cubit.tshirtModelList[index]
                                                      .description,
                                              name: cubit.currentIndex == 0
                                                  ? cubit
                                                      .productsModelList[index]
                                                      .name
                                                  : cubit.tshirtModelList[index]
                                                      .name,
                                              quantity: cubit.numLOfProduct);
                                        },
                                        icon: Icon(
                                          Icons.shopping_cart_outlined,
                                          size: 30.0,
                                          color: Color(cubit.currentIndex == 0
                                              ? cubit.productsModelList[index]
                                                  .color
                                              : cubit.tshirtModelList[index]
                                                  .color),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        color: Color(cubit.currentIndex == 0
                                            ? cubit
                                                .productsModelList[index].color
                                            : cubit
                                                .tshirtModelList[index].color),
                                      ),
                                      child: MaterialButton(
                                          onPressed: () {
                                            cubit.currentStep = 0;
                                            cubit.value = 1;

                                            navigateTo(
                                                context: context,
                                                widget: CheckOutScreen(
                                                    index: index));
                                          },
                                          child: const Text(
                                            'Checkout',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17.0,
                                            ),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
