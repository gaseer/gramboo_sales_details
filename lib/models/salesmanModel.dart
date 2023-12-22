class SalesmanModel {
  final String valueMember;
  final String displayMember;

//<editor-fold desc="Data Methods">
  const SalesmanModel({
    required this.valueMember,
    required this.displayMember,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SalesmanModel &&
          runtimeType == other.runtimeType &&
          valueMember == other.valueMember &&
          displayMember == other.displayMember);

  @override
  int get hashCode => valueMember.hashCode ^ displayMember.hashCode;

  @override
  String toString() {
    return 'SalesmanModel{' +
        ' valueMember: $valueMember,' +
        ' displayMember: $displayMember,' +
        '}';
  }

  SalesmanModel copyWith({
    String? valueMember,
    String? displayMember,
  }) {
    return SalesmanModel(
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

  factory SalesmanModel.fromMap(Map<String, dynamic> map) {
    return SalesmanModel(
      valueMember: map['valueMember'] as String,
      displayMember: map['displayMember'] as String,
    );
  }

//</editor-fold>
}
