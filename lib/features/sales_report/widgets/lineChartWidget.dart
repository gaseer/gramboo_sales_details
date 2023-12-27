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

  double maxYValue = 0.0;
  double yAxisInterval = 100;

  @override
  void initState() {
    super.initState();
    getLeftTilesData();
  }

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

  //graph root/main

  LineChartData get sampleData1 => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        //TODO change max x according to drop down date filter - now in week
        maxX: widget.xAxisFilter == "This week" ? 7 : 30,
        maxY: maxYValue,
        minY: 0,
      );

  //generate different line acc to paras

  List<LineChartBarData> getLineChartBarData(
      List<SalesSummaryModel> salesSummaryList) {
    List<LineChartBarData> linesList = [];

    //TODO multiple line add using for loop by passing wanted filters

    LineChartBarData lineChartBarData = LineChartBarData(
      isCurved: true,
      color: Colors.green,
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: salesSummaryList.map((e) {
        // TODO: Set x-axis according to filter dates
        String dateString = e.invDate!;
        DateTime dateTime = DateTime.parse(dateString);
        DateTime referenceDate = DateTime(2023, 12, 1);
        Duration difference = dateTime.difference(referenceDate);
        int daysSinceReferenceDate = difference.inDays;

        // TODO: Convert gwt to kg gwt
        return FlSpot(
          double.parse(daysSinceReferenceDate.toString()),
          (e.gwt! / 5),
        );
      }).toList(),
    );

    linesList.add(lineChartBarData);

    return linesList;
  }

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
      ];

  //line data

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

        //TODO covert gwt to kg gwt
        return FlSpot(
            double.parse(daysSinceReferenceDate.toString()), (e.gwt! / 5));
      }).toList());

  //line touch data
  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  //tiles left -> bottom
  //==============================================

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

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    print(value);

    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String text;
    switch (value.toInt()) {
      case 90:
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
        text = '5 GW';
        break;
      case 6:
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
        interval: yAxisInterval,
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

  FlGridData get gridData => FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        horizontalInterval: 10, // Adjust this based on your data range
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey,
            strokeWidth: 0.5,
          );
        },
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 2),
          left: BorderSide(color: Colors.grey, width: 2),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  //==============================================

  //FUNCTIONS FOR DYNAMIC GRAPH

  getLeftTilesData() {
    double maxValueInList = 0.0;
    double yAxisIntervalCalculate = 100;

    for (var i in widget.salesSummaryList) {
      if (i.gwt! > maxValueInList) {
        maxValueInList = i.gwt!;
      }
    }

    //calculate y axis interval acc to max value in list round to next 100
    maxValueInList = ((maxValueInList / yAxisIntervalCalculate).ceil()) *
        yAxisIntervalCalculate;

    setState(() {
      maxYValue = maxValueInList;
      yAxisInterval = yAxisIntervalCalculate;

      print("MAX Y VALUE $maxYValue");

      print("[[[[[[[[[[[");
      print(yAxisInterval);
    });
  }
}
