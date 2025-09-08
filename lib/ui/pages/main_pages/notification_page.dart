import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:beautydoz/core/services/api/api.dart';
import 'package:beautydoz/core/services/base_widget.dart';
import 'package:beautydoz/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ui_utils/ui_utils.dart';

import '../../../core/models/user_notification.dart';
import '../../../core/page_models/main_pages_models/notification_page_mode..dart';
import '../../../core/page_models/theme_provider.dart';
import '../../../core/services/localization/localization.dart';
import '../../../ui/shared/styles/gradients.dart';
import '../../../ui/widgets/loading_widget.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeProvider>(context);
    final grad = Gradients.secandaryGradient;
    final textColor = Color(0xff5C6470);
    final locale = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BaseWidget<NotificationPageModel>(
          model: NotificationPageModel(
              auth: Provider.of(context), api: Provider.of<Api>(context)),
          initState: (model) => WidgetsBinding.instance.addPostFrameCallback(
              (_) => model.getNotifications(context: context)),
          builder: (context, model, _) {
            return FocusWidget(
              child: SafeArea(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                          top: 15,
                          child: Container(
                            // decoration: BoxDecoration(
                            //   borderRadius: BorderRadius.circular(20),
                            //   gradient: Gradients.secandaryGradient,
                            // ),
                            child: SmartRefresher(
                              controller: model.refreshController,
                              enablePullDown: true,
                              enablePullUp: true,
                              onRefresh: () => model.onRefrsh(context),
                              // onLoading: () => model.onLoad(context),
                              child: ListView(
                                shrinkWrap: true,
                                physics: BouncingScrollPhysics(),
                                children: <Widget>[
                                  SizedBox(height: 25),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      // Text(
                                      //     locale.get('Notifications') ??
                                      //         "Notifications",
                                      //     style: TextStyle(
                                      //         color: theme.isDark
                                      //             ? Colors.white
                                      //             : Colors.grey[800],
                                      //         fontSize: 23)),
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  if (model.busy)
                                    Padding(
                                        padding: EdgeInsets.only(top: 150),
                                        child: LoadingIndicator()),
                                  if (!model.busy &&
                                      model.userNotifications != null &&
                                      model.userNotifications.isNotEmpty)
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: 22, bottom: 10, right: 5),
                                      child: ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 5),
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount:
                                              model.userNotifications.length,
                                          itemBuilder: (context, index) {
                                            return notificationWidget(
                                                context,
                                                model,
                                                model.userNotifications[index],
                                                grad,
                                                textColor);
                                            // return _gridItem(context, locale, model.projects[index]);
                                          }),
                                    ),
                                  if (!model.busy &&
                                      model.userNotifications != null &&
                                      model.userNotifications.isEmpty)
                                    Padding(
                                        padding: EdgeInsets.only(top: 150),
                                        child: CustomAnimatedCrossFade(
                                          showFirst: model.busy,
                                          isCenter: true,
                                          secound: Column(
                                            children: <Widget>[
                                              Text(
                                                locale.get('empty') ?? "'empty",
                                              ),
                                              // NormalButton(text: 'try again', onPressed: () => model.getNotifications(), busy: model.busy, width: 120, height: 35)
                                            ],
                                          ),
                                        ))
                                ],
                              ),
                            ),
                          )),
                      appBar(
                        context: context,
                        name: "Notification",
                        locale: locale,
                        verticalPadding: 15,
                      )
                      // smallAppbar(),
                    ],
                  ),
                ),
              ),
            );

            // Container(
            //   height: ScreenUtil.screenHeightDp,
            //   child: SingleChildScrollView(
            //     physics: Platform.isIOS ? BouncingScrollPhysics() : null,
            //     padding: EdgeInsets.all(20),
            //     child: Container(
            //       margin: EdgeInsets.only(top: 10),
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(20),
            //         gradient: theme.isDark ? Gradients.sideBlackGradient : Gradients.secandaryGradient,
            //       ),
            //       child: Column(
            //         children: <Widget>[
            //           SizedBox(height: 25),
            //           Text(locale.get('Notifications') ?? 'Notifications', style: TextStyle(color: theme.isDark ? Colors.white : Colors.grey[800], fontSize: 23)),
            //           SizedBox(height: 25),
            //           model.busy
            //               ? Container(
            //                   height: ScreenUtil.screenHeightDp / 1.35,
            //                   child: Center(child: CircularProgressIndicator( color: AppColors.accentText)),
            //                 )
            //               : model.userNotifications == null || model.userNotifications.isEmpty
            //                   ? Container(
            //                       height: ScreenUtil.screenHeightDp / 1.35,
            //                       child: Center(child: Text(locale.get('empty'), textAlign: TextAlign.center, style: TextStyle(color: theme.isDark ? Colors.white : Colors.grey[800]))),
            //                     )
            //                   : ListView.builder(
            //                       physics: NeverScrollableScrollPhysics(),
            //                       shrinkWrap: true,
            //                       itemCount: model.userNotifications.length,
            //                       itemBuilder: (context, ind) => notificationWidget(model.userNotifications[ind], grad, textColor)),
            //           SizedBox(height: 25),
            //         ],
            //       ),
            //     ),
            //   ),
            // ),
            //         smallAppbar(),
            //       ],
            //     ),
            //   ),
            // );
          }),
    );
  }

  notificationWidget(BuildContext context, NotificationPageModel model,
      UserNotification userNotification, LinearGradient grad, Color textColor) {
    final title = userNotification.title.localized(context);
    final description = userNotification.description.localized(context);

    return Card(
        margin: EdgeInsets.all(7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        child: Container(
          decoration: BoxDecoration(
            gradient: grad,
            borderRadius: BorderRadius.circular(50),
          ),
          child: ListTile(
            leading: SizedBox(
                width: 35,
                height: 35,
                child: Image.asset("assets/images/logo.png", color: textColor)),
            onTap: () {
              // model.openNotification(context: context, userNotification: userNotification);
            },
            title: Text(title ?? '',
                style: TextStyle(fontSize: 15, color: textColor)),
            subtitle: Text(description ?? '',
                style: TextStyle(fontSize: 10, color: textColor)),
          ),
        ));
  }
}
