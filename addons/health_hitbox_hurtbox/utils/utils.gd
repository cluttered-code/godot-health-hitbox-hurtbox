class_name Utils extends Object

# Remove in godot 4.5 in favor of Array.duplicate_deep()
static func array_duplicate_deep(array: Array) -> Array:
	var dups: Array
	for item in array:
		dups.append(item.duplicate())
	return dups
