import 'package:beautydoz/core/services/screen_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum WidgetType { normalBuild, staticBuild, consume }

class BaseWidget<T extends ChangeNotifier> extends StatefulWidget {
  final T model;
  final Widget staticChild;
  final WidgetType type;
  final Function(T) initState;
  final Widget Function(BuildContext context, T model, Widget child) builder;
  final Widget Function(BuildContext context, T model) staticBuilder;

  BaseWidget(
      {Key key, this.model, this.builder, this.initState, this.staticChild})
      : this.staticBuilder = null,
        this.type = WidgetType.normalBuild,
        super(key: key);

  BaseWidget.staticBuilder(
      {Key key, this.model, this.initState, this.staticBuilder})
      : this.type = WidgetType.staticBuild,
        this.staticChild = null,
        this.builder = null,
        super(key: key);

  BaseWidget.cosnume({Key key, this.builder})
      : this.type = WidgetType.consume,
        this.model = null,
        this.staticChild = null,
        this.initState = null,
        this.staticBuilder = null,
        super(key: key);

  _BaseWidgetState<T> createState() => _BaseWidgetState<T>();
}

class _BaseWidgetState<T extends ChangeNotifier> extends State<BaseWidget<T>> {
  // We want to store the instance of the model in the state
  // that way it stays constant through rebuilds
  T model;

  @override
  void initState() {
    // assign the model once when state is initialised
    model = widget.model;
    if (widget.initState != null) {
      widget.initState(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.type == WidgetType.consume) {
      return Consumer<T>(builder: widget.builder);
    } else {
      ScreenUtil.init(context);
      return ChangeNotifierProvider<T>(
        create: (context) => model,
        child: widget.type == WidgetType.staticBuild
            ? widget.staticBuilder(context, model)
            : Consumer<T>(child: widget.staticChild, builder: widget.builder),
      );
    }
  }
}
