class_name Brain extends RefCounted
var map : Rect2
var depths := {} # Vector2 : int
var base_depth
var soberness
func _init(map_, base_depth_):
	map = map_
	base_depth = base_depth_ + 1
