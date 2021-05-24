import 'package:easyinvoice/controllers/firebase_controller.dart';
import 'package:easyinvoice/controllers/import_controller.dart';
import 'package:easyinvoice/models/customer.dart';
import 'package:easyinvoice/models/item.dart';
import 'package:easyinvoice/models/job.dart';
import 'package:easyinvoice/models/service.dart';
import 'package:easyinvoice/models/station_charge.dart';
import 'package:get/get.dart';

Future<bool> testJob() async {
  ImportController controller = Get.find();
  FireBaseController controllerF = Get.find();

  Service gas = await controller.getGasService('Spot');
  Service liquid = await controller.getGasService('liquid');
  Service cal = await controllerF.getService('calibration');
  Item plate = await controllerF.getItem('MPU2-0002');
  Customer cust = await controller.parseCustomer('8093');

  controller.jobs.add(Job(
      customer: cust,
      poNumber: '101020301',
      location: 'Your moms house',
      requisitioner: 'This guy',
      techName: 'Johnny Horton',
      stationCharges: [
        StationCharge(
            meterName: 'Test Lease 1 that\'s really long',
            meterNumber: '12345',
            jobDate: DateTime(2021, 4, 1),
            serviceMap: {
              cal: 1,
              gas: 1,
              liquid: 6,
            },
            itemMap: {
              plate: 2
            }),
        StationCharge(
          meterName: 'Test Lease 2',
          meterNumber: '23456',
          jobDate: DateTime(2021, 4, 2),
          serviceMap: {
            cal: 1,
            gas: 3,
          },
          itemMap: {},
        ),
      ],
      chargeSummary: {}));
  controller.jobs.last.priceServices();

  cust = await controller.parseCustomer('8093NM');

  controller.jobs.add(Job(
      customer: cust,
      poNumber: '101020301',
      location: 'Your other house',
      requisitioner: 'Another guy',
      techName: 'Jim Hortons',
      stationCharges: [
        StationCharge(
            meterName: 'Test Lease 2',
            meterNumber: '22233',
            jobDate: DateTime(2021, 4, 15),
            serviceMap: {
              cal: 5,
              gas: 1,
            },
            itemMap: {}),
        StationCharge(
          meterName: 'Test Lease 5',
          meterNumber: '556677',
          jobDate: DateTime(2021, 4, 7),
          serviceMap: {
            cal: 1,
            gas: 3,
          },
          itemMap: {},
        ),
      ],
      chargeSummary: {}));

  controller.compileParents();
  controller.jobs.forEach((job) {
    job.priceServices();
    job.summarize();
  });
  controller.applyRules();

  // Job test = Job.fromJson(controller.jobs.first.toJson());
  try {
    // print(test.toJson());
    // print(controller.jobs.first.toJson());
  } catch (err) {
    print('$err');
  }
  return true;
}
