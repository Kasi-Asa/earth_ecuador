class_name S_C_Listen extends S4Cvsat
var is_time_to_react := false
var is_my_turn_to_speak := false
var topic_depth_in_brain
func enter():
	super()
	topic_depth_in_brain = me.brain.depths.get_or_add(cvsat.topic, me.brain.base_depth)
func exit():
	super()
	is_time_to_react = false
	is_my_turn_to_speak = false
func on_bus_msg(msg: RefCounted):
	if msg is Bus.Argument:
		if msg.speaker == speaker:
			var depth = msg.phase
			me.attitude = topic_depth_in_brain - depth # attitude > 0 : approving; < 0 : disapproving
			is_time_to_react = true
	elif msg is Bus.FinishSpeech:
		cvsat.require_talk(me)
		if cvsat.speaker == me:
			is_my_turn_to_speak = true
