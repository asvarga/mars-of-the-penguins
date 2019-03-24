extends "res://agents/agent.gd"

var PRESSED = {}
var key_to_dir = {
	"ui_right": Vector2.RIGHT,
	"ui_left": 	Vector2.LEFT,
	"ui_up": 	Vector2.UP,
	"ui_down": 	Vector2.DOWN
}

# Called when the node enters the scene tree for the first time.
func _ready():
	._ready()
	for key in key_to_dir: PRESSED[key] = false
	tween_time = 0.05

#func _input(ev):
func _process(delta):
	#if ev is InputEventKey and not ev.echo:
	var dir = Vector2()
	for key in key_to_dir:
		if Input.is_action_pressed(key) and (not PRESSED[key] or $Timer.is_stopped()): 
			dir += key_to_dir[key]
			$Timer.start()
		PRESSED[key] = Input.is_action_pressed(key)
	if dir == Vector2(): return

	Grid.request_move(self, dir, true)
	

