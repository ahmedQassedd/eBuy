import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ebuy/model/cart_model.dart';
import 'package:ebuy/shared/const.dart';
import 'package:ebuy/view_model/cubit/app_cubit.dart';
import 'package:ebuy/view_model/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            title: Text(
              'Favorites',
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
            condition: state is LoadingGetProductFromFavoriteState,
            builder: (context) => const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
                color: primaryColor,
                strokeWidth: 2.0,
              ),
            ),
            fallback: (context) => cubit.favoritesList.isNotEmpty
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
                                      cubit.putProductInCart(
                                        image: cubit.favoritesList[index].image,
                                        price: cubit.favoritesList[index].price,
                                        name: cubit.favoritesList[index].name,
                                        quantity: 1,
                                        productId:
                                            cubit.favoritesList[index].uid,
                                        description: cubit
                                            .favoritesList[index].description,
                                      );
                                    },
                                    backgroundColor: primaryColor,
                                    foregroundColor: Colors.white,
                                    icon: Icons.shopping_cart_outlined,
                                    label: 'Add To Cart',
                                  ),
                                ],
                              ),
                              endActionPane: ActionPane(
                                motion: const ScrollMotion(),
                                children: [
                                  SlidableAction(
                                    onPressed: (a) {
                                      cubit.deleteFromFavorite(
                                          id: cubit.favoritesList[index].uid);
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
                                    model: cubit.favoritesList[index],
                                    context: context,
                                    index: index),
                              ),
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 10.0,
                            ),
                            itemCount: cubit.favoritesList.length,
                          ),
                        ),
                        const SizedBox(
                          height: 5.0,
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
                                .headline6!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            '${model.description}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        '\$ ${model.price}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: Theme.of(context)
                            .textTheme
                            .headline6!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
