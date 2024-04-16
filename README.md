A simple widget which consist of two part:

1- Static part:
Static part is the fixed (pinned) part which doesn't move on scroll and always stay on top.

2- Mobile part:
The mobile part is the movable and scrollable part which moves by scrolling and it may place on static part.

This type of sliver may use on different scenario.

## Getting started

This widget is easy to use. Just use this widget define your `staticPart` parameter as simple normal widget (Renderbox) and `slivers` param as list of arbitary slivers (like SliverList or SliverGrid and so on).

## Usage

For example in following code, we create a view that display an image as static part and display a tone of boxes as slivers. With scrolling the slivers move over static part and because some boxes (boxes with even index) are transparent the static part is visible behind that boxes.

```dart
    OverlapSliver(
          clipStatic: true,
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate((ctx, idx) {
                final height = 250;
                return Container(
                  height: height.toDouble(),
                  decoration: BoxDecoration(
                    color: idx % 2 == 0
                        ? Colors.transparent
                        : Color.fromRGBO(Random().nextInt(255),
                            Random().nextInt(255), Random().nextInt(255), 1),
                  ),
                  child: Center(child: Text("$idx")),
                );
              }),
            )
          ],
          staticPart: Image.network(
            'https://www.w3schools.com/w3css/img_snowtops.jpg',
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
```

## Additional information

If you have problem or need some options, send it in github issues.
And i will be happy if you want contribute to improve this package and i will name you in contributors section.

## Contributors
