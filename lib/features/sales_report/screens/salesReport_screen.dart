import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gramboo_sales_details/core/theme/theme.dart';
import 'package:gramboo_sales_details/core/utilities/custom_dropDown.dart';

import '../../../core/global_variables.dart';

class SalesReportScreen extends ConsumerStatefulWidget {
  const SalesReportScreen({super.key});

  @override
  ConsumerState createState() => _SalesReportScreenState();
}

class _SalesReportScreenState extends ConsumerState<SalesReportScreen> {
  final dayFilterDropValueProvider = StateProvider<String?>((ref) {
    return "Today";
  });

  final weightDropValueProvider = StateProvider<String?>((ref) {
    return "StoneWt";
  });

  @override
  Widget build(BuildContext context) {
    print(ref.watch(weightDropValueProvider));
    print(ref.watch(dayFilterDropValueProvider));
    return Scaffold(
      appBar: AppBar(
        title: const Text("SALES REPORT"),
      ),
      drawer: const Drawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              CustomDropDown(
                dropList: const ["Today", "Yesterday", "This month"],
                onChanged: (p0) {},
                selectedValueProvider: dayFilterDropValueProvider,
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 50,
                width: w * .8,
                color: Colors.black,
              ),
              SizedBox(
                height: h * .2,
                width: w * .8,
                child: Card(
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          "TOTAL WEIGHT",
                          style: TextStyle(
                            fontSize: w * .09,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DottedBorder(
                              color: Palette.borderColor,
                              radius: Radius.circular(15),
                              borderType: BorderType.RRect,
                              dashPattern: [10],
                              child: Container(
                                height: h * .05,
                                width: w * .2,
                                child: Center(
                                  child: Text(
                                    "556",
                                    style: TextStyle(
                                      fontSize: w * .05,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              height: h * .06,
                              width: w * .25,
                              child: CustomDropDown(
                                dropList: ["GW", "StoneWt", "diaWt"],
                                onChanged: (p0) {},
                                selectedValueProvider: weightDropValueProvider,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
