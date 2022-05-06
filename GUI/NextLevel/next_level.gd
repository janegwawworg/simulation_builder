extends Control

onready var _button := $HBoxContainer/TextureButton
onready var _label := $HBoxContainer/Label


func _ready() -> void:
	_label.text = Library.current_level
	toggle_show_button(false)


func _on_TextureButton_pressed():
	if Library.Levels[Library.current_level] < 4:
		var next_level: int = Library.Levels[Library.current_level] + 1
		Events.emit_signal("to_next_level", "level%d" % next_level)
		toggle_show_button(false)
	else:
		get_tree().change_scene("res://GUI/Menu/StartMenu.tscn")
		Library.current_level = "level1"
		
	_label.text = Library.current_level
	if Library.Levels[Library.current_level] == 4:
		_button.texture_normal = load("res://GUI/NextLevel/end.png")


func toggle_show_button(value: bool) -> void:
	_button.visible = value
