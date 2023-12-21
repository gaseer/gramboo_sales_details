class MetalTypeModel {
  final String valueMember;
  final String displayMember;

//<editor-fold desc="Data Methods">
  const MetalTypeModel({
    required this.valueMember,
    required this.displayMember,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetalTypeModel &&
          runtimeType == other.runtimeType &&
          valueMember == other.valueMember &&
          displayMember == other.displayMember);

  @override
  int get hashCode => valueMember.hashCode ^ displayMember.hashCode;

  @override
  String toString() {
    return 'MetalTypeModel{' +
        ' valueMember: $valueMember,' +
        ' displayMember: $displayMember,' +
        '}';
  }

  MetalTypeModel copyWith({
    String? valueMember,
    String? displayMember,
  }) {
    return MetalTypeModel(
      valueMember: valueMember ?? this.valueMember,
      displayMember: displayMember ?? this.displayMember,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'valueMember': valueMember,
      'displayMember': displayMember,
    };
  }

  factory MetalTypeModel.fromMap(Map<String, dynamic> map) {
    return MetalTypeModel(
      valueMember: map['valueMember'] as String,
      displayMember: map['displayMember'] as String,
    );
  }

//</editor-fold>
}
