class Customer {
  final String custNum;
  final SubmitOption primarySubmit;
  final String billingName;
  final Map<String, dynamic> priceMap;

  String add1;
  String add2;
  String add3;
  SubmitOption secondarySubmit;
  String city;
  String state;
  String zip;
  String custClass;
  String distList;
  String fieldArea;
  String poNum;
  String requisitioner;
  double taxRate;
  bool ccFee;

  Customer(
      {this.custNum,
      this.billingName,
      this.primarySubmit,
      this.priceMap,
      this.add1,
      this.add2,
      this.add3,
      this.city,
      this.state,
      this.zip,
      this.secondarySubmit,
      this.custClass,
      this.distList,
      this.fieldArea,
      this.poNum,
      this.requisitioner,
      this.taxRate,
      this.ccFee});
}

enum SubmitOption { email, mail, openinvoice, ariba, none }
