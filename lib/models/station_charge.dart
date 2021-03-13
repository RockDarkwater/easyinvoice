class StationCharge {
  String leaseName;
  String leaseNumber;
  String notes;
  Map<dynamic, double> chargeMap = Map();

  StationCharge({this.leaseNumber, this.leaseName, this.notes, this.chargeMap});
}
