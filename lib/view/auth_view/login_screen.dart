import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:ebuy/shared/cache_helper.dart';
import 'package:ebuy/shared/const.dart';
import 'package:ebuy/shared/void_componants.dart';
import 'package:ebuy/shared/widget_componants.dart';
import 'package:ebuy/view/auth_view/loading_screen.dart';
import 'package:ebuy/view/auth_view/register_screen.dart';
import 'package:ebuy/view_model/cubit/app_cubit.dart';
import 'package:ebuy/view_model/cubit/app_states.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

var emailController = TextEditingController();
var passwordController = TextEditingController();

var loginFormKey = GlobalKey<FormState>();

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true, min: 0.3);

    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context, state) {
        if (state is SuccessSignInState) {
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

        if (state is ErrorSignInState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              'Incorrect Email or Password!',
              style: Theme.of(context)
                  .textTheme
                  .bodyText2!
                  .copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            backgroundColor: Colors.grey,
          ));
        }

        if (state is SuccessCreateGoogleUserAccountState) {
          CacheHelper.saveData(key: 'uid', value: state.uid).then((value) {
            uid = state.uid;
            AppCubit.get(context).getUserData();
            navigateAndFinish(context: context, widget: const LoadingScreen());
          });
        }
      },
      builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                        top: 30, start: 20, end: 20, bottom: 20),
                    child: FadeTransition(
                      opacity: _animation,
                      child: const Image(
                        image: AssetImage('assets/images/logo.png'),
                        height: 200,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 50.0, left: 30.0, right: 30.0, bottom: 30.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Form(
                            key: loginFormKey,
                            child: Column(
                              children: [
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
                                  height: 15.0,
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
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        ConditionalBuilder(
                          condition: state is! LoadingSignInState,
                          builder: (context) => customButton(
                              height: 50,
                              text: 'Sign In',
                              onPressed: () {
                                if (loginFormKey.currentState!.validate()) {
                                  cubit.loginWithEmailAndPassword(
                                      email: emailController.text,
                                      password: passwordController.text);
                                }
                              }),
                          fallback: (context) => const Center(
                              child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            color: primaryColor,
                            strokeWidth: 2.0,
                          )),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        TextButton(
                          onPressed: () {
                            navigateTo(
                                context: context, widget: RegisterScreen());
                          },
                          child: Text(
                            'Create an account',
                            style:
                                Theme.of(context).textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: primaryColor,
                                    ),
                          ),
                        ),
                        const SizedBox(
                          height: 10.0,
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 100.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.grey[200],
                                  height: 1.0,
                                  width: double.infinity,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 3.0),
                                child: Text(
                                  'OR',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(
                                        color: Colors.grey,
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.grey[200],
                                  height: 1.0,
                                  width: double.infinity,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        InkWell(
                            onTap: () {
                              cubit.googleSignInMethod();
                            },
                            child: const Image(
                              image: AssetImage('assets/images/google.png'),
                              height: 35,
                              width: 35,
                            )),
                      ],
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
}
