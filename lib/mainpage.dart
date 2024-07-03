import 'dart:io';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  final List<Map<String, dynamic>> items;

  MainPage({required this.items});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.0,
        ),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue),
            ),
            child: Column(
              children: [
                items[index]['image'] != null
                    ? Expanded(
                  flex: 7, // 图片占70%
                  child: Image.file(
                    File(items[index]['image']),
                    fit: BoxFit.cover,
                  ),
                )
                    : Expanded(
                  flex: 7, // 占70%的空间
                  child: Icon(Icons.image, size: 50),
                ),
                Expanded(
                  flex: 1.5.toInt(), // 文字占15%
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      items[index]['name'],
                      overflow: TextOverflow.ellipsis, // 处理文字溢出
                      maxLines: 1,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1.5.toInt(), // 标签占15%
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        List<Widget> tags = [];
                        double totalWidth = 0;
                        double maxWidth = constraints.maxWidth;

                        for (var tag in items[index]['tags']) {
                          final tagWidget = Chip(
                            label: Text(tag),
                          );
                          final tagWidth = _calculateChipWidth(tagWidget);

                          if (totalWidth + tagWidth + 20 < maxWidth) { // 20 is a buffer for padding and margins
                            tags.add(tagWidget);
                            totalWidth += tagWidth + 10; // 10 for space between tags
                          } else {
                            tags.add(Text('...'));
                            break;
                          }
                        }

                        return Wrap(
                          children: tags,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  double _calculateChipWidth(Widget chip) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: (chip as Chip).label.toString(),
        style: (chip as Chip).labelStyle,
      ),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width + 16; // Add some padding
  }
}
