class SalesSummaryParamsModel {
  final String dateFrom;
  final String dateTo;
  final int branchId;
  final List<String>? itemCategory;
  final List<String>? itemName;
  final List<String>? metalType;
  final List<String>? modelName;
  final List<String>? salesManId;
  final List<String>? measurementName;
  final List<String>? salesMode;
  final List<String>? salesCategory;

  SalesSummaryParamsModel({
    required this.dateFrom,
    required this.dateTo,
    required this.branchId,
    this.itemCategory,
    this.itemName,
    this.metalType,
    this.modelName,
    this.salesManId,
    this.measurementName,
    this.salesMode,
    this.salesCategory,
  });

  factory SalesSummaryParamsModel.fromMap(Map<String, dynamic> map) {
    List<String> _convertList(dynamic itemList) {
      if (itemList is List<dynamic>) {
        return itemList.cast<String>(); // Converts dynamic list to List<String>
      }
      return [];
    }

    return SalesSummaryParamsModel(
        dateFrom: map['dateFrom'] ?? '',
        dateTo: map['dateTo'] ?? '',
        branchId: map['branchId'] ??
            0, // Change to 0 if it should be an int, or handle accordingly
        itemCategory: _convertList(map['itemCategory']),
        itemName: _convertList(map['itemNAme']),
        metalType: _convertList(map['MetalType']),
        modelName: _convertList(map['ModelName']),
        salesManId: _convertList(map['salesmanID']),
        measurementName: _convertList(map['MeasurementName']),
        salesMode: _convertList(map['SalesMode']),
        salesCategory: _convertList(map["SalesCategory"]));
  }

  Map<String, dynamic> toMap() {
    return {
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'branchId': branchId,
      'itemCategory': itemCategory,
      'itemNAme': itemName,
      'MetalType': metalType,
      'ModelName': modelName,
      'salesmanID': salesManId,
      'MeasurementName': measurementName,
      'SalesMode': salesMode,
      "SalesCategory": salesCategory
    };
  }

  SalesSummaryParamsModel copyWith(
      {String? dateFrom,
      String? dateTo,
      int? branchId,
      List<String>? itemCategory,
      List<String>? itemName,
      List<String>? metalType,
      List<String>? modelName,
      List<String>? salesManId,
      List<String>? measurementName,
      List<String>? salesMode,
      List<String>? salesCategory}) {
    return SalesSummaryParamsModel(
        dateFrom: dateFrom ?? this.dateFrom,
        dateTo: dateTo ?? this.dateTo,
        branchId: branchId ?? this.branchId,
        itemCategory: itemCategory ?? this.itemCategory,
        itemName: itemName ?? this.itemName,
        metalType: metalType ?? this.metalType,
        modelName: modelName ?? this.modelName,
        salesManId: salesManId ?? this.salesManId,
        measurementName: measurementName ?? this.measurementName,
        salesMode: salesMode ?? this.salesMode,
        salesCategory: salesCategory ?? this.salesCategory);
  }
}
