class BranchModel {
  final int userId;
  final String userName;
  final int branchId;
  final String branchName;

//<editor-fold desc="Data Methods">
  const BranchModel({
    required this.userId,
    required this.userName,
    required this.branchId,
    required this.branchName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BranchModel &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          userName == other.userName &&
          branchId == other.branchId &&
          branchName == other.branchName);

  @override
  int get hashCode =>
      userId.hashCode ^
      userName.hashCode ^
      branchId.hashCode ^
      branchName.hashCode;

  @override
  String toString() {
    return 'BranchModel{' +
        ' userId: $userId,' +
        ' userName: $userName,' +
        ' branchId: $branchId,' +
        ' branchName: $branchName,' +
        '}';
  }

  BranchModel copyWith({
    int? userId,
    String? userName,
    int? branchId,
    String? branchName,
  }) {
    return BranchModel(
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'branchId': branchId,
      'branchName': branchName,
    };
  }

  factory BranchModel.fromMap(Map<String, dynamic> map) {
    return BranchModel(
      userId: map['userId'] as int,
      userName: map['userName'] as String,
      branchId: map['branchId'] as int,
      branchName: map['branchName'] as String,
    );
  }

//</editor-fold>
}
