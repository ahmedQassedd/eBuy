class ProductsModel {
  var image;
  var price;
  var name;
  var description;
  var color;

  ProductsModel({
    required this.image,
    required this.price,
    required this.name,
    required this.description,
    required this.color,
  });

  ProductsModel.fromJson(Map<dynamic, dynamic> json) {
    image = json['image'];
    price = json['price'];
    name = json['name'];
    description = json['description'];
    color = json['color'];
  }

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'price': price,
      'name': name,
      'description': description,
      'color': color,
    };
  }
}
