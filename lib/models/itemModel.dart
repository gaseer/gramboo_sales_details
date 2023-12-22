class ItemModel {
  final String valueMember;
  final String displayMember;

//<editor-fold desc="Data Methods">
  const ItemModel({
    required this.valueMember,
    required this.displayMember,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ItemModel &&
          runtimeType == other.runtimeType &&
          valueMember == other.valueMember &&
          displayMember == other.displayMember);

  @override
  int get hashCode => valueMember.hashCode ^ displayMember.hashCode;

  @override
  String toString() {
    return 'ItemModel{' +
        ' valueMember: $valueMember,' +
        ' displayMember: $displayMember,' +
        '}';
  }

  ItemModel copyWith({
    String? valueMember,
    String? displayMember,
  }) {
    return ItemModel(
      valueMember: valueMember ?? this.valueMember,
      displayMember: displayMember ?? this.displayMember,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'valueMember': this.valueMember,
      'displayMember': this.displayMember,
    };
  }

  factory ItemModel.fromMap(Map<String, dynamic> map) {
    return ItemModel(
      valueMember: map['valueMember'] as String,
      displayMember: map['displayMember'] as String,
    );
  }

//</editor-fold>
}
