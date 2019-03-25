extends "res://agents/agent.gd"

onready var util = preload("res://util.gd").new()

# Declare member variables here. Examples:
var dir = Vector2(0, -1)
onready var EMPTY = Grid.CellType.EMPTY



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func tick():
	# this would be more efficient if we could directly call Grid.move and prove it's safe
	# i.e. prove that move has the same effect as request_move
	for i in range(4):
		match Grid.request_look(self, dir):
			[EMPTY, null]: return Grid.request_move(self, dir)
			_: spin()

func spin(): dir = util.rot_left(dir)

func failed(action): spin()
