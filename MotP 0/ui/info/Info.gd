extends Node

#var text = preload("res://text/info.txt")

func _ready():
	var f = File.new()
	f.open("res://ui/text/info.txt", f.READ)
	$InfoBox.set_text(f.get_as_text())
	f.close()

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass