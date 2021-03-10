class Service {
  final String serviceCode;
  final String name;
  final String qbName;
  final String category;
  final double workUnits;

  Service(this.serviceCode, this.name,
      [this.qbName, this.category, this.workUnits]);
}
