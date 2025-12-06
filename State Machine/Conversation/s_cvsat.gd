class_name S4Cvsat extends RefCounted
var speaker : C4Cvsat
var me : C4Cvsat
var cvsat : Conversation
func _init(c, c4c): 
	cvsat = c
	me = c4c
	speaker = cvsat.speaker
func enter(): 
	speaker = cvsat.speaker
	Bus.message_sent.connect(on_bus_msg)
	print(me.entity.name, " -> ", me.sm._cur_state.get_script().get_path().get_file().get_basename())
func update(delta): pass
func exit():
	if Bus.message_sent.is_connected(on_bus_msg):
		Bus.message_sent.disconnect(on_bus_msg)
func on_bus_msg(msg): pass
