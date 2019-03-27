extends "res://agents/agent.gd"

var PRESSED = {
	"ui_right":  false,
	"ui_left": 	 false,
	"ui_up": 	 false,
	"ui_down": 	 false,
	"ui_select": false
}
var action_to_dir = {
	"ui_right": Vector2.RIGHT,
	"ui_left": 	Vector2.LEFT,
	"ui_up": 	Vector2.UP,
	"ui_down": 	Vector2.DOWN
}

func _ready():
	._ready()
	for action in action_to_dir: PRESSED[action] = false
	tween_time = 0.05

func _process(delta):
	var dir = Vector2()
	for action in PRESSED:
		if Input.is_action_pressed(action) and (not PRESSED[action] or $Timer.is_stopped()): 
			if action in action_to_dir:
				dir += action_to_dir[action]
			$Timer.start()
		PRESSED[action] = Input.is_action_pressed(action)
	if dir == Vector2(): return

	if PRESSED["ui_select"]: 
		Grid.request_send(self, dir, "change")
	else:
		Grid.request_move(self, dir, true)
	

