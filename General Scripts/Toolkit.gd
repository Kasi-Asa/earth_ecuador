extends Node
signal cancel_signal
func wait(duration: float):
	await get_tree().create_timer(duration).timeout
func wait_timer_or_cancel(duration: float):
	var state = { finished = false, canceled = false }
	var on_finished = func(): state.finished = true
	var on_canceled = func(): state.canceled = true
	var timer = get_tree().create_timer(duration)
	timer.timeout.connect(on_finished)
	cancel_signal.connect(on_canceled)
	while not state.finished and not state.canceled:
		await get_tree().process_frame
	timer.timeout.disconnect(on_finished)
	cancel_signal.disconnect(on_canceled)
	if state.finished == true: return 0
	if state.canceled == true: return 1
	return 2
func wait_anim_or_cancel(sprite: AnimatedSprite2D) -> int:
	var state = { finished = false, canceled = false }
	var on_finished = func(): state.finished = true
	var on_canceled = func(): state.canceled = true
	sprite.animation_finished.connect(on_finished)
	cancel_signal.connect(on_canceled)
	while not state.finished and not state.canceled:
		await get_tree().process_frame
	sprite.animation_finished.disconnect(on_finished)
	cancel_signal.disconnect(on_canceled)
	if state.finished == true: return 0
	if state.canceled == true: return 1
	return 2
func ri(max: int) -> int: # return a random int from 0 to max
	return randi_range(0, max)
func rt02(size: Vector2) -> Rect2: # return a rect2 in the first quadrant ( positive y goes down )
	return Rect2(Vector2.ZERO, size)
func arrays_share_element(a: Array, b: Array) -> bool:
	for x in a:
		if b.has(x): return true
	return false
func randp_in_rt2(rect: Rect2) -> Vector2:
	return Vector2(
		randf_range(rect.position.x, rect.end.x),
		randf_range(rect.position.y, rect.end.y)
	)
