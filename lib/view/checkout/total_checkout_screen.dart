import 'package:ebuy/shared/const.dart';
import 'package:ebuy/view_model/cubit/app_cubit.dart';
import 'package:ebuy/view_model/cubit/app_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TotalCheckOutScreen extends StatelessWidget {
  const TotalCheckOutScreen({Key? key}) : super(key: key);

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
              'Checkout',
              style: Theme.of(context)
                  .textTheme
                  .headline6!
                  .copyWith(color: Colors.black54, fontWeight: FontWeight.bold),
            ),
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
          body: Stepper(
              physics: const BouncingScrollPhysics(),
              type: StepperType.vertical,
              steps: cubit.getStepsForCart(context),
              currentStep: cubit.currentStep,
              onStepContinue: () =>
                  cubit.currentStep == 2 ? null : cubit.addStep(),
              onStepCancel: () =>
                  cubit.currentStep == 0 ? null : cubit.minusStep(),
              controlsBuilder: (context, {onStepCancel, onStepContinue}) {
                return Row(
                  children: [
                    cubit.currentStep == 1
                        ? TextButton(
                            onPressed: () {
                              if (cubit.totalFormKey.currentState!.validate()) {
                                cubit.addStep();
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(7),
                                child: Text(
                                  'Next',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          )
                        : cubit.currentStep == 0
                            ? TextButton(
                                onPressed: onStepContinue,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(7),
                                    child: Text(
                                      'Next',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                    cubit.currentStep == 0
                        ? Container()
                        : TextButton(
                            onPressed: onStepCancel,
                            child: const Text(
                              'Back',
                              style: TextStyle(color: Colors.black54),
                            ),
                          ),
                  ],
                );
              }),
        );
      },
    );
  }
}
