extends "res://agents/agent.gd"

onready var util = preload("res://util.gd").new()

var dir = Vector2(0, -1)
var angle = PI/2
var changed = false
onready var EMPTY = Grid.CellType.EMPTY

func _ready():
	modulate = Color(1, randf(), 0)

func tick():
	# this would be more efficient if we could directly call Grid.move and prove it's safe
	# i.e. prove that move has the same effect as request_move
	if changed: Grid.request_send(self, dir, "change")
	for i in range(4):
		match Grid.request_look(self, dir):
			[EMPTY, null]: return Grid.request_move(self, dir)
			_: spin()

func spin(): dir = util.rot_phi(dir, angle)

func failed(action): spin()

func receive(msg): 
	match msg:
		"change": change()

func change():
	changed = true 
	angle = -PI/2
	modulate.r = 0
	modulate.b = 1
