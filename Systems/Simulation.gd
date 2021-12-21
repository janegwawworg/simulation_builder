extends Node

var BARRIER_ID := 1
var INVISIBLE_BARRIER_ID := 2

onready var _ground := $GameWorld/GroundTile


func _ready() -> void:
	for cell in _ground.get_used_cells_by_id(BARRIER_ID):
		_ground.set_cellv(cell, INVISIBLE_BARRIER_ID)
