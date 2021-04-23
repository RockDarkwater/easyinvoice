class Item {
  final bool isItem = true;
  final String itemCode;
  final String name;
  final double price;
  final double cost;
  final bool taxable = true;

  Item({this.itemCode, this.name, this.price, this.cost});

  String toJSONString(String path) {
    Map map = {
      '$path.isItem': isItem,
      '$path.itemCode': itemCode,
      '$path.name': name,
      '$path.taxable': taxable,
    };
    return map.toString();
  }
}
