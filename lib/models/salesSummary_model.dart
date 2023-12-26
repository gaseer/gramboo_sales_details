class SalesSummaryModel {
  String? invDate;
  int? itemCategoryId;
  String? categoryName;
  int? branchId;
  String? branchName;
  int? qty;
  double? gwt;
  double? diaWt;
  double? stoneWt;
  double? netWt;
  double? metalCash;
  double? diaCash;
  double? stoneCash;
  double? vAAfterDisc;
  double? vAPercAfterDisc;

  SalesSummaryModel(
      {this.invDate,
      this.itemCategoryId,
      this.categoryName,
      this.branchId,
      this.branchName,
      this.qty,
      this.gwt,
      this.diaWt,
      this.stoneWt,
      this.netWt,
      this.metalCash,
      this.diaCash,
      this.stoneCash,
      this.vAAfterDisc,
      this.vAPercAfterDisc});

  SalesSummaryModel.fromJson(Map<String, dynamic> json) {
    invDate = json['InvDate'];
    itemCategoryId = json['ItemCategoryId'];
    categoryName = json['Category Name'];
    branchId = json['Branch_id'];
    branchName = json['BranchName'];
    qty = json['Qty'];
    gwt = json['Gwt'];
    diaWt = json['DiaWt'];
    stoneWt = json['StoneWt'];
    netWt = json['NetWt'];
    metalCash = json['MetalCash'];
    diaCash = json['DiaCash'];
    stoneCash = json['StoneCash'];
    vAAfterDisc = json['VAAfterDisc'];
    vAPercAfterDisc = json['VAPercAfterDisc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['InvDate'] = invDate;
    data['ItemCategoryId'] = itemCategoryId;
    data['Category Name'] = categoryName;
    data['Branch_id'] = branchId;
    data['BranchName'] = branchName;
    data['Qty'] = qty;
    data['Gwt'] = gwt;
    data['DiaWt'] = diaWt;
    data['StoneWt'] = stoneWt;
    data['NetWt'] = netWt;
    data['MetalCash'] = metalCash;
    data['DiaCash'] = diaCash;
    data['StoneCash'] = stoneCash;
    data['VAAfterDisc'] = vAAfterDisc;
    data['VAPercAfterDisc'] = vAPercAfterDisc;
    return data;
  }
}
