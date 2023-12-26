import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/salesSummary_model.dart';

class LineChartWidget extends ConsumerStatefulWidget {
  final String xAxisFilter;
  final List<SalesSummaryModel> salesSummaryList;
  const LineChartWidget(
      {super.key, required this.salesSummaryList, required this.xAxisFilter});

  @override
  ConsumerState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends ConsumerState<LineChartWidget> {
  bool isShowingMainData = true;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LineChart(
        sampleData1,
        // duration: const Duration(milliseconds: 250),
      ),
    );
  }

  //graph

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        //TODO change max x according to drop down date filter - now in week
        maxX: widget.xAxisFilter == "This week" ? 7 : 30,
        maxY: 4,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        // lineChartBarData1_2,
        // lineChartBarData1_3,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;

    switch (value.toInt()) {
      case 1:
        text = '1 GW';
        break;
      case 2:
        text = '2 GW';
        break;
      case 3:
        text = '3 GW';
        break;
      case 4:
        text = '5 GW';
        break;
      case 5:
        text = '6 GW';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  // mn tu wd .....
  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    if (widget.xAxisFilter == "This week") {
      switch (value.toInt()) {
        case 1:
          text = const Text('Mn', style: style);
          break;
        case 2:
          text = const Text('Tu', style: style);
          break;
        case 3:
          text = const Text('Wd', style: style);
          break;
        case 4:
          text = const Text('Th', style: style);
          break;
        case 5:
          text = const Text('Fr', style: style);
          break;
        case 6:
          text = const Text('St', style: style);
          break;
        case 7:
          text = const Text('Su', style: style);
          break;
        default:
          text = const Text('');
          break;
      }
    } else {
      switch (value.toInt()) {
        case 1:
          text = const Text('1', style: style);
          break;
        case 2:
          text = const Text('2', style: style);
          break;
        case 3:
          text = const Text('3', style: style);
          break;
        case 4:
          text = const Text('4', style: style);
          break;
        case 5:
          text = const Text('5', style: style);
          break;
        case 6:
          text = const Text('6', style: style);
          break;
        case 7:
          text = const Text('7', style: style);
          break;
        default:
          text = const Text('');
          break;
      }
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
      isCurved: true,
      color: Colors.green,
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: widget.salesSummaryList.map((e) {
        //TODO set x axis acc to filter dates
        String dateString = e.invDate!;
        DateTime dateTime = DateTime.parse(dateString);
        DateTime referenceDate = DateTime(2023, 12, 1);
        Duration difference = dateTime.difference(referenceDate);
        int daysSinceReferenceDate = difference.inDays;

        print(daysSinceReferenceDate);
        //TODO covert gwt to kg gwt
        return FlSpot(
            double.parse(daysSinceReferenceDate.toString()), (e.gwt! / 5));
      }).toList()
      // spots: const [
      //   FlSpot(1, 1),
      //   FlSpot(3, 1.5),
      //   FlSpot(5, 1.4),
      //   FlSpot(7, 3.4),
      //   FlSpot(10, 2),
      //   FlSpot(12, 2.2),
      //   FlSpot(13, 1.8),
      // ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: Colors.blueGrey,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: Colors.pink,
        ),
        spots: const [
          FlSpot(1, 1),
          FlSpot(3, 2.8),
          FlSpot(7, 1.2),
          FlSpot(10, 2.8),
          FlSpot(12, 2.6),
          FlSpot(13, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: Colors.cyan,
        barWidth: 8,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(1, 2.8),
          FlSpot(3, 1.9),
          FlSpot(6, 3),
          FlSpot(10, 1.3),
          FlSpot(13, 2.5),
        ],
      );
}
