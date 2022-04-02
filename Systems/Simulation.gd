extends Node

var BARRIER_ID := 1
var INVISIBLE_BARRIER_ID := 2

var _tracker := EntityTracker.new()

export var simulation_speed := 1.0 / 30.0

onready var _ground := $GameWorld/GroundTile
onready var _entity_place := $GameWorld/YSort/EntityPlacer
onready var _player := $GameWorld/YSort/Player
onready var _flat_entities := $GameWorld/FlatEntities
onready var _power_system := PowerSystem.new()
onready var _gui := $CanvasLayer/GUI
onready var _work_system := WorkSystem.new()


func _ready() -> void:
	$Timer.start(simulation_speed)
	_entity_place.setup(_gui, _tracker, _ground, _flat_entities, _player)
	var barriers: Array = _ground.get_used_cells_by_id(BARRIER_ID)
	
	for cell in barriers:
		_ground.set_cellv(cell, INVISIBLE_BARRIER_ID)


func _on_Timer_timeout() -> void:
	Events.emit_signal("systems_ticked", simulation_speed)
