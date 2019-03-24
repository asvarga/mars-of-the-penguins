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
			_: spin()
	# if not Grid.request_move(self, dir):
	# 	# print("wall")
	# 	dir = Vector2(dir.y, -dir.x)

func spin(): dir = Vector2(dir.y, -dir.x)

# func move(new_pos, new_position=false):
# 	pos = new_pos
# 	$Tween.interpolate_property(self, "position", 
# 								position, new_position, 
# 								0.25, 
# 								Tween.TRANS_LINEAR, Tween.EASE_IN)
# 	$Tween.start()
# 	return pos

func failed(action): spin()
