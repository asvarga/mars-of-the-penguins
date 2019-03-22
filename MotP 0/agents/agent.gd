extends Node2D

onready var Grid = get_parent()
var pos = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func move(new_pos, new_position=false):
	pos = new_pos
	position = new_position #or Grid.map_to_world(pos) + Grid.cell_size/2
	return pos

func can_look(dir):
	return dir.length() == 1

func can_move(dir):
	return dir.length() == 1

func tick(): pass
