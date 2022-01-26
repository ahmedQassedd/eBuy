import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ebuy/shared/const.dart';
import 'package:ebuy/shared/void_componants.dart';
import 'package:ebuy/view/product/home_screen.dart';
import 'package:ebuy/view_model/cubit/app_cubit.dart';
import 'package:ebuy/view_model/cubit/app_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {},
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: primaryColor,
            title: Text(
              'Profile',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              padding: const EdgeInsetsDirectional.only(start: 15.0),
              onPressed: () {
                navigateTo(context: context, widget: HomeScreen());
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),
          ),
          body: ConditionalBuilder(
            condition: state is LoadingGetUserDataState,
            builder: (context) => const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                color: primaryColor,
                strokeWidth: 2.0,
              ),
            ),
            fallback: (context) => Column(
              children: [
                Expanded(
                  child: Center(
                    child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xff2E4C6D),
                            radius: 60,
                            backgroundImage: NetworkImage('${cubit.user?.pic}'),
                          ),
                        ]),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(40.0),
                        topEnd: Radius.circular(40.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(bottom: 20),
                              child: InkWell(
                                onTap: () {
                                  navigateTo(
                                      context: context,
                                      widget: EditProfileScreen());
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.edit,
                                      color: primaryColor,
                                      size: 20,
                                    ),
                                    Text(
                                      'Edit',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption!
                                          .copyWith(color: primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      'Name : ',
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                15)),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          '${cubit.user?.name}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                        )),
                                  )),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      'Email : ',
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius:
                                          BorderRadiusDirectional.circular(15),
                                    ),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          '${cubit.user?.email}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                        )),
                                  )),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      'Phone : ',
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                15)),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          '${cubit.user?.phone}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                        )),
                                  )),
                                ],
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 50,
                                    child: Text(
                                      'Address : ',
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ),
                                  Expanded(
                                      child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius:
                                            BorderRadiusDirectional.circular(
                                                15)),
                                    child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Text(
                                          '${cubit.user?.address}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .subtitle2!
                                              .copyWith(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.bold),
                                        )),
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
