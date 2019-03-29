extends Node2D


"""
!! Remember: These classes serve as the interface between the agent and the world.
Not as the agent itself.
In other words, the script defining the agents behavior won't have access to everything
that the agent object itself has.
"""

onready var Grid = get_parent()
onready var Game = Grid.get_parent().get_parent()
var pos = Vector2()
export var tween_time = 0.25

var paused = false

func _ready(): 
	Grid.scale(self)
	tween_time = 0.25 # TODO:

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
	
func can_look(dir): return dir.length() == 1
func can_move(dir): return dir.length() == 1 and not paused
func can_send(dir): return dir.length() == 1
func can_edit(dir): return dir.length() == 1

func failed(action): pass

func tick(): pass

func receive(msg): pass
