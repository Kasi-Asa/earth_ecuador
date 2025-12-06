class_name C4Cvsat extends Node
@export var friendliness := 0.6
@export var boredom := 0.3
@export var talkable := 0.7
var entity : Entity
var sm : SM # current
var cur_cvsat : Conversation
var cvsat_dict := {Conversation : SM}
var brain : Brain
var flow : int = 3
var attitude : int

func _ready():
	entity = get_parent()
	var b_map = tk.rt02( Vector2(tk.ri(3), tk.ri(3)) )
	brain = Brain.new(b_map, tk.ri(4))
	# test
	await tk.wait(1)
	if entity.test_bool:
		initiate_conversation(entity.get_c4cvsat_around())
func _process(delta: float): 
	if sm: 
		sm.update(delta)
func start_conversation(c: Conversation):
	sm = SM.new()
	var free = S_C_Free.new(c, self)
	var listen = S_C_Listen.new(c, self)
	var speak = S_C_Speak.new(c, self)
	var react = S_C_React.new(c, self)
	var interrupt = S_C_Interrupt.new(c, self)
	
	var no_cvsat = func(): return c == null
	var joined_cvsat = func(): return c.speaker != self
	var initiated_cvsat = func(): return c.speaker == self
	var finished_speech_OR_lost_flow = func(): return speak.finished or flow <= 0
	var listen_to_react = func(): return listen.is_time_to_react
	var my_turn_to_speak = func(): return listen.is_my_turn_to_speak
	var reacted_AND_not_speaker = func(): return react.reacted and c.speaker != self
	var reacted_AND_became_speaker = func(): return react.reacted and c.speaker == self
	
	#var placeholder = func (): return
	sm.add_any_transition(free, no_cvsat)
	at(free, listen, joined_cvsat)
	at(free, speak, initiated_cvsat)
	at(speak, listen, finished_speech_OR_lost_flow) # finished speech OR been interruptted/disapproved too much
	at(listen, react, listen_to_react) # compare depth
	at(listen, speak, my_turn_to_speak) # the other finished their speech
	at(react, listen, reacted_AND_not_speaker)
	at(react, speak, reacted_AND_became_speaker) # the other lost flow. continue the same conversation
	
	#at(listen, interrupt, placeholder)
	#at(interrupt, speak, placeholder)
	#at(interrupt, listen, placeholder)
	#at(react, interrupt, placeholder) # emotional
	
	cvsat_dict.set(c, sm)
	cur_cvsat = c
	c.on_end.connect(on_cvsat_end)
	sm.set_state(free)
func at(from, to, condition: Callable): sm.add_transition(from, to, condition)

func initiate_conversation(others: Array[C4Cvsat]):
	var topic = Vector2(randf(), randf()) * brain.map.size # size = position + end. the position is (0,0) here
	if cur_cvsat == null or !tk.arrays_share_element(cur_cvsat.participants, others):
		ConversationM.request_new_conversation(topic, self, others)
func consider_joining_conversation(topic: Vector2, initiator: C4Cvsat) -> bool:
	var depths = brain.depths.get_or_add(topic, 1) # use it in the future
	var threshold = initiator.friendliness + boredom
	return threshold > randf()
func is_happy_to_end() -> bool:
	return true
func on_cvsat_end(c): cvsat_dict.erase(c)
