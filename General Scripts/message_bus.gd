extends Node # Autoload
signal message_sent(msg)
func send(msg):
	message_sent.emit(msg)

class Argument:
	var speaker : C4Cvsat
	var phase : int
	func _init(speaker_, phase_): 
		speaker = speaker_
		phase = phase_
class React:
	var attitude : int
	func _init(attitude_):
		attitude = attitude_
class FinishSpeech:
	pass
class LostFlow:
	func _init() -> void:
		print("LostFlow emitted")
