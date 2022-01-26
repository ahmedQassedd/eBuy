class CartModel {
  var image;
  var price;
  var name;
  var quantity;
  var description;
  var uid;
  var cart;
  var favorite;

  CartModel({
    required this.image,
    required this.price,
    required this.name,
    required this.quantity,
    required this.uid,
    required this.description,
    required this.cart,
    required this.favorite,
  });

  CartModel.fromJson(Map<String, dynamic>? json) {
    image = json?['image'];
    price = json?['price'];
    name = json?['name'];
    quantity = json?['quantity'];
    uid = json?['uid'];
    description = json?['description'];
    cart = json?['cart'];
    favorite = json?['favorite'];
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'price': price,
      'name': name,
      'quantity': quantity,
      'uid': uid,
      'description': description,
      'cart': cart,
      'favorite': favorite,
    };
  }
}
