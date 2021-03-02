class Item {
  final String itemCode;
  final String name;
  final double price;
  final double cost;
  bool taxable = true;

  Item(this.itemCode, this.name, this.price, this.cost) {
    print('building item: $itemCode');
  }
}
