import 'package:auto_size_text/auto_size_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gramboo_sales_details/features/sales_report/data/multiSelectType.dart';
import 'package:gramboo_sales_details/models/salesSummaryParamModel.dart';
import 'package:intl/intl.dart';

import '../../../models/salesSummary_model.dart';
import '../data/graphType.dart';

class NewLineChart extends ConsumerStatefulWidget {
  final SalesSummaryParamsModel paramModel;
  final List<String> filters;
  final String multiSelect;
  final List<SalesSummaryModel> salesSummaryList;
  final String yAxisConstraint;
  final List<Color> colorList;
  final String graphType;

  const NewLineChart(
      {Key? key,
      required this.multiSelect,
      required this.salesSummaryList,
      required this.paramModel,
      required this.yAxisConstraint,
      required this.filters,
      required this.colorList,
      required this.graphType})
      : super(key: key);

  @override
  ConsumerState createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends ConsumerState<NewLineChart> {
  double minY = 0.0;
  double maxY = 0.0;
  double minX = 0.0;
  double maxX = 0.0;
  double yAxisInterval = 0;
  double xAxisInterval = 0;

  @override
  void initState() {
    super.initState();
    updateYAxisValues();
    updateXAxisValues();
  }

  @override
  void didUpdateWidget(covariant NewLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    updateYAxisValues();
    updateXAxisValues();
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
              minX: minX,
              maxX: maxX,
              minY: minY,
              maxY: maxY,
              lineTouchData: LineTouchData(
                handleBuiltInTouches: true,
                touchTooltipData: LineTouchTooltipData(
                  tooltipBgColor: Colors.white,
                  tooltipPadding: EdgeInsets.all(8),
                  fitInsideVertically: true,
                  fitInsideHorizontally: true,
                  getTooltipItems: (touchedSpots) {
                    return buildTooltip(touchedSpots);
                  },
                ),
              ),
              gridData: FlGridData(
                  // ... (existing code)
                  ),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: widget.graphType == GraphType.daysInMonth
                        ? false
                        : true,
                    reservedSize: 30,
                    getTitlesWidget: getBottomTile,
                    interval: xAxisInterval,
                  ),
                ),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(
                    widget.yAxisConstraint,
                    style: TextStyle(fontSize: 12),
                  ),
                  axisNameSize: 25,
                  drawBehindEverything: true,
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: maxY > 100000
                        ? 55
                        : maxY > 10000
                            ? 35
                            : 30,
                    getTitlesWidget: getLeftTile,
                    interval: yAxisInterval,
                  ),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: false,
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
              lineBarsData: getLineChartBarData(
                widget.salesSummaryList,
                widget.colorList,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> getLineChartBarData(
    List<SalesSummaryModel> salesSummaryList,
    List<Color> colorsList,
  ) {
    List<LineChartBarData> linesList = [];
    List<SalesSummaryModel> dataList = [];

    for (int i = 0; i < widget.filters.length; i++) {
      String filter = widget.filters[i];

      double startingXAxisValue = minX;

      dataList = getGraphLineData(
          filter: filter,
          multiSelect: widget.multiSelect,
          saleSummaryList: widget.salesSummaryList);

      LineChartBarData lineChartBarData = LineChartBarData(
        isCurved: false,
        color: colorsList[i],
        barWidth: 3,
        isStrokeCapRound: false,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: dataList.map((e) {
          double xAxisValue = startingXAxisValue;
          double yAxisValue = 0.0;

          startingXAxisValue++;

          if (widget.graphType == GraphType.daysInMonth) {
            yAxisValue = getYAxisValue(model: e);
          }

          if (widget.graphType == GraphType.monthly) {
            yAxisValue = getYAxisValue(model: e);
          }
          if (widget.graphType == GraphType.yearly) {
            yAxisValue = getYAxisValue(model: e);
          }

          return FlSpot(xAxisValue, yAxisValue);
        }).toList(),
      );

      linesList.add(lineChartBarData);
    }

    return linesList;
  }

  //X AXIS =====================================

  Widget getBottomTile(double value, TitleMeta meta) {
    if (widget.graphType == GraphType.monthly) {
      String month = getMonths(xValue: value.toInt());

      return Text(month);
    }

    return Text(value.toInt().toString());
  }

  void updateXAxisValues() {
    DateFormat dateFormat = DateFormat("dd-MMM-yyyy");
    String startDateString = widget.paramModel.dateFrom;
    String endDateString = widget.paramModel.dateTo;
    DateTime startDateDateTime = dateFormat.parse(startDateString);
    DateTime endDateDateTime = dateFormat.parse(endDateString);
    Duration difference = endDateDateTime.difference(startDateDateTime);
    int numberOfDays = difference.inDays + 1;
    //TODO edge case dec 12 = jan 13 month

    if (widget.graphType == GraphType.daysInMonth) {
      setState(() {
        minX = startDateDateTime.day.toDouble();
        maxX = numberOfDays + minX - 1;
        xAxisInterval = 1;
      });
    } else if (widget.graphType == GraphType.monthly && numberOfDays <= 365) {
      int numberOfMonths =
          ((endDateDateTime.year - startDateDateTime.year) * 12) +
              (endDateDateTime.month - startDateDateTime.month);

      setState(() {
        minX = startDateDateTime.month.toDouble();
        maxX = numberOfMonths.toDouble() + minX;
        xAxisInterval = 1;
      });
    } else {
      int numberOfYears = endDateDateTime.year - startDateDateTime.year;

      setState(() {
        minX = startDateDateTime.year.toDouble();
        maxX = numberOfYears.toDouble() + minX;
        xAxisInterval = 1;
      });
    }
  }

  //======================================

  //Y AXIS =================================================

  Widget getLeftTile(double value, TitleMeta meta) {
    return AutoSizeText(
      value.toInt().toString(),
      style: TextStyle(fontSize: 12),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  double getYAxisLineData({required List<SalesSummaryModel> saleSummaryList}) {
    double maxValueInList = 0.0;
    switch (widget.yAxisConstraint) {
      case "Gross Weight":
        final lineData =
            getMaxXValueAccGraphType(saleSummaryList: saleSummaryList);

        for (var i in lineData) {
          if (maxValueInList < i.gwt!) {
            maxValueInList = i.gwt!;
          }
        }

        return maxValueInList;
      case "Stone Weight":
        final lineData =
            getMaxXValueAccGraphType(saleSummaryList: saleSummaryList);
        for (var i in lineData) {
          if (maxValueInList < i.stoneWt!) {
            maxValueInList = i.stoneWt!;
          }
        }
        return maxValueInList;
      case "Dia Weight":
        final lineData =
            getMaxXValueAccGraphType(saleSummaryList: saleSummaryList);

        for (var i in lineData) {
          if (maxValueInList < i.diaWt!) {
            maxValueInList = i.diaWt!;
          }
        }
        return maxValueInList;
      case "Net Weight":
        final lineData =
            getMaxXValueAccGraphType(saleSummaryList: saleSummaryList);
        for (var i in lineData) {
          if (maxValueInList < i.netWt!) {
            maxValueInList = i.netWt!;
          }
        }
        return maxValueInList;
      case "Total Qty":
        final lineData =
            getMaxXValueAccGraphType(saleSummaryList: saleSummaryList);
        for (var i in lineData) {
          if (maxValueInList < i.qty!) {
            maxValueInList = i.qty!;
          }
        }
        return maxValueInList;
      case "VA Percentage":
        final lineData =
            getMaxXValueAccGraphType(saleSummaryList: saleSummaryList);
        for (var i in lineData) {
          if (maxValueInList < i.vAPercAfterDisc!) {
            maxValueInList = i.vAPercAfterDisc!;
          }
        }
        return maxValueInList;
      case "VA Amount":
        final lineData =
            getMaxXValueAccGraphType(saleSummaryList: saleSummaryList);
        for (var i in lineData) {
          if (maxValueInList < i.vAAfterDisc!) {
            maxValueInList = i.vAAfterDisc!;
          }
        }
        return maxValueInList;
      default:
        final lineData =
            getMaxXValueAccGraphType(saleSummaryList: saleSummaryList);
        for (var i in lineData) {
          if (maxValueInList < i.diaCash!) {
            maxValueInList = i.diaCash!;
          }
        }
        return maxValueInList;
    }
  }

  void updateYAxisValues() {
    double _maxValueInList = 0.0;
    double _yAxisInterval = 0;

    _maxValueInList =
        getYAxisLineData(saleSummaryList: widget.salesSummaryList);

    // Round max value to the nearest 100's multiple
    _maxValueInList = ((_maxValueInList / 100).ceil()) * 100;
    _yAxisInterval = _maxValueInList / 10;

    setState(() {
      maxY = _maxValueInList;
      yAxisInterval = _yAxisInterval == 0 ? 10 : _yAxisInterval;
    });
  }

  List<SalesSummaryModel> getMaxXValueAccGraphType(
      {required List<SalesSummaryModel> saleSummaryList}) {
    List<SalesSummaryModel> summaryList = [];
    switch (widget.graphType) {
      case GraphType.monthly:
        Map<String, dynamic> monthlySales = {};

        for (var sale in saleSummaryList) {
          DateTime invDate = DateTime.parse(sale.invDate!);
          String monthKey = '${invDate.year}-${invDate.month}';

          if (!monthlySales.containsKey(monthKey)) {
            monthlySales[monthKey] = {
              "Qty": 0,
              "Gwt": 0.0,
              "DiaWt": 0.0,
              "StoneWt": 0.0,
              "NetWt": 0.0,
              "VAPercAfterDisc": 0.0,
              "VAAfterDisc": 0.0,
              "StoneCash": 0.0,
              "DiaCash": 0.0,
              "MetalCash": 0.0,
            };
          }

          monthlySales[monthKey]!['Gwt'] =
              (monthlySales[monthKey]!['Gwt'] ?? 0) + sale.gwt!;
          monthlySales[monthKey]!['NetWt'] =
              (monthlySales[monthKey]!['NetWt'] ?? 0) + sale.netWt!;
          monthlySales[monthKey]!['Qty'] =
              (monthlySales[monthKey]!['Qty'] ?? 0) + sale.qty!;
          monthlySales[monthKey]!['DiaWt'] =
              (monthlySales[monthKey]!['DiaWt'] ?? 0) + sale.diaWt!;
          monthlySales[monthKey]!['StoneWt'] =
              (monthlySales[monthKey]!['StoneWt'] ?? 0) + sale.stoneWt!;
          monthlySales[monthKey]!['VAPercAfterDisc'] =
              (monthlySales[monthKey]!['VAPercAfterDisc'] ?? 0) +
                  sale.vAPercAfterDisc!;
          monthlySales[monthKey]!['VAAfterDisc'] =
              (monthlySales[monthKey]!['VAAfterDisc'] ?? 0) + sale.vAAfterDisc!;
          monthlySales[monthKey]!['StoneCash'] =
              (monthlySales[monthKey]!['StoneCash'] ?? 0) + sale.stoneCash!;
          monthlySales[monthKey]!['DiaCash'] =
              (monthlySales[monthKey]!['DiaCash'] ?? 0) + sale.diaCash!;
          monthlySales[monthKey]!['MetalCash'] =
              (monthlySales[monthKey]!['MetalCash'] ?? 0) + sale.metalCash!;
        }

        List<SalesSummaryModel> monthlySaleSummaries = [];
        for (var key in monthlySales.keys) {
          monthlySaleSummaries
              .add(SalesSummaryModel.fromJson(monthlySales[key]));
        }

        return monthlySaleSummaries;

      case GraphType.yearly:
        Map<String, dynamic> yearlySales = {};

        for (var sale in saleSummaryList) {
          DateTime invDate = DateTime.parse(sale.invDate!);
          String yearKey = '${invDate.year}';

          if (!yearlySales.containsKey(yearKey)) {
            yearlySales[yearKey] = {
              "Qty": 0,
              "Gwt": 0.0,
              "DiaWt": 0.0,
              "StoneWt": 0.0,
              "NetWt": 0.0,
              "VAPercAfterDisc": 0.0,
              "VAAfterDisc": 0.0,
              "StoneCash": 0.0,
              "DiaCash": 0.0,
              "MetalCash": 0.0,
            };
          }

          yearlySales[yearKey]!['Gwt'] =
              (yearlySales[yearKey]!['Gwt'] ?? 0) + sale.gwt!;
          yearlySales[yearKey]!['NetWt'] =
              (yearlySales[yearKey]!['NetWt'] ?? 0) + sale.netWt!;
          yearlySales[yearKey]!['Qty'] =
              (yearlySales[yearKey]!['Qty'] ?? 0) + sale.qty!;
          yearlySales[yearKey]!['DiaWt'] =
              (yearlySales[yearKey]!['DiaWt'] ?? 0) + sale.diaWt!;
          yearlySales[yearKey]!['StoneWt'] =
              (yearlySales[yearKey]!['StoneWt'] ?? 0) + sale.stoneWt!;
          yearlySales[yearKey]!['VAPercAfterDisc'] =
              (yearlySales[yearKey]!['VAPercAfterDisc'] ?? 0) +
                  sale.vAPercAfterDisc!;
          yearlySales[yearKey]!['VAAfterDisc'] =
              (yearlySales[yearKey]!['VAAfterDisc'] ?? 0) + sale.vAAfterDisc!;
          yearlySales[yearKey]!['StoneCash'] =
              (yearlySales[yearKey]!['StoneCash'] ?? 0) + sale.stoneCash!;
          yearlySales[yearKey]!['DiaCash'] =
              (yearlySales[yearKey]!['DiaCash'] ?? 0) + sale.diaCash!;
          yearlySales[yearKey]!['MetalCash'] =
              (yearlySales[yearKey]!['MetalCash'] ?? 0) + sale.metalCash!;
        }

        List<SalesSummaryModel> yearlySaleSummaries = [];
        for (var key in yearlySales.keys) {
          yearlySaleSummaries.add(SalesSummaryModel.fromJson(yearlySales[key]));
        }

        return yearlySaleSummaries;

      default:
        return saleSummaryList;
    }
  }

//YAXIS ==================================================

//Graph Line data ========================

  List<SalesSummaryModel> getGraphLineData(
      {required List<SalesSummaryModel> saleSummaryList,
      required String filter,
      required String multiSelect}) {
    switch (widget.graphType) {
      case GraphType.monthly:
        final filterItemSummaryList =
            getLineAccToFilters(filter: filter, multiSelect: multiSelect);
        Map<String, dynamic> monthlySales = {};

        for (var sale in filterItemSummaryList) {
          DateTime invDate = DateTime.parse(sale.invDate!);
          String monthKey = '${invDate.year}-${invDate.month}';

          if (!monthlySales.containsKey(monthKey)) {
            monthlySales[monthKey] = {
              "Qty": 0,
              "Gwt": 0.0,
              "DiaWt": 0.0,
              "StoneWt": 0.0,
              "NetWt": 0.0,
              "VAPercAfterDisc": 0.0,
              "VAAfterDisc": 0.0,
              "StoneCash": 0.0,
              "DiaCash": 0.0,
              "MetalCash": 0.0,
            };
          }

          monthlySales[monthKey]!['Gwt'] =
              (monthlySales[monthKey]!['Gwt'] ?? 0) + sale.gwt!;
          monthlySales[monthKey]!['NetWt'] =
              (monthlySales[monthKey]!['NetWt'] ?? 0) + sale.netWt!;
          monthlySales[monthKey]!['Qty'] =
              (monthlySales[monthKey]!['Qty'] ?? 0) + sale.qty!;
          monthlySales[monthKey]!['DiaWt'] =
              (monthlySales[monthKey]!['DiaWt'] ?? 0) + sale.diaWt!;
          monthlySales[monthKey]!['StoneWt'] =
              (monthlySales[monthKey]!['StoneWt'] ?? 0) + sale.stoneWt!;
          monthlySales[monthKey]!['VAPercAfterDisc'] =
              (monthlySales[monthKey]!['VAPercAfterDisc'] ?? 0) +
                  sale.vAPercAfterDisc!;
          monthlySales[monthKey]!['VAAfterDisc'] =
              (monthlySales[monthKey]!['VAAfterDisc'] ?? 0) + sale.vAAfterDisc!;
          monthlySales[monthKey]!['StoneCash'] =
              (monthlySales[monthKey]!['StoneCash'] ?? 0) + sale.stoneCash!;
          monthlySales[monthKey]!['DiaCash'] =
              (monthlySales[monthKey]!['DiaCash'] ?? 0) + sale.diaCash!;
          monthlySales[monthKey]!['MetalCash'] =
              (monthlySales[monthKey]!['MetalCash'] ?? 0) + sale.metalCash!;
        }

        List<SalesSummaryModel> monthlySaleSummaries = [];
        for (var key in monthlySales.keys) {
          monthlySaleSummaries
              .add(SalesSummaryModel.fromJson(monthlySales[key]));
        }

        return monthlySaleSummaries;

      case GraphType.yearly:
        final filterSummaryList =
            getLineAccToFilters(filter: filter, multiSelect: multiSelect);

        Map<String, dynamic> yearlySales = {};

        for (var sale in filterSummaryList) {
          DateTime invDate = DateTime.parse(sale.invDate!);
          String yearKey = '${invDate.year}';

          if (!yearlySales.containsKey(yearKey)) {
            yearlySales[yearKey] = {
              "Qty": 0,
              "Gwt": 0.0,
              "DiaWt": 0.0,
              "StoneWt": 0.0,
              "NetWt": 0.0,
              "VAPercAfterDisc": 0.0,
              "VAAfterDisc": 0.0,
              "StoneCash": 0.0,
              "DiaCash": 0.0,
              "MetalCash": 0.0,
            };
          }

          yearlySales[yearKey]!['Gwt'] =
              (yearlySales[yearKey]!['Gwt'] ?? 0) + sale.gwt!;
          yearlySales[yearKey]!['NetWt'] =
              (yearlySales[yearKey]!['NetWt'] ?? 0) + sale.netWt!;
          yearlySales[yearKey]!['Qty'] =
              (yearlySales[yearKey]!['Qty'] ?? 0) + sale.qty!;
          yearlySales[yearKey]!['DiaWt'] =
              (yearlySales[yearKey]!['DiaWt'] ?? 0) + sale.diaWt!;
          yearlySales[yearKey]!['StoneWt'] =
              (yearlySales[yearKey]!['StoneWt'] ?? 0) + sale.stoneWt!;
          yearlySales[yearKey]!['VAPercAfterDisc'] =
              (yearlySales[yearKey]!['VAPercAfterDisc'] ?? 0) +
                  sale.vAPercAfterDisc!;
          yearlySales[yearKey]!['VAAfterDisc'] =
              (yearlySales[yearKey]!['VAAfterDisc'] ?? 0) + sale.vAAfterDisc!;
          yearlySales[yearKey]!['StoneCash'] =
              (yearlySales[yearKey]!['StoneCash'] ?? 0) + sale.stoneCash!;
          yearlySales[yearKey]!['DiaCash'] =
              (yearlySales[yearKey]!['DiaCash'] ?? 0) + sale.diaCash!;
          yearlySales[yearKey]!['MetalCash'] =
              (yearlySales[yearKey]!['MetalCash'] ?? 0) + sale.metalCash!;
        }

        List<SalesSummaryModel> yearlySaleSummaries = [];
        for (var key in yearlySales.keys) {
          yearlySaleSummaries.add(SalesSummaryModel.fromJson(yearlySales[key]));
        }

        return yearlySaleSummaries;

      default:
        final filterItemSummaryList =
            getLineAccToFilters(filter: filter, multiSelect: multiSelect);
        return filterItemSummaryList;
    }
  }

  List<SalesSummaryModel> getLineAccToFilters(
      {required String filter, required String multiSelect}) {
    List summaryList = widget.salesSummaryList.map((e) => e.toJson()).toList();

    List allSummaryNoSaleList = [];

    switch (multiSelect) {
      case MultiSelectType.itemName:
        allSummaryNoSaleList.addAll(summaryList
            .where((summary) => summary[MultiSelectType.itemName] == filter));
        return allSummaryNoSaleList
            .map((e) => SalesSummaryModel.fromJson(e))
            .toList();

      case MultiSelectType.categoryName:
        allSummaryNoSaleList.addAll(summaryList.where(
            (summary) => summary[MultiSelectType.categoryName] == filter));
        return allSummaryNoSaleList
            .map((e) => SalesSummaryModel.fromJson(e))
            .toList();
      default:
        return [];
    }
  }

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

//========================================

  String getMonths({required int xValue}) {
    switch (xValue) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "Jun";
      case 7:
        return "Jul";
      case 8:
        return "Aug";
      case 9:
        return "Sep";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      case 13:
        return "Jan";
      case 14:
        return "Feb";
      case 15:
        return "Mar";
      case 16:
        return "Apr";
      case 17:
        return "May";
      case 18:
        return "Jun";
      default:
        return "";
    }
  }

  List<LineTooltipItem> buildTooltip(List<LineBarSpot> touchedSpots) {
    return touchedSpots.map((LineBarSpot touchedSpot) {
      double dateValue = touchedSpot.x;
      double dataValue = touchedSpot.y;

      String formattedDate = '';

      if (widget.graphType == GraphType.daysInMonth) {
        DateFormat dateFormat = DateFormat('dd-MMM-yyyy');
        DateTime startDateTime = dateFormat.parse(widget.paramModel.dateFrom);

        DateTime startDate = startDateTime;
        DateTime actualDate =
            startDate.add(Duration(days: (dateValue - minX).toInt()));

        formattedDate = DateFormat('dd-MM-yyyy').format(actualDate);
      }

      return LineTooltipItem(
        '$formattedDate\n${dataValue.toStringAsFixed(3)}',
        TextStyle(
          color: touchedSpot.bar.color, // Use the color of the touched spot
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      );
    }).toList();
  }
}
