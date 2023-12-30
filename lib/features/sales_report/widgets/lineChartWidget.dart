import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gramboo_sales_details/models/salesSummaryParamModel.dart';
import 'package:intl/intl.dart';

import '../../../models/salesSummary_model.dart';

class LineChartWidget extends ConsumerStatefulWidget {
  final SalesSummaryParamsModel paramModel;
  final List<String> filters;
  final List<SalesSummaryModel> salesSummaryList;
  final String yAxisConstraint;
  const LineChartWidget(
      {super.key,
      required this.salesSummaryList,
      required this.paramModel,
      required this.yAxisConstraint,
      required this.filters});

  @override
  ConsumerState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends ConsumerState<LineChartWidget> {
  bool isShowingMainData = true;
  double maxYValue = 0.0;
  double maxXValue = 0.0;
  double minXValue = 1.0;
  double yAxisInterval = 0;
  double xAxisInterval = 0;
  List<String> xAxisLabels = [];
  int i = 0;

  @override
  void initState() {
    print(widget.filters);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getLeftTilesData();
    getBottomTileData();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: LineChart(
        LineChartData(
          lineTouchData: LineTouchData(
            handleBuiltInTouches: true,
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.white.withOpacity(0.8),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: true,
            horizontalInterval: yAxisInterval,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey,
                strokeWidth: 0.3,
              );
            },
          ),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: xAxisInterval,
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 5,
                  );

                  if (value == minXValue) {
                    i = 0;
                  } else {
                    i = i + 1;
                  }

                  String text = xAxisLabels[i];

                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 10,
                    child:
                        Text(text, style: style, textAlign: TextAlign.center),
                  );
                },
              ),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                getTitlesWidget: (value, meta) {
                  const style = TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  );

                  String text = "${value.toInt()}";

                  return Text(text, style: style, textAlign: TextAlign.center);
                },
                showTitles: true,
                interval: yAxisInterval,
                reservedSize: 40,
              ),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              bottom: BorderSide(color: Colors.grey, width: 1.5),
              left: BorderSide(color: Colors.grey, width: 1.5),
              right: BorderSide(color: Colors.transparent),
              top: BorderSide(color: Colors.transparent),
            ),
          ),
          lineBarsData: getLineChartBarData(widget.salesSummaryList, [
            Colors.green,
            Colors.red,
            Colors.blue,
            Colors.black,
            Colors.brown,
            Colors.deepOrange
          ]),
          minX: minXValue,
          maxX: maxXValue,
          maxY: maxYValue,
          minY: 0,
        ),
      ),
    );
  }

  //generate different line acc to paras

  List<LineChartBarData> getLineChartBarData(
      List<SalesSummaryModel> salesSummaryList, List<Color> colorsList) {
    List<LineChartBarData> linesList = [];
    List<SalesSummaryModel> dataList = [];

    for (int i = 0; i < widget.filters.length; i++) {
      String filter = widget.filters[i];

      //IIIIIIIIIIIIISSSSSSSSSSUUUUUUUUUUUUUUUUUEEEEEEEEEEEEEEEEeee

      //TODO itemName only filter -> switch case

      dataList = widget.salesSummaryList
          .where((element) => element.itemName == filter)
          .toList();

      print(dataList);
      LineChartBarData lineChartBarData = LineChartBarData(
        isCurved: false,
        color: colorsList[i % colorsList.length],
        barWidth: 3,
        isStrokeCapRound: false,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: dataList.map((e) {
          String dateString = e.invDate!;
          DateTime dateTime = DateTime.parse(dateString);

          double yAxisValue = getYAxisValue(model: e);

          return FlSpot(
            dateTime.day.toDouble(),
            yAxisValue,
          );
        }).toList(),
      );

      linesList.add(lineChartBarData);
    }

    print(linesList.length);
    print("LENGTH");
    return linesList;
  }

  //FUNCTIONS FOR DYNAMIC GRAPH

  getLeftTilesData() {
    double _maxValueInList = 0.0;
    double _yAxisInterval = 0;

    for (var i in widget.salesSummaryList) {
      if (i.gwt! > _maxValueInList) {
        _maxValueInList = i.gwt!;
      }
    }

    //round max value to 100's multiple
    _maxValueInList = ((_maxValueInList / 100).ceil()) * 100;
    _yAxisInterval = _maxValueInList / 10;

    setState(() {
      maxYValue = _maxValueInList;
      yAxisInterval = _yAxisInterval == 0 ? 100 : _yAxisInterval;
    });
  }

  //DATES x AXIS
  getBottomTileData() {
    List<String> _xAxisLabels = [];
    double _maxValue = 0.0;
    double _xAxisIntervals = 0;
    double _minXValue = 0;

    DateFormat dateFormat = DateFormat("dd-MMM-yyyy");

    String startDateString = widget.paramModel.dateFrom;
    String endDateString = widget.paramModel.dateTo;
    DateTime startDateDateTime = dateFormat.parse(startDateString);
    DateTime endDateDateTime = dateFormat.parse(endDateString);
    Duration diffBetween = endDateDateTime.difference(startDateDateTime);
    DateFormat dayOnly = DateFormat('E');
    DateFormat dateOnly = DateFormat('dd');
    String firstDate = dateOnly.format(startDateDateTime);
    String lastDate = dateOnly.format(endDateDateTime);
    int difference = diffBetween.inDays;
    difference = difference + 1;

    if (difference <= 7) {
      _maxValue = difference.toDouble();
      _xAxisIntervals = 1;
      List<String> dayNames = [];

      for (DateTime date = startDateDateTime;
          date.isBefore(endDateDateTime.add(Duration(days: 1)));
          date = date.add(Duration(days: 1))) {
        String dayName = dayOnly.format(date);
        dayNames.add(dayName);
      }

      _xAxisLabels = dayNames;
      _minXValue = double.parse(firstDate).ceil().toDouble();
      _maxValue = double.parse(lastDate).ceil().toDouble();
    } else {
      DateFormat dateFormat = DateFormat('dd');
      for (DateTime date = startDateDateTime;
          date.isBefore(endDateDateTime.add(Duration(days: 1)));
          date = date.add(Duration(days: 1))) {
        String singleDay = dateFormat.format(date);
        _xAxisLabels.add(singleDay);
      }

      _minXValue = double.parse(_xAxisLabels[0]).ceil().toDouble();
      _maxValue = double.parse(lastDate).ceil().toDouble();

      _xAxisIntervals = 1;
    }

    setState(() {
      minXValue = _minXValue;
      maxXValue = _maxValue;
      xAxisLabels = _xAxisLabels;
      xAxisInterval = _xAxisIntervals == 0 ? 100 : _xAxisIntervals;
    });
  }

  //Change points calc acc to drop selected value

  double getYAxisValue({required SalesSummaryModel model}) {
    switch (widget.yAxisConstraint) {
      case "Gross Weight":
        return model.gwt!;
      case "Stone Weight":
        return model.stoneWt!;
      case "Dia Weight":
        return model.diaWt!;
      case "Net Weight":
        return model.netWt!;
      case "Total Qty":
        return model.qty!.toDouble();
      case "VA Percentage":
        return model.vAPercAfterDisc!;
      case "VA Amount":
        return model.vAAfterDisc!;
      default:
        return model.diaCash!;
    }
  }
}
