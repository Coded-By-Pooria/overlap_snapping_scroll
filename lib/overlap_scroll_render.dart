part of 'overlap_snapping_scroll_widget.dart';

class OverlapPhysics extends ScrollPhysics {
  const OverlapPhysics({
    super.parent,
  });

  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return OverlapPhysics(parent: buildParent(ancestor));
  }

  @override
  Simulation? createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    // If scroll is out of scrollExtent range we want back to bound
    if ((velocity <= 0.0 && position.pixels <= position.minScrollExtent) ||
        (velocity >= 0.0 && position.pixels >= position.maxScrollExtent)) {
      return super.createBallisticSimulation(position, velocity);
    }

    final Tolerance tolerance = this.tolerance;

    final offset = position.pixels;

    // If scroll offset is over on static part and drag had left.
    if (position is OverlapScrollPosition &&
        position.hasStatic &&
        velocity < tolerance.velocity &&
        offset < position.staticSize) {
      final staticBound = position.staticSize / 2;

      double target;
      if (offset <= staticBound) {
        target = 0;
      } else {
        target = position.staticSize;
      }

      return ScrollSpringSimulation(spring, offset, target, velocity,
          tolerance: tolerance);
    }

    return super.createBallisticSimulation(position, velocity);
  }
}

class OverlapScrollPosition extends ScrollPositionWithSingleContext {
  OverlapScrollPosition({required super.physics, required super.context});

  double? _staticSize;

  get staticSize => _staticSize;
  get hasStatic => _staticSize != null;

  applyStaticDimension(double? size) {
    if (size == staticSize) {
      return;
    }
    _staticSize = size;
  }
}

class OverlapScrollController extends ScrollController {
  @override
  ScrollPosition createScrollPosition(ScrollPhysics physics,
      ScrollContext context, ScrollPosition? oldPosition) {
    return OverlapScrollPosition(physics: physics, context: context);
  }
}
