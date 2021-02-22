class Item {
  final String name;
  final String itemCode;
  final String category;
  final String qbName;
  final double price;
  final bool taxable;

  double cost;
  double workUnits;

  Item(this.name, this.itemCode, this.category, this.qbName, this.price,
      this.taxable,
      {this.cost, this.workUnits});

  // Item.fromFirebase(this.itemCode) {
  //   //look on firebase for the item code, pull item details
  // }
}
