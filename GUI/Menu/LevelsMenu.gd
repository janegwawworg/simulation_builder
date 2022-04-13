extends MarginContainer

onready var button1 := $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Button
onready var button2 := $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Button2
onready var button3 := $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Button3
onready var button4 := $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Button4
onready var button5 := $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Button5
onready var button6 := $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Button6
onready var button7 := $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Button7
onready var button8 := $MarginContainer/VBoxContainer/VBoxContainer/HBoxContainer/Button8


func _ready() -> void:
	button1.connect("pressed", self, "_go_to_level", ["level1"])
	button2.connect("pressed", self, "_go_to_level", ["level2"])
	button3.connect("pressed", self, "_go_to_level", ["level3"])
	button4.connect("pressed", self, "_go_to_level", ["level4"])
	button5.connect("pressed", self, "_go_to_level", ["level5"])
	button6.connect("pressed", self, "_go_to_level", ["level6"])
	button7.connect("pressed", self, "_go_to_level", ["level7"])
	button8.connect("pressed", self, "_go_to_level", ["level8"])


func _go_to_level(value: String) -> void:
	get_tree().change_scene("res://Systems/Simulation.tscn")


func _on_Button9_pressed():
	get_tree().change_scene("res://GUI/Menu/StartMenu.tscn")
