import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ebuy/shared/cache_helper.dart';
import 'package:ebuy/shared/const.dart';
import 'package:ebuy/shared/void_componants.dart';
import 'package:ebuy/shared/widget_componants.dart';
import 'package:ebuy/view_model/cubit/app_cubit.dart';
import 'package:ebuy/view_model/cubit/app_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'loading_screen.dart';

class RegisterScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
      if (state is SuccessCreateUserAccountState) {
        CacheHelper.saveData(key: 'uid', value: state.uid).then((value) {
          uid = state.uid;

          AppCubit.get(context).getUserData();
          AppCubit.get(context).getOrder();
          AppCubit.get(context).getProducts();
          AppCubit.get(context).getProductFromFavorite();
          AppCubit.get(context).getProductFromCart();
          navigateAndFinish(context: context, widget: const LoadingScreen());
        });
      }

      if (state is ErrorCreateUserAccountState) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            'The Password must contain more than 5 numbers or Email was taken before!  ',
            style: Theme.of(context)
                .textTheme
                .bodyText2!
                .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
          ),
          backgroundColor: Colors.grey,
        ));
      }
    }, builder: (context, state) {
      AppCubit cubit = AppCubit.get(context);
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
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
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Create an account',
                          style: Theme.of(context)
                              .textTheme
                              .headline5!
                              .copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 40.0,
                        ),
                        customTextFormField(
                            controller: nameController,
                            inputType: TextInputType.name,
                            label: 'Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your name';
                              }
                            },
                            prefix: Icons.person_outline),
                        const SizedBox(
                          height: 50.0,
                        ),
                        customTextFormField(
                            controller: emailController,
                            label: 'Email',
                            inputType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your email';
                              }
                            },
                            prefix: Icons.email_outlined),
                        const SizedBox(
                          height: 50.0,
                        ),
                        customTextFormField(
                            controller: passwordController,
                            label: 'Password',
                            secure: cubit.secure,
                            inputType: TextInputType.visiblePassword,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your password';
                              }
                            },
                            suffix: cubit.suffixIcon,
                            suffixPressed: () {
                              cubit.showAndHiddenPass();
                            },
                            prefix: Icons.lock_outline),
                        const SizedBox(
                          height: 50.0,
                        ),
                        customTextFormField(
                            controller: phoneController,
                            label: 'Phone',
                            inputType: TextInputType.phone,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'please enter your phone';
                              }
                            },
                            prefix: Icons.phone_outlined),
                        const SizedBox(
                          height: 80.0,
                        ),
                      ],
                    ),
                    ConditionalBuilder(
                        condition: state is! LoadingCreateUserAccountState,
                        builder: (context) => customButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  cubit.createUserAccount(
                                      name: nameController.text,
                                      email: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text);
                                }
                              },
                              text: 'Sign Up',
                              width: double.infinity,
                            ),
                        fallback: (context) => const Center(
                                child: CircularProgressIndicator(
                              backgroundColor: Colors.white,
                              color: primaryColor,
                              strokeWidth: 2.0,
                            ))),
                  ],
                )),
          ),
        ),
      );
    });
  }
}
