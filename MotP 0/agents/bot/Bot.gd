extends "res://agents/agent.gd"

onready var util = preload("res://util.gd").new()
onready var Modes = util.Modes

var dir = Vector2(0, -1)
var mode
var c
onready var EMPTY = Grid.CellType.EMPTY

####

func _ready(): 
	c = randc()
	set_mode(randi()%3)

func tick():
	# this would be more efficient if we could directly call Grid.move and prove it's safe
	# i.e. prove that move has the same effect as request_move
	Grid.request_send(self, dir, ["mode", mode])
	for i in range(4):
		match Grid.request_look(self, dir):
			[EMPTY, null]: return Grid.request_move(self, dir)
			_: spin()

func spin(): dir = util.rot_phi(dir, get_angle())

func failed(action): spin()

func receive(msg): 
	match msg:
		["mode", var m]: set_mode(m)
		"cycle": set_mode((mode+1)%3)

func set_mode(m):
	mode = m 
	match m:
		Modes.LEFT: 	modulate = Color(c, c, 1)
		Modes.CENTER: 	modulate = Color(c, 1, c)
		Modes.RIGHT:	modulate = Color(1, c, c)

func get_angle():
	match mode:
		Modes.LEFT: 	return -PI/2
		Modes.CENTER: 	return PI
		Modes.RIGHT:	return PI/2
	return 0

func randc(): return randf()*1/2
