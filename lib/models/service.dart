class Service {
  final String code;
  final String name;
  final String qbName;
  final String category;
  final double workUnits;

  Service(this.code, this.name, this.qbName, this.category, this.workUnits) {
    print('building service: $code');
  }
}
