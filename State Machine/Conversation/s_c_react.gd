class_name S_C_React extends S4Cvsat
# Tak / He
var reacted := false
func enter():
	# message the visual queue
	super()
	print(me.entity.name, " react to ", speaker.entity.name, " with " ,me.attitude)
	me.flow += 1
	Bus.send(Bus.React.new(me.attitude))
	reacted = true
func exit():
	super()
	reacted = false
func on_bus_msg(msg):
	if msg is Bus.LostFlow:
		print(me.entity.name, " received lostFlow signal")
		cvsat.require_talk(me)
