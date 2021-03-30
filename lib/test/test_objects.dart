import 'package:easyinvoice/controllers/firebase_controller.dart';
import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/models/customer.dart';
import 'package:easyinvoice/models/item.dart';
import 'package:easyinvoice/models/job.dart';
import 'package:easyinvoice/models/service.dart';
import 'package:easyinvoice/models/station_charge.dart';
import 'package:get/get.dart';

Future<void> testJob() async {
  ImportController controller = Get.find();
  FireBaseController controllerF = Get.find();

  Service gas = await controller.getGasService('Spot');
  Service liquid = await controller.getGasService('liquid');
  Item plate = await controllerF.getItem('MPU2-0002');
  Customer cust = await controller.parseCustomer('BTA');

  controller.jobs.add(Job(
    customer: cust,
    jobDate: DateTime.tryParse('1/1/2021'),
    poNumber: 'PO#101020301',
    location: 'Your moms house',
    requisitioner: 'This guy',
    techName: 'Johnny Horton',
    stationCharges: [
      StationCharge(
          leaseName: 'Test Lease 1',
          leaseNumber: '12345',
          serviceMap: {
            gas: 1,
            liquid: 6,
          },
          itemMap: {
            plate: 2
          }),
      StationCharge(
        leaseName: 'Test Lease 2',
        leaseNumber: '23456',
        serviceMap: {
          gas: 3,
        },
        itemMap: {},
      ),
    ],
  ));
}
