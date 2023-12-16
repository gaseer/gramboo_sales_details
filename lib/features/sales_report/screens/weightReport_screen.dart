import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gramboo_sales_details/features/sales_report/screens/salesReport_screen.dart';

import '../../../core/global_variables.dart';
import '../../../core/utilities/custom_dropDown.dart';

class WeightReportScreen extends StatefulWidget {
  const WeightReportScreen({super.key});

  @override
  State<WeightReportScreen> createState() => _WeightReportScreenState();
}

class _WeightReportScreenState extends State<WeightReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "WEIGHT REPORT",
        ),
        actions: const [
          Text("Today's RS"),
        ],
      ),
      drawer: const Drawer(),
      body: ListView(padding: EdgeInsets.all(30), children: [
        SizedBox(
          height: w * .025,
        ),
        Container(
          // margin: EdgeInsets.only(left: w * .1, right: w * .1),
          height: w * .3,
          decoration: BoxDecoration(
            color: Colors.lightBlueAccent,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3), // changes the position of the shadow
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '255.009',
                style: GoogleFonts.alice(
                  fontSize: w * .09,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: w * .07,
              ),
              SizedBox(
                height: h * .06,
                width: w * .3,
                child: CustomDropDown(
                  dropList: const ["GW", "StoneWt", "diaWt"],
                  selectedValueProvider: weightDropValueProvider,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: w * .1,
        ),
        ListView.builder(
          physics: ScrollPhysics(),
          shrinkWrap: true,
          itemCount: names.length,
          itemBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: w * .2,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 6,
                color: Colors.lightBlueAccent,
                margin: EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: const Icon(Icons.production_quantity_limits,
                      color: Colors.black),
                  title: Text(
                    names[index],
                    style: GoogleFonts.alice(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    // Do something when the ListTile is tapped
                    print('Selected: ${names[index]}');
                  },
                ),
              ),
            );
          },
        ),
      ]),
    );
  }

  final List<String> names = [
    'GOLD 18 K',
    'GOLD 22 K',
    'DIAMOND',
    'SILVER',
    'BULLION',
    'OLD GOLD',
    'OLD DIAMOND',
    'UNCUT',
    'PRECIOUS',
    'RP'
  ];
}
