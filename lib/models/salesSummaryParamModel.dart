class SalesSummaryParamsModel {
  final String dateFrom;
  final String dateTo;
  final int branchId;
  final String? multiSelectName;
  final List<String>? multiSelectList;

  SalesSummaryParamsModel(
      {required this.dateFrom,
      required this.dateTo,
      required this.branchId,
      required this.multiSelectName,
      required this.multiSelectList});

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
      multiSelectName: map["multiSelectName"],
      branchId: map['branchId'] ??
          0, // Change to 0 if it should be an int, or handle accordingly
      multiSelectList: _convertList(map['multiSelectList']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dateFrom': dateFrom,
      'dateTo': dateTo,
      'branchId': branchId,
      'multiSelectList': multiSelectList,
      'multiSelectName': multiSelectName
    };
  }

  SalesSummaryParamsModel copyWith(
      {String? dateFrom,
      String? dateTo,
      int? branchId,
      List<String>? multiSelectList,
      String? multiSelectName}) {
    return SalesSummaryParamsModel(
        dateFrom: dateFrom ?? this.dateFrom,
        dateTo: dateTo ?? this.dateTo,
        branchId: branchId ?? this.branchId,
        multiSelectName: multiSelectName ?? this.multiSelectName,
        multiSelectList: multiSelectList ?? this.multiSelectList);
  }
}
