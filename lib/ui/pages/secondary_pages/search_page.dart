import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/models/category_items.dart';
import 'package:beautydoz/core/page_models/secondary_pages/search_page_model.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/core/services/localization/localization.dart';
import 'package:beautydoz/core/services/screen_util.dart';
import 'package:beautydoz/ui/routes/routes.dart';
import 'package:beautydoz/ui/shared/styles/colors.dart';
import 'package:beautydoz/ui/widgets/items_list_widget.dart';
import 'package:beautydoz/ui/widgets/new_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui_utils/ui_utils.dart';

class SearchPage extends StatelessWidget {
  List<CategoryItems> resultItems;
  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context);

    return FocusWidget(
      child: Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: PreferredSize(
          child: NewAppBar(
            title: 'Search',
            drawer: false,
            returnBtn: true,
            onLanguageChanged: null,
          ),
          preferredSize: Size(ScreenUtil.screenWidthDp, 80),
        ),
        body: BaseWidget<SearchPageModel>(
            model: SearchPageModel(
                auth: Provider.of(context),
                api: Provider.of<Api>(context),
                cartService: Provider.of(context),
                favouriteService: Provider.of(context),
                locale: locale),
            builder: (context, model, child) {
              return Container(
                width: ScreenUtil.screenWidthDp,
                height: ScreenUtil.screenHeightDp,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    searchBar(context, locale, model),
                    model.items != null
                        ? items(context, locale, model)
                        : buildSearchText(locale)
                  ],
                ),
              );
            }),
      ),
    );
  }

  Widget buildSearchText(AppLocalizations locale) {
    return Expanded(
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.search,
                size: 28,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(locale.get("Search for what you want")),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget logo(context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          UI.pushReplaceAll(context, Routes.home); //* adding navigation
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Container(
            width: 57.5,
            height: 39.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7.0),
              image: DecorationImage(
                  image: const AssetImage('assets/images/beautyLogo.png'),
                  fit: BoxFit.fitWidth),
            ),
          ),
        ),
      ),
    );
  }

  Widget searchBar(
      BuildContext context, AppLocalizations locale, SearchPageModel model) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: ScreenUtil.portrait ? 44 : 75),
      // width: 317.0,
      height: 42.0,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        color: Theme.of(context).primaryColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onSecondary.withOpacity(0.2),
            offset: Offset(0, 0),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              // padding: EdgeInsets.only(left: 2),
              child: TextField(
                autofocus: true,

                onEditingComplete: () async {
                  // if (text.length >= 3) {
                  // resultItems = await model.search(
                  //   context,
                  // );
                  // model.setState();
                  // }
                },
                // onChanged: (text) async {
                //   // if (text.length >= 3) {
                //   // print(model.searchTextController.text);
                //   // print(text);
                //   // resultItems = await model.search(context, text);
                //   // model.setState();
                //   model._onChangeHandler;

                //   // }
                // },
                onChanged: (text) async {
                  model.onChangeHandler(context, text);
                  model.setState();
                },
                maxLines: 1,
                cursorColor: Theme.of(context).textTheme.bodyText1.color,

                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,
                      color: Theme.of(context).textTheme.bodyText1.color),
                  hintText: locale.get('Search'),
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                ),

                controller: model.searchTextController,
                textAlign: TextAlign.left,
              ),
            ),
          ),
          // Icon(Icons.search),

          // InkWell(
          //   onTap: () {
          //     model.search(
          //       context,
          //     );
          //   },
          //   child: Icon(Icons.send),
          // )
        ],
      ),
    );
  }

  Widget items(
      BuildContext context, AppLocalizations locale, SearchPageModel model) {
    // var isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
    return model.busy
        ? Expanded(
            child: Center(
            child: CircularProgressIndicator(
              color: AppColors.accentText,
            ),
          ))
        : model.hasError
            ? Expanded(
                child: Center(
                child: Text(locale.get("Error") ?? "Error"),
              ))
            : PaginatedItemsWidget(
                items: model.items,
                refreshController: model.refreshController,
                onLoad: () => model.onload(context),
                onRefresh: () =>
                    model.onRefresh(context, model.searchTextController.text),
                enablePullUp: true,
                enablePullDown: true,
              );
  }
}
