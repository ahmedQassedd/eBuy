import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ebuy/model/cart_model.dart';
import 'package:ebuy/shared/const.dart';
import 'package:ebuy/shared/void_componants.dart';
import 'package:ebuy/view/checkout/total_checkout_screen.dart';
import 'package:ebuy/view_model/cubit/app_cubit.dart';
import 'package:ebuy/view_model/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text(
              'Cart',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            backgroundColor: Colors.grey[200],
            leading: IconButton(
              padding: const EdgeInsetsDirectional.only(start: 15.0),
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.grey[600],
              ),
            ),
            elevation: 0.0,
          ),
          body: ConditionalBuilder(
            condition: state is LoadingGetProductInCartState,
            builder: (context) => const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
                color: primaryColor,
                strokeWidth: 2.0,
              ),
            ),
            fallback: (context) => cubit.cartProducts.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => Slidable(
                              key: const ValueKey(0),
                              startActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (a) {
                                      cubit.putProductInFavorite(
                                        image: cubit.cartProducts[index].image,
                                        price: cubit.cartProducts[index].price,
                                        name: cubit.cartProducts[index].name,
                                        quantity: 1,
                                        productId:
                                            cubit.cartProducts[index].uid,
                                        description: cubit
                                            .cartProducts[index].description,
                                      );
                                    },
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    icon: Icons.favorite_outline_outlined,
                                    label: 'Add To Favorites',
                                  ),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (a) {
                                      cubit.deleteFromCart(
                                          id: cubit.cartProducts[index].uid);
                                    },
                                    backgroundColor: const Color(0xFFFE4A49),
                                    foregroundColor: Colors.white,
                                    icon: Icons.delete,
                                    label: 'Remove',
                                  ),
                                ],
                              ),
                              child: ListTile(
                                title: productItem(
                                    model: cubit.cartProducts[index],
                                    context: context,
                                    index: index),
                              ),
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10.0,
                            ),
                            itemCount: cubit.cartProducts.length,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          width: size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.white),
                          ),
                          child: Padding(
                              padding: const EdgeInsetsDirectional.all(20.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Total Price :',
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '\$${cubit.totalPrice}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline4!
                                            .copyWith(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    width: 40.0,
                                  ),
                                  Expanded(
                                    child: Container(
                                      height: 50.0,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          color: primaryColor),
                                      child: MaterialButton(
                                          onPressed: () {
                                            cubit.currentStep = 0;
                                            cubit.value = 1;

                                            navigateTo(
                                                context: context,
                                                widget: TotalCheckOutScreen());
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
                              )),
                        ),
                      ],
                    ),
                  )
                : const Center(
                    child: SizedBox(
                      height: 200,
                      child: Image(
                        image: AssetImage('assets/images/a.png'),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }
}

Widget productItem(
        {required CartModel model, required context, required int index}) =>
    Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              SizedBox(
                height: 90,
                width: 80,
                child: Image.network(
                  '${model.image}',
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${model.name}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            '\$ ${model.price}',
                            style: Theme.of(context)
                                .textTheme
                                .headline6!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          height: 25,
                          width: 35,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              if (model.quantity == 1) {
                                return;
                              } else {
                                AppCubit.get(context)
                                    .minusQuantityInCart(index: index);
                                AppCubit.get(context)
                                    .updateQuantityInCart(index: index);
                              }
                            },
                            icon: const Icon(
                              Icons.remove,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              '${model.quantity}',
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
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              if (model.quantity == 20) {
                                return;
                              } else {
                                AppCubit.get(context)
                                    .plusQuantityInCart(index: index);
                                AppCubit.get(context)
                                    .updateQuantityInCart(index: index);
                              }
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
