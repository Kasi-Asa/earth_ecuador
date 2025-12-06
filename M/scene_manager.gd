extends Node
@export var pub : PackedScene
@export var church : PackedScene
@export var bus : PackedScene
var _cur_scene : Node
func _ready():
	if pub:
		_cur_scene = pub.instantiate()
		add_child(_cur_scene)
func load_scene(new_scene : PackedScene):
	if _cur_scene != new_scene and new_scene.can_instantiate():
		_cur_scene.queue_free()
		_cur_scene = new_scene.instantiate()
		add_child(_cur_scene)
		
