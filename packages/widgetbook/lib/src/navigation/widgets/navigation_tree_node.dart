import 'package:flutter/material.dart';

import '../nodes/nodes.dart';
import 'navigation_tree_tile.dart';

class NavigationTreeNode extends StatefulWidget {
  const NavigationTreeNode({
    super.key,
    required this.node,
    this.selectedNode,
    this.onNodeSelected,
  });

  final WidgetbookNode node;
  final WidgetbookNode? selectedNode;
  final ValueChanged<WidgetbookNode>? onNodeSelected;

  @override
  State<NavigationTreeNode> createState() => _NavigationTreeNodeState();
}

class _NavigationTreeNodeState extends State<NavigationTreeNode> {
  late bool isExpanded;

  @override
  void initState() {
    super.initState();

    isExpanded = widget.node.isInitiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    const animationDuration = Duration(
      milliseconds: 200,
    );

    return Column(
      children: [
        NavigationTreeTile(
          node: widget.node,
          isExpanded: isExpanded,
          isSelected: widget.node.path == widget.selectedNode?.path,
          onTap: () {
            // Redirect click to the use-case of the leaf component, so that
            // when it's clicked, the route is updated to the use-case.
            final targetNode = widget.node is WidgetbookLeafComponent
                ? (widget.node as WidgetbookLeafComponent).useCase
                : widget.node;

            setState(() => isExpanded = !isExpanded);
            widget.onNodeSelected?.call(targetNode);
          },
        ),
        if (widget.node.children != null &&
            widget.node is! WidgetbookLeafComponent)
          ClipRect(
            child: AnimatedSlide(
              duration: animationDuration,
              curve: Curves.easeInOut,
              offset: Offset(0, isExpanded ? 0 : -1),
              child: AnimatedAlign(
                duration: animationDuration,
                curve: Curves.easeInOut,
                alignment: Alignment.topCenter,
                heightFactor: isExpanded ? 1 : 0,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.node.children!.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) => NavigationTreeNode(
                    node: widget.node.children![index],
                    selectedNode: widget.selectedNode,
                    onNodeSelected: widget.onNodeSelected,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
