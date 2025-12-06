class_name SM extends RefCounted
var _cur_state
var _transitions := {} # for normal transitions, exculde any_transitions
var _cur_transitions : Array
var _any_transitions : Array
const EMPTY := []
func update(delta):
	var transition = get_transition()
	if transition != null:
		set_state(transition.to)
	if _cur_state: 
		_cur_state.update(delta)
func set_state(state):
	if state == _cur_state: return
	if _cur_state: _cur_state.exit()
	if _transitions.has(state):
		_cur_transitions = _transitions.get(state)
	else:
		_cur_transitions = EMPTY
		push_error("Has no transition for this cur state!")
	_cur_state = state
	_cur_state.enter()
func add_transition(from, to, condition: Callable):
	var trans = _transitions.get_or_add(from, []) # Array[Transition]
	trans.append(Transition.new(to, condition))
func add_any_transition(to, condition: Callable):
	_any_transitions.append(Transition.new(to, condition))
func get_transition() -> Transition:
	for t in _any_transitions:
		if t.condition.call(): return t
	for t in _cur_transitions:
		if t.condition.call(): return t
	return null
class Transition:
	var to
	var condition : Callable
	func _init(to_, condition_: Callable):
		to = to_
		condition = condition_
