import 'job.dart';

class Billable {
  final Job job;
  final String leaseNumber;
  final String leaseName;
  final double quantity;
  var itemOrService;

  Billable(this.job, this.leaseNumber, this.leaseName, this.quantity,
      this.itemOrService);

  //if creating billable from Amis or Accugas, take Row in constructor
  //if creating from work ticket take a Job item and a map of code : quantity pairs?

}
