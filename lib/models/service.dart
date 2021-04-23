class Service {
  final bool isItem = false;
  final String serviceCode;
  final String name;
  final String qbName;
  final String category;
  final double workUnits;
  double price;
  bool taxable = false;

  Service(
      {this.serviceCode,
      this.name,
      this.qbName,
      this.category,
      this.workUnits,
      this.price,
      this.taxable});

  String toJSONString(String path) {
    Map map = {
      '$path.isItem': isItem,
      '$path.serviceCode': serviceCode,
      '$path.name': name,
      '$path.qbName': qbName,
      '$path.category': category,
      '$path.workUnits': workUnits,
      '$path.taxable': taxable,
    };
    return map.toString();
  }
}
