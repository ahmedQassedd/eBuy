import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ebuy/shared/const.dart';
import 'package:ebuy/shared/void_componants.dart';
import 'package:ebuy/shared/widget_componants.dart';
import 'package:ebuy/view_model/cubit/app_cubit.dart';
import 'package:ebuy/view_model/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'profile_screen.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is SuccessUpdateUserDataWithProfileState ||
            state is SuccessUpdateUserDataState) {
          navigateTo(context: context, widget: const ProfileScreen());
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);

        nameController.text = cubit.user!.name;
        phoneController.text = (cubit.user!.phone)!;
        addressController.text = (cubit.user!.address)!;

        return Scaffold(
          backgroundColor: primaryColor,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: primaryColor,
            title: Text(
              'Edit profile',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              padding: const EdgeInsetsDirectional.only(start: 15.0),
              onPressed: () {
                Navigator.pop(context);
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
                            backgroundImage: cubit.profileImage == null
                                ? NetworkImage('${cubit.user?.pic}')
                                : FileImage(cubit.profileImage!)
                                    as ImageProvider,
                          ),
                          Padding(
                            padding:
                                const EdgeInsetsDirectional.only(bottom: 5.0),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(0.5),
                              radius: 14.0,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  cubit.pickProfileImage();
                                },
                                icon: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: Colors.white,
                                ),
                                //iconSize: 16.0,
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
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
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: customTextFormField(
                                  hint: 'Name',
                                  controller: nameController,
                                  inputType: TextInputType.name,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please enter your name';
                                    }
                                  },
                                  prefix: Icons.person),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: customTextFormField(
                                  hint: 'Number',
                                  controller: phoneController,
                                  inputType: TextInputType.phone,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please enter your phone';
                                    }
                                  },
                                  prefix: Icons.phone),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 20.0),
                              child: customTextFormField(
                                  hint: 'Address',
                                  controller: addressController,
                                  inputType: TextInputType.text,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'please enter your address';
                                    }
                                  },
                                  prefix: Icons.house),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 10.0),
                              child: ConditionalBuilder(
                                condition: state
                                        is LoadingUpdateUserDataWithProfileState ||
                                    state is LoadingUpdateUserDataState,
                                builder: (context) => const Center(
                                    child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  color: primaryColor,
                                  strokeWidth: 2.0,
                                )),
                                fallback: (context) => Container(
                                  decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (cubit.profileImage == null) {
                                        cubit.updateUserData(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          address: addressController.text,
                                          pic: cubit.user!.pic,
                                        );
                                      } else {
                                        cubit.updateUserDataWithProfileImage(
                                          name: nameController.text,
                                          phone: phoneController.text,
                                          address: addressController.text,
                                        );
                                      }
                                    },
                                    child: Text(
                                      'Save',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText2!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            )
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
