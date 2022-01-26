import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:ebuy/model/order_model.dart';
import 'package:ebuy/shared/cache_helper.dart';
import 'package:ebuy/shared/void_componants.dart';
import 'package:ebuy/shared/widget_componants.dart';
import 'package:ebuy/view/auth_view/login_screen.dart';
import 'package:ebuy/view/auth_view/onboard_page.dart';
import 'package:ebuy/view/profile/edit_profile_screen.dart';
import 'package:ebuy/view/profile/orders_screen.dart';
import 'package:ebuy/view_model/cubit/app_states.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ebuy/model/cart_model.dart';
import 'package:ebuy/model/products_model.dart';
import 'package:ebuy/model/user_model.dart';
import 'package:ebuy/shared/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(InitState());

  static AppCubit get(context) => BlocProvider.of(context);

  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseFirestore fireStore = FirebaseFirestore.instance;

  late int currentIndex = 0;

  String id = 'id';

  bool secure = true;

  int numLOfProduct = 1;

  bool lastPage = false;

  double customOpacity = 0;

  IconData suffixIcon = Icons.visibility_off_outlined;

  var street1Controller = TextEditingController();
  var street2Controller = TextEditingController();
  var cityController = TextEditingController();
  var countryController = TextEditingController();

  List<BoardingModel> pages = [
    BoardingModel(
        image: 'assets/images/logo.png', title: 'Welcome!', subTitle: ''),
    BoardingModel(
        image: 'assets/images/shop2.png',
        title: 'Our Products',
        subTitle:
            'Here you will find all the products you need and more, Such as boots, bags, T-shirts, dresses and others. All you have to do is register, login, and then search for what you want.'),
    BoardingModel(
        image: 'assets/images/shop3.png',
        title: 'The Payment',
        subTitle:
            'For payment, all you have to do is choose your product, fill in your details, place an order, wait for the shipping representative, and pay at the time of receipt.'),
  ];

  void changeOpacity() {
    customOpacity = 1;
    emit(ChangeOpacity());
  }

  void changeLastPage() {
    lastPage = !lastPage;
    emit(ChangeLastPage());
  }

  void skipOnBoard(context) {
    CacheHelper.saveData(key: 'opened', value: true).then((value) {
      navigateAndFinish(context: context, widget: const LoginScreen());
    });
  }

  void showAndHiddenPass() {
    secure = !secure;
    suffixIcon =
        secure ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(SuccessShowPassState());
  }

  void currentIndexMethod({required int index}) {
    currentIndex = index;
    emit(CurrentIndexState());
  }

  int currentStep = 0;
  Object value = 1;
  var formKey = GlobalKey<FormState>();
  var totalFormKey = GlobalKey<FormState>();

  addStep() {
    currentStep++;
    emit(AddStep());
  }

  minusStep() {
    currentStep--;
    emit(MinusStep());
  }

  changeRadio(val) {
    value = val;
    emit(ChangeRadio());
  }

  void plusProduct() {
    if (numLOfProduct <= 19) {
      numLOfProduct++;
    }
    emit(AddProduct());
  }

  void minusProduct() {
    if (numLOfProduct > 1) {
      numLOfProduct--;
    }
    emit(MinusProduct());
  }

  List<String> catalogList = [
    'Hand bag',
    'Tshirt',
    'Dresses',
    'Jewellery',
    'Short',
    'Shoes',
  ];

  void googleSignInMethod() async {
    emit(LoadingCreateGoogleUserAccountState());

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser!.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );

    await auth.signInWithCredential(credential).then((value) {
      emit(SuccessCreateGoogleUserAccountState(value.user!.uid));

      if (user!.uid != value.user!.uid) {
        saveUserData(
            name: (value.user!.displayName)!,
            email: (value.user!.email)!,
            uid: value.user!.uid);
      }
    }).catchError((onError) {
      emit(ErrorCreateGoogleUserAccountState());
    });
  }

  void loginWithEmailAndPassword(
      {required String email, required String password}) async {
    emit(LoadingSignInState());

    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      emit(SuccessSignInState(value.user!.uid));
    }).catchError((onError) {
      emit(ErrorSignInState());
    });
  }

  void createUserAccount(
      {required String email,
      required String password,
      required String name,
      required String phone}) async {
    emit(LoadingCreateUserAccountState());

    await auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      saveUserData(
          name: name, email: email, phone: phone, uid: value.user!.uid);

      emit(SuccessCreateUserAccountState(value.user!.uid));
    }).catchError((onError) {
      emit(ErrorCreateUserAccountState());
    });
  }

  void saveUserData({
    required String name,
    required String email,
    String? phone = '',
    String? address = '',
    required String uid,
    String? pic =
        'https://dentistry.tiu.edu.iq/wp-content/uploads/2018/12/profile-unknown-male.png',
  }) {
    UserModel userModel = UserModel(
        address: address,
        name: name,
        email: email,
        phone: phone,
        uid: uid,
        pic: pic);

    fireStore.collection('users').doc(uid).set(userModel.toMap());
  }

  File? profileImage;

  var picker = ImagePicker();

  Future<void> pickProfileImage() async {
    emit(LoadingPickedImageState());

    final pickedProfileFile =
        await picker.getImage(source: ImageSource.gallery);

    if (pickedProfileFile != null) {
      profileImage = File(pickedProfileFile.path);

      emit(SuccessPickedImageState());
    } else {
      emit(ErrorPickedImageState());
    }
  }

  void updateUserData({
    required var name,
    required var phone,
    required var address,
    required var pic,
  }) {
    emit(LoadingUpdateUserDataState());

    UserModel userModel = UserModel(
      address: address ?? user!.address,
      name: name ?? user!.name,
      email: user!.email,
      phone: phone ?? user!.phone,
      uid: user!.uid,
      pic: pic ?? user!.pic,
    );

    fireStore.collection('users').doc(uid).update(userModel.toMap());

    emit(SuccessUpdateUserDataState());

    getUserData();
  }

  void updateUserDataWithProfileImage({
    required var name,
    required var phone,
    required var address,
  }) {
    emit(LoadingUpdateUserDataWithProfileState());

    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('profileImage/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUserData(name: name, phone: phone, address: address, pic: value);

        emit(SuccessUpdateUserDataWithProfileState());
      }).catchError((onError) {
        emit(ErrorUpdateProfileState());
      });
    }).catchError((onError) {
      emit(ErrorUploadProfileState());
    });
  }

  UserModel? user;

  void getUserData() {
    emit(LoadingGetUserDataState());
    fireStore.collection('users').doc(uid).get().then((value) {
      user = UserModel.fromJson(value.data()!);

      emit(SuccessGetUserDataState());
    }).catchError((onError) {
      emit(ErrorGetUserDataState());
    });
  }

  List<ProductsModel> productsModelList = [];
  List<ProductsModel> tshirtModelList = [];

  List<String> tshirtId = [];
  List<String> bagId = [];
  late String productsDocId;

  void getProducts() {
    productsModelList = [];
    tshirtModelList = [];

    emit(LoadingGetProductsDataState());
    fireStore.collection('products').get().then((value) {
      value.docs.forEach((element) {
        productsDocId = element.id;

        element.reference.collection('tshirt').get().then((value) {
          value.docs.forEach((element) {
            tshirtModelList.add(ProductsModel.fromJson(element.data()));
            tshirtId.add(element.id);

            emit(SuccessGetTshirtDataState());
          });
        }).catchError((onError) {
          emit(ErrorGetTshirtDataState());
        });

        element.reference.collection('bags').get().then((value) {
          value.docs.forEach((element) {
            productsModelList.add(ProductsModel.fromJson(element.data()));
            bagId.add(element.id);

            emit(SuccessGetBagsDataState());
          });
        }).catchError((onError) {
          print(onError.toString());
          emit(ErrorGetBagsDataState());
        });
      });
    }).catchError((onError) {
      print(onError.toString());
      emit(ErrorGetProductsDataState());
    });
  }

  void putProductInCart({
    required image,
    required price,
    required name,
    required quantity,
    required productId,
    required description,
  }) {
    emit(LoadingPutProductInCartState());

    CartModel cartModel = CartModel(
      favorite: true,
      cart: true,
      description: description,
      image: image,
      price: price,
      name: name,
      quantity: quantity,
      uid: productId,
    );

    fireStore
        .collection('users')
        .doc(uid)
        .collection('myCart')
        .doc(productId)
        .set(cartModel.toMap())
        .then((value) {
      emit(SuccessPutProductInCartState());
    }).catchError((onError) {
      emit(ErrorPutProductInCartState());
    });
  }

  void plusQuantityInCart({required index}) {
    if (cartProducts[index].quantity <= 19) {
      cartProducts[index].quantity++;
    }
    emit(AddQuantity());
  }

  void minusQuantityInCart({required index}) {
    if (cartProducts[index].quantity > 1) {
      cartProducts[index].quantity--;
    }
    emit(MinusQuantity());
  }

  void updateQuantityInCart({
    required index,
  }) {
    emit(LoadingUpdateQuantityInCartState());

    CartModel cartModel = CartModel(
      favorite: true,
      cart: true,
      description: cartProducts[index].description,
      uid: cartProducts[index].uid,
      image: cartProducts[index].image,
      price: cartProducts[index].price,
      name: cartProducts[index].name,
      quantity: cartProducts[index].quantity,
    );

    fireStore
        .collection('users')
        .doc(uid)
        .collection('myCart')
        .doc(cartProducts[index].uid)
        .update(cartModel.toMap())
        .then((value) {
      emit(SuccessUpdateQuantityInCartState());
    }).catchError((onError) {
      emit(ErrorUpdateQuantityInCartState());
    });
  }

  List<CartModel> cartProducts = [];

  num totalPrice = 0;

  void getProductFromCart() {
    emit(LoadingGetProductInCartState());

    fireStore
        .collection('users')
        .doc(uid)
        .collection('myCart')
        .snapshots()
        .listen((event) {
      cartProducts = [];
      event.docs.forEach((element) {
        cartProducts.add(CartModel.fromJson(element.data()));
      });
      emit(SuccessGetProductInCartState());
      totalPrice = 0;

      for (int i = 0; i < cartProducts.length; i++) {
        totalPrice += (cartProducts[i].price) * (cartProducts[i].quantity);
        emit(UpDateTotalPrice());
      }
    });
  }

  void putProductInFavorite({
    required image,
    required price,
    required name,
    required description,
    required quantity,
    required productId,
  }) {
    emit(LoadingPutProductInFavoriteState());

    CartModel favoriteModel = CartModel(
      favorite: true,
      cart: true,
      quantity: quantity,
      image: image,
      price: price,
      name: name,
      description: description,
      uid: productId,
    );

    fireStore
        .collection('users')
        .doc(uid)
        .collection('myFavorite')
        .doc(productId)
        .set(favoriteModel.toMap())
        .then((value) {
      emit(SuccessPutProductInFavoriteState());
    }).catchError((onError) {
      emit(ErrorPutProductInFavoriteState());
    });
  }

  List<CartModel> favoritesList = [];

  void getProductFromFavorite() {
    emit(LoadingGetProductFromFavoriteState());

    fireStore
        .collection('users')
        .doc(uid)
        .collection('myFavorite')
        .snapshots()
        .listen((event) {
      favoritesList = [];
      event.docs.forEach((element) {
        favoritesList.add(CartModel.fromJson(element.data()));
      });
      emit(SuccessGetProductFromFavoriteState());
    });
  }

  void deleteFromFavorite({required String id}) {
    emit(LoadingDeleteFromFavoriteState());

    fireStore
        .collection('users')
        .doc(uid)
        .collection('myFavorite')
        .doc(id)
        .delete()
        .then((value) {
      emit(SuccessDeleteFromFavoriteState());
    }).catchError((onError) {
      emit(ErrorDeleteFromFavoriteState());
    });
  }

  void deleteFromCart({required String id}) {
    emit(LoadingDeleteFromCartState());

    fireStore
        .collection('users')
        .doc(uid)
        .collection('myCart')
        .doc(id)
        .delete()
        .then((value) {
      emit(SuccessDeleteFromCartState());
    }).catchError((onError) {
      emit(ErrorDeleteFromCartState());
    });
  }

  CartModel? singleFavorite;

  void getSingleFavorite(productId) {
    emit(LoadingGetSingleFavoriteState());

    fireStore
        .collection('users')
        .doc(uid)
        .collection('myFavorite')
        .doc(productId)
        .snapshots()
        .listen((event) {
      singleFavorite = CartModel.fromJson(event.data());

      emit(SuccessGetSingleFavoriteState());
    });
  }

  CartModel? singleCart;

  void getSingleCart(productId) {
    emit(LoadingGetSingleCartState());

    fireStore
        .collection('users')
        .doc(uid)
        .collection('myCart')
        .doc(productId)
        .snapshots()
        .listen((event) {
      singleCart = CartModel.fromJson(event.data());

      emit(SuccessGetSingleCartState());
    });
  }

  void makeOrder({
    required code,
    required date,
    required total,
    required delivered,
  }) {
    emit(LoadingMakeOrderState());

    OrderModel orderModel =
        OrderModel(code: code, date: date, total: total, delivered: delivered);

    fireStore
        .collection('users')
        .doc(uid)
        .collection('order')
        .doc()
        .set(orderModel.toMap())
        .then((value) {
      emit(SuccessMakeOrderState());
    }).catchError((onError) {
      emit(ErrorMakeOrderState());
    });
  }

  List<OrderModel> orderList = [];

  void getOrder() {
    emit(LoadingGetOrderState());

    fireStore
        .collection('users')
        .doc(uid)
        .collection('order')
        .snapshots()
        .listen((event) {
      orderList = [];
      event.docs.forEach((element) {
        orderList.add(OrderModel.fromJson(element.data()));
      });
      emit(SuccessGetOrderState());
    });
  }

  List<Step> getSteps(context, index) => [
        Step(
            state: StepState.editing,
            isActive: currentStep >= 0,
            title: const Text('Delivery Options'),
            content: Column(
              children: [
                RadioListTile(
                  value: 1,
                  groupValue: value,
                  onChanged: (val) {
                    changeRadio(val);
                  },
                  activeColor: Colors.green,
                  title: Text(
                    'Standard',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      'Order will be delivered between ( 3-5 ) bussiness days. ',
                      style: Theme.of(context).textTheme.caption),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                RadioListTile(
                  value: 2,
                  groupValue: value,
                  onChanged: (val) {
                    changeRadio(val);
                  },
                  activeColor: Colors.green,
                  title: Text(
                    'Next Day',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      'Place your order before ( 6PM ) and your items will be delivered the next day.',
                      style: Theme.of(context).textTheme.caption),
                ),
              ],
            )),
        Step(
          state: StepState.editing,
          isActive: currentStep >= 1,
          title: const Text('Address'),
          content: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: street1Controller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your address.';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Street 1',
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: street2Controller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your address.';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Street 2',
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: cityController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter your city.';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'City',
                                hintStyle: TextStyle(color: Colors.grey[300]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: countryController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter your country.';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Country',
                                hintStyle: TextStyle(color: Colors.grey[300]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
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
          ),
        ),
        Step(
          state: StepState.complete,
          isActive: currentStep >= 2,
          title: const Text('Summary'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 5.0,
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Image.network(
                                      '${currentIndex == 0 ? productsModelList[index].image : tshirtModelList[index].image}',
                                      fit: BoxFit.fill,
                                      height: 60,
                                      width: 50,
                                    ),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${currentIndex == 0 ? productsModelList[index].name : tshirtModelList[index].name}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
                                        ),
                                        Text(
                                          '$numLOfProduct x',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption!
                                              .copyWith(
                                                  //color: Colors.grey,
                                                  fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                const Spacer(),
                                Text(
                                  '\$ ${currentIndex == 0 ? '${productsModelList[index].price * numLOfProduct}' : '${tshirtModelList[index].price * numLOfProduct}'}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1!
                                      .copyWith(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                ),
                              ],
                            )),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        'Address : ',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadiusDirectional.circular(15)),
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            '${street1Controller.text} - ${street2Controller.text} - ${cityController.text} - ${countryController.text}.',
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
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        'Phone : ',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadiusDirectional.circular(15)),
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            '${user!.phone}',
                            style: Theme.of(context)
                                .textTheme
                                .subtitle2!
                                .copyWith(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                          )),
                    )),
                    SizedBox(
                      width: 50,
                      child: TextButton(
                        onPressed: () {
                          navigateTo(
                              context: context, widget: EditProfileScreen());
                        },
                        child: const Text('Edit'),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        'Delivery : ',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadiusDirectional.circular(15)),
                      child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            value == 1
                                ? '(3 - 5 Days)    Free'
                                : '(Next day)    \$10',
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
                padding: const EdgeInsetsDirectional.only(top: 8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        'Total : ',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadiusDirectional.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: value == 2
                            ? Text(
                                '\$ ${currentIndex == 0 ? (productsModelList[index].price * numLOfProduct) + 10 : (tshirtModelList[index].price * numLOfProduct) + 10}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                              )
                            : Text(
                                '\$ ${currentIndex == 0 ? productsModelList[index].price * numLOfProduct : tshirtModelList[index].price * numLOfProduct}',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black),
                              ),
                      ),
                    )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(20)),
                      child: MaterialButton(
                        onPressed: () {
                          makeOrder(
                              code: Random().nextInt(90000000).toString(),
                              date: DateFormat('dd-MMM-yyyy')
                                  .format(DateTime.now()),
                              total: value == 2
                                  ? currentIndex == 0
                                      ? (productsModelList[index].price *
                                              numLOfProduct) +
                                          10
                                      : (tshirtModelList[index].price *
                                              numLOfProduct) +
                                          10
                                  : currentIndex == 0
                                      ? productsModelList[index].price *
                                          numLOfProduct
                                      : tshirtModelList[index].price *
                                          numLOfProduct,
                              delivered: false);

                          navigateAndFinish(
                              context: context, widget: const OrderScreen());
                        },
                        child: Text(
                          'Confirm order',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ];

  List<Step> getStepsForCart(context) => [
        Step(
            state: StepState.editing,
            isActive: currentStep >= 0,
            title: const Text('Delivery Options'),
            content: Column(
              children: [
                RadioListTile(
                  value: 1,
                  groupValue: value,
                  onChanged: (val) {
                    changeRadio(val);
                  },
                  activeColor: Colors.green,
                  title: Text(
                    'Standard',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      'Order will be delivered between ( 3-5 ) bussiness days. ',
                      style: Theme.of(context).textTheme.caption),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                RadioListTile(
                  value: 2,
                  groupValue: value,
                  onChanged: (val) {
                    changeRadio(val);
                  },
                  activeColor: Colors.green,
                  title: Text(
                    'Next Day',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle1!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      'Place your order before ( 6PM ) and your items will be delivered the next day.',
                      style: Theme.of(context).textTheme.caption),
                ),
              ],
            )),
        Step(
          state: StepState.editing,
          isActive: currentStep >= 1,
          title: const Text('Address'),
          content: Form(
            key: totalFormKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: street1Controller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your address.';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Street 1',
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: street2Controller,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter your address.';
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Street 2',
                          hintStyle: TextStyle(color: Colors.grey[300]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: cityController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter your city.';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'City',
                                hintStyle: TextStyle(color: Colors.grey[300]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: countryController,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'please enter your country.';
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Country',
                                hintStyle: TextStyle(color: Colors.grey[300]),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
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
          ),
        ),
        Step(
          state: StepState.complete,
          isActive: currentStep >= 2,
          title: const Text('Summary'),
          content: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 200.0,
                      width: double.infinity,
                      child: ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) => Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 3.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Card(
                                        elevation: 5.0,
                                        child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Row(
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Image.network(
                                                      '${cartProducts[index].image}',
                                                      fit: BoxFit.fill,
                                                      height: 60,
                                                      width: 50,
                                                    ),
                                                    const SizedBox(
                                                      width: 10.0,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          '${cartProducts[index].name}',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .caption!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .black),
                                                        ),
                                                        Text(
                                                          '${cartProducts[index].quantity} x',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .caption!
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                const Spacer(),
                                                Text(
                                                  '\$ ${cartProducts[index].price * cartProducts[index].quantity}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .subtitle1!
                                                      .copyWith(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          separatorBuilder: (context, index) =>
                              const SizedBox(),
                          itemCount: cartProducts.length),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 7.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text(
                            'Address : ',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius:
                                  BorderRadiusDirectional.circular(15)),
                          child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '${street1Controller.text} - ${street2Controller.text} - ${cityController.text} - ${countryController.text}.',
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
                  Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text(
                          'Phone : ',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadiusDirectional.circular(15)),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              '${user!.phone}',
                              style: Theme.of(context)
                                  .textTheme
                                  .subtitle2!
                                  .copyWith(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                            )),
                      )),
                      SizedBox(
                        width: 50,
                        child: TextButton(
                          onPressed: () {
                            navigateTo(
                                context: context, widget: EditProfileScreen());
                          },
                          child: const Text('Edit'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 50,
                        child: Text(
                          'Delivery : ',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadiusDirectional.circular(15)),
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              value == 1
                                  ? '(3 - 5 Days)    Free'
                                  : '(Next day)    \$10',
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
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 5.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text(
                            'Total : ',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius:
                                  BorderRadiusDirectional.circular(15)),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: value == 2
                                ? Text(
                                    '\$ ${(totalPrice + 10).toString()}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                  )
                                : Text(
                                    '\$ ${totalPrice.toString()}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6!
                                        .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                  ),
                          ),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(20)),
                          child: MaterialButton(
                            onPressed: () {
                              makeOrder(
                                  code: Random().nextInt(90000000).toString(),
                                  date: DateFormat('dd-MMM-yyyy')
                                      .format(DateTime.now()),
                                  total: value == 2
                                      ? (totalPrice + 10).toString()
                                      : totalPrice.toString(),
                                  delivered: false);

                              navigateAndFinish(
                                  context: context,
                                  widget: const OrderScreen());
                            },
                            child: Text(
                              'Confirm order',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ];
}
