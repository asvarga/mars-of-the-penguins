extends Node

onready var util = preload("res://util.gd").new()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	print(util.MAGIC)
	# pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TickTimer_timeout():
	$CenterContainer/Grid.tick()
