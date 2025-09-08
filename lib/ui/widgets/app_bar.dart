import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:flutter/material.dart';

class appBar extends StatelessWidget {
  const appBar({
    Key key,
    @required this.context,
    this.locale,
    @required this.name,
    this.verticalPadding = 20,
    this.horizontalPadding = 20,
    this.showSearch = false,
    this.showFilters = false,
    this.onSearchTap,
    this.onFiltersTap,
  }) : super(key: key);

  final BuildContext context;
  final AppLocalizations locale;
  final String name;
  final double verticalPadding;
  final double horizontalPadding;
  final bool showSearch;
  final VoidCallback onSearchTap;
  final bool showFilters;
  final VoidCallback onFiltersTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding, vertical: verticalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          // back arrow
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              child: Icon(Icons.arrow_back_ios, size: 28, color: Colors.black),
            ),
          ),

          Text(
            locale != null ? locale.get(name) ?? name : name,
            style: TextStyle(
                fontSize: 25,
                color: const Color(0xff313131),
                fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (showSearch)
                Padding(
                  padding: showFilters
                      ? const EdgeInsets.only(right: 20.0)
                      : const EdgeInsets.all(0),
                  child: InkWell(
                      onTap: onSearchTap,
                      child: Icon(
                        Icons.search,
                        size: 26,
                        color: Colors.black,
                      )),
                ),
              if (showFilters)
                InkWell(
                    onTap: onFiltersTap,
                    child: Icon(
                      Icons.filter_list,
                      size: 26,
                      color: Colors.black,
                    )),
            ],
          ),
        ],
      ),
    );
  }
}
