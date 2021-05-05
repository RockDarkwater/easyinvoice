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
  Service cal = await controllerF.getService('calibration');
  Item plate = await controllerF.getItem('MPU2-0002');
  Customer cust = await controller.parseCustomer('8093NM');

  controller.jobs.add(Job(
      customer: cust,
      poNumber: '101020301',
      location: 'Your moms house',
      requisitioner: 'This guy',
      techName: 'Johnny Horton',
      stationCharges: [
        StationCharge(
            leaseName: 'Test Lease 1',
            leaseNumber: '12345',
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
          leaseName: 'Test Lease 2',
          leaseNumber: '23456',
          jobDate: DateTime(2021, 4, 2),
          serviceMap: {
            cal: 1,
            gas: 3,
          },
          itemMap: {},
        ),
      ],
      chargeSummary: {
        cal: 2,
        gas: 4,
        liquid: 6,
        plate: 2
      }));
  controller.jobs.last.priceServices();
  controller.compileParents();
}
