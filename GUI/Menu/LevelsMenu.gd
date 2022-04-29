extends MarginContainer

onready var button1 := $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Button
onready var button2 := $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Button2
onready var button3 := $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Button3
onready var button4 := $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Button4



func _ready() -> void:
	button1.connect("pressed", self, "_go_to_level", ["level1"])
	button2.connect("pressed", self, "_go_to_level", ["level2"])
	button3.connect("pressed", self, "_go_to_level", ["level3"])
	button4.connect("pressed", self, "_go_to_level", ["level4"])


func _go_to_level(value: String) -> void:
	get_tree().change_scene("res://Systems/Simulation.tscn")


func _on_Button9_pressed():
	get_tree().change_scene("res://GUI/Menu/StartMenu.tscn")
