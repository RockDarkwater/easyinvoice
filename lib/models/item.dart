class Item {
  final bool isItem = true;
  final String itemCode;
  final String name;
  final double price;
  final double cost;
  bool taxable = true;

  Item({this.itemCode, this.name, this.price, this.cost});

  Item.fromJson(Map<String, dynamic> json)
      : itemCode = json['itemCode'],
        name = json['name'],
        price = json['price'],
        cost = json['cost'],
        taxable = json['taxable'];

  Map<String, dynamic> toJson() => {
        'isItem': true,
        'price': price,
        'cost': cost,
        'itemCode': itemCode,
        'name': name.replaceAll("\"", "").replaceAll(",", ""),
        'taxable': taxable,
      };
}
