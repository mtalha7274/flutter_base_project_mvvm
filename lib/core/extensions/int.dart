import '../utils/responsive.dart';

extension ResponsiveExtension on int {
  double get w => Responsive.w(toDouble());
  double get h => Responsive.h(toDouble());
  double get f => Responsive.f(toDouble());

  double ws({double startpoint = 480.0}) =>
      Responsive.ws(toDouble(), startpoint: startpoint);
  double hs({double startpoint = 640.0}) =>
      Responsive.hs(toDouble(), startpoint: startpoint);
}
