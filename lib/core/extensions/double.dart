import '../utils/responsive.dart';

extension ResponsiveExtension on double {
  double get w => Responsive.w(this);
  double get h => Responsive.h(this);
  double get f => Responsive.f(this);

  double ws({double startpoint = 480.0}) =>
      Responsive.ws(this, startpoint: startpoint);
  double hs({double startpoint = 640.0}) =>
      Responsive.hs(this, startpoint: startpoint);
}
