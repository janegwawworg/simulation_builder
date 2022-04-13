extends Node2D
class_name level

export var move_limit_left := -10000000
export var move_limit_top := -100000000
export var move_limit_right := 100000000
export var move_limit_bottom := 100000000

var BARRIER_ID := 1
var INVISIBLE_BARRIER_ID := 2
var _tracker := EntityTracker.new()

onready var _ground := $GroundTile
onready var _entity_place := $YSort/EntityPlacer
onready var _player := $YSort/Player
onready var _flat_entities := $FlatEntities
onready var _gui := $"../../CanvasLayer/GUI"

func _ready():
	add_to_group("persist")
	_entity_place.setup(_gui, _tracker, _ground, _flat_entities, _player)
	var barriers: Array = _ground.get_used_cells_by_id(BARRIER_ID)
	for cell in barriers:
		_ground.set_cellv(cell, INVISIBLE_BARRIER_ID)


func get_limit() -> Dictionary:
	return {
		left = move_limit_left,
		top = move_limit_top,
		right = move_limit_right,
		bottom = move_limit_bottom,
	}
