extends Control

onready var util = preload("res://util.gd").new()
onready var Modes = util.Modes

var editor
var edited

func _ready():
	for m in Modes: $OptionButton.add_item(m)

func edit(editor, edited):
	self.editor = editor
	self.edited = edited
	editor.paused = true
	edited.paused = true
	editor.editing = edited
	update()
	show()

func update():
	if edited:
		$OptionButton.select(edited.mode)
	
func _on_OptionButton_item_selected(m):
	edited.set_mode(m)
	hide()

func exit():
	if editor:
		editor.paused = false
		edited.paused = false
		editor.editing = null




