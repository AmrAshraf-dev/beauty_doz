import 'package:flutter/cupertino.dart';

enum NotifierState { busy, idle, error }

class BaseNotifier extends ChangeNotifier {
  NotifierState _state = NotifierState.idle;
  bool _mounted = true;

  BaseNotifier({NotifierState state}) {
    if (state != null) _state = state;
  }

  bool get mounted => _mounted;
  NotifierState get state => _state;
  bool get idle => _state == NotifierState.idle;
  bool get busy => _state == NotifierState.busy;
  bool get hasError => _state == NotifierState.error;

  setBusy() => setState(state: NotifierState.busy);
  setIdle() => setState(state: NotifierState.idle);
  setError() => setState(state: NotifierState.error);

  setState({NotifierState state, bool notifyListener = true}) {
    if (state != null) _state = state;
    if (mounted && notifyListener) notifyListeners();
  }

  @override
  dispose() {
    _mounted = false;
    super.dispose();
  }
}
