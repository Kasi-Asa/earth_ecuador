extends Node
var conversations : Array[Conversation]

func request_new_conversation(topic: Vector2, requester: C4Cvsat, others: Array[C4Cvsat]):
	var succeeded = true
	for c4c in others:
		var result = c4c.consider_joining_conversation(topic, requester)
		succeeded = result
	if !succeeded: 
		print("dont wanna talk")
		return
	var participants = others
	participants.append(requester)
	var c = Conversation.new(topic, requester, participants)
	conversations.append(c)
	c. name = "conversation"
	add_child(c)
	c.on_end.connect(on_one_cvsat_end)
func pause_conversation(conversation: Conversation):
	pass
func resume_conversation(conversation: Conversation):
	pass
func on_one_cvsat_end(c: Conversation):
	conversations.erase(c)

func require_joining_conversation(requirer: Entity, conversation: Conversation):
	pass
