import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/page_models/theme_provider.dart';
import '../../ui/shared/styles/gradients.dart';

class SearchBar extends StatelessWidget {
  final Function(String text) onSearch;
  final TextEditingController controller;

  const SearchBar({Key key, @required this.onSearch, this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 9, vertical: 5),
        width: double.infinity,
        height: 46,
        decoration: BoxDecoration(
          border: Border.all(width: .7, color: Colors.grey.withOpacity(.7)),
          borderRadius: BorderRadius.circular(55.34481430053711),
          // gradient: theme.isDark ? Gradients.sideBlackGradient : Gradients.secandaryGradient,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.only(start: 14),
          child: TextField(
            controller: controller,
            // style: TextStyle(color: theme.isDark ? Colors.white70 : Colors.black87),
            onChanged: (text) => onSearch(text),
            decoration: InputDecoration(
              border: InputBorder.none,
              suffixIcon: Icon(Icons.search, color: Color(0xffa8a8a8)),
            ),
          ),
        ));
  }
}
