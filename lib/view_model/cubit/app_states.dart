abstract class AppStates {}

class InitState extends AppStates {}

class LoadingSignInState extends AppStates {}

class SuccessSignInState extends AppStates {
  final String uid;
  SuccessSignInState(this.uid);
}

class ErrorSignInState extends AppStates {}

class SuccessShowPassState extends AppStates {}

class LoadingCreateUserAccountState extends AppStates {}

class SuccessCreateUserAccountState extends AppStates {
  final String uid;
  SuccessCreateUserAccountState(this.uid);
}

class ErrorCreateUserAccountState extends AppStates {}

class LoadingCreateGoogleUserAccountState extends AppStates {}

class SuccessCreateGoogleUserAccountState extends AppStates {
  final String uid;
  SuccessCreateGoogleUserAccountState(this.uid);
}

class ErrorCreateGoogleUserAccountState extends AppStates {}

class CurrentIndexState extends AppStates {}

class LoadingGetProductsDataState extends AppStates {}

class SuccessGetProductsDataState extends AppStates {}

class ErrorGetProductsDataState extends AppStates {}

class SuccessGetBagsDataState extends AppStates {}

class ErrorGetBagsDataState extends AppStates {}

class ErrorGetTshirtDataState extends AppStates {}

class SuccessGetTshirtDataState extends AppStates {}

class AddProduct extends AppStates {}

class MinusProduct extends AppStates {}

class LoadingGetUserDataState extends AppStates {}

class SuccessGetUserDataState extends AppStates {}

class ErrorGetUserDataState extends AppStates {}

class LoadingPutProductInCartState extends AppStates {}

class SuccessPutProductInCartState extends AppStates {}

class ErrorPutProductInCartState extends AppStates {}

class LoadingGetProductInCartState extends AppStates {}

class SuccessGetProductInCartState extends AppStates {}

class ErrorGetProductInCartState extends AppStates {}

class LoadingUpdateQuantityInCartState extends AppStates {}

class SuccessUpdateQuantityInCartState extends AppStates {}

class ErrorUpdateQuantityInCartState extends AppStates {}

class MinusQuantity extends AppStates {}

class AddQuantity extends AppStates {}

class UpDateTotalPrice extends AppStates {}

class LoadingPutProductInFavoriteState extends AppStates {}

class SuccessPutProductInFavoriteState extends AppStates {}

class ErrorPutProductInFavoriteState extends AppStates {}

class LoadingGetProductFromFavoriteState extends AppStates {}

class SuccessGetProductFromFavoriteState extends AppStates {}

class LoadingDeleteFromFavoriteState extends AppStates {}

class SuccessDeleteFromFavoriteState extends AppStates {}

class ErrorDeleteFromFavoriteState extends AppStates {}

class LoadingDeleteFromCartState extends AppStates {}

class SuccessDeleteFromCartState extends AppStates {}

class ErrorDeleteFromCartState extends AppStates {}

class ChangeFavoriteState extends AppStates {}

class LoadingGetSingleFavoriteState extends AppStates {}

class SuccessGetSingleFavoriteState extends AppStates {}

class LoadingGetSingleCartState extends AppStates {}

class SuccessGetSingleCartState extends AppStates {}

class LoadingUpdateUserDataState extends AppStates {}

class SuccessUpdateUserDataState extends AppStates {}

class LoadingPickedImageState extends AppStates {}

class SuccessPickedImageState extends AppStates {}

class ErrorPickedImageState extends AppStates {}

class LoadingUpdateUserDataWithProfileState extends AppStates {}

class SuccessUpdateUserDataWithProfileState extends AppStates {}

class ErrorUploadProfileState extends AppStates {}

class ErrorUpdateProfileState extends AppStates {}

class AddStep extends AppStates {}

class MinusStep extends AppStates {}

class ChangeRadio extends AppStates {}

class ChangeLastPage extends AppStates {}

class ChangeOpacity extends AppStates {}

class LoadingMakeOrderState extends AppStates {}

class SuccessMakeOrderState extends AppStates {}

class ErrorMakeOrderState extends AppStates {}

class LoadingGetOrderState extends AppStates {}

class SuccessGetOrderState extends AppStates {}
