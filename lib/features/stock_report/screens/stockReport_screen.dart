import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gramboo_sales_details/features/stock_report/screens/detailedView_screen.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../../../core/global_variables.dart';
import '../../../core/navigation_services.dart';
import '../../../core/utilities/custom_dropDown.dart';
import 'itemReport_screen.dart';

class StockReportScreen extends StatefulWidget {
  const StockReportScreen({super.key});

  @override
  State<StockReportScreen> createState() => _StockReportScreenState();
}

class _StockReportScreenState extends State<StockReportScreen> {
  final dayFilterDropValueProvider = StateProvider<String?>((ref) {
    return "Metal Wise";
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "STOCK REPORT",
          style: GoogleFonts.alice(
            fontSize: w * .07,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDropDownDialog,
        child: const Icon(Icons.filter_list),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: 10,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    trailing: GestureDetector(
                        onTap: () => NavigationService.navigateToScreen(
                            context, DetailedViewScreen()),
                        child: Text(
                          'DETAIL',
                          style: GoogleFonts.alice(
                            fontWeight: FontWeight.w500,
                            fontSize: w * 0.035,
                          ),
                        )),
                    backgroundColor: Colors.white,
                    title: Text(
                      'Metal Type $index',
                      style: GoogleFonts.alice(
                        fontWeight: FontWeight.w500,
                        fontSize: w * 0.05,
                      ),
                    ),
                    subtitle: const Text('Category'),
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          NavigationService.navigateToScreen(
                              context,
                              ItemReportScreen(
                                catName: 'Item Category $index',
                              ));
                        },
                        child: Hero(
                          tag: 'Item Category $index',
                          child: Text(
                            'Item Category $index',
                            style: GoogleFonts.alice(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: w * 0.05,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showDropDownDialog() {
    Future.delayed(Duration.zero, () {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Select Options',
              textAlign: TextAlign.center,
            ),
            content: Wrap(
              children: [
                const SizedBox(
                  height: 20,
                ),

                //1
                // multiSelectDialogField(
                //   title: 'Report',
                //   items: ['Category Wise, , items'],
                // ),

                //2
                multiSelectDialogField(
                  title: 'ITEM NAME',
                  items: ['values, stock, items'],
                ),

                //3
                multiSelectDialogField(
                  title: 'STOCK TYPE',
                  items: ['values, stock, items'],
                ),

                //4
                multiSelectDialogField(
                  title: 'CATEGORY',
                  items: ['values, stock, items'],
                ),

                //5
                multiSelectDialogField(
                  title: 'METAL TYPE',
                  items: ['values, stock, items'],
                ),
                //6
                multiSelectDialogField(
                  title: 'ITEM GROUP',
                  items: ['values, stock, items'],
                ),

                //7
                multiSelectDialogField(
                  title: 'DEPARTMENT',
                  items: ['values, stock, items'],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Close'),
              ),
            ],
          );
        },
      );
    });
  }

  Padding multiSelectDialogField({required title, required items}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MultiSelectDialogField(
        buttonText: Text(title),
        title: Text(
          title,
          style: GoogleFonts.alice(
              fontSize: w * .045, fontWeight: FontWeight.w400),
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(20)),
        searchHint: 'Search Here...',
        items: [
          for (var item in ['Category Wise', 'Item Wise', 'Metal Wise'])
            MultiSelectItem<Object?>(
              item,
              item,
            ),
        ],
        // initialValue: _selectedItems,
        searchable: true,
        onConfirm: (values) {
          // TODO give applicable code here !
        },
      ),
    );
  }
}
