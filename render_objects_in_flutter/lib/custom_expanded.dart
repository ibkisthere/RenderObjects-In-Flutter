import 'package:flutter/material.dart';
import 'package:render_objects_in_flutter/custom_column.dart';



//Here we are making a Cust9mParentData Widget 
class CustomExpanded extends ParentDataWidget<CustomColumnParentData> {
  CustomExpanded({Key? key, this.flex = 1, required Widget child})
      : assert(flex > 0),
        super(key: key, child: child);

  final int flex;

  @override
  void applyParentData(RenderObject renderObject) {
    // get the parent data 
    final parentData = renderObject.parentData as CustomColumnParentData;


    if (parentData.flex != flex) {
      parentData.flex = flex;

      final targetObject = renderObject.parent;
      if (targetObject is RenderObject) {
        targetObject.markNeedsLayout();
      }
    }
  }

  @override
  Type get debugTypicalAncestorWidgetClass => CustomColumn;
}
