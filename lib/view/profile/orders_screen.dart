import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ebuy/model/order_model.dart';
import 'package:ebuy/shared/const.dart';
import 'package:ebuy/view_model/cubit/app_cubit.dart';
import 'package:ebuy/view_model/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({Key? key}) : super(key: key);

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
              'Orders',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.grey[200],
            elevation: 0.0,
          ),
          body: ConditionalBuilder(
            condition: state is LoadingGetOrderState,
            builder: (context) => const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.grey,
                color: primaryColor,
                strokeWidth: 2.0,
              ),
            ),
            fallback: (context) => cubit.orderList.isNotEmpty
                ? ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) =>
                        orderItem(cubit.orderList[index], context),
                    separatorBuilder: (context, index) => Container(),
                    itemCount: cubit.orderList.length)
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

Widget orderItem(OrderModel model, context) => Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17.0),
        ),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 8.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order ID: ${model.code}',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 3.0,
                          ),
                          Text(
                            'Placed on: ${model.date}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(color: Colors.grey),
                          ),
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(bottom: 10.0),
                            child: Container(
                              color: Colors.grey[200],
                              height: 0.5,
                              width: double.infinity,
                            ),
                          ),
                          Text(
                            'Preparing The Order...',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1!
                                .copyWith(
                                    color: Colors.amber,
                                    fontWeight: FontWeight.bold),
                          ),
                        ]),
                  ),
                ),
                Column(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price:',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          fontWeight: FontWeight.bold, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Text(
                      '\$ ${model.total}',
                      style: Theme.of(context)
                          .textTheme
                          .headline6!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
