import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/global_variables.dart';

class DetailedViewScreen extends StatefulWidget {
  const DetailedViewScreen({super.key});

  @override
  State<DetailedViewScreen> createState() => _DetailedViewScreenState();
}

class _DetailedViewScreenState extends State<DetailedViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'DETAIL VIEW',
            style: GoogleFonts.alice(
              fontSize: w * .07,
            ),
          ),
        ),
        body: ListView(
          children: [
            Text(
              '---- DATE :  ${DateFormat('dd MM yyyy').format(DateTime.now())} ----',
              style: GoogleFonts.teko(fontSize: w * 0.075, color: Colors.black),
              textAlign: TextAlign.center,
            ),
            CustomDetailCard(title: 'OPENING', qty: '35'),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                  title: Text(
                    'RECEIPT',
                    style: GoogleFonts.teko(
                      fontSize: w * 0.075,
                    ),
                  ),
                  subtitle: Text('DESCRITION ----'),
                  trailing: Text(
                    'TOTAL : 32987',
                    style: GoogleFonts.teko(
                      fontSize: w * 0.075,
                    ),
                  )),
            ),
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                  title: Text(
                    'ISSUE',
                    style: GoogleFonts.teko(
                      fontSize: w * 0.075,
                    ),
                  ),
                  subtitle: Text('DESCRITION -----'),
                  trailing: Text(
                    'TOTAL : 32987',
                    style: GoogleFonts.teko(
                      fontSize: w * 0.075,
                    ),
                  )),
            ),
            const CustomDetailCard(title: 'SALE', qty: '8'),
            const CustomDetailCard(title: 'SMITH', qty: '55'),
            // CustomDetailCard(title: 'PERCE', qty: '55'),
            const CustomDetailCard(title: 'CLOSING', qty: '55'),
          ],
        ));
  }
}

class CustomDetailCard extends StatelessWidget {
  final String title;
  final String qty;
  const CustomDetailCard({
    super.key,
    required this.title,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.teko(
            fontSize: w * 0.075,
          ),
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Qty : $qty   ',
              style: GoogleFonts.alice(
                fontWeight: FontWeight.w500,
                fontSize: w * 0.05,
              ),
            ),
            Text(
              'Gwt : 20.323',
              style: GoogleFonts.alice(
                fontSize: w * 0.05,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('NET wt : 21.213'),
            Text('STONE wt : 11.032'),
            Text('DIA  wt : 22.133'),
          ],
        ),
      ),
    );
  }
}
