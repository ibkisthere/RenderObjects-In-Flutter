import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class CustomColumn extends MultiChildRenderObjectWidget {
  const CustomColumn({Key? key, List<Widget> children = const []})
      : super(key: key, children: children);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderCustomColumn();
  }
}

class CustomColumnParentData extends ContainerBoxParentData<RenderBox> {
  int? flex;
}

class RenderCustomColumn extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, CustomColumnParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, CustomColumnParentData> {
  @override
  void setupParentData(covariant RenderObject child) {
    if (child.parentData is! CustomColumnParentData) {
      child.parentData = CustomColumnParentData();
    }
  }

// COnsttraints go down sizes go up, parents sets position
  @override
  void performLayout() {
    // think of it - we are a column , we go through all the children , add up the heights and we want the maximum width
    // through ContainerRenderObjectMixin we have access to the first and the last child

    //Set constraints
    double height = 0, width = 0;

    int totalFlex = 0;

    //remember the last Renderobject that had a flex was, and we can go backwards
    RenderBox? lastFlexChild;

    RenderBox? child = firstChild;

    while (child != null) {
      // we get the CustomParentData from the child
      final childParentData = child.parentData as CustomColumnParentData;
      final flex = childParentData.flex ?? 0;
      // we alyout the child, we use BoxConstraints because it is a column and the height and width is effectively infinite
      if (flex > 0) {
        totalFlex += flex;
        lastFlexChild = child;
      } else {
        child.layout(BoxConstraints(maxWidth: constraints.maxWidth),
            parentUsesSize: true);
      }
      // add up all the heights and widths

      height += child.size.height;
      width += child.size.width;

      child = childParentData.nextSibling;
    }

    // the optimization - if the
    // we are calculating the flexHeight here - height of each flex item / child, when we have flex
    final flexHeight = (constraints.maxHeight - height) / totalFlex;

    child = lastFlexChild;

    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      final flex = childParentData.flex ?? 0;

      if (flex > 0) {
        final childHeight = flexHeight * flex;

        child.layout(
            BoxConstraints(
                minHeight: childHeight,
                maxHeight: childHeight,
                maxWidth: constraints.maxWidth),
            parentUsesSize: true);
        height += childHeight;
        width += max(width,child.size.width);
      }

      child = childParentData.previousSibling;
    }

    // set position
    // we will use offsets
    // don't know why he reassigned child
    var childOffset = const Offset(0, 0);
    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;

      childParentData.offset = Offset(0, childOffset.dy);

      childOffset += Offset(0, child.size.height);

      child = childParentData.nextSibling;
    }
    size = Size(width, height);
  }

  // set size
  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}

// need to fix an error - RenderCustomColumn does not meet its constraints