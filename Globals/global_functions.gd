extends Node


## Return the [AABB] of the node.
func get_node_aabb(node : Node, excluded_nodes: Array[Node], exclude_top_level_transform: bool = true) -> AABB:
	var bounds : AABB = AABB()

	# Do not include children that is queued for deletion
	if node.is_queued_for_deletion():
		return bounds
	
	if node in excluded_nodes:
		return bounds
	
	if node is SubViewport:
		return bounds
	
	# Get the aabb of the visual instance
	if node is VisualInstance3D:
		bounds = node.get_aabb();
	
	# Recurse through all children
	for child in node.get_children():
		var child_bounds : AABB = get_node_aabb(child, excluded_nodes, false)
		if bounds.size == Vector3.ZERO:
			bounds = child_bounds
		else:
			bounds = bounds.merge(child_bounds)
	
	if !exclude_top_level_transform:
		bounds = node.transform * bounds

	return bounds
