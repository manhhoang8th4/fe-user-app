import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // 👈 Thêm import
class CustomSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final void Function(String)? onChanged;

  const CustomSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  CustomSearchBarState createState() => CustomSearchBarState();
}

class CustomSearchBarState extends State<CustomSearchBar> {
  bool isExpanded = false;
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isExpanded = !isExpanded;
          if (!isExpanded) {
            _focusNode.unfocus();
          }
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isExpanded ? Colors.white : Colors.grey[200],
        ),
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: FocusScope(
          node: FocusScopeNode(),
          child: Row(
            children: [
              const Icon(Icons.search),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  focusNode: _focusNode,
                  controller: widget.controller,
                  decoration: InputDecoration(
                    hintText: 'search.hint'.tr(), // 👈 Sử dụng EasyLocalization
                    border: InputBorder.none,
                  ),
                  autofocus: false,
                  onChanged: widget.onChanged,
                ),
              ),
              GestureDetector(
                onTap: () {
                  widget.controller.clear();
                  _focusNode.unfocus();
                },
                child: const Icon(Icons.close),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
