extends Node2D

onready var Grid = get_parent()
onready var Game = Grid.get_parent()
var pos = Vector2()
export var tween_time = 0.25

# Called when the node enters the scene tree for the first time.
func _ready(): 
	Grid.scale(self)
	tween_time = 0.25 # TODO:

# func move(new_pos, new_position=false):
# 	pos = new_pos
# 	position = new_position #or Grid.map_to_world(pos) + Grid.cell_size/2
# 	return pos

func move(new_pos, new_position=false, animate=true):
	pos = new_pos

	if animate:
		$Tween.interpolate_property(self, "position", 
			position, new_position, 
			tween_time, 
			Tween.TRANS_LINEAR, Tween.EASE_IN)
		$Tween.start()
	else:
		self.position = new_position

	return pos

func can_look(dir):
	return dir.length() == 1

func can_move(dir):
	return dir.length() == 1

func failed(action): pass

func tick(): pass
