class SalesTypeModel {
  //<editor-fold desc="Data Methods">
  final String valueMember;
  final String displayMember;

  const SalesTypeModel({
    required this.valueMember,
    required this.displayMember,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalesTypeModel &&
          runtimeType == other.runtimeType &&
          valueMember == other.valueMember &&
          displayMember == other.displayMember);

  @override
  int get hashCode => valueMember.hashCode ^ displayMember.hashCode;

  @override
  String toString() {
    return 'SalesTypeModel{' +
        ' valueMember: $valueMember,' +
        ' displayMember: $displayMember,' +
        '}';
  }

  SalesTypeModel copyWith({
    String? valueMember,
    String? displayMember,
  }) {
    return SalesTypeModel(
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

  factory SalesTypeModel.fromMap(Map<String, dynamic> map) {
    return SalesTypeModel(
      valueMember: map['valueMember'] as String,
      displayMember: map['displayMember'] as String,
    );
  }
}

//</editor-fold>
