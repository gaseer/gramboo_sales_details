import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gramboo_sales_details/core/navigation_services.dart';

import '../../../core/global_variables.dart';
import 'detailedView_screen.dart';
import 'itemDetailReport_screen.dart';

class ItemReportScreen extends StatefulWidget {
  final String catName;
  const ItemReportScreen({super.key, required this.catName});

  @override
  _ItemReportScreenState createState() => _ItemReportScreenState();
}

class _ItemReportScreenState extends State<ItemReportScreen> {
  List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4'
  ]; // Replace with your actual items
  List<String> filteredItems = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems.addAll(items);
  }

  void filterItems(String query) {
    setState(() {
      filteredItems = items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ITEM WISE REPORT",
          style: GoogleFonts.alice(
            fontSize: w * .07,
          ),
        ),
      ),
      body: Column(
        children: [
          Hero(
            tag: widget.catName,
            child: Text(
              widget.catName,
              style: GoogleFonts.alice(
                color: Colors.black,
                fontWeight: FontWeight.w500,
                fontSize: w * 0.065,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: searchController,
                onChanged: (query) {
                  filterItems(query);
                },
                decoration: InputDecoration(
                  labelText: 'Search',
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          filteredItems.isEmpty
              ? Text(
                  "NO SEARCHED ITEM",
                  style: GoogleFonts.alice(
                    fontWeight: FontWeight.w500,
                    fontSize: w * 0.065,
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () => NavigationService.navigateToScreen(
                            context,
                            ItemDetailReportScreen(
                              itemName: filteredItems[index],
                            )),
                        child: Hero(
                          tag: filteredItems[index],
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              title: Text(
                                filteredItems[index],
                                style: GoogleFonts.alice(
                                  fontWeight: FontWeight.w500,
                                  fontSize: w * 0.05,
                                ),
                              ),
                              subtitle: Text('Category'),
                              leading: GestureDetector(
                                  onTap: () =>
                                      NavigationService.navigateToScreen(
                                          context, DetailedViewScreen()),
                                  child: Text(
                                    'DETAIL',
                                    style: GoogleFonts.alice(
                                      fontWeight: FontWeight.w500,
                                      fontSize: w * 0.035,
                                    ),
                                  )),
                              trailing: const Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('GROSS WT'),
                                  Text('STONE WT'),
                                  Text('DIA  WT'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
