import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gramboo_sales_details/features/sales_report/data/multiSelectType.dart';
import 'package:gramboo_sales_details/models/salesSummaryParamModel.dart';
import 'package:intl/intl.dart';

import '../../../models/salesSummary_model.dart';

class LineChartWidget extends ConsumerStatefulWidget {
  final SalesSummaryParamsModel paramModel;
  final List<String> filters;
  final String multiSelect;
  final List<SalesSummaryModel> salesSummaryList;
  final String yAxisConstraint;
  const LineChartWidget(
      {super.key,
      required this.multiSelect,
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
  double minXValue = 0.0;
  double yAxisInterval = 0;
  double xAxisInterval = 0;

  int i = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          padding: const EdgeInsets.all(10).copyWith(top: 30),
          width: MediaQuery.of(context).size.width * 1.5,
          child: LineChart(
            LineChartData(
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.white.withOpacity(0.8),
                  tooltipPadding: EdgeInsets.all(8),
                  getTooltipItems: (List<LineBarSpot> touchedSpots) {
                    return touchedSpots.map((LineBarSpot touchedSpot) {
                      final TextStyle textStyle = TextStyle(
                        color: touchedSpot.bar.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      );
                      //TODO change List to fix bug

                      print("touch length = ${touchedSpots}");

                      // final SalesSummaryModel model =
                      //     allSummaryListTouch[touchedSpot.x.toInt()];
                      //
                      // String dateString = model.invDate!;
                      //
                      // DateTime dateTime = DateTime.parse(dateString);

                      // String formattedDate =
                      //     DateFormat('dd-MMM-yyyy').format(dateTime);
                      double dataValue = touchedSpot.y;

                      return LineTooltipItem(
                        '$dataValue',
                        textStyle,
                      );
                    }).toList();
                  },
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                drawVerticalLine: false,
                horizontalInterval: yAxisInterval == 0 ? 10 : yAxisInterval,
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
                    getTitlesWidget: getBottomTileData(),
                    showTitles: true,
                    reservedSize: 32,
                    interval: xAxisInterval,
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
                    getTitlesWidget: getLeftTilesData(),
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

      dataList =
          getLineAccToFilters(filter: filter, multiSelect: widget.multiSelect);

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

    return linesList;
  }

  //FUNCTIONS FOR DYNAMIC GRAPH

  getLeftTilesData() {
    double _maxValueInList = 0.0;
    double _yAxisInterval = 0;

    _maxValueInList =
        getYAxisLineData(saleSummaryList: widget.salesSummaryList);

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
    DateFormat dateFormat = DateFormat("dd-MMM-yyyy");

    String startDateString = widget.paramModel.dateFrom;
    String endDateString = widget.paramModel.dateTo;
    DateTime startDateDateTime = dateFormat.parse(startDateString);
    DateTime endDateDateTime = dateFormat.parse(endDateString);
    Duration difference = endDateDateTime.difference(startDateDateTime);
    int numberOfDays = difference.inDays + 1;

    setState(() {
      minXValue = startDateDateTime.day.toDouble();

      //TODO max Value issue
      maxXValue = numberOfDays.toDouble();
      // startDateDateTime
      // .add(Duration(days: numberOfDays - 1))
      // .day
      // .toDouble();
      print(minXValue);

      print("maxx $maxXValue");
      xAxisInterval = 1; // Interval between x-axis values
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

  double getYAxisLineData({required List<SalesSummaryModel> saleSummaryList}) {
    double _maxValueInList = 0.0;
    switch (widget.yAxisConstraint) {
      case "Gross Weight":
        for (var i in saleSummaryList) {
          if (i.gwt! > _maxValueInList) {
            _maxValueInList = i.gwt!;
          }
        }
        return _maxValueInList;
      case "Stone Weight":
        for (var i in saleSummaryList) {
          if (i.stoneWt! > _maxValueInList) {
            _maxValueInList = i.stoneWt!;
          }
        }
        return _maxValueInList;
      case "Dia Weight":
        for (var i in saleSummaryList) {
          if (i.diaWt! > _maxValueInList) {
            _maxValueInList = i.diaWt!;
          }
        }
        return _maxValueInList;
      case "Net Weight":
        for (var i in saleSummaryList) {
          if (i.netWt! > _maxValueInList) {
            _maxValueInList = i.netWt!;
          }
        }
        return _maxValueInList;
      case "Total Qty":
        for (var i in saleSummaryList) {
          if (i.qty! > _maxValueInList) {
            _maxValueInList = i.qty == null ? 0 : i.qty!.toDouble();
          }
        }
        return _maxValueInList;
      case "VA Percentage":
        for (var i in saleSummaryList) {
          if (i.vAPercAfterDisc! > _maxValueInList) {
            _maxValueInList = i.vAPercAfterDisc!;
          }
        }
        return _maxValueInList;
      case "VA Amount":
        for (var i in saleSummaryList) {
          if (i.vAAfterDisc! > _maxValueInList) {
            _maxValueInList = i.vAAfterDisc!;
          }
        }
        return _maxValueInList;
      default:
        for (var i in saleSummaryList) {
          if (i.diaCash! > _maxValueInList) {
            _maxValueInList = i.diaCash!;
          }
        }
        return _maxValueInList;
    }
  }

  List<SalesSummaryModel> getLineAccToFilters(
      {required String filter, required String multiSelect}) {
    switch (multiSelect) {
      case MultiSelectType.itemName:
        List summaryList = widget.salesSummaryList
            .where((element) => element.itemName == filter)
            .map((e) => e.toJson())
            .toList();
        final salesSummaryList = getNoSaleDaySummary(
            summaryList: summaryList, multiSelect: multiSelect, filter: filter);
        return salesSummaryList;
      case MultiSelectType.categoryName:
        List summaryList = widget.salesSummaryList
            .where((element) => element.categoryName == filter)
            .map((e) => e.toJson())
            .toList();
        final salesSummaryList = getNoSaleDaySummary(
            summaryList: summaryList, multiSelect: multiSelect, filter: filter);
        return salesSummaryList;
      default:
        return [];
    }
  }

  List<SalesSummaryModel> getNoSaleDaySummary(
      {required List summaryList,
      required String multiSelect,
      required String filter}) {
    DateFormat dateFormat = DateFormat("dd-MMM-yyyy");
    List allSummaryList = [];

    String startDateInIso =
        dateFormat.parse(widget.paramModel.dateFrom).toIso8601String();
    String endDateInIso =
        dateFormat.parse(widget.paramModel.dateTo).toIso8601String();
    List<String> allDatesInIso = getISO8601DatesBetween(
        startDate: startDateInIso, endDate: endDateInIso);

    for (var i in summaryList) {
      if (allDatesInIso.contains(i["InvDate"])) {
        allSummaryList.add(i);
      }
    }

    for (int j = 0; j < allDatesInIso.length; j++) {
      if (!allSummaryList.contains(allDatesInIso[j])) {
        allSummaryList.add({
          "InvDate": allDatesInIso[j],
          "Gwt": 0.0,
          multiSelect: filter,
          "StoneWt": 0.0,
          "NetWt": 0.0,
          "DiaWt": 0.0,
          "MetalCash": 0.0,
          "DiaCash": 0.0,
          "StoneCash": 0.0,
          "VAAfterDisc": 0.0,
          "VAPercAfterDisc": 0.0
        });
      }
    }

    allSummaryList.sort((a, b) =>
        DateTime.parse(a["InvDate"]).compareTo(DateTime.parse(b["InvDate"])));

    return allSummaryList.map((e) => SalesSummaryModel.fromJson(e)).toList();
  }

  //TODO change logic

  List<String> getISO8601DatesBetween(
      {required String startDate, required String endDate}) {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    DateTime startDateTime = dateFormat.parse(startDate);
    DateTime endDateTime = dateFormat.parse(endDate);

    List<DateTime> allDates = getDatesBetween(startDateTime, endDateTime);

    List<String> isoDatesList =
        allDates.map((date) => date.toIso8601String().split('.')[0]).toList();

    return isoDatesList;
  }

  List<DateTime> getDatesBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> dates = [];
    for (var i = 0; i <= endDate.difference(startDate).inDays; i++) {
      dates.add(startDate.add(Duration(days: i)));
    }
    return dates;
  }
}
