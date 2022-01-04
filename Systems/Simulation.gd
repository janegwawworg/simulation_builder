extends Node

var BARRIER_ID := 1
var INVISIBLE_BARRIER_ID := 2

var _tracker := EntityTracker.new()

onready var _ground := $GameWorld/GroundTile
onready var _entity_place := $GameWorld/YSort/TileMap
onready var _player := $GameWorld/YSort/Player


func _ready() -> void:
	_entity_place.setup(_tracker, _ground, _player)
	for cell in _ground.get_used_cells_by_id(BARRIER_ID):
		_ground.set_cellv(cell, INVISIBLE_BARRIER_ID)
