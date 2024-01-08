import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gramboo_sales_details/core/theme/theme.dart';

class CustomDropDown extends ConsumerStatefulWidget {
  final List<String> dropList;
  final Function(String?)? onChanged;
  final StateProvider<String?> selectedValueProvider;

  const CustomDropDown(
      {Key? key,
      required this.dropList,
      required this.selectedValueProvider,
      this.onChanged})
      : super(key: key);

  @override
  ConsumerState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends ConsumerState<CustomDropDown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: const Row(
          children: [
            Icon(
              Icons.list,
              size: 16,
              color: Palette.textColor,
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Text(
                'Select Item',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Palette.textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        items: widget.dropList
            .map(
              (String item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Palette.textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
            .toList(),
        value: ref.watch(widget.selectedValueProvider),
        onChanged: widget.onChanged ??
            (String? value) {
              ref
                  .read(widget.selectedValueProvider.notifier)
                  .update((state) => value);
            },
        buttonStyleData: ButtonStyleData(
          height: 50,
          width: 160,
          padding: const EdgeInsets.only(left: 14, right: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.black26,
            ),
            color: Palette.cardColor,
          ),
          elevation: 2,
        ),
        iconStyleData: const IconStyleData(
          icon: Icon(
            Icons.arrow_forward_ios_outlined,
          ),
          iconSize: 14,
          iconEnabledColor: Palette.iconColor,
          iconDisabledColor: Colors.grey,
        ),
        dropdownStyleData: DropdownStyleData(
          maxHeight: 200,
          width: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: Palette.cardColor,
          ),
          offset: const Offset(-20, 0),
          scrollbarTheme: ScrollbarThemeData(
            radius: const Radius.circular(40),
            thickness: MaterialStateProperty.all<double>(6),
            thumbVisibility: MaterialStateProperty.all<bool>(true),
          ),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 14, right: 14),
        ),
      ),
    );
  }
}
