class SalesSummaryModel {
  final DateTime invDate;
  final int itemCategoryId;
  final String categoryName;
  final int branchId;
  final String branchName;
  final int qty;
  final double gwt;
  final int diaWt;
  final int stoneWt;
  final double netWt;
  final double metalCash;
  final int diaCash;
  final int stoneCash;
  final double vaAfterDisc;
  final double vaPercAfterDisc;

//<editor-fold desc="Data Methods">
  const SalesSummaryModel({
    required this.invDate,
    required this.itemCategoryId,
    required this.categoryName,
    required this.branchId,
    required this.branchName,
    required this.qty,
    required this.gwt,
    required this.diaWt,
    required this.stoneWt,
    required this.netWt,
    required this.metalCash,
    required this.diaCash,
    required this.stoneCash,
    required this.vaAfterDisc,
    required this.vaPercAfterDisc,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalesSummaryModel &&
          runtimeType == other.runtimeType &&
          invDate == other.invDate &&
          itemCategoryId == other.itemCategoryId &&
          categoryName == other.categoryName &&
          branchId == other.branchId &&
          branchName == other.branchName &&
          qty == other.qty &&
          gwt == other.gwt &&
          diaWt == other.diaWt &&
          stoneWt == other.stoneWt &&
          netWt == other.netWt &&
          metalCash == other.metalCash &&
          diaCash == other.diaCash &&
          stoneCash == other.stoneCash &&
          vaAfterDisc == other.vaAfterDisc &&
          vaPercAfterDisc == other.vaPercAfterDisc);

  @override
  int get hashCode =>
      invDate.hashCode ^
      itemCategoryId.hashCode ^
      categoryName.hashCode ^
      branchId.hashCode ^
      branchName.hashCode ^
      qty.hashCode ^
      gwt.hashCode ^
      diaWt.hashCode ^
      stoneWt.hashCode ^
      netWt.hashCode ^
      metalCash.hashCode ^
      diaCash.hashCode ^
      stoneCash.hashCode ^
      vaAfterDisc.hashCode ^
      vaPercAfterDisc.hashCode;

  @override
  String toString() {
    return 'SalesSummaryModel{' +
        ' invDate: $invDate,' +
        ' itemCategoryId: $itemCategoryId,' +
        ' categoryName: $categoryName,' +
        ' branchId: $branchId,' +
        ' branchName: $branchName,' +
        ' qty: $qty,' +
        ' gwt: $gwt,' +
        ' diaWt: $diaWt,' +
        ' stoneWt: $stoneWt,' +
        ' netWt: $netWt,' +
        ' metalCash: $metalCash,' +
        ' diaCash: $diaCash,' +
        ' stoneCash: $stoneCash,' +
        ' vaAfterDisc: $vaAfterDisc,' +
        ' vaPercAfterDisc: $vaPercAfterDisc,' +
        '}';
  }

  SalesSummaryModel copyWith({
    DateTime? invDate,
    int? itemCategoryId,
    String? categoryName,
    int? branchId,
    String? branchName,
    int? qty,
    double? gwt,
    int? diaWt,
    int? stoneWt,
    double? netWt,
    double? metalCash,
    int? diaCash,
    int? stoneCash,
    double? vaAfterDisc,
    double? vaPercAfterDisc,
  }) {
    return SalesSummaryModel(
      invDate: invDate ?? this.invDate,
      itemCategoryId: itemCategoryId ?? this.itemCategoryId,
      categoryName: categoryName ?? this.categoryName,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      qty: qty ?? this.qty,
      gwt: gwt ?? this.gwt,
      diaWt: diaWt ?? this.diaWt,
      stoneWt: stoneWt ?? this.stoneWt,
      netWt: netWt ?? this.netWt,
      metalCash: metalCash ?? this.metalCash,
      diaCash: diaCash ?? this.diaCash,
      stoneCash: stoneCash ?? this.stoneCash,
      vaAfterDisc: vaAfterDisc ?? this.vaAfterDisc,
      vaPercAfterDisc: vaPercAfterDisc ?? this.vaPercAfterDisc,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'invDate': this.invDate,
      'itemCategoryId': this.itemCategoryId,
      'categoryName': this.categoryName,
      'branchId': this.branchId,
      'branchName': this.branchName,
      'qty': this.qty,
      'gwt': this.gwt,
      'diaWt': this.diaWt,
      'stoneWt': this.stoneWt,
      'netWt': this.netWt,
      'metalCash': this.metalCash,
      'diaCash': this.diaCash,
      'stoneCash': this.stoneCash,
      'vaAfterDisc': this.vaAfterDisc,
      'vaPercAfterDisc': this.vaPercAfterDisc,
    };
  }

  factory SalesSummaryModel.fromMap(Map<String, dynamic> map) {
    return SalesSummaryModel(
      invDate: map['invDate'] as DateTime,
      itemCategoryId: map['itemCategoryId'] ?? 0,
      categoryName: map['categoryName'] ?? "",
      branchId: map['branchId'] as int,
      branchName: map['branchName'] as String,
      qty: map['qty'] as int,
      gwt: map['gwt'] as double,
      diaWt: map['diaWt'] as int,
      stoneWt: map['stoneWt'] as int,
      netWt: map['netWt'] as double,
      metalCash: map['metalCash'] as double,
      diaCash: map['diaCash'] as int,
      stoneCash: map['stoneCash'] as int,
      vaAfterDisc: map['vaAfterDisc'] as double,
      vaPercAfterDisc: map['vaPercAfterDisc'] as double,
    );
  }

//</editor-fold>
}
