import 'package:flutter/material.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class CustomMultiDropDown extends StatelessWidget {
  final List<MultiSelectItem<Object?>> items;
  const CustomMultiDropDown({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return MultiSelectDialogField(
      items: items,
      // initialValue: _selectedItems,
      searchable: true,
      onConfirm: (values) {
        // setState(() {
        //   _selectedItems = values;
        // });
      },
    );
  }
}
