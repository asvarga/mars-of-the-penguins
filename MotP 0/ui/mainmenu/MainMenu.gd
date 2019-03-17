extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	#print("\n========\n")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_StartButton_pressed():
	get_tree().change_scene("res://game/Game.tscn")


func _on_InfoButton_pressed():
	get_tree().change_scene("res://ui/info/Info.tscn")
