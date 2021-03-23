import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/models/customer.dart';
import 'package:easyinvoice/models/job.dart';
import 'package:easyinvoice/models/service.dart';
import 'package:easyinvoice/models/station_charge.dart';
import 'package:get/get.dart';

Future<Job> testJob() async {
  ImportController controller = Get.find();
  Service gas = await controller.getGasService('Spot');

  await controller.parseCustomer('BTA').then((value) {
    return Job(
      customer: value,
      techName: 'Johnny Horton',
      stationCharges: [
        StationCharge(
          leaseName: 'Test Lease 1',
          leaseNumber: '12345',
          serviceMap: {
            gas: 1,
          },
        ),
        StationCharge(
            leaseName: 'Test Lease 2',
            leaseNumber: '23456',
            serviceMap: {
              gas: 3,
            }),
      ],
    );
  });
}
