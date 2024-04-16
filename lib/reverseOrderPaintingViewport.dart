part of 'overlap_snapping_scroll_widget.dart';

class ReverseOrderPaintingViewport extends Viewport {
  ReverseOrderPaintingViewport({
    super.key,
    super.axisDirection,
    super.crossAxisDirection,
    super.anchor = 0.0,
    required super.offset,
    super.center,
    super.cacheExtent,
    super.cacheExtentStyle,
    super.clipBehavior,
    super.slivers,
  });

  @override
  RenderViewport createRenderObject(BuildContext context) {
    return _ReverseOrderPaintingViewport(
      axisDirection: axisDirection,
      crossAxisDirection: crossAxisDirection ??
          Viewport.getDefaultCrossAxisDirection(context, axisDirection),
      anchor: anchor,
      offset: offset,
      cacheExtent: cacheExtent,
      cacheExtentStyle: cacheExtentStyle,
      clipBehavior: clipBehavior,
    );
  }
}

class _ReverseOrderPaintingViewport extends RenderViewport {
  _ReverseOrderPaintingViewport({
    super.axisDirection,
    required super.crossAxisDirection,
    required super.offset,
    super.anchor,
    super.children,
    super.center,
    super.cacheExtent,
    super.cacheExtentStyle,
    super.clipBehavior,
  });

  @override
  Iterable<RenderSliver> get childrenInPaintOrder {
    print('Reverse order');
    final List<RenderSliver> children = <RenderSliver>[];
    if (firstChild == null) {
      return children;
    }
    RenderSliver? child = firstChild;
    while (true) {
      children.add(child!);
      if (child == lastChild) {
        return children;
      }
      child = childAfter(child);
    }
    // child = firstChild;
    // while (true) {
    //   children.add(child!);
    //   if (child == center) {
    //     return children;
    //   }
    //   child = childAfter(child);
    // }
  }
}
