import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/global_variables.dart';

class ItemDetailReportScreen extends StatefulWidget {
  final String itemName;
  const ItemDetailReportScreen({super.key, required this.itemName});

  @override
  State<ItemDetailReportScreen> createState() => _ItemDetailReportScreenState();
}

class _ItemDetailReportScreenState extends State<ItemDetailReportScreen> {
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
      body: Hero(
        tag: widget.itemName,
        child: Center(
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: SizedBox(
              height: 100,
              width: 300,
              child: Column(
                children: [
                  Text(
                    widget.itemName,
                    style: GoogleFonts.alice(
                      fontSize: w * .07,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'GWT  , Stone Wt, Dia Wt',
                        style: GoogleFonts.alice(
                          fontSize: w * .05,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
