class_name Entity extends Node2D
@onready var action_compo: C4Action = $compo_action
@onready var cvsat_compo: C4Cvsat = $compo_cvsat
@export var cvsat_range = 5
@export var Name : String
@export var test_bool : bool
var _entities
func _ready():
	name = Name
	_entities = get_tree().get_nodes_in_group("Entities")
func get_c4cvsat_around() -> Array[C4Cvsat]:
	var results : Array[C4Cvsat] = []
	for e in _entities:
		if e == self: continue
		if e.global_position.distance_to(global_position) < cvsat_range:
			if e.cvsat_compo != null:
				results.append(e.cvsat_compo)
	#print(results.size())
	return results
