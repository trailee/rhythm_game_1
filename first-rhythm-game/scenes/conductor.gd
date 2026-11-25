extends AudioStreamPlayer2D
@export var bpm = 162
var beat := 0.0
var notes = [
	[2, 7],
	[3, 8],
	[4, 9],
	[5, 10]
]
var score := 0

# when node enters scene first time
func _ready() -> void:
	pass

# call every frame
func _process(delta: float) -> void:
	beat = get_playback_position() * bpm / 60
	queue_redraw()
	
	# delete when note passes the line
	for i in 4:
		var lane = notes[i]
		while not lane.is_empty():
			var note = lane[0]
			if note < beat - 0.5:
				lane.pop_front()
			else:
				break

func _draw() -> void:
	# vertical lines
	for i in 5:
		var start = Vector2(100 * i + 200, 0)
		var end = Vector2(100 * i + 200, 720)
		draw_line(start, end, Color.WHITE)
		if i < 4:
			var label_pos = Vector2(100 * (i+0.5) + 200, 620 + 30)
	
	# judgemental line
	var judge_start = Vector2(200, 620)
	var judge_end = Vector2(100 * 4 + 200, 620)
	draw_line(judge_start, judge_end, Color.WHITE)
	# arrows
	for i in 4:
		for note in notes[i]:
			var y = 620 + 100 * (beat - note)
			var start = Vector2(100 * i + 200, y)
			var end = Vector2(100 * (i+1) + 200, y)
			draw_line(start, end, Color.WHITE, 5)
	
	#score
	draw_string(ThemeDB.fallback_font, Vector2(60, 60), "Score: " + str(score))

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("q"):
		_handle_lane_press(0)
	elif event.is_action_pressed("w"):
		_handle_lane_press(1)
	elif event.is_action_pressed("o"):
		_handle_lane_press(2)
	elif event.is_action_pressed("p"):
		_handle_lane_press(3)

func _handle_lane_press(lane: int) -> void:
	var lane_notes = notes[lane]
	var note = lane_notes[0]
	if lane_notes.is_empty():
		return
	if abs(beat - note) < 1:
		lane_notes.pop_front()
		score +=1
