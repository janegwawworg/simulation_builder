extends Node

export var simulation_speed := 1.0 / 30.0


onready var _power_system := PowerSystem.new()
onready var _gui := $CanvasLayer/GUI
onready var _work_system := WorkSystem.new()


func _ready() -> void:
	$Timer.start(simulation_speed)


func _on_Timer_timeout() -> void:
	Events.emit_signal("systems_ticked", simulation_speed)
