part of 'overlap_snapping_scroll_widget.dart';

class OverlapScrollStaticPart extends SingleChildRenderObjectWidget {
  final OverlapScrollPosition position;
  final bool shouldAlive;
  const OverlapScrollStaticPart(
      {super.key,
      super.child,
      required this.position,
      this.shouldAlive = false});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderOverlapSliverStaticPart(
        position: position, shouldAlive: shouldAlive);
  }

  @override
  void updateRenderObject(
      BuildContext context, covariant RenderObject renderObject) {
    super.updateRenderObject(context, renderObject);
    if (renderObject is _RenderOverlapSliverStaticPart) {
      if (renderObject.position != position) {
        renderObject.position = position;
      }
    }
  }
}

class _RenderOverlapSliverStaticPart extends RenderSliverToBoxAdapter {
  OverlapScrollPosition _position;
  bool shouldAlive;
  OverlapScrollPosition get position => _position;

  set position(OverlapScrollPosition newPos) {
    _position = newPos;
    markNeedsLayout();
  }

  _RenderOverlapSliverStaticPart(
      {required OverlapScrollPosition position, required this.shouldAlive})
      : _position = position;

  @override
  void markNeedsLayout() {
    super.markNeedsLayout();
    _position.applyStaticDimension(null);
  }

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    final double scrollOffset = constraints.scrollOffset;

    child!.layout(
      constraints.asBoxConstraints(
        maxExtent: max(
            shouldAlive
                ? constraints.remainingPaintExtent
                : constraints.remainingPaintExtent - scrollOffset,
            0),
      ),
      parentUsesSize: true,
    );

    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child!.size.width;
        break;
      case Axis.vertical:
        childExtent = child!.size.height;
        break;
    }

    // childExtent -= scrollOffset;

    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);
    final double layoutExtent =
        clampDouble(childExtent - constraints.scrollOffset, 0.0, childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);

    final notVisible = !shouldAlive && scrollOffset >= childExtent;

    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintOrigin: constraints.overlap,
      paintExtent: paintedChildSize,
      cacheExtent: cacheExtent,
      layoutExtent: layoutExtent,
      visible: !notVisible,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
      hasVisualOverflow: true,
    );
    setChildParentData(child!, constraints, geometry!);

    _position.applyStaticDimension(childExtent);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (child != null && ((geometry!.scrollExtent) > 0 || shouldAlive)) {
      if (!shouldAlive) {
        final clip = ClipRRectLayer(
          clipRRect: RRect.fromLTRBR(
            0,
            0,
            constraints.crossAxisExtent,
            geometry?.scrollExtent != null
                ? geometry!.scrollExtent - constraints.scrollOffset
                : 0,
            const Radius.circular(0),
          ),
        );

        context.pushLayer(
          clip,
          (context, offset) {
            context.paintChild(child!, offset);
          },
          offset,
        );
        return;
      }

      context.paintChild(child!, offset);
    }
  }
}
