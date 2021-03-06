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

  Service.fromJson(Map<String, dynamic> json)
      : serviceCode = json['serviceCode'],
        name = json['name'],
        qbName = json['qbName'],
        category = json['category'],
        workUnits = json['workUnits'],
        price = json['price'],
        taxable = json['taxable'];

  Map<String, dynamic> toJson() => {
        'isItem': isItem,
        'serviceCode': serviceCode,
        'name': name,
        'qbName': qbName,
        'category': category,
        'workUnits': workUnits,
        'price': price,
        'taxable': taxable,
      };
}
