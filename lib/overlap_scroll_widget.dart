part of 'overlap_snapping_scroll_widget.dart';

class OverlapScroll extends StatelessWidget {
  final List<Widget> slivers;
  final Widget staticPart;
  final OverlapScrollController? controller;
  final String? restorationId;
  final double? cacheExtent;
  final ScrollPhysics? physics;
  final bool clipStatic;

  const OverlapScroll({
    super.key,
    this.controller,
    this.cacheExtent,
    this.physics,
    this.restorationId,
    this.clipStatic = true,
    required this.slivers,
    required this.staticPart,
  });

  @override
  Widget build(BuildContext context) {
    OverlapPhysics physics;
    if (this.physics is! OverlapPhysics) {
      physics = OverlapPhysics(parent: this.physics);
    } else {
      physics = const OverlapPhysics();
    }

    return Scrollable(
      physics: physics,
      controller: controller ?? OverlapScrollController(),
      restorationId: restorationId,

      // scrollBehavior: widget.scrollBehavior ??
      //     ScrollConfiguration.of(context).copyWith(scrollbars: false),
      viewportBuilder: (BuildContext context, ViewportOffset position) {
        return clipStatic
            ? Viewport(
                cacheExtent: cacheExtent,
                offset: position,
                slivers: <Widget>[
                  OverlapScrollStaticPart(
                    position: position as OverlapScrollPosition,
                    child: staticPart,
                  ),
                  ...slivers
                ],
              )
            : ReverseOrderPaintingViewport(
                cacheExtent: cacheExtent,
                offset: position,
                slivers: <Widget>[
                  OverlapScrollStaticPart(
                    child: staticPart,
                    shouldAlive: true,
                    position: position as OverlapScrollPosition,
                  ),
                  ...slivers
                ],
              );
      },
    );
  }
}
