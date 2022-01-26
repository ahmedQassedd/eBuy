class OrderModel {
  var code;
  var date;
  var total;
  var delivered;

  OrderModel({
    required this.code,
    required this.date,
    required this.total,
    required this.delivered,
  });

  OrderModel.fromJson(Map<String, dynamic>? json) {
    code = json?['code'];
    date = json?['date'];
    total = json?['total'];
    delivered = json?['delivered'];
  }

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'date': date,
      'total': total,
      'delivered': delivered,
    };
  }
}
