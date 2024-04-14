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
    double height = 0, width = 0;

    RenderBox? child = firstChild;

    while (child != null) {
      // we get the CustomParentData from the child
      final childParentData = child.parentData as CustomColumnParentData;

      // we alyout the child, we use BoxConstraints because it is a column and the height and width is effectively infinite
      child.layout(BoxConstraints(maxWidth: constraints.maxWidth),
          parentUsesSize: true);

      // add up all the heights and widths

      height += child.size.height;
      width += child.size.width;
      
      child = childParentData.nextSibling;
    }

    // set position
  }
}
