import 'package:drag_drop/widget/five.dart';
import 'package:drag_drop/widget/four.dart';
import 'package:drag_drop/widget/one.dart';
import 'package:drag_drop/widget/six.dart';
import 'package:drag_drop/widget/three.dart';
import 'package:drag_drop/widget/two.dart';
import 'package:flutter/material.dart';

class DragDrop extends StatefulWidget {
  @override
  _DragDropState createState() => _DragDropState();
}

class _DragDropState extends State<DragDrop> {
  // List to hold the widgets in the two columns
  List<List<Widget>> columns = [
    [const one(), const two(), const three()],
    [const four(), const five(), const six()],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                color: Colors.blue,
                height: 200,
                width: double.infinity,
              ),
              const SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: buildColumn(0),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 5,
                    child: buildColumn(1),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build each column with draggable and drag targets
  Widget buildColumn(int columnIndex) {
    return Column(
      children: columns[columnIndex].asMap().entries.map((entry) {
        int rowIndex = entry.key;
        Widget widget = entry.value;

        return DragTarget<Map<String, int>>(
          onWillAccept: (data) => true,
          onAccept: (data) {
            setState(() {
              // Swap widgets between columns when a drop occurs
              Widget temp = columns[columnIndex][rowIndex];
              columns[columnIndex][rowIndex] =
                  columns[data['column']!][data['row']!];
              columns[data['column']!][data['row']!] = temp;
            });
          },
          builder: (context, acceptedItems, rejectedItems) {
            return Draggable<Map<String, int>>(
              data: {'column': columnIndex, 'row': rowIndex},
              feedback: Material(
                child: Column(
                  children: [
                    Container(
                      // padding: EdgeInsets.all(16.0),
                      child: widget,
                      width: MediaQuery.of(context).size.width / 2 - 25,
                    ),
                  ],
                ),
              ),
              childWhenDragging: Opacity(
                opacity: 0.5,
                child: Column(
                  children: [
                    widget,
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
              child: Column(
                children: [
                  widget,
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

// void main() {
//   runApp(MaterialApp(home: DragDropDemo()));
// }
