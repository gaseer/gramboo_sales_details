class CategoryModel {
  final String valueMember;
  final String displayMember;

//<editor-fold desc="Data Methods">
  const CategoryModel({
    required this.valueMember,
    required this.displayMember,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryModel &&
          runtimeType == other.runtimeType &&
          valueMember == other.valueMember &&
          displayMember == other.displayMember);

  @override
  int get hashCode => valueMember.hashCode ^ displayMember.hashCode;

  @override
  String toString() {
    return 'CategoryModel{' +
        ' valueMember: $valueMember,' +
        ' displayMember: $displayMember,' +
        '}';
  }

  CategoryModel copyWith({
    String? valueMember,
    String? displayMember,
  }) {
    return CategoryModel(
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

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      valueMember: map['valueMember'] as String,
      displayMember: map['displayMember'] as String,
    );
  }

//</editor-fold>
}
