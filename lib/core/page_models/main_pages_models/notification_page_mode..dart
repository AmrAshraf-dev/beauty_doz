import 'package:beautydoz/core/services/base_notifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../core/models/user_notification.dart';
import '../../../core/services/api/http_api.dart';
import '../../../core/services/auth/authentication_service.dart';

class NotificationPageModel extends BaseNotifier {
  int lastId;
  final HttpApi api;
  final AuthenticationService auth;
  final refreshController = RefreshController();

  List<UserNotification> userNotifications;

  NotificationPageModel({this.api, this.auth});

  getNotifications({BuildContext context}) async {
    setBusy();

    await Future.delayed(Duration(milliseconds: 300));

    // try {
    //   userNotifications = await api.getNotifications(
    //       context: context, userId: auth.user.user.id, lastId: lastId);

    //   if (userNotifications != null && userNotifications.isNotEmpty) {
    //     lastId = userNotifications.last.id;
    //   }
    // } catch (e) {}

    setIdle();
  }

  onRefrsh(BuildContext context) async {
    lastId = null;
    await getNotifications();
    refreshController.refreshCompleted();
  }

  onLoad(BuildContext context) async {
    userNotifications.addAll((await api.getNotifications(
        context: context, userId: auth.user.user.id, lastId: lastId)));
    if (userNotifications != null && userNotifications.isNotEmpty) {
      lastId = userNotifications.last.id;
    }
    setIdle();
    refreshController.loadComplete();
  }

  void openNotification(
      {BuildContext context, UserNotification userNotification}) {
    // if (userNotification.notificationType == NotificationType.attendance) {
    //   final projectId = userNotification.notificationData['data']['projectId'];
    //   if (projectId != null) {
    //     UI.push(context, Routes.allUsersAttendanceScreen(project: Project(id: projectId)));
    //   }
    // } else if (userNotification.notificationType == NotificationType.instalment) {
    //   final projectId = userNotification.notificationData['data']['projectId'];
    //   if (projectId != null) {
    //     UI.push(context, Routes.accountingScreen(project: Project(id: projectId)));
    //   }
    // } else if (userNotification.notificationType == NotificationType.purchaseRequest) {
    //   final projectId = userNotification.notificationData['data']['projectId'];
    //   if (projectId != null) {
    //     UI.push(context, Routes.purchaseRequestScreen(project: Project(id: projectId)));
    //   }
    // }
  }
}
