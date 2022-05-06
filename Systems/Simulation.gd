extends Node

export var simulation_speed := 1.0 / 30.0
onready var _power_system := PowerSystem.new()
onready var _gui := $CanvasLayer/GUI
onready var _work_system := WorkSystem.new()
onready var _game_world := $GameWorld
onready var _level := $GameWorld/Level1
onready var _next_level_scene := $CanvasLayer/NextLevel


func _ready() -> void:
	$Timer.start(simulation_speed)
	Events.connect("to_next_level", self, "_next_level")
	_start_level()


func _process(delta) -> void:
	_count_children()


# includes "level1" to "level4"
func _next_level(value: String) -> void:
	if (not Library.Levels.has(value)):
		return
	var current_level: int = Library.Levels[value]
	Library.current_level = "level%d" % current_level
	var level_address: String = "res://Level/Level%s.tscn" % current_level
	
	_level.free()
	var level_scene = ResourceLoader.load(level_address)
	_level = level_scene.instance()
	_game_world.add_child(_level)


func _start_level() -> void:
	Library.current_level = "level1"
	call_deferred("_next_level", Library.current_level)


func _on_Timer_timeout() -> void:
	Events.emit_signal("systems_ticked", simulation_speed)


func _count_children() -> void:
	if _level.get_child(2).get_child(0).get_child_count() <= 2:
		_next_level_scene.toggle_show_button(true)
