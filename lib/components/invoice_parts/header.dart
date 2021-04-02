import 'package:easyinvoice/models/job.dart';
import 'package:flutter/material.dart';

class InvoiceHeader extends StatelessWidget {
  final AssetImage howard = AssetImage('assets/logo.png');
  final Job job;
  final TextStyle remitStyle =
      TextStyle(fontSize: 15, fontWeight: FontWeight.normal);

  InvoiceHeader(this.job);

  @override
  Widget build(BuildContext context) {
    Size screen = MediaQuery.of(context).size;
    double invWidth = screen.width * 8.5 / 11;
    Image logo = Image(image: howard, width: invWidth * 2 / 5);
    return Container(
      constraints: BoxConstraints.tightFor(
        width: invWidth,
      ),
      color: Colors.orange[50],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: logo,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: logo.width * .2,
                  ),
                  Text(
                    'Remit To:',
                    textAlign: TextAlign.left,
                    style: remitStyle,
                  ),
                  Text(
                    '1637 Enterprise St.',
                    textAlign: TextAlign.left,
                    style: remitStyle,
                  ),
                  Text(
                    'Athens, TX 75751',
                    textAlign: TextAlign.left,
                    style: remitStyle,
                  ),
                  Text(
                    '903-677-0700',
                    textAlign: TextAlign.left,
                    style: remitStyle,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  'Page 1 of 1',
                  textAlign: TextAlign.left,
                  style: remitStyle,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'INVOICE',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
