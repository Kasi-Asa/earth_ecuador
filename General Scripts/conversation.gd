class_name Conversation extends Node
var participants : Array[C4Cvsat]
var speaker : C4Cvsat
var is_paused := false
var flow : int = 3
var totem
var spark
var topic : Vector2
signal on_end
func _init(topic_: Vector2, init_speaker: C4Cvsat, participants_ : Array[C4Cvsat]):
	topic = topic_
	participants = participants_
	speaker = init_speaker
func _ready():
	for p in participants:
		p.start_conversation(self)
		#print(p.entity.name, " is in conversation")
		#print(speaker.entity.name, " is the speaker")
func require_end():
	var succeeded = true
	for p in participants:
		succeeded = p.is_happy_to_end()
	if succeeded:
		on_end.emit(self)
		queue_free()
func require_talk(requester: C4Cvsat):
	if speaker == null:
		speaker = requester
		print(requester.entity.name," is the new speaker now")
