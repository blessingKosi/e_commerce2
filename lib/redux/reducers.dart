import 'package:e_commerce/models/app_state.dart';
import 'package:e_commerce/models/product.dart';
import 'package:e_commerce/models/user.dart';
import 'package:e_commerce/redux/actions.dart';

AppState appReducer(AppState state, dynamic action) {
  return AppState(
      user: userReducer(state.user, action),
      products: productsReducer(state.products, action));
}


// responsible for updating our user state
User userReducer(User user, dynamic action) {
  // conditional to check if zn action is an instance of a class
  if (action is GetUserAction) {
    // return the user we were given from the action 
    return action.user;
  } else if (action is LogoutUserAction) {
    return action.user;
  }
  return user;
}

List<Product> productsReducer(List<Product> products, dynamic action) {
  if (action is GetProductsAction) {
    return action.products;
  }
  return products;
}
