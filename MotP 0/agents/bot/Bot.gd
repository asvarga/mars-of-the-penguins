extends "res://agents/agent.gd"

# Declare member variables here. Examples:
var dir = Vector2(0, -1)
onready var EMPTY = Grid.CellType.EMPTY

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func tick():
	# this would be more efficient if we could directly call Grid.move and prove it's safe
	# i.e. prove that move has the same effect as request_move
	for i in range(4):
		match Grid.request_look(self, dir):
			[EMPTY, null]: return Grid.request_move(self, dir)
			_: dir = Vector2(dir.y, -dir.x)
	# if not Grid.request_move(self, dir):
	# 	# print("wall")
	# 	dir = Vector2(dir.y, -dir.x)
