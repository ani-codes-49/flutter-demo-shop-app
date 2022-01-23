import 'package:flutter/material.dart';

class CustomRoute<T> extends MaterialPageRoute<T> {
  CustomRoute({
    @required WidgetBuilder? builder,
    @required RouteSettings? routeSetting,
  }) : super(builder: builder!, settings: routeSetting);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.name == '/auth' ||
        settings.name == '/ProductsOverviewScreen') {
      return child;
    }

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

class CustomTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
      PageRoute<T> route,
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child) {

    if (route.isFirst) {
      return child;
    }

    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
