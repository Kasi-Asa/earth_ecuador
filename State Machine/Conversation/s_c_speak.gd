class_name S_C_Speak extends S4Cvsat
var tick := 0.0
var sentence_length := 5.0
var argu_depth : int = 0
var topic_depth_in_brain = 0
var finished := false
func enter():
	super()
	if argu_depth > topic_depth_in_brain:
		cvsat.topic = tk.randp_in_rt2(me.brain.map)
		print("changed topic")
	topic_depth_in_brain = me.brain.depths.get_or_add(cvsat.topic, me.brain.base_depth) # change it after using noise
	Bus.send(Bus.Argument.new(me, argu_depth))
	#print(me.entity.name, " speak: ", argu_depth)
func update(delta):
	if tick < sentence_length + randf_range(-2, 2): # need time to finish a sentence
		tick += delta
	else: # tick done
		if argu_depth <= topic_depth_in_brain: # keep talking
			argu_depth += 1
			Bus.send(Bus.Argument.new(me, argu_depth))
			print(me.entity.name, " speak: ", argu_depth, " flow: ", me.flow)
		elif cvsat.spark: # got inspired
			argu_depth += 1
			cvsat.spark = false
			me.brain.depths.set(cvsat.topic, argu_depth)
			Bus.send(Bus.Argument.new(me, argu_depth))
			print(me.entity.name, " speak: ", argu_depth, " flow: ", me.flow)
		else: # finished speech
			finished = true
		tick = 0
func exit():
	super()
	print(me.entity.name ," exit speak, finished: ", finished, " flow: ", me.flow)
	if finished: 
		cvsat.speaker = null
		Bus.send(Bus.FinishSpeech.new())
	if me.flow <= 0:
		Bus.send(Bus.LostFlow.new())
		me.flow = abs(me.attitude)
		print("attitude: ", me.attitude)
	finished = false
func on_bus_msg(msg: RefCounted):
	if msg is Bus.React:
		me.flow += msg.attitude
		# attitude > 0 : approving
		# attitude < 0 : disapproving
		if me.flow <= 0:
			print(me.entity.name, " lost flow")
			if cvsat.speaker == me:
				cvsat.speaker = null
				print("speaker is null now")
