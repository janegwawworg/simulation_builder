extends Node

export var simulation_speed := 1.0 / 30.0
enum Levels {level1 = 1, level2, level3, level4, level5, level6, level7, level8}

onready var _power_system := PowerSystem.new()
onready var _gui := $CanvasLayer/GUI
onready var _work_system := WorkSystem.new()
onready var _game_world := $GameWorld
onready var _level := $GameWorld/Level1


func _ready() -> void:
	$Timer.start(simulation_speed)
	call_deferred("_next_level", "level1")


# includes "level1" to "level8"
func _next_level(value: String) -> void:
	if (not Levels.has(value)):
		return
	var level_address: String = "res://Level/Level%s.tscn" % Levels[value]
	
	_level.free()
	var level_scene = ResourceLoader.load(level_address)
	_level = level_scene.instance()
	_game_world.add_child(_level)


func _on_Timer_timeout() -> void:
	Events.emit_signal("systems_ticked", simulation_speed)
