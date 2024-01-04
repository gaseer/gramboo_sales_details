import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gramboo_sales_details/core/theme/theme.dart';
import 'package:gramboo_sales_details/features/sales_report/data/graphType.dart';
import 'package:intl/intl.dart';

import '../../../models/salesSummaryParamModel.dart';
import '../../../models/salesSummary_model.dart';
import '../data/multiSelectType.dart';

class BarCharWidget extends StatefulWidget {
  final SalesSummaryParamsModel paramModel;
  final List<String> filters;
  final String multiSelect;
  final List<SalesSummaryModel> salesSummaryList;
  final String yAxisConstraint;
  final List<Color> colorList;
  final String graphType;
  const BarCharWidget(
      {super.key,
      required this.yAxisConstraint,
      required this.filters,
      required this.salesSummaryList,
      required this.paramModel,
      required this.colorList,
      required this.multiSelect,
      required this.graphType});

  List<Color> get availableColors => const <Color>[
        Colors.green,
        Colors.red,
        Colors.blue,
        Colors.black,
        Colors.brown,
        Colors.deepOrange,
        Colors.amber,
        Colors.cyanAccent,
        Colors.deepPurple
      ];

  final Color barBackgroundColor = Colors.white;
  final Color barColor = Colors.red;
  final Color touchedBarColor = Colors.green;

  @override
  State<StatefulWidget> createState() => BarCharWidgetState();
}

class BarCharWidgetState extends State<BarCharWidget> {
  final Duration animDuration = const Duration(milliseconds: 250);

  double maxYValue = 0.0;
  double maxXValue = 0.0;
  double minXValue = 0.0;
  double yAxisInterval = 0;
  double xAxisInterval = 0;
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BarChart(
                      mainBarData(),
                      swapAnimationDuration: animDuration,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.blueGrey,
          tooltipMargin: -10,
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              print(value);
              return Text("Today");
            },
            reservedSize: 25,
            interval: xAxisInterval == 0 ? 10 : xAxisInterval,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            reservedSize: 30,
            showTitles: true,
            getTitlesWidget: getLeftTilesData(),
            interval: yAxisInterval,
          ),
        ),
      ),
      borderData: FlBorderData(
        border: const Border(
            top: BorderSide.none,
            left: BorderSide(color: Colors.black),
            bottom: BorderSide(color: Colors.black)),
        show: true,
      ),
      barGroups: showingGroups(
        [
          getBarAccToFilters(),
        ],
      ),
      gridData: FlGridData(show: false),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: Palette.borderColor)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxYValue,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  //bottom line and data

  List<BarChartGroupData> showingGroups(List<List<double>> valuesList) {
    final List<BarChartGroupData> groups = [];
    for (int i = 0; i < valuesList.length; i++) {
      final List<double> values = valuesList[i];
      final List<BarChartRodData> bars = [];
      for (int j = 0; j < values.length; j++) {
        bars.add(BarChartRodData(
          color: widget.availableColors[j % widget.availableColors.length],
          width: 22,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          toY: values[j],
        ));
      }
      groups.add(BarChartGroupData(
        x: i,
        barRods: bars,
      ));
    }

    return groups;
  }

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

  // getBottomTileData() {
  //   DateFormat dateFormat = DateFormat("dd-MMM-yyyy");
  //   String startDateString = widget.paramModel.dateFrom;
  //   String endDateString = widget.paramModel.dateTo;
  //   DateTime startDateDateTime = dateFormat.parse(startDateString);
  //   DateTime endDateDateTime = dateFormat.parse(endDateString);
  //   int numberOfDays = endDateDateTime.difference(startDateDateTime).inDays + 1;
  //
  //   setState(() {
  //     minXValue = startDateDateTime.day.toDouble();
  //     maxXValue = numberOfDays.toDouble() + minXValue - 1;
  //     xAxisInterval = 1;
  //   });
  // }

  getBarAccToFilters() {
    List<double> barList = [];

    for (String filter in widget.filters) {
      double dataValue = 0.0;
      final dataList =
          getLineAccToFilters(filter: filter, multiSelect: widget.multiSelect);

      for (var i in dataList) {
        dataValue = getYAxisValue(model: i);
      }

      barList.add(dataValue);
    }
    return barList;
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
}
