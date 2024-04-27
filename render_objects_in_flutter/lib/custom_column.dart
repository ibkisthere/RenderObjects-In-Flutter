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

  Size _performLayout(
      {required BoxConstraints constraints, required bool dryLayout}) {
    // think of it - we are a column , we go through all the children , add up the heights and we want the maximum width
    // through ContainerRenderObjectMixin we have access to the first and the last child

    //Set constraints
    double height = 0, width = 0;

    int totalFlex = 0;

    //remember the last Renderobject that had a flex was, and we can go backwards
    RenderBox? lastFlexChild;

    // Laying out the fixed height children
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
        late final Size childSize;
        if (!dryLayout) {
          child.layout(BoxConstraints(maxWidth: constraints.maxWidth),
              parentUsesSize: true);
          childSize = child.size;
        } else {
          childSize = child
              .getDryLayout(BoxConstraints(maxWidth: constraints.maxWidth));
        }
        // add up all the heights and widths
        height += childSize.height;
        width += max(width, childSize.width);
      }
      child = childParentData.nextSibling;
    }

    // the optimization - if the
    // we are calculating the flexHeight here - height of each flex item / child, when we have flex
    // distributing the remaining height to flex children
    final flexHeight = (constraints.maxHeight - height) / totalFlex;

    child = lastFlexChild;

    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;
      final flex = childParentData.flex ?? 0;

      if (flex > 0) {
        final childHeight = flexHeight * flex;
        late final Size childSize;
        if (!dryLayout) {
          child.layout(
              BoxConstraints(
                  minHeight: childHeight,
                  maxHeight: childHeight,
                  maxWidth: constraints.maxWidth),
              parentUsesSize: true);
          childSize = child.size;
        } else {
          height += childHeight;
          width += max(width, child.size.width);
        }
      }
      child = childParentData.previousSibling;
    }
    return Size(width, height);
  }

// Constraints go down sizes go up, parents sets position
  @override
  void performLayout() {
    // we're saying this is not the dryLayout , this is the real deal
    size = _performLayout(constraints: constraints, dryLayout: false);
    // set position
    // we will use offsets
    // Here , we are positioning the children
    RenderBox? child = firstChild;
    var childOffset = const Offset(0, 0);
    while (child != null) {
      final childParentData = child.parentData as CustomColumnParentData;

      childParentData.offset = Offset(0, childOffset.dy);

      childOffset += Offset(0, child.size.height);

      child = childParentData.nextSibling;
    }
  }

  @override
  Size computeDryLayout(covariant BoxConstraints constraints) {
    return _performLayout(constraints: constraints, dryLayout: true);
  }

  // set size
  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}

// need to fix an error - RenderCustomColumn does not meet its constraints

//computeDryLayout - a layout pass without any side effects , we just want to report what our size would be if we did a real layout

//sometimes we need to calculate sizes before we do the actual layout just to calculate the layout of the parent

// a usual layout passs doe a lot of things - in the coe above, we are setting the offset
